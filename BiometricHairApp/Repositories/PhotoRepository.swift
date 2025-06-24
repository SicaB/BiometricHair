//
//  PhotoRepository.swift
//  BiometricHairApp
//
//  Created by Admin on 23/06/2025.
//

import UIKit
import AVFoundation

protocol PhotoRepositoryProtocol {
    func prepareCamera() async throws -> AVCaptureVideoPreviewLayer
    func stopSession()
    func capturePhotoWithHairMask() async throws -> CapturedPhotoData
}

class PhotoRepository: PhotoRepositoryProtocol {
    private let hairMaskService: HairMaskServiceProtocol
    private let photoCaptureService: PhotoCaptureServiceProtocol

    init(
        hairMaskService: HairMaskServiceProtocol = HairMaskService(),
        photoCaptureService: PhotoCaptureServiceProtocol = PhotoCaptureService()
    ) {
        self.hairMaskService = hairMaskService
        self.photoCaptureService = photoCaptureService
    }

    func prepareCamera() async throws -> AVCaptureVideoPreviewLayer {
        try photoCaptureService.setupCamera()
        photoCaptureService.startSession()
        return photoCaptureService.getFreshPreviewLayer()
    }

    func stopSession() {
        photoCaptureService.stopSession()
    }

    func capturePhotoWithHairMask() async throws -> CapturedPhotoData {
        let capturedPhoto = try await photoCaptureService.takePhoto()

        // 🎯 Brug cgImageRepresentation direkte (uden takeUnretainedValue)
        guard let cgImage = capturedPhoto.cgImageRepresentation() else {
            throw CaptureDeviceError.invalidPhotoData
        }

        // 🎯 Brug spejlvendt orientering (venstre-spejlvendt = frontkamera)
        let uiImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: .leftMirrored)

        // 🎯 Hent hårmasken (allerede spejlvendt i din hårmaskeservice)
        let hairMask = hairMaskService.extractHairMask(from: capturedPhoto)

        return CapturedPhotoData(photo: uiImage, hairMask: hairMask)
    }
}
