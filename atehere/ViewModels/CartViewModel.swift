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
    @Published var sessionID: String?
    
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

            guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(tableID)/order") else {
                completion(false, "Invalid URL.")
                return
            }
        
            let orderItems = cartItems.map { ["menu_item_id": $0.menuItemId, "quantity": $0.quantity] }
            let requestBody: [String: Any] = ["orders": orderItems]

            AuthService.shared.getIdToken { [weak self] token in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    guard let bearerToken = token else {
                        completion(false, "Failed to retrieve bearer token.")
                        return
                    }

                    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
                        completion(false, "Failed to encode order data.")
                        return
                    }

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
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
                                do {
                                    let payload = try JSONDecoder().decode(ResponsePayload<OrderSessionResponse>.self, from: data!)
                                    if let sessionData = payload.data {
                                        self.sessionID = sessionData.sessionId
                                        self.cartItems.removeAll()
                                        UserDefaults.standard.set(sessionData.sessionId, forKey: "session_id")
                                        //print("Session_id: ", self.sessionID)
                                        completion(true, nil)
                                    } else if let payloadError = payload.error {
                                        completion(false, payloadError.message)
                                    } else {
                                        completion(true, "Order created, but no session ID found.")
                                    }
                                } catch {
                                    print("Decoding error: \(error)")
                                    completion(true, "Order created, but parsing session ID failed.")
                                }
                            } else {
                                print("Status code: \(httpResponse.statusCode)")
                                if let data = data {
                                    let rawString = String(data: data, encoding: .utf8) ?? "nil"
                                    print("Raw server response: \(rawString)")
                                    if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                                        completion(false, serverError.message)
                                    } else {
                                        completion(false, "Failed to submit order. Unknown error.")
                                    }
                                } else {
                                    completion(false, "Failed to submit order. No data received.")
                                }
                            }

                        }
                    }.resume()
                }
            }
        }
    
}

