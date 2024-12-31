//
//  BillData.swift
//  atehere
//
//  Created by Berke Bozacı on 27.12.2024.
//

import Foundation

struct BillData: Codable {
    let billItems: [BillItem]
    let totalDue: Double
    let remainingPrice: Double
    let individualPaymentTotal: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case billItems = "bill_items"
        case totalDue = "total_due"
        case remainingPrice = "remaining_price"
        case individualPaymentTotal = "individual_payment_total"
        case currency
    }
}
