//
//  OrderItem.swift
//  atehere
//
//  Created by Berke Bozacı on 3.12.2024.
//

import Foundation

struct OrderItem: Codable, Identifiable {
    let id =  UUID()
    let menuItemName: String
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case menuItemName = "menu_item_name"
        case quantity
    }
}
