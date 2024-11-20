//
//  QRMenuView.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import SwiftUI

struct QRMenuView: View {
    let restaurantID: String
        let tableID: String
        
        var body: some View {
            VStack {
                Text("Restaurant ID: \(restaurantID)")
                Text("Table ID: \(tableID)")
            }
            .navigationTitle("Menu")
        }
}

