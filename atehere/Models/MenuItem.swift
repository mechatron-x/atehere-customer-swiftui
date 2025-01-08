//
//  MenuItem.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import Foundation

struct MenuItem: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String?
    let price: Price
    let discountPercentage: Double
    let discountedPrice: Price
    let ingredients: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageUrl = "image_url"
        case price
        case discountPercentage = "discount_percentage"
        case discountedPrice = "discounted_price"
        case ingredients
    }
}
