//
//  Item.swift
//  RestAPI
//
//  Created by Turma01-23 on 14/07/25.
//

import Foundation

struct Item: Decodable, Identifiable {
    var id: Int
    var title: String?
    var price: Float?
    var description: String?
    var image: String?
}
