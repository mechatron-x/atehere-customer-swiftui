//
//  RestaurantDetailView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 24.10.2024.
//

import SwiftUI
import MapKit

struct RestaurantDetailView: View {
    let restaurant: Restaurant

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @StateObject private var menuViewModel: MenuViewModel

    @State private var selectedMenuIndex: Int = 0

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        _menuViewModel = StateObject(wrappedValue: MenuViewModel(restaurantID: restaurant.id))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(restaurant.name)
                    .font(.title)
                    .bold()
                    .padding(.top)

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

                VStack(alignment: .leading, spacing: 8) {
                    Text("Phone: \(restaurant.phoneNumber)")
                        .font(.body)
                    
                    Text("Working Days: \(restaurant.workingDays.joined(separator: ", "))")
                        .font(.body)
                    
                    Text("Working Hours: \(restaurant.openingTime) - \(restaurant.closingTime)")
                        .font(.body)
                }

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
                    .font(.title2)
                    .bold()

                if menuViewModel.isLoading {
                    ProgressView("Loading Menu...")
                }
                else if let errorMsg = menuViewModel.errorMessage {
                    Text(errorMsg)
                        .foregroundColor(.red)
                        .padding()
                }
                else if menuViewModel.menus.isEmpty {
                    Text("No menu items found.")
                        .foregroundColor(.gray)
                }
                else {
                    Picker("Menu", selection: $selectedMenuIndex) {
                        ForEach(menuViewModel.menus.indices, id: \.self) { index in
                            Text(menuViewModel.menus[index].category.capitalized)
                                .tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    HStack {
                        Text(menuViewModel.menus[selectedMenuIndex].category.capitalized)
                            .font(.headline)
                            .padding(.top, 4)
                        Spacer()
                    }
                    .padding(.horizontal)

                    VStack {
                        ForEach(menuViewModel.menus[selectedMenuIndex].menuItems ?? []) { item in
                            DisplayMenuItemView(menuItem: item)
                                .padding(.bottom, 4)
                        }
                    }
                }
                
            }
            .padding(.horizontal)
        }
        .onAppear {
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

