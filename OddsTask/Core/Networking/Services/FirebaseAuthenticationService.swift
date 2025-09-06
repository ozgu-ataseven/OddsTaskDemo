//
//  AuthenticationService.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import Foundation
import FirebaseAuth

public protocol FirebaseAuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
    func getCurrentUser() -> User?
    func signOut() -> Result<Void, AuthError>
    func getUserId() -> String?
    func isLoggedIn() -> Bool
}

final class FirebaseAuthService: FirebaseAuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let _ = result?.user {
                    completion(.success(()))
                } else if let error = error {
                    let authError = self.mapFirebaseError(error)
                    completion(.failure(authError))
                }
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        DispatchQueue.main.async {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let _ = result?.user {
                    completion(.success(()))
                } else if let error = error {
                    let authError = self.mapFirebaseError(error)
                    completion(.failure(authError))
                }
            }
        }
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func signOut() -> Result<Void, AuthError> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch {
            let authError = mapFirebaseError(error)
            return .failure(authError)
        }
    }
    
    func getUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func isLoggedIn() -> Bool {
        Auth.auth().currentUser != nil
    }
    
    // MARK: - Private Methods
    private func mapFirebaseError(_ error: Error) -> AuthError {
        guard let authErrorCode = AuthErrorCode(rawValue: (error as NSError).code) else {
            return .unknownAuthError(error.localizedDescription)
        }
        
        switch authErrorCode {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .invalidCredentials
        case .userNotFound:
            return .userNotFound
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .tooManyRequests:
            return .tooManyRequests
        case .userDisabled:
            return .userDisabled
        case .networkError:
            return .networkError
        default:
            return .unknownAuthError(error.localizedDescription)
        }
    }
}
