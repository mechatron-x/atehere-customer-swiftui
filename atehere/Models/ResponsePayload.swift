//
//  ResponsePayload.swift
//  atehere
//
//  Created by Berke Bozacı on 17.11.2024.
//

import Foundation

struct ResponsePayload<T: Decodable>: Decodable {
    var data: T?
    var error: ServerError?
}
