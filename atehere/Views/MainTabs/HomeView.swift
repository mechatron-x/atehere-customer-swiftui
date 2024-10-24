//
//  HomeView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI

// Home Tab View
struct HomeView: View {
    var body: some View {
        NavigationView {
            List(restaurants) { restaurant in
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                RestaurantRow(restaurant: restaurant)
                            }
                        }
                        .navigationTitle("Restaurants")
        }
    }
}

// Data Model - to be changed later by the database integration
struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

// Sample Data
let restaurants = [
    Restaurant(name: "Pizza Palace", imageName: "pizza_palace"),
    Restaurant(name: "Sushi World", imageName: "sushi_world"),
    Restaurant(name: "Burger Barn", imageName: "burger_barn")
]

// Restaurant Row View
struct RestaurantRow: View {
    let restaurant: Restaurant

    var body: some View {
        HStack {
            // Restaurant Image
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(5)

            // Restaurant Name
            Text(restaurant.name)
                .font(.headline)
                .padding(.leading, 10)

            Spacer()

        }
        .padding(.vertical, 5)
    }
}

#Preview {
    HomeView()
}
