//
//  API.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import Foundation

class API: ObservableObject {
    let apiURL: String
    @Published var items: [Item] = []
    
    init(apiURL: String) {
        self.apiURL = apiURL
    }
    
    func fetch() {
        guard let fetchURL = URL(string: self.apiURL + "/fetchItems") else {return}
        let task = URLSession.shared.dataTask(with: fetchURL) { [weak self] aData, _, aError in
            guard let data = aData, aError == nil else {return}
            
            do {
                let parsed = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async { self?.items = parsed }
            }
            catch { print(error); }
        }
        
        task.resume()
    }
    
    func add(item: Item) {
        guard let postURL = URL(string: self.apiURL + "/addItem") else {return}
        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("Trying to add to the API the item: \(item)")
        do {
            let jsonData = try JSONEncoder().encode(item)
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
                self.items.append(item)
            }
        }

        task.resume()
    }
}
