//
//  PastBillItem.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import Foundation

struct PastBillItem: Identifiable, Decodable {
    let id = UUID().uuidString

    let itemName: String
    let quantity: Int
    let unitPrice: Double
    let orderPrice: Double
    let paidPrice: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case itemName   = "item_name"
        case quantity
        case unitPrice  = "unit_price"
        case orderPrice = "order_price"
        case paidPrice  = "paid_price"
        case currency
    }
}
