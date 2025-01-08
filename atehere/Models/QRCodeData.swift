//
//  QRCodeData.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import Foundation
struct QRCodeData: Codable, Equatable {
    let tableID: String?
    let restaurantID: String?

    enum CodingKeys: String, CodingKey {
        case tableID = "table_id"
        case restaurantID = "restaurant_id"
    }
}
