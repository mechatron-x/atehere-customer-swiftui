//
//  BillViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 24.12.2024.
//

import Foundation

class BillViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    @Published var sessionState: String?

    var sessionID: String?

    @Published var billItems: [BillItem] = []

    init(sessionID: String? = nil) {
        self.sessionID = sessionID
    }

    func fetchBillItems(completion: @escaping (Bool, String?) -> Void) {
        guard let sessionID = sessionID, !sessionID.isEmpty else {
            completion(false, "Session ID is missing.")
            return
        }

        guard let url = URL(string: "\(Config.baseURL)/api/v1/sessions/\(sessionID)/bills") else {
            completion(false, "Invalid bills URL.")
            return
        }

        isLoading = true
        errorMessage = nil

        AuthService.shared.getIdToken { [weak self] token in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let bearerToken = token else {
                    self.isLoading = false
                    completion(false, "Failed to retrieve bearer token.")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let error = error {
                            completion(false, "Network error: \(error.localizedDescription)")
                            return
                        }
                        guard let data = data else {
                            completion(false, "No data received from server.")
                            return
                        }

                        
                        do {
                            let payload = try JSONDecoder().decode(ResponsePayload<BillData>.self, from: data)
                            if let billData = payload.data {
                                self.billItems = billData.billItems
                                print(self.billItems)
                                completion(true, nil)
                            } else if let payloadError = payload.error {
                                self.errorMessage = payloadError.message
                                completion(false, payloadError.message)
                            } else {
                                self.errorMessage = "Failed to load bills."
                                completion(false, "No data returned.")
                            }
                        } catch {
                            print("Decoding error: \(error)")
                            self.errorMessage = "Failed to parse bills."
                            completion(false, "Failed to parse bills.")
                        }

                        
                    }
                }.resume()
            }
        }
    }

    
    
    func paySession(selectedItems: [BillItem], completion: @escaping (Bool, String?) -> Void) {
        guard let sessionID = sessionID, !sessionID.isEmpty else {
            completion(false, "Session ID is missing.")
            return
        }

        guard let url = URL(string: "\(Config.baseURL)/api/v1/sessions/\(sessionID)/pay") else {
            completion(false, "Invalid pay URL.")
            return
        }

        isLoading = true
        errorMessage = nil

        
        let payItems = selectedItems.map {
            [
                "bill_item_id": $0.id,
                "amount": $0.remainingPrice,
                "currency": $0.currency
            ] as [String : Any]
        }
        print("Payed Items",payItems)
        let requestBody: [String: Any] = ["bill_items": payItems]

        AuthService.shared.getIdToken { [weak self] token in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let bearerToken = token else {
                    self.isLoading = false
                    completion(false, "Failed to retrieve bearer token.")
                    return
                }

                guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
                    self.isLoading = false
                    completion(false, "Failed to encode bill items.")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData

                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        self.isLoading = false

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

                            if let data = data {
                                let rawString = String(data: data, encoding: .utf8) ?? "nil"

                                if let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                                    completion(false, serverError.message)
                                } else {
                                    completion(false, "Payment failed.")
                                }
                            } else {
                                completion(false, "Payment failed: no response data.")
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    func checkSessionState(sessionID: String, completion: @escaping (Bool, String?, String?) -> Void) {
        guard !sessionID.isEmpty else {
            completion(false, "Session ID is missing.", nil)
            return
        }

        guard let url = URL(string: "\(Config.baseURL)/api/v1/sessions/\(sessionID)/state") else {
            completion(false, "Invalid session state URL.", nil)
            return
        }

        isLoading = true
        errorMessage = nil

        AuthService.shared.getIdToken { [weak self] token in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let bearerToken = token else {
                    self.isLoading = false
                    completion(false, "Failed to retrieve bearer token.", nil)
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        self.isLoading = false

                        if let error = error {
                            completion(false, "Network error: \(error.localizedDescription)", nil)
                            return
                        }
                    
                        guard let data = data else {
                            self.errorMessage = "No data received from server."
                            return
                        }
                        //print(httpResponse)
                        do {
                            let decoder = JSONDecoder()
                            let payload = try decoder.decode(ResponsePayload<StateResponse>.self, from: data)
                            //print(payload)
                            if let payloadData = payload.data {
                                self.sessionState = payloadData.state
                                completion(true, nil, payloadData.state)

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

    
    func checkoutTable(tableID: String, completion: @escaping (Bool, String?) -> Void) {
        guard !tableID.isEmpty else {
            completion(false, "Table ID is missing.")
            return
        }

        guard let url = URL(string: "\(Config.baseURL)/api/v1/tables/\(tableID)/checkout") else {
            completion(false, "Invalid checkout URL.")
            return
        }

        isLoading = true
        errorMessage = nil

        AuthService.shared.getIdToken { [weak self] token in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let bearerToken = token else {
                    self.isLoading = false
                    completion(false, "Failed to retrieve bearer token.")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")


                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        self.isLoading = false

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
                            print("Checkout successful")
                        } else {
                            if let data = data,
                               let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
                                
                                if serverError.message.contains("checkout has already been requested") {
                                    completion(true, nil)
                                } else {
                                    completion(false, serverError.message)
                                }
                            } else {
                                completion(false, "Checkout failed.")
                            }
                        }
                    }
                }.resume()
            }
        }
    }
}
