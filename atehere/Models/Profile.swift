//
//  Profile.swift
//  atehere
//
//  Created by Berke Bozacı on 2.11.2024.
//

import Foundation

struct Profile: Codable {
    var email: String
    var fullName: String
    var gender: String?
    var birthDate: String

    enum CodingKeys: String, CodingKey {
        case email
        case fullName = "full_name"
        case gender
        case birthDate = "birth_date"
    }
}
