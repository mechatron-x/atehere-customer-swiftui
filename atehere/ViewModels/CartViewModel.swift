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

        let dispatchGroup = DispatchGroup()
        var errors: [String] = []

        for cartItem in cartItems {
            dispatchGroup.enter()

            submitCartItem(cartItem) { success, errorMessage in
                if !success {
                    if let errorMessage = errorMessage {
                        errors.append(errorMessage)
                    } else {
                        errors.append("Unknown error occurred while submitting cart item.")
                    }
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if errors.isEmpty {
                self.cartItems.removeAll()
                completion(true, nil)
            } else {
                completion(false, errors.joined(separator: "\n"))
            }
        }
    }

    private func submitCartItem(_ cartItem: CartItem, completion: @escaping (Bool, String?) -> Void) {
        AuthService.shared.getIdToken { [weak self] token in
            guard let self = self else { return }
            guard let bearerToken = token else {
                DispatchQueue.main.async {
                    completion(false, "Failed to retrieve bearer token.")
                }
                return
            }
            

            guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(self.tableID)/orders") else {
                DispatchQueue.main.async {
                    completion(false, "Invalid URL.")
                }
                return
            }

            let orderData: [String: Any] = [
                "menu_item_id": cartItem.menuItemId,
                "quantity": cartItem.quantity
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: orderData, options: []) else {
                DispatchQueue.main.async {
                    completion(false, "Failed to encode order data.")
                }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
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
}
