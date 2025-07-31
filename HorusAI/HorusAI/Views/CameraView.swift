//
//  CameraView.swift
//  MLModelsTest
//
//  Created by Turma01-23 on 23/07/25.
//

import SwiftUI
import UIKit
import AVFoundation

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
        if self.wait(time: 0.3) { return }
        
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
        private let bufferLimit = 16

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
    @EnvironmentObject var manager: ConfigurationManager
    @Environment(\.dismiss) var dismiss
    @State private var predictions: [YOLO.ImageLabel] = []
    @State private var hasLoadedFramebuffers = false
    @State private var canCall: Bool = false;
    @State private var rippleProgress: Double = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            CameraView(predictions: $predictions)
                //.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 10) {
                ForEach(predictions, id: \.id) { label in
                    ObjectFrame(label: label)
                }
            }
            .padding()
            
            VStack {
                Spacer()
                Button(action: {}) {
                    HorusAIView(rippleProgress: $rippleProgress, discard: 1.0)
                        .gesture(
                            TapGesture(count: 2).onEnded {
                                let generator = UINotificationFeedbackGenerator()
                                generator.prepare()
                                generator.notificationOccurred(.success)
                                Speecher.shared.stopSpeaking()
                                dismiss()
                            }.exclusively(before: TapGesture(count: 1).onEnded {
                                guard canCall else { return }
                                canCall = false
                                Task {
                                    Speecher.shared.speak("Aguarde um momento enquanto obtemos Informações do ambiente", language: manager.currentConfig.idioma, voice: manager.currentConfig.voz)
                                    let gpsData = try await GPSAPI.shared.getClosestPoint()
                                    let prompt = Gemini.shared.createPrompt(from: self.predictions, at: gpsData, with: manager.currentConfig.idioma)
                                    let speechText = await Gemini.shared.call(prompt: prompt)
                                    Speecher.shared.speak(speechText, language: manager.currentConfig.idioma, voice: manager.currentConfig.voz)
                                    canCall = true
                                }
                            })
                        )
                        .simultaneousGesture(
                            LongPressGesture(minimumDuration: Double(manager.currentConfig.toques))
                                .onEnded { _ in
                                    Speecher.shared.speak("Chamando número de emergência", language: manager.currentConfig.idioma, voice: manager.currentConfig.voz)
                                }
                        )
                }
                
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            Speecher.shared.speak("Iniciando o HorusAI! Aguarde um momento enquanto obtemos informações do ambiente", language: manager.currentConfig.idioma, voice: manager.currentConfig.voz)
        }
        .onChange(of: predictions) {
            if hasLoadedFramebuffers { return; }
            hasLoadedFramebuffers = true

            print("First predictions received!")
            Task {
                
                let gpsData = try await GPSAPI.shared.getClosestPoint()
                print(gpsData?.point.name)
                print("Generating prompt...")
                let prompt = Gemini.shared.createPrompt(from: self.predictions, at: gpsData, with: manager.currentConfig.idioma)
                //print("Prompt: \(prompt)")
                
                print("Calling Gemini...")
                let speechText = await Gemini.shared.call(prompt: prompt)
                print("Response: \(speechText)")
                
                print("Speaking...")
                Speecher.shared.speak(speechText, language: manager.currentConfig.idioma, voice: manager.currentConfig.voz)
                canCall = true;
            }
        }
        
    }
    
}
