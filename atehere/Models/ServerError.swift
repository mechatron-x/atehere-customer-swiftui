//
//  ServerError.swift
//  atehere
//
//  Created by Berke Bozacı on 25.10.2024.
//

import Foundation

struct ServerError: Decodable {
    let code: Int
    let message: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case code
        case message
        case createdAt = "created_at"
    }
}
