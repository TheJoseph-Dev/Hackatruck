import SwiftUI
import AVFoundation

// Classe helper para fala
class SpeechHelper: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var isSpeaking = false

    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        synthesizer.speak(utterance)
        isSpeaking = true
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

// View principal
struct ContentView: View {
    @State private var input = ""
    @State private var descriptionText = ""
    @State private var isLoading = false

    @StateObject private var speechHelper = SpeechHelper()

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    TextField("Digite o nome do objeto", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Descrever objeto") {
                        isLoading = true
                        Task {
                                let text = await Gemini.shared.call(prompt: input)
                                DispatchQueue.main.async {
                                    isLoading = false
                                    descriptionText = text
                                    speechHelper.speak(text)
                                }
                            }
                    }
                    .disabled(input.isEmpty)
                    .padding()

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        ScrollView {
                            Text(descriptionText)
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                    }

                    Spacer()
                }

                // Botão invisível para parar fala
                if speechHelper.isSpeaking {
                    Button(action: {
                        speechHelper.stopSpeaking()
                    }) {
                        Color.clear
                    }
                    .accessibilityLabel("Toque para parar a descrição falada")
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationTitle("Acessibilidade AI")
        }
    }
}

#Preview {
    ContentView()
}
