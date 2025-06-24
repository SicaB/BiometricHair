//
//  CameraButton.swift
//  BiometricHairApp
//
//  Created by Admin on 23/06/2025.
//

import Foundation
import SwiftUI

struct CameraButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 80, height: 80)
                    .shadow(radius: 4)

                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            }
        }
        .padding()
    }
}
