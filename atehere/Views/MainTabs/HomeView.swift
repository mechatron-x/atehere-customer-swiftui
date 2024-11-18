//
//  HomeView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI

// Home Tab View
struct HomeView: View {
//    var body: some View {
//        NavigationView {
//            List(restaurants) { restaurant in
//                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
//                                RestaurantRow(restaurant: restaurant)
//                            }
//                        }
//                        .navigationTitle("Restaurants")
//        }
//    }
    
    @StateObject private var viewModel = HomeViewModel()

        var body: some View {
            NavigationView {
                VStack {
                    TextField("Search by name", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    if !viewModel.availableWorkingDays.isEmpty {
                        DaySelectionView(selectedDays: $viewModel.selectedDays, availableDays: viewModel.availableWorkingDays)
                    }

                    Group {
                        if viewModel.isLoading {
                            ProgressView("Loading Restaurants...")
                        } else if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        } else if viewModel.filteredRestaurants.isEmpty {
                            Text("No restaurants available.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            List(viewModel.filteredRestaurants) { restaurant in
                                let today = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1].lowercased()
                                let isOpenToday = restaurant.workingDays.contains(today)

                                NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                                    RestaurantRowView(restaurant: restaurant, isOpenToday: isOpenToday)
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    Spacer()
                    
                    .navigationTitle("Restaurants")
                    .onAppear {
                        viewModel.fetchRestaurants()
                    }
                }
            }
        }
}

// Data Model - to be changed later by the database integration
//struct Restaurant: Identifiable {
//    let id = UUID()
//    let name: String
//    let imageName: String
//}

// Sample Data
//let restaurants = [
//    Restaurant(name: "Pizza Palace", imageName: "pizza_palace"),
//    Restaurant(name: "Sushi World", imageName: "sushi_world"),
//    Restaurant(name: "Burger Barn", imageName: "burger_barn")
//]

// Restaurant Row View
//struct RestaurantRow: View {
//    let restaurant: Restaurant
//
//    var body: some View {
//        HStack {
//            // Restaurant Image
//            Image(restaurant.imageName)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 50, height: 50)
//                .clipped()
//                .cornerRadius(5)
//
//            // Restaurant Name
//            Text(restaurant.name)
//                .font(.headline)
//                .padding(.leading, 10)
//
//            Spacer()
//
//        }
//        .padding(.vertical, 5)
//    }
//}

#Preview {
    HomeView()
}
