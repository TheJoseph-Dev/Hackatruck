import Foundation
import SwiftUI

struct DecodeConfig: Identifiable, Codable {
    var _id: String = ""
    var _rev: String = ""
    var id: String?
    var nome: String
    var toques: String
    var telefone: String
    var voz: String
    var idioma: String
}

struct UserConfig: Identifiable {
    static let holdOptions = [2, 3, 5, 8]
    static let voiceOptions = ["Male", "Female", "Taylor Swift", "Pelé"]
    static let languageOptions = ["pt-BR", "pt-PT", "en-US", "es-ES", "zh-CN", "ja-JP"]

    private var _id: String = ""
    private var _rev: String = ""
    var id: UUID = UUID()
    var nome: String
    var toques: Int
    var telefone: String
    var voz: String
    var idioma: String
    
    init(nome: String, touches: Int = UserConfig.holdOptions[0], telefone: String, voz: String = UserConfig.voiceOptions[0], idioma: String = UserConfig.languageOptions[0]) {
        self.nome = nome
        self.toques = touches
        self.telefone = telefone
        self.voz = voz
        self.idioma = idioma
    }
    
    init(from decode: DecodeConfig) {
        self._id = decode._id
        self._rev = decode._rev
        self.id = UUID(uuidString: decode.id ?? "") ?? UUID()
        self.nome = decode.nome
        self.telefone = decode.telefone
        self.voz = decode.voz
        
        let numberString = decode.toques
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        self.toques = Int(numberString) ?? 0
        self.idioma = decode.idioma
    }
}

extension UserConfig {
    func toDecodeConfig() -> DecodeConfig {
        return DecodeConfig(
            _id: self._id,
            _rev: self._rev,
            id: self.id.uuidString,
            nome: self.nome,
            toques: "\(toques) seconds",
            telefone: self.telefone,
            voz: self.voz,
            idioma: self.idioma
        )
    }
}


class ConfigurationManager: ObservableObject {
    let url: String
    @Published var currentConfig: UserConfig = UserConfig(nome: "", telefone: "")

    init(url: String = "http://192.168.128.9:1880/") {
        self.url = url
    }

    func loadProfile() async {
        guard let url = URL(string: self.url + "perfil/") else {
            print("URL inválida")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let jsonString = String(data: data, encoding: .utf8) {
                //print("Raw JSON string:\n\(jsonString)")
            } else {
                print("Failed to convert data to string")
            }
            let perfis = try JSONDecoder().decode([DecodeConfig].self, from: data)

            DispatchQueue.main.async {
                self.currentConfig = UserConfig(from: perfis.first!)
                print(self.currentConfig.nome)
            }

        } catch let DecodingError.keyNotFound(key, context) {
            print("Missing key: \(key.stringValue) - \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type mismatch for type \(type) - \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value not found for: \(value) - \(context.debugDescription)")
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context.debugDescription)")
        } catch {
            print("Unknown error: \(error)")
        }

    }
    
    func updateProfile() async {
        guard let url = URL(string: self.url + "perfil/") else {
            print("Invalid URL")
            return
        }
        
        let encodeConfig = currentConfig.toDecodeConfig()
        print(encodeConfig._id)
        print(encodeConfig._rev)
        do {
            let jsonData = try JSONEncoder().encode(encodeConfig)
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    print("Profile updated successfully")
                    
                    if let jsonString = String(data: data, encoding: .utf8) {
                        //print("Response JSON: \(jsonString)")
                    }
                    
                } else {
                    print("Server error: \(httpResponse.statusCode)")
                }
            }
        } catch {
            print("Error updating profile: \(error.localizedDescription)")
        }
    }

 }
