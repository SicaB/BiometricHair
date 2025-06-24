//
//  CaptureDeviceError.swift
//  BiometricHairApp
//
//  Created by Admin on 20/06/2025.
//

import Foundation

enum CaptureDeviceError: Error, LocalizedError {
    case cameraNotFound
    case inputSetupFailed
    case outputSetupFailed
    case invalidPhotoData

    var errorDescription: String? {
        switch self {
        case .cameraNotFound:
            return "No suitable camera device was found on this device."
        case .inputSetupFailed:
            return "Failed to add the camera input to the capture session."
        case .outputSetupFailed:
            return "Failed to add the photo output to the capture session."
        case .invalidPhotoData:
            return "Could not extract valid photo data from captured photo."
            
        }
    }
}
