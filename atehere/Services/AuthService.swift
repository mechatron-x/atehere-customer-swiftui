//
//  AuthService.swift
//  atehere
//
//  Created by Berke Bozacı on 30.10.2024.
//

import Foundation
import Security
import FirebaseAuth

class AuthService {
    static let shared = AuthService()

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
            self.storeUserCredentials(user: firebaseUser)
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


    private func storeUserCredentials(user: FirebaseAuth.User) {
        user.getIDToken { token, error in
            if let token = token {
                self.storeValue(token, key: "idToken")
                print(token)
            }
        }
    }

    private func storeValue(_ value: String, key: String) {
        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "media.dorduncuboyut.atehere",
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
            print("Error storing \(key) in Keychain: \(status)")
        }
    }

    func getIdToken(completion: @escaping (String?) -> Void) {
        if let user = Auth.auth().currentUser {
            user.getIDTokenForcingRefresh(false) { [weak self] idToken, error in
                if let idToken = idToken {
                    self?.storeValue(idToken, key: "idToken")
                    completion(idToken)
                } else {
                    print("Error retrieving idToken: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }

    private func getValue(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "media.dorduncuboyut.atehere",
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?

        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess {
            if let data = item as? Data, let value = String(data: data, encoding: .utf8) {
                return value
            }
        } else {
            print("Error retrieving \(key) from Keychain: \(status)")
        }

        return nil
    }

    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            deleteValue(forKey: "idToken")
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }

    private func deleteValue(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "media.dorduncuboyut.atehere",
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess && status != errSecItemNotFound {
            print("Error deleting \(key) from Keychain: \(status)")
        }
    }
}
