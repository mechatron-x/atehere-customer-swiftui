//
//  Invoice.swift
//  atehere
//
//  Created by Berke Bozacı on 3.12.2024.
//

import Foundation

struct Invoice: Codable {
    let orders: [OrderItem]
}
