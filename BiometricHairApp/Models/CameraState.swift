//
//  CameraState.swift
//  BiometricHairApp
//
//  Created by Admin on 23/06/2025.
//

import Foundation

enum CameraState {
    case idle            // intet kamera – kun ikon og "Tag billede"-knap
    case preview         // kamera live – vis preview + optageknap
    case photoCaptured   // foto taget – vis billede + "Tag billede"-knap
}
