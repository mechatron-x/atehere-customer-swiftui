//
//  RestaurantInfo.swift
//  atehere
//
//  Created by Berke Bozacı on 29.12.2024.
//

import Foundation

struct RestaurantInfo: Codable, Identifiable {
    let id: String
    let name: String
    let phoneNumber: String
    let openingTime: String
    let closingTime: String
    let imageUrl: String
    var workingDays: [String]
    var locations: [Coordinates]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone_number"
        case openingTime = "opening_time"
        case closingTime = "closing_time"
        case imageUrl = "image_url"
        case workingDays = "working_days"
        case locations
    }
}
