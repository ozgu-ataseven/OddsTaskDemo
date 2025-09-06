//
//  AuthenticationService.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import Foundation
import FirebaseAuth

public protocol FirebaseAuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getCurrentUser() -> User?
    func signOut() -> Result<Void, Error>
    func getUserId() -> String?
    func isLoggedIn() -> Bool
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let _ = result?.user {
                    completion(.success(()))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let _ = result?.user {
                    completion(.success(()))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func signOut() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func isLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
}
