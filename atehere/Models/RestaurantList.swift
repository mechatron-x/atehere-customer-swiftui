//
//  RestaurantList.swift
//  atehere
//
//  Created by Berke Bozacı on 12.11.2024.
//

import Foundation

struct RestaurantList: Codable {
    let availableWorkingDays: [String]
    let foundationYearFormat: String
    let workingTimeFormat: String
    let restaurants: [Restaurant]
}
