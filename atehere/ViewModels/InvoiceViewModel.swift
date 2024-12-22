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
    @Published var tableOrderItems: [TableOrderItem] = []
    @Published var tableTotalPrice: Double = 0.0
    @Published var tableCurrency: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    var tableID: String

    init(tableID: String) {
        self.tableID = tableID
    }

    func fetchAllOrders() {
        self.isLoading = true
        self.errorMessage = nil

        let group = DispatchGroup()
        var localError: String?

        group.enter()
        fetchCustomerOrders { success, message in
            if !success {
                localError = message
            }
            group.leave()
        }

        group.enter()
        fetchTableOrders { success, message in
            if !success {
                localError = message
            }
            group.leave()
        }

        group.notify(queue: .main) {
            self.isLoading = false
            if let localError = localError {
                self.errorMessage = localError
            }
        }
    }

    private func fetchCustomerOrders(completion: @escaping (Bool, String?) -> Void) {
        guard !tableID.isEmpty else {
            completion(false, "Table ID is missing.")
            return
        }

        guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(tableID)/orders?role=customer") else {
            completion(false, "Invalid URL.")
            return
        }

        AuthService.shared.getIdToken { token in
            DispatchQueue.main.async {
                guard let bearerToken = token else {
                    completion(false, "Failed to retrieve bearer token.")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(false, "Network error: \(error.localizedDescription)")
                            return
                        }

                        guard let data = data else {
                            completion(false, "No data received from server.")
                            return
                        }

                        do {
                            let decoder = JSONDecoder()
                            let payload = try decoder.decode(ResponsePayload<Invoice>.self, from: data)
                            if let payloadData = payload.data {
                                self.orderItems = payloadData.orders
                                completion(true, nil)
                            } else if let payloadError = payload.error {
                                completion(false, payloadError.message)
                            } else {
                                completion(false, "Failed to load customer orders.")
                            }
                        } catch {
                            completion(false, "Failed to parse customer orders.")
                        }
                    }
                }.resume()
            }
        }
    }

    private func fetchTableOrders(completion: @escaping (Bool, String?) -> Void) {
        guard !tableID.isEmpty else {
            completion(false, "Table ID is missing.")
            return
        }

        guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(tableID)/orders") else {
            completion(false, "Invalid URL.")
            return
        }

        AuthService.shared.getIdToken { token in
            DispatchQueue.main.async {
                guard let bearerToken = token else {
                    completion(false, "Failed to retrieve bearer token.")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            completion(false, "Network error: \(error.localizedDescription)")
                            return
                        }

                        guard let data = data else {
                            completion(false, "No data received from server.")
                            return
                        }

                        do {
                            let decoder = JSONDecoder()
                            let payload = try decoder.decode(ResponsePayload<TableOrders>.self, from: data)
                            if let tableData = payload.data {
                                self.tableOrderItems = tableData.orders
                                self.tableTotalPrice = tableData.totalPrice
                                self.tableCurrency = tableData.currency
                                completion(true, nil)
                            } else if let payloadError = payload.error {
                                completion(false, payloadError.message)
                            } else {
                                completion(false, "Failed to load table orders.")
                            }
                        } catch {
                            completion(false, "Failed to parse table orders.")
                        }
                    }
                }.resume()
            }
        }
    }
}

