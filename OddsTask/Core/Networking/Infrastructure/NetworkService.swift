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
        endpoint: Endpoint,
        headers: [String: String]? = nil
    ) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: APIConfiguration.baseURL + endpoint.path) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        let method: HTTPMethod = {
            switch endpoint.method {
            case .get: return .get
            case .post: return .post
            case .put: return .put
            case .delete: return .delete
            case .patch: return .patch
            }
        }()

        let encoding: ParameterEncoding = {
            switch endpoint.encoding {
            case .url: return URLEncoding.default
            case .json: return JSONEncoding.default
            }
        }()

        let afHeaders: HTTPHeaders? = headers.map { HTTPHeaders($0.map { HTTPHeader(name: $0.key, value: $0.value) }) }

        return AF.request(
            url,
            method: method,
            parameters: endpoint.parameters,
            encoding: encoding,
            headers: afHeaders
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
