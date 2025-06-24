//
//  HairMaskService.swift
//  BiometricHairApp
//
//  Created by Admin on 20/06/2025.
//

import Foundation
import AVFoundation
import UIKit

protocol HairMaskServiceProtocol {
    func extractHairMask(from photo: AVCapturePhoto) -> UIImage?
}

class HairMaskService: HairMaskServiceProtocol {
    
    func extractHairMask(from photo: AVCapturePhoto) -> UIImage? {
        guard let matte = photo.semanticSegmentationMatte(for: .hair) else {
            print("❌ Fandt ingen hårmaske i billedet")
            return nil
        }

        // Brug korrekt orientering
        let orientedMatte = matte.applyingExifOrientation(.leftMirrored) // eller dynamisk hvis du vil
        let ciImage = CIImage(cvPixelBuffer: orientedMatte.mattingImage)

        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            print("⚠️ Kunne ikke konvertere matte til CGImage")
            return nil
        }

        return UIImage(cgImage: cgImage)
    }


}

