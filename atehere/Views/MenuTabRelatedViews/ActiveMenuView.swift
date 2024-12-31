//
//  ActiveMenuView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 27.11.2024.
//

import SwiftUI

struct ActiveMenuView: View {
    let qrCodeData: QRCodeData

    @StateObject private var menuViewModel: MenuViewModel
    @StateObject private var cartViewModel: CartViewModel
    @StateObject private var restaurantViewModel: RestaurantViewModel

    @State private var selectedMenuIndex: Int = 0
    @State private var showingCart = false
    @State private var showingAddToCart = false
    @State private var selectedMenuItem: MenuItem?

    init(qrCodeData: QRCodeData) {
        self.qrCodeData = qrCodeData
        _menuViewModel = StateObject(wrappedValue: MenuViewModel(restaurantID: qrCodeData.restaurantID ?? ""))
        _cartViewModel = StateObject(wrappedValue: CartViewModel(tableID: qrCodeData.tableID ?? ""))
        _restaurantViewModel = StateObject(wrappedValue: RestaurantViewModel(restaurantID: qrCodeData.restaurantID ?? ""))
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if restaurantViewModel.isLoading {
                        ProgressView("Loading Restaurant...")
                    } else if let errorMsg = restaurantViewModel.errorMessage {
                        Text(errorMsg)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    } else if let restaurant = restaurantViewModel.restaurant {
                        Text(restaurant.name)
                            .font(.largeTitle.bold())
                    } else {
                        Text("Restaurant Name")
                            .font(.largeTitle.bold())
                    }

                    Spacer()

                    Button {
                        showingCart = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 70, height: 40)

                            Image(systemName: "cart.fill")
                                .foregroundColor(.black)
                                .font(.title)
                        }
                    }
                }
                .padding(.horizontal)

                if !menuViewModel.menus.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(menuViewModel.menus.indices, id: \.self) { index in
                                Button(action: {
                                    selectedMenuIndex = index
                                }) {
                                    Text(menuViewModel.menus[index].category.capitalized)
                                        .font(.subheadline)
                                        .fontWeight(selectedMenuIndex == index ? .bold : .regular)
                                        .foregroundColor(selectedMenuIndex == index ? .white : .blue)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(selectedMenuIndex == index ? Color.blue : Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                    }
                }

                HStack {
                    if !menuViewModel.menus.isEmpty {
                        Text(menuViewModel.menus[selectedMenuIndex].category)
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.top, 4)
                .padding(.horizontal)

                Divider()

                // Main content: Menu Items or Loading/Error
                if menuViewModel.isLoading {
                    ProgressView("Loading Menu...")
                } else if let errorMessage = menuViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            // Show items of the selected menu
                            if let items = menuViewModel.menus[safe: selectedMenuIndex]?.menuItems {
                                ForEach(items) { item in
                                    MenuItemView(menuItem: item) {
                                        // On "Add to Cart" action
                                        selectedMenuItem = item
                                        showingAddToCart = true
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Menu") // You can keep or remove the nav bar title
            .sheet(isPresented: $showingCart) {
                CartView(cartViewModel: cartViewModel, menuViewModel: menuViewModel)
            }
            .sheet(item: $selectedMenuItem) { menuItem in
                AddToCartView(menuItem: menuItem, cartViewModel: cartViewModel)
            }
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
