//
//  DependencyContainer.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import Foundation

public final class DependencyContainer {
    public enum Scope { case singleton, transient }

    private var singletons: [ObjectIdentifier: Any] = [:]
    private var factories: [ObjectIdentifier: (DependencyContainer) -> Any] = [:]
    private let lock = NSRecursiveLock()

    public init(userDefaultsService: UserDefaultsServiceProtocol) {
        register(UserDefaultsServiceProtocol.self, scope: .singleton) { _ in userDefaultsService }
    }

    public func register<T>(_ type: T.Type,
                            scope: Scope = .transient,
                            factory: @escaping (DependencyContainer) -> T) {
        let key = ObjectIdentifier(type)
        lock.lock(); defer { lock.unlock() }
        factories[key] = { [weak self] container in
            guard let self = self else { return factory(container) }
            switch scope {
            case .singleton:
                if let cached = self.singletons[key] as? T { return cached }
                let created = factory(container)
                self.singletons[key] = created
                return created
            case .transient:
                return factory(container)
            }
        }
    }

    @discardableResult
    public func resolve<T>(_ type: T.Type = T.self) -> T {
        let key = ObjectIdentifier(type)
        lock.lock(); defer { lock.unlock() }
        guard let factory = factories[key], let instance = factory(self) as? T else {
            fatalError("No registration found for \(type). Make sure to register it in the composition root.")
        }
        return instance
    }

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        singletons.removeAll()
    }

    public func withOverrides(_ configure: (DependencyContainer) -> Void) -> DependencyContainer {
        let child = DependencyContainer(userDefaultsService: resolve(UserDefaultsServiceProtocol.self))
        child.lock.lock(); defer { child.lock.unlock() }
        child.singletons = self.singletons
        child.factories = self.factories
        configure(child)
        return child
    }

    @available(*, deprecated, message: "Use resolve(UserDefaultsServiceProtocol.self) instead.")
    public var userDefaultsService: UserDefaultsServiceProtocol { resolve(UserDefaultsServiceProtocol.self) }
}
