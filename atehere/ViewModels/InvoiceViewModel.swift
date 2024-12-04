//
//  InvoiceViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 3.12.2024.
//

import Foundation
import SwiftUI

class InvoiceViewModel: ObservableObject {
    @Published var orderItems: [OrderItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var tableID: String

    init(tableID: String) {
        self.tableID = tableID
    }

    func fetchOrders() {
        
        guard !tableID.isEmpty else {
            self.errorMessage = "Table ID is missing."
            return
        }
        

        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(tableID)/customers/orders") else {
            self.errorMessage = "Invalid URL."
            self.isLoading = false
            return
        }
        
        

        AuthService.shared.getIdToken { [weak self] token in
            guard let self = self else { return }
            guard let bearerToken = token else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to retrieve bearer token."
                    self.isLoading = false
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false

                    if let error = error {
                        self.errorMessage = "Network error: \(error.localizedDescription)"
                        return
                    }

                    guard let data = data else {
                        self.errorMessage = "No data received from server."
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        let payload = try decoder.decode(ResponsePayload<Invoice>.self, from: data)

                        if let payloadData = payload.data {
                            self.orderItems = payloadData.orders
                        } else if let payloadError = payload.error {
                            self.errorMessage = payloadError.message
                        } else {
                            self.errorMessage = "Failed to load menu."
                        }
                    } catch {
                        self.errorMessage = "Failed to parse menu data."
                        print("Decoding error: \(error)")
                    }
                }
            }.resume()
        }
    }
}
