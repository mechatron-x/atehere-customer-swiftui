//
//  atehereApp.swift
//  atehere
//
//  Created by Berke Bozacı on 21.10.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct atehereApp: App {
    
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject var qrScanViewModel = QRScanViewModel()

    //@State private var isLoggedIn = Auth.auth().currentUser != nil

    @State private var hasValidToken: Bool = false

    
    init (){
        FirebaseApp.configure()
        restoreQRCodeIfNeeded()
//        if let token = AuthService.shared.getValue(forKey: "idToken") {
//            // 2) Check if token is expired
//            let expired = AuthService.shared.isTokenExpired(token)
//            if !expired {
//                // Token is present and not expired
//                hasValidToken = true
//            } else {
//                // If expired, remove it from Keychain or handle how you wish
//                AuthService.shared.deleteValue(forKey: "idToken")
//            }
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            
            // if user token exists and didnt expired nav to root
            // else nav to login
            
            if loginViewModel.isAuthenticated {
                RootView()
                    .environmentObject(loginViewModel)
                    .environmentObject(qrScanViewModel)
            } else {
                LoginView(loginViewModel: loginViewModel)
                    .environmentObject(loginViewModel)
                    //.environmentObject(qrScanViewModel)
            }
//            if isLoggedIn{
//                RootView()
//                    .environmentObject(loginViewModel)
//                    .environmentObject(qrScanViewModel)
//            }
//            else {
//                LoginView(loginViewModel: loginViewModel)
//                    .environmentObject(loginViewModel)
//                    //.environmentObject(qrScanViewModel)
//            }
//            if hasValidToken {
//                // If token is valid, skip login
//                RootView()
//                    .environmentObject(loginViewModel)
//                    .environmentObject(qrScanViewModel)
//            } else {
//                // Otherwise, show login
//                LoginView()
//            }
            
        }
        
        
    }
    
    private func restoreQRCodeIfNeeded() {
        let defaults = UserDefaults.standard
        if let storedRestaurantID = defaults.string(forKey: "restaurantID"),
           let storedTableID = defaults.string(forKey: "tableID") {
            let restoredQR = QRCodeData(tableID: storedTableID, restaurantID: storedRestaurantID)
            qrScanViewModel.qrCodeData = restoredQR
        }
    }
}
