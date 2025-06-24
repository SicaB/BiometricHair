//
//  PhotoCaptureView.swift
//  BiometricHairApp
//
//  Created by Admin on 20/06/2025.
//

import SwiftUI
import AVFoundation


struct PhotoCaptureView: View {
    @StateObject var viewModel = CameraViewModel()
    let startView = true

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Biometric Hair")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Group {
                    switch viewModel.cameraState {
                    case .idle:
                        ZStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.1)) // Giver ramme-effekt
                                .frame(width: 240, height: 320)
                                .cornerRadius(12)

                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                        }
                        .padding(.bottom, 16)
                        
                    case .preview:
                        if let previewLayer = viewModel.previewLayer {
                            CameraPreviewView(previewLayer: previewLayer)
                                .aspectRatio(3/4, contentMode: .fit)
                                .cornerRadius(12)
                                .padding()
                        } else {
                            ProgressView("Indlæser kamera...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        }
                        
                    case .photoCaptured:
                        if let photo = viewModel.capturedPhoto {
                            ZStack {
                                Image(uiImage: photo)
                                    .resizable()
                                    .scaledToFit()
                                
                                if let mask = viewModel.hairMaskImage {
                                    Image(uiImage: mask)
                                        .resizable()
                                        .scaledToFit()
                                        .opacity(0.5)
                                        .blendMode(.plusLighter)
                                }
                            }
                            .background(.black)
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    
                    switch viewModel.cameraState {
                    case .idle:
                        StartCameraButton(title: "Start kamera") {
                                Task { await viewModel.startCamera() }
                            }
                        
                    case .photoCaptured:
                        CameraButton() {
                                viewModel.prepareForNewPhoto()
                            }
                        
                    case .preview:
                        TakePhotoButton {
                                Task { await viewModel.takePhoto() }
                            }
                    }
                }
                .onDisappear {
                    viewModel.stopCamera()
                }
                
            }
            .padding(.bottom, 16)
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black

        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)

        return view
    }


    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            self.previewLayer.frame = uiView.bounds
        }
    }

}

#Preview {
    PhotoCaptureView()
}
