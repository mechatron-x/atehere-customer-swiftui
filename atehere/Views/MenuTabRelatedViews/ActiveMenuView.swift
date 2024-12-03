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
    @State private var selectedMenuIndex: Int = 0
    @State private var showingCart = false
    @State private var showingAddToCart = false
    @State private var selectedMenuItem: MenuItem?

    init(qrCodeData: QRCodeData) {
        self.qrCodeData = qrCodeData
        _menuViewModel = StateObject(wrappedValue: MenuViewModel(restaurantID: qrCodeData.restaurantID))
        _cartViewModel = StateObject(wrappedValue: CartViewModel(tableID: qrCodeData.tableID))
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // TODO: Add Restaurant Name From ViewModel
                    Text("Restaurant Name")
                        .font(.largeTitle.bold())

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
                    Picker("Menu", selection: $selectedMenuIndex) {
                        ForEach(menuViewModel.menus.indices, id: \.self) { index in
                            Text(menuViewModel.menus[index].category.capitalized)
                                .tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }

                HStack {
                    if !menuViewModel.menus.isEmpty {
                        Text(menuViewModel.menus[selectedMenuIndex].category)
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                }
                .padding()

                Divider()

                if menuViewModel.isLoading {
                    ProgressView("Loading Menu...")
                } else if let errorMessage = menuViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(menuViewModel.menus[selectedMenuIndex].menuItems ?? []) { item in
                                MenuItemView(menuItem: item) {
                                    selectedMenuItem = item
                                    showingAddToCart = true
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Menu")
            .sheet(isPresented: $showingCart) {
                CartView(cartViewModel: cartViewModel, menuViewModel: menuViewModel)
            }
            .sheet(item: $selectedMenuItem) { menuItem in
                AddToCartView(menuItem: menuItem, cartViewModel: cartViewModel)
            }
        }
    }
}


