//
//  RestaurantViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 28.12.2024.
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject {
    @Published var restaurant: RestaurantInfo?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let restaurantID: String
    
    init(restaurantID: String) {
        self.restaurantID = restaurantID
        fetchRestaurant()
    }
    
    func fetchRestaurant() {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(Config.baseURL)/api/v1/customers/restaurants/\(restaurantID)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL."
                self.isLoading = false
            }
            return
        }
        print("Restaurant ID: ", restaurantID)
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

                print(data)
                do {
                    let decoder = JSONDecoder()
                    let payload = try decoder.decode(ResponsePayload<RestaurantInfoData>.self, from: data)
                    if let payloadData = payload.data {
                        print("Restaurant: \(payloadData)")
                        self.restaurant = payloadData.restaurant
                    } else if let payloadError = payload.error {
                        self.errorMessage = payloadError.message
                    } else {
                        self.errorMessage = "Failed to load restaurant."
                    }
                } catch {
                    self.errorMessage = "Failed to parse restaurant data."
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
       
    }
}
