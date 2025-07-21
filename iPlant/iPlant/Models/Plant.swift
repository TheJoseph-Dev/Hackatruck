//
//  Plant.swift
//  iPlant
//
//  Created by Turma01-23 on 21/07/25.
//

import Foundation



struct Plant: Hashable, Codable {
    private(set) var name: String
    private(set) var description: String
    private(set) var idealUmidity: Double
    private(set) var image: String
    private(set) var umidity: Double = 0
    
    init(name: String, description: String = "", idealUmidity: Double, image: String = "") {
        self.name = name
        self.description = description
        self.idealUmidity = idealUmidity
        self.image = image;
    }
    
    mutating func update(name: String) {
        self.name = name;
    }
    
    mutating func update(description: String) {
        self.description = description;
    }
    
    mutating func update(image: String) {
        self.image = image;
    }
    
    mutating func update(idealUmidity: Double) {
        self.idealUmidity = idealUmidity;
    }
    
    mutating func update(umidity: Double) {
        self.umidity = umidity;
    }
}
