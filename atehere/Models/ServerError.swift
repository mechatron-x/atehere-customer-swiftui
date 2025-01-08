//
//  ServerError.swift
//  atehere
//
//  Created by Berke Bozacı on 25.10.2024.
//

import Foundation

struct ServerError: Decodable {
    let status: Int
    let code: String
    let message: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case status
        case code
        case message
        case createdAt = "created_at"
    }
}
