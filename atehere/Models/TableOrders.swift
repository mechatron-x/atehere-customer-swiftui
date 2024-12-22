//
//  TableOrders.swift
//  atehere
//
//  Created by Berke Bozacı on 8.12.2024.
//

import Foundation

struct TableOrders: Codable {
    let orders: [TableOrderItem]
    let totalPrice: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case orders
        case totalPrice = "total_price"
        case currency
    }
}
