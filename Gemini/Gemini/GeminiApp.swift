import SwiftUI
import Foundation

@main
struct GeminiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct GeminiRequest: Codable {
    struct Content: Codable {
        struct Part: Codable {
            let text: String
        }
        let parts: [Part]
    }
    let contents: [Content]
}

struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String
            }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}

class Gemini {
    static let shared = Gemini()
    
    private let apiKey = "AIzaSyC63SWM2BVhBXaUb-9UV3Ezf-QLuPrTT1g"
    
    func call(prompt: String) async -> String {
           do {
               if let response = try await getDescription(for: prompt) {
                   return response
               } else {
                   return "Erro: descrição vazia."
               }
           } catch {
               return "Erro: \(error.localizedDescription)"
           }
       }
       
       // Função privada usando async/await
       private func getDescription(for objectName: String) async throws -> String? {
           guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=\(apiKey)") else {
               return nil
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"
           request.addValue("application/json", forHTTPHeaderField: "Content-Type")

           let prompt = "Descreva detalhadamente o seguinte objeto como se estivesse explicando para uma pessoa cega: \(objectName)"
           let body = GeminiRequest(contents: [.init(parts: [.init(text: prompt)])])
           request.httpBody = try JSONEncoder().encode(body)

           let (data, _) = try await URLSession.shared.data(for: request)

           let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
           return geminiResponse.candidates.first?.content.parts.first?.text
       }
}
