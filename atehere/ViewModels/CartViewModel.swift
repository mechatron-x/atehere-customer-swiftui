//
//  CartViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 30.11.2024.
//

import Foundation
import SwiftUI

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var errorMessage: String?

    let tableID: String

    init(tableID: String) {
        self.tableID = tableID
    }

    func addToCart(menuItem: MenuItem, quantity: Int) {
        if let existingIndex = cartItems.firstIndex(where: { $0.menuItemId == menuItem.id }) {
            cartItems[existingIndex].quantity += quantity
        } else {
            let cartItem = CartItem(id: UUID().uuidString, menuItemId: menuItem.id, quantity: quantity)
            cartItems.append(cartItem)
        }
    }

    func submitOrder(completion: @escaping (Bool, String?) -> Void) {
        guard !cartItems.isEmpty else {
            completion(false, "Cart is empty.")
            return
        }

        guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(tableID)/orders") else {
            completion(false, "Invalid URL.")
            return
        }

        let orderItems = cartItems.map { ["menu_item_id": $0.menuItemId, "quantity": $0.quantity] }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: orderItems, options: []) else {
            completion(false, "Failed to encode order data.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, "Network error: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(false, "Invalid server response.")
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    self.cartItems.removeAll()
                    completion(true, nil)
                } else {
                    if let data = data, let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                        completion(false, serverError.message)
                    } else {
                        completion(false, "Failed to submit order.")
                    }
                }
            }
        }.resume()
    }
}

