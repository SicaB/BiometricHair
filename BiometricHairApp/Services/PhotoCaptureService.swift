//
//  PhotoCaptureService.swift
//  BiometricHairApp
//
//  Created by Admin on 20/06/2025.
//

import AVFoundation
import UIKit

protocol PhotoCaptureServiceProtocol {
    func setupCamera() throws
    func setupOutput()
    func startSession()
    func stopSession()
    func takePhoto() async throws -> AVCapturePhoto
    func getSemanticMatteAsImage(from photo: AVCapturePhoto, type: AVSemanticSegmentationMatte.MatteType) throws -> CIImage?
    func getFreshPreviewLayer() -> AVCaptureVideoPreviewLayer
}

final class PhotoCaptureService: NSObject, PhotoCaptureServiceProtocol, AVCapturePhotoCaptureDelegate {
    private let captureSession = AVCaptureSession()
    private var captureDeviceInput: AVCaptureDeviceInput?
    private(set) var photoOutput = AVCapturePhotoOutput()
    private var photoContinuation: CheckedContinuation<AVCapturePhoto, Error>?
    private var isCameraConfigured = false // setupCamera må kun blive kørt 1 gang. for at forhindre at tilføje input/output til sessionen mere end én gang

    func setupCamera() throws {
        guard !isCameraConfigured else { return }

        guard let camera = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) else {
            throw CaptureDeviceError.cameraNotFound
        }

        captureDeviceInput = try AVCaptureDeviceInput(device: camera)

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .photo

        if let input = captureDeviceInput, captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            throw CaptureDeviceError.inputSetupFailed
        }

        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            throw CaptureDeviceError.outputSetupFailed
        }

        setupOutput()
        captureSession.commitConfiguration()
        isCameraConfigured = true
    }

    func setupOutput() {
        photoOutput.maxPhotoQualityPrioritization = .speed

        if photoOutput.isDepthDataDeliverySupported {
            photoOutput.isDepthDataDeliveryEnabled = true
        }

        if photoOutput.isPortraitEffectsMatteDeliverySupported {
            photoOutput.enabledSemanticSegmentationMatteTypes = [.hair]
            photoOutput.isPortraitEffectsMatteDeliveryEnabled = true
        }
    }

    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }

    func stopSession() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    func takePhoto() async throws -> AVCapturePhoto {
        return try await withCheckedThrowingContinuation { continuation in
            self.photoContinuation = continuation

            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            settings.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliveryEnabled
            settings.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliveryEnabled
            settings.enabledSemanticSegmentationMatteTypes = photoOutput.enabledSemanticSegmentationMatteTypes

            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }




    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let matte = photo.semanticSegmentationMatte(for: .hair) {
            print("✅ Hårmaske fundet")
        } else {
            print("❌ Fandt ingen hårmaske i billedet")
        }

        if let error = error {
            photoContinuation?.resume(throwing: error)
        } else {
            photoContinuation?.resume(returning: photo)
        }
        photoContinuation = nil
    }


    func getSemanticMatteAsImage(from photo: AVCapturePhoto, type: AVSemanticSegmentationMatte.MatteType) throws -> CIImage? {
        guard 
            let semanticRaw = photo.semanticSegmentationMatte(for: type) else {
            return nil
        }
        return CIImage(cvPixelBuffer: semanticRaw.mattingImage)
    }

    func getFreshPreviewLayer() -> AVCaptureVideoPreviewLayer {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        return layer
    }
}

