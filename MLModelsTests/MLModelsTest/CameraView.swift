//
//  CameraView.swift
//  MLModelsTest
//
//  Created by Turma01-23 on 23/07/25.
//

import SwiftUI
import UIKit
import AVFoundation

/*
    Put into info.plist:
    <key>NSCameraUsageDescription</key>
    <string>We need access to your camera to detect objects in real-time.</string>

    Must ensure the app requests camera permission at runtime using AVCaptureDevice.requestAccess(for: .video)
*/

protocol CameraFrameDelegate: AnyObject {
    func didCapture(frame: UIImage)
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    weak var delegate: CameraFrameDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let previewLayer = view.layer.sublayers?.compactMap({ $0 as? AVCaptureVideoPreviewLayer }).first {
            previewLayer.frame = view.bounds
        }
    }

    func setupSession() {
        guard let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device) else {
            print("Failed to access camera.")
            return
        }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .medium

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        videoOutput.alwaysDiscardsLateVideoFrames = true

        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        captureSession.commitConfiguration()

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    private func setupCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                DispatchQueue.main.async {
                    self.setupSession()
                }
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.setupSession()
                        }
                    }
                    else {
                        print("Camera Access Denied")
                    }
                }
            default:
                print("Camera Access Denied")
            // Denied/restricted: handle gracefully
        }
    }

    // Frame captured from camera
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let uiImage = UIImage(ciImage: ciImage)

        DispatchQueue.main.async {
            self.delegate?.didCapture(frame: uiImage)
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var predictions: [YOLO.ImageLabel]

    func makeUIViewController(context: Context) -> CameraViewController {
        let controller = CameraViewController()
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CameraFrameDelegate {
        var parent: CameraView
        private var isProcessing = false

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func didCapture(frame: UIImage) {
            guard !isProcessing else { return }
            isProcessing = true

            DispatchQueue.global(qos: .userInitiated).async {
                let results = YOLO.process(image: frame)
                DispatchQueue.main.async {
                    self.parent.predictions = results
                    self.isProcessing = false
                }
            }
        }
    }
}


struct CameraViewWrapper: View {
    @State private var predictions: [YOLO.ImageLabel] = []

    var body: some View {
        ZStack(alignment: .topLeading) {
            CameraView(predictions: $predictions)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                ForEach(predictions, id: \.id) { label in
                    Text("\(label.name)")
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }

    }
}

#Preview {
    CameraViewWrapper()
}
