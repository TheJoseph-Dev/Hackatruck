//
//  YOLO.swift
//  MLModelsTest
//
//  Created by Turma01-23 on 23/07/25.
//

import Foundation
import UIKit
import Vision
import AVFoundation

class YOLO {
    struct ImageLabel: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let confidence: Float
        let boundingBox: CGRect // Normalized bounding box
        
        init(name: String, confidence: Float, boundingBox: CGRect) {
            self.name = name
            self.confidence = confidence
            self.boundingBox = boundingBox
        }

        /**
         Heuristic for determining the depth of an object based on the proportion of the area
         it occupies on the screen

         - Returns: A `Double` between 0 (close) and 1 (far)
        */
        func getApproximateDepth() -> Double {
            return 1.0-(self.boundingBox.width * self.boundingBox.height);
        }

        func screenSpaceBoundingBox(imageSize: CGSize) -> CGRect {
            let width = boundingBox.width * imageSize.width
            let height = boundingBox.height * imageSize.height
            let x = boundingBox.minX * imageSize.width
            // Flip y-axis (Vision's origin is bottom-left, UIKit is top-left)
            let y = (1 - self.boundingBox.minY - self.boundingBox.height) * imageSize.height
            return CGRect(x: x, y: y, width: width, height: height)
        }
        /*
            Rectangle()
            .path(in: convertBoundingBox(label.boundingBox, imageSize: viewSize))
            .stroke(Color.red, lineWidth: 2)
        */
    }

    static let model = try? VNCoreMLModel(for: YOLOv3().model)
    
    static func process(image: UIImage, threshold: Float = 0.6) -> [ImageLabel] {
        let rImage = YOLO.resizeImage(image, targetSize: image.size) ?? image
        guard let model = model else {
            print("Failed to load CoreML model")
            return []
        }

        var imgLabels: [ImageLabel] = []
        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNRecognizedObjectObservation] {
                print(results.count)
                for observation in results {
                    let best = observation.labels[0]
                    print("Label: " + String(best.identifier) + " - Confidence: " + String(best.confidence))
                    if best.confidence < threshold { continue; }
                    imgLabels.append(ImageLabel(name: best.identifier, confidence: best.confidence, boundingBox: observation.boundingBox))
                        //print(best.identifier)
//                    for imgLabel in observation.labels {
//                        print("Label: \(imgLabel.identifier), Confidence: \(imgLabel.confidence)")
//                    }
                }
            }
        }
        
        guard let ciImage = CIImage(image: rImage) else {
            print("Failed to convert UIImage to CIImage")
            return []
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
        
        return imgLabels
    }
    
    private static func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(width: size.width * scaleFactor,
                             height: size.height * scaleFactor)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

}

/*
 class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
     
     var bufferSize: CGSize = .zero
     var rootLayer: CALayer! = nil
     
     private let session = AVCaptureSession()
     private var previewLayer: AVCaptureVideoPreviewLayer! = nil
     private let videoDataOutput = AVCaptureVideoDataOutput()
     
     private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
     
     func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
         // to be implemented in the subclass
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         setupAVCapture()
     }
     
     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
     
     func setupAVCapture() {
         var deviceInput: AVCaptureDeviceInput!
         
         // Select a video device, make an input
         let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
         do {
             deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
         } catch {
             print("Could not create video device input: \(error)")
             return
         }
         
         session.beginConfiguration()
         session.sessionPreset = .vga640x480 // Model image size is smaller.
         
         // Add a video input
         guard session.canAddInput(deviceInput) else {
             print("Could not add video device input to the session")
             session.commitConfiguration()
             return
         }
         session.addInput(deviceInput)
         if session.canAddOutput(videoDataOutput) {
             session.addOutput(videoDataOutput)
             // Add a video data output
             videoDataOutput.alwaysDiscardsLateVideoFrames = true
             videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
             videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
         } else {
             print("Could not add video data output to the session")
             session.commitConfiguration()
             return
         }
         let captureConnection = videoDataOutput.connection(with: .video)
         // Always process the frames
         captureConnection?.isEnabled = true
         do {
             try  videoDevice!.lockForConfiguration()
             let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
             bufferSize.width = CGFloat(dimensions.width)
             bufferSize.height = CGFloat(dimensions.height)
             videoDevice!.unlockForConfiguration()
         } catch {
             print(error)
         }
         session.commitConfiguration()
         previewLayer = AVCaptureVideoPreviewLayer(session: session)
         previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
         let view = UIView();
         rootLayer = view.layer;
         previewLayer.frame = rootLayer.bounds
         rootLayer.addSublayer(previewLayer)
     }
     
     func startCaptureSession() {
         session.startRunning()
     }
     
     // Clean up capture setup
     func teardownAVCapture() {
         previewLayer.removeFromSuperlayer()
         previewLayer = nil
     }
     
     func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
         // print("frame dropped")
     }
     
     public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
         let curDeviceOrientation = UIDevice.current.orientation
         let exifOrientation: CGImagePropertyOrientation
         
         switch curDeviceOrientation {
         case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
             exifOrientation = .left
         case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
             exifOrientation = .upMirrored
         case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
             exifOrientation = .down
         case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
             exifOrientation = .up
         default:
             exifOrientation = .up
         }
         return exifOrientation
     }
 }
 
*/
