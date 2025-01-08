//
//  BillItem.swift
//  atehere
//
//  Created by Berke Bozacı on 24.12.2024.
//

import Foundation

struct BillItem: Identifiable, Codable {
    let id: String
    let ownerId: String
    let itemName: String
    let unitPrice: Double
    let quantity: Int
    let totalDue: Double
    let remainingPrice: Double
    let individualPayment: Double
    let currency: String
    let isAllPaid: Bool    

    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case itemName = "item_name"
        case unitPrice = "unit_price"
        case quantity
        case totalDue = "total_due"
        case remainingPrice = "remaining_price"
        case individualPayment = "individual_payment"
        case currency
        case isAllPaid = "is_all_paid"
    }
}
