//
//  AlamofireNetworkService.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Alamofire
import Combine
import Foundation

final class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: OddsAPIEndpoint,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: APIConfiguration.baseURL + endpoint.path) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return AF.request(
            url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: headers
        )
        .validate()
        .responseData { response in
            if let afRequest = response.request {
                debugPrint("➡️ Request URL: \(afRequest.url?.absoluteString ?? "")")
            }
            
            if let afOriginalRequest = response.request,
               let curl = (response.metrics?.taskInterval).map({ _ in
                   return AF.request(afOriginalRequest).cURLDescription()
               }) {
                print("🧪 cURL: \(curl)")
            }
            
            if case let .success(data) = response.result {
                NetworkLogger.logJSON(data: data, prefix: "📥 Response JSON")
            } else {
                debugPrint("✅ Response: \(response)")
            }
        }
        .publishDecodable(type: T.self)
        .value()
        .mapError { NetworkError.serverError(message: $0.localizedDescription) }
        .eraseToAnyPublisher()
    }
}
