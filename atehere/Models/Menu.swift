//
//  Menu.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import Foundation

struct Menu: Codable, Identifiable {
    let id: String
    let category: String
    let menuItems: [MenuItem]

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case menuItems = "menu_items"
    }
}
