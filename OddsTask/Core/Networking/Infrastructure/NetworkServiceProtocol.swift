//
//  NetworkServiceProtocol.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Combine

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        headers: [String: String]?
    ) -> AnyPublisher<T, NetworkError>
}
