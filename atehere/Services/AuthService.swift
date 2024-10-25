//
//  AuthService.swift
//  atehere
//
//  Created by Berke Bozacı on 25.10.2024.
//

import Foundation
import FirebaseAuth
import KeychainAccess

class AuthService {
    static let shared = AuthService()
    private let keychain = Keychain(service: "com.yourapp.identifier")
    
    private init() {}


    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let firebaseUser = authResult?.user else {
                completion(.failure(AuthErrorCode.userNotFound))
                return
            }
            self.storeIdToken(user: firebaseUser)
            completion(.success(firebaseUser))
        }
    }

    func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }


    private func storeIdToken(user: FirebaseAuth.User) {
        user.getIDToken { token, error in
            if let token = token {
                do {
                    try self.keychain.set(token, key: "idToken")
                    // print("Token stored: \(token)")
                } catch let error {
                    // print("Keychain error: \(error)")
                }
            }
        }
    }

    func getIdToken() -> String? {
        return try? keychain.get("idToken")
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            try keychain.remove("idToken")
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
}
