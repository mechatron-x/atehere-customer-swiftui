//
//  ActiveMenuView.swift
//  atehere
//
//  Created by Mehmet Kağan Aydoğan on 27.11.2024.
//

import SwiftUI

struct ActiveMenuView: View {
    @ObservedObject var viewModel: QRScanViewModel = QRScanViewModel()
    @State private var selectedMenuIndex: Int = 0

    var body: some View {
        NavigationStack {
            VStack {
                // Header with Restaurant Name and Cart Button
                HStack {
                    Text("Restaurant Name")
                        .font(.largeTitle.bold())

                    Spacer()

                    Button {
                        // TODO: Cart action
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

                // Picker for Menu Categories
                Picker("Menu", selection: $selectedMenuIndex) {
                    ForEach(viewModel.menus.indices, id: \.self) { index in
                        Text(viewModel.menus[index].category.capitalized)
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                // Selected Menu Category Title
                HStack {
                    Text(viewModel.menus[selectedMenuIndex].category)
                        .font(.title2)
                        .bold()

                    Spacer()
                }
                .padding()

                Divider()

                // Menu Items List
                ScrollView {
                    VStack {
                        ForEach(viewModel.menus[selectedMenuIndex].menuItems) { item in
                            MenuItemView(menuItem: item)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .onAppear {
                // Fetch menu data if not already fetched
                if viewModel.menus.isEmpty {
                    if let restaurantID = viewModel.qrCodeData?.restaurantID {
                        viewModel.fetchMenu(restaurantID: restaurantID)
                    }
                }
            }
        }
    }
}

