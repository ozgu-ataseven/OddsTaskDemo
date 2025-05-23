//
//  NetworkServiceProtocol.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Combine
import Alamofire

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: OddsAPIEndpoint,
        headers: HTTPHeaders?
    ) -> AnyPublisher<T, NetworkError>
}
