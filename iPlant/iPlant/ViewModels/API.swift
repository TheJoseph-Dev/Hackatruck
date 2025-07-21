//
//  API.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import Foundation

struct UmidityData: Hashable, Decodable {
    let umidity: String?
}

class API: ObservableObject {
    let apiURL: String
    @Published var plants: [Plant] = [Plant(name: "Samambaia", idealUmidity: 50)]
    
    init(apiURL: String) {
        self.apiURL = apiURL
    }
    
    func fetch() {
        guard let fetchURL = URL(string: self.apiURL + "/fetchData") else {return}
        let task = URLSession.shared.dataTask(with: fetchURL) { [weak self] aData, _, aError in
            guard let data = aData, aError == nil else {return}
            
            do {
                let parsed = try JSONDecoder().decode([UmidityData].self, from: data)
                DispatchQueue.main.async {
                    print(parsed)
                    for i in 0..<(self?.plants.count ?? 0) {
                        self?.plants[i].update(umidity: Double(parsed[parsed.count-i-1].umidity ?? "-1.0") ?? 0);
                    }
                }
            }
            catch { print(error); }
        }
        
        task.resume()
    }
    
    func add(plant: Plant) {
        guard let postURL = URL(string: self.apiURL + "/add") else {return}
        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Trying to add to the API the item: \(plant)")
        do {
            let jsonData = try JSONEncoder().encode(plant)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode item:", error)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil else {
                print("Request error:", error!)
                return
            }

            DispatchQueue.main.async {
                self.plants.append(plant)
            }
        }

        task.resume()
    }
}
