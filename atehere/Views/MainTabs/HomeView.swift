//
//  HomeView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 22.10.2024.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject var locationViewModel = LocationViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }

                VStack {
                    TextField("Search by name", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    if !viewModel.availableWorkingDays.isEmpty {
                        DaySelectionView(
                            selectedDays: $viewModel.selectedDays,
                            availableDays: viewModel.availableWorkingDays
                        )
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
                                    RestaurantRowView(
                                        restaurant: restaurant,
                                        isOpenToday: isOpenToday
                                    )
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Restaurants")
            .onAppear {
                viewModel.fetchRestaurants()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}
