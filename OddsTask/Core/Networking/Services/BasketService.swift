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
    func addItem(_ item: BasketItem, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchItems(for userId: String, completion: @escaping (Result<[BasketItem], Error>) -> Void)
    func removeItem(itemId: String, for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func clearBasket(for userId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class BasketService: BasketServiceProtocol {
    
    private let db = Firestore.firestore()

    func addItem(_ item: BasketItem, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(item)
            let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]

            db.collection("baskets").document(userId).collection("items").document(item.id).setData(dict) { error in
                if let error = error as NSError? {
                    print("🔥 Firestore Error: \(error.localizedDescription)")
                    print("🔥 Error Code: \(error.code)")
                    print("🔥 Error Domain: \(error.domain)")
                    print("🔥 User Info: \(error.userInfo)")
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func fetchItems(for userId: String, completion: @escaping (Result<[BasketItem], Error>) -> Void) {
        db.collection("baskets").document(userId).collection("items").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                do {
                    let items = try snapshot?.documents.compactMap {
                        try $0.data(as: BasketItem.self)
                    } ?? []
                    completion(.success(items))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func removeItem(itemId: String, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("baskets").document(userId).collection("items").document(itemId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func clearBasket(for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let itemsRef = db.collection("baskets").document(userId).collection("items")
        itemsRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let batch = self.db.batch()
                snapshot?.documents.forEach { batch.deleteDocument($0.reference) }
                batch.commit { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
}
