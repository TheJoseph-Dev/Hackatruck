//
//  API.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import Foundation

class API: ObservableObject {
    @Published var items: [Item] = []
    
    func fetch() {
        guard let fetchURL = URL(string: "https://fakestoreapi.com/products") else {return}
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
}
