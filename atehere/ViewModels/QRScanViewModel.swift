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
    @Published var isLoading: Bool = false
    
    @Published var errorMessage: String?
    
    init(){
        if let restaurantID = UserDefaults.standard.string(forKey: "restaurantID"),
           let tableID = UserDefaults.standard.string(forKey: "tableID") {
            qrCodeData = QRCodeData(tableID: tableID, restaurantID: restaurantID)
        }
    }
    
    func handleScannedText(_ text: String) {
        scannedText = text
        if let qrCodeData = parseQRCodeData(from: text) {
            self.qrCodeData = qrCodeData
            saveQRCodeData(qrCodeData)

            navigateToMenu = true
            errorMessage = nil
        } else {
            print("Failed to parse QR code data.")
            errorMessage = "Invalid QR code."
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


    func removeQRCodeData() {
        self.qrCodeData = nil
        self.scannedText = ""
        self.navigateToMenu = false
        
        UserDefaults.standard.removeObject(forKey: "restaurantID")
        UserDefaults.standard.removeObject(forKey: "tableID")
        UserDefaults.standard.removeObject(forKey: "session_id")
    }
}
