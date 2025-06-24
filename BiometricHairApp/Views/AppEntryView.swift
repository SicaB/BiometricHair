//
//  AppEntryView.swift
//  BiometricHairApp
//
//  Created by Admin on 24/06/2025.
//

import Foundation
import SwiftUI

struct AppEntryView: View {
    @State private var showMainView = false

    var body: some View {
        ZStack {
            if showMainView {
                PhotoCaptureView()
                    .transition(.opacity) // Glidende overgang
            } else {
                SplashScreenView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showMainView)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showMainView = true
            }
        }
    }
}

