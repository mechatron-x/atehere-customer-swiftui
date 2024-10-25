//
//  Customer.swift
//  atehere
//
//  Created by Berke Bozacı on 25.10.2024.
//

import Foundation

struct Customer: Codable {
    var email: String
    var password: String
    var fullName: String
    var gender: String?
    var birthDate: String

    enum CodingKeys: String, CodingKey {
        case email
        case password
        case fullName = "full_name"
        case gender
        case birthDate = "birth_date"
    }
}
