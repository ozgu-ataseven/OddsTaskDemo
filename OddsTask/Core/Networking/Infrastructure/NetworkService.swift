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
    private let configuration: APIConfiguration
    private let session: Session
    private let logger: NetworkLogger

    init(configuration: APIConfiguration,
         logger: NetworkLogger,
         session: Session = .default) {
        self.configuration = configuration
        self.logger = logger
        self.session = session
    }

    func request<T: Decodable>(
        endpoint: Endpoint,
        headers: [String: String]? = nil
    ) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: configuration.baseURL + endpoint.path) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        let method: HTTPMethod = {
            switch endpoint.method {
            case .get:    return .get
            case .post:   return .post
            case .put:    return .put
            case .delete: return .delete
            case .patch:  return .patch
            }
        }()

        let encoding: ParameterEncoding = {
            switch endpoint.encoding {
            case .url:  return URLEncoding.default
            case .json: return JSONEncoding.default
            }
        }()

        var mergedHeaders: [String: String] = ["Accept": "application/json"]
        if let headers { for (k, v) in headers { mergedHeaders[k] = v } }
        let afHeaders = HTTPHeaders(mergedHeaders.map { HTTPHeader(name: $0.key, value: $0.value) })

        var parameters = endpoint.parameters ?? [:]
        if parameters["apiKey"] == nil, !configuration.apiKey.isEmpty {
            parameters["apiKey"] = configuration.apiKey
        }

        return session.request(
            url,
            method: method,
            parameters: parameters,
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
                   AF.request(afOriginalRequest).cURLDescription()
               }) {
                _ = self.logger
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
        .mapError { [weak self] error in
            self?.mapAlamofireError(error) ?? NetworkError.unknownError(error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    private func mapAlamofireError(_ error: Error) -> NetworkError {
        if let afError = error as? AFError {
            switch afError {
            case .sessionTaskFailed(let error):
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        return .noInternetConnection
                    case .timedOut:
                        return .requestTimeout
                    case .cannotFindHost, .cannotConnectToHost:
                        return .networkUnavailable
                    default:
                        return .unknownError(urlError.localizedDescription)
                    }
                }
                return .unknownError(error.localizedDescription)
                
            case .responseValidationFailed(let reason):
                switch reason {
                case .unacceptableStatusCode(let code):
                    return mapHTTPStatusCode(code, message: "HTTP \(code)")
                default:
                    return .invalidResponse
                }
                
            case .responseSerializationFailed:
                return .decodingError
                
            case .invalidURL:
                return .invalidURL
                
            default:
                return .unknownError(afError.localizedDescription)
            }
        }
        
        // Handle DecodingError specifically
        if error is DecodingError {
            return .decodingError
        }
        
        return .unknownError(error.localizedDescription)
    }
    
    private func mapHTTPStatusCode(_ statusCode: Int, message: String) -> NetworkError {
        switch statusCode {
        case 400...499:
            // Client errors
            return .serverError(statusCode: statusCode, message: "İstek hatası (\(statusCode))")
        case 500...599:
            // Server errors
            return .serverError(statusCode: statusCode, message: "Sunucu hatası (\(statusCode))")
        default:
            return .serverError(statusCode: statusCode, message: message)
        }
    }
}
