////
////  LoginViewModel.swift
////  atehere
////
////  Created by Berke Bozacı on 25.10.2024.
////
//
//import Foundation
//import FirebaseAuth
//
//class LoginViewModel: ObservableObject {
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var errorMessage: String? = nil
//    @Published var isLoading: Bool = false
//    @Published var isAuthenticated: Bool = false
//    @Published var isVerified: Bool = false
//    @Published var showAlert: Bool = false
//    @Published var alertMessage: String = ""
//
//    @Published var canLogin: Bool = false
//
//    private let authService = AuthService.shared
//
//    
//    init() {
//       
//        //checkIfTokenIsExpired()
////        if let user = Auth.auth().currentUser, user.isEmailVerified {
////            self.isAuthenticated = true
////            self.isVerified = true
////        }
//    }
//    
//    func login() {
//        isLoading = true
//        errorMessage = nil
//
//        authService.login(email: email, password: password) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isLoading = false
//                switch result {
//                case .success(let user):
//                    self?.isVerified = user.isEmailVerified
//                    self?.isAuthenticated = user.isEmailVerified
//                    self?.canLogin = true
//                    print(self?.canLogin)
//                    if !user.isEmailVerified {
//                        self?.sendEmailVerification()
//                        self?.errorMessage = "Please verify your email to continue."
//                    }
//
//                case .failure(let error):
//                    self?.handleAuthError(error)
//                }
//            }
//        }
//    }
//
//    func sendEmailVerification() {
//        authService.sendEmailVerification { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    self?.alertMessage = "A verification email has been sent. Please check your inbox."
//                    self?.showAlert = true
//                case .failure(let error):
//                    self?.errorMessage = "Email verification error: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//
//    // MARK: - Token Expiration Check
//   /// For example, call this periodically or on certain views to check if token is valid.
//   /// If the token is expired and user cannot refresh it, set isAuthenticated = false.
//   func checkIfTokenIsExpired() {
//       guard let user = Auth.auth().currentUser else {
//           // No user => definitely not authenticated
//           self.isAuthenticated = false
//           self.canLogin = false
//           return
//       }
//
//       // Attempt to retrieve a fresh token. If the token is expired but Firebase can refresh,
//       // this will succeed automatically. If it fails (e.g., user is invalid), you can log them out.
//       user.getIDTokenForcingRefresh(false) { [weak self] idToken, error in
//           DispatchQueue.main.async {
//               if let error = error {
//                   // Possibly means user’s credential is revoked or no longer valid.
//                   // Force a re-login
//                   print("Token retrieval error: \(error.localizedDescription)")
//                   self?.isAuthenticated = false
//                   self?.canLogin = false
//                   // Optionally set errorMessage for UI
//                   self?.errorMessage = "Session expired. Please log in again."
//                   self?.forceLogout()
//               } else if let idToken = idToken {
//                   // All good; user’s ID token is valid or just got refreshed
//                   print("ID Token is valid: \(idToken.prefix(10))...")
//                   // Keep isAuthenticated = true, no changes needed.
//               }
//           }
//       }
//   }
//
//   // MARK: - Logout
//   /// If you want to forcibly log user out (ex: if token expired)
//   func forceLogout() {
//       self.isAuthenticated = false
//       self.canLogin = false
//       do {
//           try Auth.auth().signOut()
//       } catch {
//           print("Sign out error: \(error)")
//       }
//   }
//    
//    private func handleAuthError(_ error: Error) {
//        if let error = error as NSError? {
//            switch AuthErrorCode(rawValue: error.code) {
//            case .networkError:
//                self.errorMessage = "Network error. Please try again."
//            case .wrongPassword:
//                self.errorMessage = "Incorrect password. Please try again."
//            case .invalidEmail:
//                self.errorMessage = "Invalid email address."
//            case .userNotFound:
//                self.errorMessage = "No account found with this email."
//            default:
//                self.errorMessage = "Login error: \(error.localizedDescription)"
//            }
//        } else {
//            self.errorMessage = "An unknown error occurred."
//        }
//    }
//    
//    
//}


import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    /// Whether user can proceed directly to the app
    @Published var isAuthenticated: Bool = false
    
    /// Whether user’s email is verified
    @Published var isVerified: Bool = false
    
    /// Show alerts
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""

    private let authService = AuthService.shared
    
    init() {
        // On init, check if Firebase user is present
        // and if so, check if token is valid / or if they are verified.
        self.checkCurrentUserStatus()
    }

    // MARK: - Check Current User
    private func checkCurrentUserStatus() {
        if let user = Auth.auth().currentUser {
            // If user is present, let’s see if they are verified
            if user.isEmailVerified {
                // Attempt to see if token can still be refreshed
                user.getIDTokenForcingRefresh(false) { [weak self] idToken, error in
                    DispatchQueue.main.async {
                        if let _ = idToken, error == nil {
                            // All good => user is authenticated
                            self?.isAuthenticated = true
                            self?.isVerified = true
                            print("User is already authenticated/verified.")
                        } else {
                            // If token retrieval fails => user not authenticated
                            print("Token retrieval error => forcing logout.")
                            self?.forceLogout()
                        }
                    }
                }
            } else {
                // Email not verified
                // You can either sign them out or let them stay
                print("User is not verified => force them to verify or log out.")
                self.isVerified = false
                self.isAuthenticated = false
            }
        } else {
            // No user => not authenticated
            self.isAuthenticated = false
            self.isVerified = false
        }
    }

    // MARK: - Login
    func login() {
        isLoading = true
        errorMessage = nil

        authService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.isVerified = user.isEmailVerified
                    self?.isAuthenticated = user.isEmailVerified
                    if !user.isEmailVerified {
                        self?.sendEmailVerification()
                        self?.errorMessage = "Please verify your email to continue."
                    }
                case .failure(let error):
                    self?.handleAuthError(error)
                }
            }
        }
    }

    // MARK: - Send Verification Email
    func sendEmailVerification() {
        authService.sendEmailVerification { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.alertMessage = "A verification email has been sent. Please check your inbox."
                    self?.showAlert = true
                case .failure(let error):
                    self?.errorMessage = "Email verification error: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - Logout (forced or user-initiated)
    func forceLogout() {
        self.isAuthenticated = false
        self.isVerified = false
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out error: \(error)")
        }
    }

    // MARK: - Token Expiration Check (Optional)
    func checkIfTokenIsExpired() {
        guard let user = Auth.auth().currentUser else {
            self.isAuthenticated = false
            return
        }

        user.getIDTokenForcingRefresh(false) { [weak self] idToken, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Possibly means user’s credential is revoked or no longer valid => log them out
                    print("Token retrieval error: \(error.localizedDescription)")
                    self?.errorMessage = "Session expired. Please log in again."
                    self?.forceLogout()
                } else if let idToken = idToken {
                    // Token is valid or just refreshed => do nothing special
                    print("ID Token is valid: \(idToken.prefix(10))...")
                }
            }
        }
    }

    // MARK: - Handle Auth Errors
    private func handleAuthError(_ error: Error) {
        if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .networkError:
                self.errorMessage = "Network error. Please try again."
            case .wrongPassword:
                self.errorMessage = "Incorrect password. Please try again."
            case .invalidEmail:
                self.errorMessage = "Invalid email address."
            case .userNotFound:
                self.errorMessage = "No account found with this email."
            default:
                self.errorMessage = "Login error: \(error.localizedDescription)"
            }
        } else {
            self.errorMessage = "An unknown error occurred."
        }
    }
}
