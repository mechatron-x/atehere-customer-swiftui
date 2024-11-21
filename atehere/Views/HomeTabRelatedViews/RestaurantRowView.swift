//
//  RestaurantRowView.swift
//  atehere
//
//  Created by Berke Bozacı on 12.11.2024.
//

import SwiftUI

struct RestaurantRowView: View {
    let restaurant: Restaurant
    let isOpenToday: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: restaurant.imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .padding(.trailing, 8)
                } else if phase.error != nil {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .padding(.trailing, 8)
                } else {
                    ProgressView()
                        .frame(width: 60, height: 60)
                        .padding(.trailing, 8)
                }
            }
                
                VStack(alignment: .leading) {
                    Text(restaurant.name)
                        .font(.headline)
                    Text("Open: \(restaurant.openingTime) - \(restaurant.closingTime)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    if isOpenToday {
                        Text("Open Today")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    } else {
                        Text("Closed Today")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.vertical, 4)
        }
}
