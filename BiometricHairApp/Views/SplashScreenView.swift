//
//  SplashScreenView.swift
//  BiometricHairApp
//
//  Created by Admin on 24/06/2025.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Image(systemName: "camera.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 16)

            Text("Biometric Hair")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

