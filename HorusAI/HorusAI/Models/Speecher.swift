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
    private let voices = AVSpeechSynthesisVoice.speechVoices()
    private let voicesMap: [String: [String]] = [
        "pt-BR": ["Lucia", "Ricardo"],
        "pt-PT": ["Maria", "João"],
        "en-US": ["Samantha", "David"],
        "es-ES": ["Carmen", "Jorge"],
        "zh-CN": ["Mei-Jia", "Xiaozhi"],
        "ja-JP": ["Kyoko", "Rocko"]
    ]

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, language: String, voice: String) {
        queue.async {
            let utterance = AVSpeechUtterance(string: text)
            let langVoices = self.voices.filter { $0.language == language }
            let pickedVoice = self.voicesMap[language]![voice == "Male" ? 1 : 0]
            print(pickedVoice)
            guard let sVoice = langVoices.first(where: { $0.name == pickedVoice }) else {
                return
            }
            
            utterance.voice = sVoice
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
