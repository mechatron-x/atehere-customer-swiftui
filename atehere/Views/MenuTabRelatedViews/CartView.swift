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
            VStack(alignment: .leading) {
                // Title
                Text("Your Cart")
                    .font(.largeTitle.bold())
                    .padding(.horizontal)
                    .padding(.top)

                if cartViewModel.cartItems.isEmpty {
                    Spacer()
                    VStack {
                        Text("Your cart is empty.")
                            .font(.headline)
                            .padding(.bottom, 4)
                        Text("Go to the menu to order some delicious foods.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(cartViewModel.cartItems) { cartItem in
                            let menuItem = findMenuItem(by: cartItem.menuItemId)
                            CartItemRowView(
                                cartItem: cartItem,
                                menuItem: menuItem,
                                onDelete: {
                                    deleteItem(item: cartItem)
                                },
                                onQuantityChange: { newQuantity in
                                    updateQuantity(for: cartItem, quantity: newQuantity)
                                }
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                        }
                    }
                }

                Spacer()

                if !cartViewModel.cartItems.isEmpty {
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
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingConfirmation) {
                Alert(title: Text("Order Status"),
                      message: Text(confirmationMessage),
                      dismissButton: .default(Text("OK"), action: {
                    if confirmationMessage == "Your order has been submitted!" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
            .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        }
    }

    // MARK: - Helper Methods

    private func findMenuItem(by id: String) -> MenuItem? {
        for menu in menuViewModel.menus {
            if let item = menu.menuItems.first(where: { $0.id == id }) {
                return item
            }
        }
        return nil
    }

    private func deleteItem(item: CartItem) {
        if let index = cartViewModel.cartItems.firstIndex(where: { $0.menuItemId == item.menuItemId }) {
            cartViewModel.cartItems.remove(at: index)
        }
    }

    private func updateQuantity(for item: CartItem, quantity: Int) {
        if let index = cartViewModel.cartItems.firstIndex(where: { $0.menuItemId == item.menuItemId }) {
            cartViewModel.cartItems[index].quantity = quantity
        }
    }
}
