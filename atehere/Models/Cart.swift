//
//  Cart.swift
//  atehere
//
//  Created by Berke Bozacı on 30.11.2024.
//

import Foundation

struct Cart: Codable {
    let id: String
    let items: [CartItem]
}
