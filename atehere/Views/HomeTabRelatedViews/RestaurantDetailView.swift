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
                    if let phoneURL = URL(string: "tel://\(restaurant.phoneNumber.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: ""))") {
                        Link(destination: phoneURL) {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.blue)
                                Text(restaurant.phoneNumber)
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .font(.body)
                        }
                        .accessibilityLabel("Call \(restaurant.phoneNumber)")
                    } else {
                        Text(restaurant.phoneNumber)
                            .font(.body)
                    }
                    
                    Text("Working Days: \(restaurant.workingDays.joined(separator: ", "))")
                        .font(.body)
                    
                    Text("Working Hours: \(restaurant.openingTime) - \(restaurant.closingTime)")
                        .font(.body)
                }

                if !restaurant.locations.isEmpty {
                    Text("Locations:")
                        .font(.headline)
                    
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
                    Map(coordinateRegion: $region,
                       annotationItems: restaurant.locations) { location in
                       // Use MapAnnotation for clickable pins
                       MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                           Button(action: {
                               openMaps(location: location)
                           }) {
                               Image(systemName: "mappin.circle")
                                   .resizable()
                                   .frame(width: 30, height: 30)
                                   .foregroundColor(.blue)
                           }
                       }
                   }
                    .frame(height: 200)
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
                
                
//                else {
//                    Picker("Menu", selection: $selectedMenuIndex) {
//                        ForEach(menuViewModel.menus.indices, id: \.self) { index in
//                            Text(menuViewModel.menus[index].category.capitalized)
//                                .tag(index)
//                        }
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//
//                    HStack {
//                        Text(menuViewModel.menus[selectedMenuIndex].category.capitalized)
//                            .font(.title2)
//                            .padding(.top, 4)
//                            .bold()
//                        Spacer()
//                    }
//                    Divider()
//
//                    VStack {
//                        ForEach(menuViewModel.menus[selectedMenuIndex].menuItems ?? []) { item in
//                            DisplayMenuItemView(menuItem: item)
//                                .padding(.bottom, 4)
//                        }
//                    }
//                }
                else {
                    // Category Slider
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(menuViewModel.menus.indices, id: \.self) { index in
                                Button(action: {
                                    selectedMenuIndex = index
                                }) {
                                    Text(menuViewModel.menus[index].category.capitalized)
                                        .font(.caption)
                                        .fontWeight(selectedMenuIndex == index ? .bold : .regular)
                                        .foregroundColor(selectedMenuIndex == index ? .white : .blue)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(selectedMenuIndex == index ? Color.blue : Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .shadow(color: selectedMenuIndex == index ? Color.blue.opacity(0.5) : Color.clear, radius: 3, x: 0, y: 1)
                                        .scaleEffect(selectedMenuIndex == index ? 1.02 : 1.0)
                                }
                                .frame(minWidth: 120, maxWidth: 140)
                            }
                        }
                        .padding(.vertical, 8)
                    }

                    Divider()

                    // Selected Category Title
                    HStack {
                        Text(menuViewModel.menus[selectedMenuIndex].category.capitalized)
                            .font(.title3)
                            .padding(.top, 4)
                        Spacer()
                    }
                    Divider()

                    // Menu Items List
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
    
    private func openMaps(location: Coordinates) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurant.name

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        MKMapItem.openMaps(with: [mapItem], launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ])
    }
}
