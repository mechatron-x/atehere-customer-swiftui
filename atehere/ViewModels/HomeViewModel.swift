//
//  HomeViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 12.11.2024.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var filteredRestaurants: [Restaurant] = []
    @Published var availableWorkingDays: [String] = []
    @Published var selectedDays: Set<String> = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    
    @Published var userCoordinates: Coordinates?
    @Published var searchRadius: Double = 60
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        Publishers.CombineLatest($searchText, $selectedDays)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] (searchText, selectedDays) in
                self?.filterRestaurants(searchText: searchText, selectedDays: selectedDays)
            }
            .store(in: &cancellables)
    }

//    func fetchRestaurants(completion: (() -> Void)? = nil) {
//        isLoading = true
//        errorMessage = nil
//
//        guard let url = URL(string: "\(Config.baseURL)/api/v1/customers/restaurants") else {
//            self.errorMessage = "Invalid URL."
//            self.isLoading = false
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
//
//        request.httpBody = "{}".data(using: .utf8)
//
//        performRequest(request, completion: completion)
//    }
    
    func fetchRestaurants(completion: (() -> Void)? = nil) {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "\(Config.baseURL)/api/v1/customers/restaurants") else {
            self.errorMessage = "Invalid URL."
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")

        var requestBody: [String: Any] = [:]


        requestBody["working_days"] = ["Monday"]
        
        if let coords = userCoordinates {
            requestBody["customer_location"] = [
                "latitude": coords.latitude,
                "longitude": coords.longitude
            ]
        }
        let storedLat = UserDefaults.standard.value(forKey: "UserLatitude") ?? 0.0
        let storedLon = UserDefaults.standard.value(forKey: "UserLongitude") ?? 0.0
        
        requestBody["customer_location"] = [
            "latitude": storedLat,
            "longitude": storedLon
        ]
        requestBody["search_radius"] = searchRadius

        // (Optionally) If your backend also expects "name" for text filtering
        // requestBody["name"] = searchText

        
        print(requestBody)
        do {
            let data = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = data
        } catch {
            self.errorMessage = "Failed to encode request body."
            self.isLoading = false
            return
        }

        // 4) Send off to your existing “performRequest” method
        performRequest(request, completion: completion)
    }


    private func performRequest(_ request: URLRequest, completion: (() -> Void)? = nil) {
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self?.errorMessage = "Invalid server response."
                    return
                }

                if httpResponse.statusCode == 200 {
                    guard let data = data else {
                        self?.errorMessage = "No data received from server."
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let payload = try decoder.decode(ResponsePayload<RestaurantList>.self, from: data)
                        print(payload)
                        
                        if let payloadData = payload.data {
                            let normalizedRestaurants = payloadData.restaurants.map { restaurant -> Restaurant in
                                var restaurant = restaurant
                                restaurant.workingDays = restaurant.workingDays.map { $0.lowercased() }
                                return restaurant
                            }
                            self?.restaurants = normalizedRestaurants
                            self?.filteredRestaurants = normalizedRestaurants
                            self?.availableWorkingDays = payloadData.availableWorkingDays.map { $0.lowercased() }
                            self?.filterRestaurants(searchText: self?.searchText ?? "", selectedDays: self?.selectedDays ?? [])
                            completion?()
                        }
                    } catch let decodingError {
                        print("Decoding error: \(decodingError)")
                        self?.errorMessage = "Failed to parse data: \(decodingError.localizedDescription)"
                    }
                } else {
                    self?.handleErrorResponse(data: data, defaultMessage: "An unexpected error occurred. Please try again.")
                }
            }
        }.resume()
    }

    func filterRestaurants(searchText: String, selectedDays: Set<String>) {
        let today = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1].lowercased()

        filteredRestaurants = restaurants.filter { restaurant in
            let matchesSearchText = searchText.isEmpty || restaurant.name.lowercased().contains(searchText.lowercased())

            let matchesSelectedDays: Bool
            if selectedDays.isEmpty {
                matchesSelectedDays = true
            } else {
                let restaurantWorkingDaysSet = Set(restaurant.workingDays)
                matchesSelectedDays = !restaurantWorkingDaysSet.isDisjoint(with: selectedDays)
            }

            return matchesSearchText && matchesSelectedDays
        }

        filteredRestaurants.sort { (restaurant1, restaurant2) -> Bool in
            let isRestaurant1OpenToday = restaurant1.workingDays.contains(today)
            let isRestaurant2OpenToday = restaurant2.workingDays.contains(today)

            if isRestaurant1OpenToday && !isRestaurant2OpenToday {
                return true
            } else if !isRestaurant1OpenToday && isRestaurant2OpenToday {
                return false
            } else {
                return restaurant1.name < restaurant2.name
            }
        }
    }

    private func handleErrorResponse(data: Data?, defaultMessage: String) {
        if let data = data,
           let serverError = try? JSONDecoder().decode(ServerError.self, from: data) {
            self.errorMessage = serverError.message
        } else {
            self.errorMessage = defaultMessage
        }
    }
}
