//
//  CartItem.swift
//  atehere
//
//  Created by Berke Bozacı on 30.11.2024.
//

import Foundation

struct CartItem: Codable, Identifiable {
    let id: String
    let menuItemId: String
    var quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case menuItemId = "menu_item_id"
        case quantity
        case id
    }
}
