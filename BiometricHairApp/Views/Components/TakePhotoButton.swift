//
//  TakePhotoButton.swift
//  BiometricHairApp
//
//  Created by Admin on 24/06/2025.
//

import Foundation
import SwiftUI

struct TakePhotoButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.white)
                .frame(width: 70, height: 70)
                .overlay(
                    Circle().stroke(Color.gray, lineWidth: 2)
                )
        }
        .padding()
    }
}
