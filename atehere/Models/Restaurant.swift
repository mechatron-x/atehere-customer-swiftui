//
//  Restaurant.swift
//  atehere
//
//  Created by Berke Bozacı on 11.11.2024.
//

import Foundation


struct Restaurant: Codable, Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let openingTime: String
    let closingTime: String
    let imageUrl: String
    var workingDays: [String]
    var locations: [Coordinates]
    
}
