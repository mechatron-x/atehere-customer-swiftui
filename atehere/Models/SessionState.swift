//
//  SessionState.swift
//  atehere
//
//  Created by Berke Bozacı on 27.12.2024.
//

import Foundation

struct StateResponse: Decodable {
    let state: String
    let availableStates: [String]
    
    enum CodingKeys: String, CodingKey {
        case state = "session_state"
        case availableStates = "available_session_states"
    }
}
