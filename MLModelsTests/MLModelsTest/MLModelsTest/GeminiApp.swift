import SwiftUI
import Foundation

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
    
    func createPrompt(from imageLabels: [YOLO.ImageLabel]) -> String {
        var prompt = "Voce sera responsavel por guiar uma pessoa com deficiencia visual e descrever o ambiente ao redor dela com base nas informacoes coletadas do ambiente que serao passadas a seguir. Seja bem objetivo e detalhado, sem palavras desnecesarias. Alem disso, se, e somente se, possivel, tente induzir o ambiente em que ela pode estar com base nisso. Interprete os seguintes dados de forma a indicar se um objeto esta próximo ou nao e utilize palavreas que expressam a probabilidade de realmente existir tal objeto. Dados: ";
        
        for imgLabel in imageLabels {
            prompt += "Label: \(imgLabel.name) - Confidence: \(imgLabel.confidence) - AproxDepth/Distance: \(imgLabel.getApproximateDepth())"
        }
        
        return prompt;
    }
    
    func call(prompt: String) async -> String {
       do {
           if let response = try await self.getDescription(for: prompt) {
               return response
           } else {
               return "Erro: descrição vazia."
           }
       } catch {
           return "Erro: \(error.localizedDescription)"
       }
   }
   
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
