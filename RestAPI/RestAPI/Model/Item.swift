//
//  Item.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import Foundation

struct Item: Codable, Identifiable {
    private var _id: String = ""
    private var _rev: String = ""
    var id: String
    var title: String?
    var price: Float?
    var description: String?
    var image: String?
    
    init(title: String, price: Float, description: String, image: String) {
        self.id = String(Int.random(in: 1...1000))
        self.title = title
        self.price = price
        self.description = description
        self.image = image
    }
    
    // Avoid including _id and _rev when encoding
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case description
        case image
    }
}
