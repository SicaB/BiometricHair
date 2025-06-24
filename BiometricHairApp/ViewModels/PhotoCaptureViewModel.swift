//
//  PhotoCaptureViewModel.swift
//  BiometricHairApp
//
//  Created by Admin on 20/06/2025.
//

import Foundation
import AVFoundation
import SwiftUI

@MainActor
final class CameraViewModel: ObservableObject {
    @Published var capturedPhoto: UIImage?
    @Published var hairMaskImage: UIImage?
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var cameraState: CameraState = .idle
    @Published var errorMessage: String?

    private let photoRepository: PhotoRepositoryProtocol

    init(
        photoRepository: PhotoRepositoryProtocol = PhotoRepository()
    ) {
        self.photoRepository = photoRepository
    }

    func startCamera() async {
        do {
            let layer = try await photoRepository.prepareCamera()
            self.previewLayer = layer
            self.cameraState = .preview
        } catch {
            self.errorMessage = "Fejl ved kamera: \(error.localizedDescription)"
        }
    }



    func stopCamera() {
        photoRepository.stopSession()
        previewLayer = nil
        cameraState = .idle
    }

    func takePhoto() async {
        do {
            let result = try await photoRepository.capturePhotoWithHairMask()
            self.capturedPhoto = result.photo
            self.hairMaskImage = result.hairMask
            self.cameraState = .photoCaptured
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func prepareForNewPhoto() {
        // Skifter bare state tilbage, preview er stadig aktiv
        self.capturedPhoto = nil
        self.hairMaskImage = nil
        self.cameraState = .preview
    }

}
