# BiometricHairApp – Caseopgave

## Formål
Formålet med opgaven er at tage et billede med iOS-kameraet og udtrække hårmaske-data (Hair Matte) ved hjælp af AVFoundation og Swift. Fokus ligger på **tilgang og arkitektur**, ikke på færdig UI.

---

## Teknisk tilgang

### Arkitektur
Jeg har valgt en enkel **MVVM-struktur**, som giver god adskillelse mellem View og logik, og som let kan udvides til Clean Architecture:
- `CameraView`: UI og visning
- `CameraViewModel`: håndterer permissions, billedtagning og status
- `PhotoService`: adskilt klasse til behandling af billeddata og matte
- `HairMaskRenderer`: konverterer matte til UIImage

Alle tunge funktioner holdes væk fra View’et.

---

### Brug af AVFoundation
Jeg bruger:
- `AVCaptureSession`, `AVCapturePhotoOutput`
- Aktiverer `PortraitEffectsMatteDeliveryEnabled`
- Udtrækker `semanticSegmentationMatte(for: .hair)`

Matten konverteres til et billede med gennemsigtighed og vises sammen med det originale billede.

---

### Hvorfor denne tilgang?
- Tydelig ansvarfordeling (MVVM)
- Gør det let at skrive tests og genbruge processorlogik
- Nem at udvide med fx face detection (VNFaceLandmarks)

---

## Hvordan bruger man appen?
- Åbn appen → kamera aktiveres
- Tryk på "Tag billede"
- Originalbillede og hårmaske vises

---

## Mulige udvidelser (næste skridt)
- Detektere øjenafstand med `Vision` API (VNDetectFaceLandmarksRequest)
- Automatisk validering mod pasfoto-regler
- Gem billede lokalt eller upload til server
- UI-feedback: vis om afstand, skarphed, eller lys er godkendt
- Async processing med Combine eller Task

---

## Test og kvalitet
Jeg har struktureret koden med henblik på testbarhed. I en større app ville jeg:
- Lave unittests for `PhotoService`
- Mocke AVCapture og Vision for tests
- Validere med snapshots og snapshot testing af UI

---

## Brugte teknologier og metoder
- Swift + SwiftUI
- AVFoundation
- PortraitEffectsMatte
- MVVM-arkitektur
- Async / Await
