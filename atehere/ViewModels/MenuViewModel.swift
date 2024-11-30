//
//  MenuViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 30.11.2024.
//

import Foundation
import SwiftUI

class MenuViewModel: ObservableObject {
    @Published var menus: [Menu] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let restaurantID: String

    init(restaurantID: String) {
        self.restaurantID = restaurantID
        fetchMenu()
    }

    func fetchMenu() {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "\(Config.baseURL)/api/v1/restaurants/\(restaurantID)/menus") else {
            self.errorMessage = "Invalid URL."
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

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
                    let payload = try decoder.decode(ResponsePayload<MenuData>.self, from: data)

                    if let payloadData = payload.data {
                        self.menus = payloadData.menus
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
