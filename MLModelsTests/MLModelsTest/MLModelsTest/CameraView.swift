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

*/

protocol CameraFrameDelegate: AnyObject {
    func didCapture(frame: UIImage)
}

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var lastProcessedTime: TimeInterval = 0
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

    private func wait(time: Double = 1.0) -> Bool {
        let currentTime = CACurrentMediaTime()
        guard currentTime - lastProcessedTime >= time else { return true }
        self.lastProcessedTime = currentTime
        return false;
    }
    
    // Frame captured from camera
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if self.wait(time: 0.2) { return }
        
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
        private var frameBuffer: [[YOLO.ImageLabel]] = []
        private let bufferLimit = 20
        private var hasSpoken = false

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func didCapture(frame: UIImage) {
            guard !isProcessing else { return }
            isProcessing = true

            DispatchQueue.global(qos: .userInitiated).async {
                let results = YOLO.process(image: frame)
                DispatchQueue.main.async {
                    //self.parent.predictions = results
                    self.frameBuffer.append(results)
                    if self.frameBuffer.count > self.bufferLimit {
                        self.frameBuffer.removeFirst(self.frameBuffer.count - self.bufferLimit)
                    }
                    self.parent.predictions = self.analyzeBuffer().sorted(by: { $0.getApproximateDepth() < $1.getApproximateDepth() })
                    self.isProcessing = false
                }
            }
        }
        
        private func analyzeBuffer() -> [YOLO.ImageLabel] {
            var labelInstances: [String: [YOLO.ImageLabel]] = [:]

            // Count label occurrences and store instances
            for frame in frameBuffer {
                for label in frame {
                    labelInstances[label.name, default: []].append(label)
                }
            }

            var reliableLabels: [YOLO.ImageLabel] = []

            for (_, instances) in labelInstances {
                let averageCount = Double(instances.count) / Double(frameBuffer.count)
                let countToAdd = Int(round(averageCount))

                if countToAdd > 0 {
                    // Sort by confidence and take top N
                    let topLabels = instances
                        .sorted(by: { $0.confidence > $1.confidence })
                        .prefix(countToAdd)
                    reliableLabels.append(contentsOf: topLabels)
                }
            }

            return reliableLabels
        }
        
    }
}


struct CameraViewWrapper: View {
    @State private var predictions: [YOLO.ImageLabel] = []
    @State private var hasLoadedFramebuffers = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            CameraView(predictions: $predictions)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                ForEach(predictions, id: \.id) { label in
                    ObjectFrame(label: label)
                }
            }
            .padding()
            
            VStack {
                Spacer()
                HStack {
                    
                    Button(action: {
                        /*
                        var text = "Objetos: "
                        for prediction in predictions.sorted(by: { $0.getApproximateDepth() < $1.getApproximateDepth() } ) {
                            text += String(prediction.name) + ", ";
                        }
                        print(text)
                        Speecher.shared.speak(text)
                         */
                        Task {
                            let prompt = Gemini.shared.createPrompt(from: self.predictions)
                            let speechText = await Gemini.shared.call(prompt: prompt)
                            Speecher.shared.speak(speechText)
                        }
                        
                        }) {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(25)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 40)
                }
                .padding(.leading, 40)
            }
        }
        .onAppear {
            Speecher.shared.speak("Iniciando o HorusAI!")
        }
        .onChange(of: predictions) { newPredictions in
            if hasLoadedFramebuffers { return; }
            hasLoadedFramebuffers = true

            print("First predictions received!")

            /*let text = newPredictions
                
                .map(\.name)
                .joined(separator: ", ")

            Speecher.shared.speak("Primeiras detecções: \(text)")
            */
            
            Task {
                let prompt = Gemini.shared.createPrompt(from: self.predictions)
                let speechText = await Gemini.shared.call(prompt: prompt)
                Speecher.shared.speak(speechText)
            }
        }
        
    }
}
