//
//  CartView.swift
//  atehere
//
//  Created by Berke Bozacı on 30.11.2024.
//

import SwiftUI

struct CartView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @ObservedObject var menuViewModel: MenuViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingConfirmation = false
    @State private var confirmationMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                if cartViewModel.cartItems.isEmpty {
                    Text("Your cart is empty.")
                        .font(.headline)
                        .padding()
                } else {
                    List {
                        ForEach(cartViewModel.cartItems) { cartItem in
                            HStack {
                                Text(getMenuItemName(by: cartItem.menuItemId))
                                Spacer()
                                Text("Quantity: \(cartItem.quantity)")
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }

                    Button(action: {
                        cartViewModel.submitOrder { success, message in
                            if success {
                                confirmationMessage = "Your order has been submitted!"
                            } else {
                                confirmationMessage = message ?? "Failed to submit order."
                            }
                            showingConfirmation = true
                        }
                    }) {
                        Text("Submit Order")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Your Cart")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingConfirmation) {
                Alert(title: Text("Order Status"), message: Text(confirmationMessage), dismissButton: .default(Text("OK"), action: {
                    if confirmationMessage == "Your order has been submitted!" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
        }
    }

    func getMenuItemName(by id: String) -> String {
        for menu in menuViewModel.menus {
            if let item = menu.menuItems.first(where: { $0.id == id }) {
                return item.name
            }
        }
        return "Unknown Item"
    }

    func deleteItems(at offsets: IndexSet) {
        cartViewModel.cartItems.remove(atOffsets: offsets)
    }
}
