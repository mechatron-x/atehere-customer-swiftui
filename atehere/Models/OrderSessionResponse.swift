//
//  OrderSessionResponse.swift
//  atehere
//
//  Created by Berke Bozacı on 24.12.2024.
//

import Foundation

struct OrderSessionResponse: Decodable {
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}
