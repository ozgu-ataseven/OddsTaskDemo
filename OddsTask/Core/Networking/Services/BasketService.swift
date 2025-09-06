//
//  BasketService.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 23.05.2025.
//

import Foundation
import FirebaseFirestore
import UIKit

public protocol BasketServiceProtocol {
    func addItem(_ item: BasketItem, for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void)
    func fetchItems(for userId: String, completion: @escaping (Result<[BasketItem], BusinessError>) -> Void)
    func removeItem(itemId: String, for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void)
    func clearBasket(for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void)
}

final class BasketService: BasketServiceProtocol {
    
    private let db = Firestore.firestore()

    func addItem(_ item: BasketItem, for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void) {
        do {
            let data = try JSONEncoder().encode(item)
            let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]

            db.collection("baskets").document(userId).collection("items").document(item.id).setData(dict) { error in
                if let error = error {
                    let businessError = self.mapFirestoreError(error)
                    completion(.failure(businessError))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            let businessError = mapFirestoreError(error)
            completion(.failure(businessError))
        }
    }

    func fetchItems(for userId: String, completion: @escaping (Result<[BasketItem], BusinessError>) -> Void) {
        db.collection("baskets").document(userId).collection("items").getDocuments { snapshot, error in
            if let error = error {
                let businessError = self.mapFirestoreError(error)
                completion(.failure(businessError))
            } else {
                do {
                    let items = try snapshot?.documents.compactMap {
                        try $0.data(as: BasketItem.self)
                    } ?? []
                    completion(.success(items))
                } catch {
                    let businessError = self.mapFirestoreError(error)
                    completion(.failure(businessError))
                }
            }
        }
    }
    
    func removeItem(itemId: String, for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void) {
        db.collection("baskets").document(userId).collection("items").document(itemId).delete { error in
            if let error = error {
                let businessError = self.mapFirestoreError(error)
                completion(.failure(businessError))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func clearBasket(for userId: String, completion: @escaping (Result<Void, BusinessError>) -> Void) {
        let itemsRef = db.collection("baskets").document(userId).collection("items")
        itemsRef.getDocuments { snapshot, error in
            if let error = error {
                let businessError = self.mapFirestoreError(error)
                completion(.failure(businessError))
            } else {
                let batch = self.db.batch()
                snapshot?.documents.forEach { batch.deleteDocument($0.reference) }
                batch.commit { error in
                    if let error = error {
                        let businessError = self.mapFirestoreError(error)
                        completion(.failure(businessError))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func mapFirestoreError(_ error: Error) -> BusinessError {
        let nsError = error as NSError
        
        switch nsError.code {
        case 5: // NOT_FOUND
            return .resourceNotFound("Sepet")
        case 7: // PERMISSION_DENIED
            return .operationNotAllowed
        default:
            return .invalidOperation(error.localizedDescription)
        }
    }
}
