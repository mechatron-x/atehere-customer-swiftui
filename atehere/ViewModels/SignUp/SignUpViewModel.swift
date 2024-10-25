//
//  SignUpViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 25.10.2024.
//

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var gender: String? = ""
    @Published var birthDate: Date = Date()
    @Published var errorMessage: String? = nil
    @Published var isSignedUp: Bool = false
    @Published var isLoading: Bool = false
    
    func signUp() {
        isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let birthDateString = dateFormatter.string(from: birthDate)
        
        let genderToSend = gender ?? "Undefined"

        let customer = Customer(email: email, password: password, fullName: fullName, gender: gender, birthDate: birthDateString)
        
        guard let jsonData = try? JSONEncoder().encode(customer) else {
                    self.errorMessage = "Failed to encode customer data."
                    self.isLoading = false
                    return
                }
        
        guard let url = URL(string: "http://127.0.0.1:8080/api/v1/customer/auth") else {
                   self.errorMessage = "Invalid URL."
                   self.isLoading = false
                   return
               }
        
        var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        if let error = error {
                            self.errorMessage = "Network error: \(error.localizedDescription)"
                            return
                        }

                        guard let httpResponse = response as? HTTPURLResponse else {
                                            self.errorMessage = "Invalid server response."
                                            return
                                        }

                        switch httpResponse.statusCode {
                        case 200...299:
                            self.isSignedUp = true
                        case 400:
                            self.handleErrorResponse(data: data, defaultMessage: "Bad request. Please check your input.")
                        case 401:
                            self.handleErrorResponse(data: data, defaultMessage: "Unauthorized access.")
                        case 403:
                            self.errorMessage = "Access forbidden."
                        case 404:
                            self.errorMessage = "Server not found. Please try again later."
                        case 409:
                            self.handleErrorResponse(data: data, defaultMessage: "Conflict error. Possibly the email already exists.")
                        case 500:
                            self.handleErrorResponse(data: data, defaultMessage: "Server error. Please try again later.")
                        default:
                            self.handleErrorResponse(data: data, defaultMessage: "An unexpected error occurred. Please try again.")
                        }

                        self.isSignedUp = true
                    }
                }.resume()
        
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