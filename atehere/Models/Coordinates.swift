//
//  Coordinates.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import Foundation

struct Coordinates: Codable, Hashable, Identifiable {
    let latitude: Double
    let longitude: Double
    
    var id: UUID { UUID() }

}
