//
//  RestaurantDetailView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 24.10.2024.
//

import SwiftUI

// Restaurant Detail View
struct RestaurantDetailView: View {
    let restaurant: Restaurant

    var body: some View {
        VStack {
            // Restaurant Image
            Image(restaurant.imageName)
                .resizable()
                .scaledToFit()

            // Restaurant Name
            Text(restaurant.name)
                .font(.largeTitle)
                .padding()

            Spacer()
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    RestaurantDetailView(restaurant: Restaurant(name: "Pizza Palace", imageName: "pizza_palace"))
}
