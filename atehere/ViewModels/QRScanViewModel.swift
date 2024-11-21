//
//  QRScanViewModel.swift
//  atehere
//
//  Created by Berke Bozacı on 20.11.2024.
//

import Foundation
import SwiftUI

class QRScanViewModel: ObservableObject {
    @Published var scannedText: String = ""
    @Published var qrCodeData: QRCodeData?
    @Published var navigateToMenu: Bool = false
    @Published var showAlert: Bool = false

    
    @Published var menus: [Menu] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func handleScannedText(_ text: String) {
        scannedText = text
        if let qrCodeData = parseQRCodeData(from: text) {
            self.qrCodeData = qrCodeData
            saveQRCodeData(qrCodeData)
            fetchMenu(restaurantID: qrCodeData.restaurantID)
            navigateToMenu = true
        } else {
            print("Failed to parse QR code data.")
            showAlert = true
        }
    }

    private func parseQRCodeData(from scannedText: String) -> QRCodeData? {
        let components = scannedText.components(separatedBy: "/")
        guard components.count == 2 else {
            return nil
        }
        let restaurantID = components[0]
        let tableID = components[1]
        return QRCodeData(tableID: tableID, restaurantID: restaurantID)
    }

    private func saveQRCodeData(_ qrCodeData: QRCodeData) {
        UserDefaults.standard.set(qrCodeData.restaurantID, forKey: "restaurantID")
        UserDefaults.standard.set(qrCodeData.tableID, forKey: "tableID")
    }
    
    func fetchMenu(restaurantID: String) {
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

    
//    private func getQRCodeDataFromUserDefaults(){
//        let restaurantID = UserDefaults.standard.string(forKey: "restaurantID")
//        let tableID = UserDefaults.standard.string(forKey: "tableID")
//    }
}

