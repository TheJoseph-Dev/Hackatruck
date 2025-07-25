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
    @State private var selectedImage: UIImage? = (UIImage(named: "jjj") ?? nil)

    var body: some View {
        VStack {
            if let uiImage = selectedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .onAppear() {
                        let labels = YOLO.process(image: selectedImage!)
                        
                        print(labels)
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
                //let rImage = resizeImage(image, targetSize: CGSize(width: 416, height: 416))
                //processImage(rImage)
            }
        }
    }

}

#Preview {
    MainView()
}
