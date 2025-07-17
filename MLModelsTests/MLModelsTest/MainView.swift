//
//  ContentView.swift
//  MLModelsTest
//
//  Created by Turma01-23 on 17/07/25.
//

import SwiftUI
import CoreML
import Vision
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    var completionHandler: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.completionHandler(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct MainView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = (UIImage(named: "japan-street-r") ?? nil)

    var body: some View {
        VStack {
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .onAppear() {
                        processImage(selectedImage!)
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .foregroundStyle(.tint)
            }

            Button("Pick Image") {
                showImagePicker = true
            }
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image in
                selectedImage = image
                let rImage = resizeImage(image, targetSize: CGSize(width: 416, height: 416))
                processImage(rImage)
            }
        }
    }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    func processImage(_ image: UIImage) {
        guard let model = try? VNCoreMLModel(for: YOLOv3Tiny().model) else {
            print("Failed to load CoreML model")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNRecognizedObjectObservation] {
                print(results.count)
                for observation in results {
                    for imgLabel in observation.labels {
                        print("Label: \(imgLabel.identifier), Confidence: \(imgLabel.confidence)")
                    }
                }
            }
        }
        
        guard let ciImage = CIImage(image: image) else {
            print("Failed to convert UIImage to CIImage")
            return
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }
    
}


#Preview {
    MainView()
}
