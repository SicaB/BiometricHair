//
//  StartCameraButton.swift
//  BiometricHairApp
//
//  Created by Admin on 24/06/2025.
//

import Foundation
import SwiftUI

struct StartCameraButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}
