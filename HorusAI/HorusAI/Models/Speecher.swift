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
    static private let voices = AVSpeechSynthesisVoice.speechVoices()
    private let voicesMap: [String: [String]] = [
        "pt-BR": ["com.apple.voice.enhanced.pt-BR.Luciana", "com.apple.voice.enhanced.pt-BR.Felipe"], // change -compact to -premium and download the voice bundle
        "pt-PT": ["com.apple.ttsbundle.Joana-compact", "João"],
        "en-US": ["com.apple.ttsbundle.siri_nicky_en-US_compact", "com.apple.speech.synthesis.voice.Fred"],
        "es-ES": ["com.apple.ttsbundle.Monica-compact", "Jorge"],
        "zh-CN": ["com.apple.ttsbundle.Mei-Jia-compact", "com.apple.ttsbundle.siri_male_zh-CN_compact"],
        "ja-JP": ["com.apple.voice.enhanced.ja-JP.Kyoko", "com.apple.ttsbundle.siri_hattori_ja-JP_compact"]
    ]

    override init() {
        super.init()
        synthesizer.delegate = self
        //print("====> Speech Synthesizer voices = ", Speecher.voices)
    }

    func speak(_ text: String, language: String, voice: String) {
        queue.async {
            let utterance = AVSpeechUtterance(string: text)
            let pickedVoice = self.voicesMap[language]![voice == "Male" ? 1 : 0]

            
                // To get all available voices:
            

                // You will see what are the available voices on the device.
                // Else, you have to go to the Settings -> Accessibility -> Live Speech -> English (or the language) => Download form the list if it is not downloaded.
                // In my case I had to download above two, and then those two showed up with above command on my App.
            
            
            utterance.voice = AVSpeechSynthesisVoice(identifier: pickedVoice)
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
