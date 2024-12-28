//
//  PastBill.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import Foundation

struct PastBill: Identifiable, Decodable {
    let id: String
    let restaurantName: String
    let billItems: [PastBillItem]

    enum CodingKeys: String, CodingKey {
        case id = "bill_id"
        case restaurantName = "restaurant_name"
        case billItems = "bill_items"
    }
}
