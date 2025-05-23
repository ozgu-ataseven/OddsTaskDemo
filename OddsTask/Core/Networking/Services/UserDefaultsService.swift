//
//  UserDefaultsService.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import Foundation

public protocol UserDefaultsServiceProtocol {
    func set(data: Any, forKey: UserDefaultsService.Keys)
    func value<T: Any>(forKey: UserDefaultsService.Keys) -> T?
    func setObject<T: Codable>(data: T, forKey: UserDefaultsService.Keys)
    func getObject<T: Codable>(forKey: UserDefaultsService.Keys) -> T?
    func removeAll()
}

public class UserDefaultsService: UserDefaultsServiceProtocol {

    public enum Keys: String {
        case themeMode = "themeMode"
    }

    public let userDefaults: UserDefaults

    public init(defaults: UserDefaults) {
        self.userDefaults = defaults
    }

    public func set(data: Any, forKey: Keys) {
        userDefaults.set(data, forKey: forKey.rawValue)
    }

    public func value<T: Any>(forKey: Keys) -> T? {
        let value = userDefaults.value(forKey: forKey.rawValue)
        return value as? T
    }
    
    public func setObject<T: Codable>(data: T, forKey: Keys) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            userDefaults.set(encodedData, forKey: forKey.rawValue)
        } catch {
            print("Failed to encode \(T.self): \(error)")
        }
    }
    
    public func getObject<T: Codable>(forKey: Keys) -> T? {
        guard let savedData = userDefaults.data(forKey: forKey.rawValue) else {
            return nil
        }
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: savedData)
            return decodedData
        } catch {
            print("Failed to decode \(T.self): \(error)")
            return nil
        }
    }

    private func removeObject(forKey: String) {
        userDefaults.removeObject(forKey: forKey)
    }
}

public extension UserDefaultsService {
    
    func removeAll() {
        let dictionary = userDefaults.dictionaryRepresentation()
        
        dictionary.keys.forEach { key in
            self.removeObject(forKey: key)
        }
    }
}
