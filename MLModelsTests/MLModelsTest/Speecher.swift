//
//  Speech.swift
//  MLModelsTest
//
//  Created by Turma01-23 on 24/07/25.
//

import Foundation
import AVFoundation

class Speecher: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    static let shared = Speecher()

    private let queue = DispatchQueue(label: "speecherQueue")
    
    @Published var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        queue.async {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
            self.synthesizer.speak(utterance)
            self.isSpeaking = true
        }
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}
