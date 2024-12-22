//
//  TableOrderItem.swift
//  atehere
//
//  Created by Berke Bozacı on 8.12.2024.
//

import Foundation

struct TableOrderItem: Codable, Identifiable {
    let id = UUID()
    let customerFullName: String
    let menuItemName: String
    let quantity: Int
    let unitPrice: Double
    let totalPrice: Double

    enum CodingKeys: String, CodingKey {
        case customerFullName = "customer_full_name"
        case menuItemName = "menu_item_name"
        case quantity
        case unitPrice = "unit_price"
        case totalPrice = "total_price"
    }
}
