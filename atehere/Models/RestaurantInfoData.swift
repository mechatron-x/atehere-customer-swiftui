//
//  RestaurantInfoData.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import Foundation
struct RestaurantInfoData: Codable {
    let availableWorkingDays: [String]
    let foundationYearFormat: String
    let workingTimeFormat: String
    let restaurant: RestaurantInfo
    
    enum CodingKeys: String, CodingKey {
        case availableWorkingDays = "available_working_days"
        case foundationYearFormat = "foundation_year_format"
        case workingTimeFormat = "working_time_format"
        case restaurant
    }
}
