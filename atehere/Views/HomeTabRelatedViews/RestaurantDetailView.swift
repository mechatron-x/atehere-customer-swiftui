//
//  RestaurantDetailView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 24.10.2024.
//

import SwiftUI
import MapKit

//struct RestaurantDetailView: View {
//    let restaurant: Restaurant
//
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading) {
//                Text(restaurant.name)
//                    .font(.title)
//                    .bold()
//                    .padding(.top)
//
//                AsyncImage(url: URL(string: restaurant.imageUrl)) { phase in
//                    switch phase {
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(maxWidth: .infinity)
//                            .cornerRadius(8)
//                    case .failure(_):
//                        Image(systemName: "photo")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(maxWidth: .infinity)
//                    case .empty:
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//                .padding(.top)
//
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Phone: \(restaurant.phoneNumber)")
//                        .font(.body)
//                    Text("Working Days: \(restaurant.workingDays.joined(separator: ", "))")
//                        .font(.body)
//                }
//                .padding(.top)
//
//                if !restaurant.locations.isEmpty {
//                    Text("Locations:")
//                        .font(.headline)
//                        .padding(.top, 8)
//
//                    Map(coordinateRegion: $region,
//                        annotationItems: restaurant.locations
//                    ) { location in
//                        MapMarker(
//                            coordinate: CLLocationCoordinate2D(
//                                latitude: location.latitude,
//                                longitude: location.longitude
//                            ),
//                            tint: .blue
//                        )
//                    }
//                    .frame(height: 300)
//                    .cornerRadius(8)
//                    .padding(.top, 4)
//                }
//            }
//            .padding(.horizontal)
//        }
//        .onAppear {
//            if let firstLoc = restaurant.locations.first {
//                region.center = CLLocationCoordinate2D(
//                    latitude: firstLoc.latitude,
//                    longitude: firstLoc.longitude
//                )
//            }
//        }
//        .navigationTitle(restaurant.name)
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}


import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    // For the map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    // 1) The MenuViewModel to fetch & display menus
    @StateObject private var menuViewModel: MenuViewModel

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        // 2) Initialize the MenuViewModel with the restaurant.id
        _menuViewModel = StateObject(wrappedValue: MenuViewModel(restaurantID: restaurant.id))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Title
                Text(restaurant.name)
                    .font(.title)
                    .bold()
                    .padding(.top)

                // Image
                AsyncImage(url: URL(string: restaurant.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                    case .failure(_):
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }

                // Basic info
                VStack(alignment: .leading, spacing: 10) {
                    Text("Phone: \(restaurant.phoneNumber)")
                    Text("Working Days: \(restaurant.workingDays.joined(separator: ", "))")
                    // e.g. openingTime, closingTime, etc.
                }

                // MARK: Map with multiple pins
                if !restaurant.locations.isEmpty {
                    Text("Locations:")
                        .font(.headline)
                    
                    Map(coordinateRegion: $region,
                        annotationItems: restaurant.locations
                    ) { location in
                        MapMarker(
                            coordinate: CLLocationCoordinate2D(
                                latitude: location.latitude,
                                longitude: location.longitude
                            ),
                            tint: .blue
                        )
                    }
                    .frame(height: 300)
                    .cornerRadius(8)
                }

                Divider().padding(.vertical, 8)

                // MARK: Menu Section
                Text("Menu")
                    .font(.headline)

                if menuViewModel.isLoading {
                    ProgressView("Loading Menu...")
                } else if let errorMsg = menuViewModel.errorMessage {
                    Text(errorMsg)
                        .foregroundColor(.red)
                        .padding()
                } else if menuViewModel.menus.isEmpty {
                    Text("No menu items found.")
                        .foregroundColor(.gray)
                } else {
                    // The menus array you have is `[Menu]`, each Menu can have `category` and `[MenuItem]`.
                    ForEach(menuViewModel.menus) { menu in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(menu.category)
                                .font(.headline)
                            ForEach(menu.menuItems) { item in
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                        .font(.subheadline)
                                        .bold()
                                    Text(item.description)
                                        .foregroundColor(.gray)
                                        .font(.footnote)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }

            }
            .padding(.horizontal)
        }
        .onAppear {
            // If you want to center the map on the first location
            if let firstLoc = restaurant.locations.first {
                region.center = CLLocationCoordinate2D(
                    latitude: firstLoc.latitude,
                    longitude: firstLoc.longitude
                )
            }
        }
        .navigationTitle(restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
