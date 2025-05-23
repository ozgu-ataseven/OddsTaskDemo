//
//  SportsEndpoint.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation
import Combine
import Alamofire

public protocol OddsAPIServiceProtocol {
    func getAllSports() -> AnyPublisher<[Sport], NetworkError>
    func getOddEvents(for sportKey: String) -> AnyPublisher<[OddEvent], NetworkError>
    func getOddEventDetail(sportKey: String, eventId: String) -> AnyPublisher<OddEventDetail, NetworkError>
}

final class OddsAPIService: OddsAPIServiceProtocol {
    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }

    func getAllSports() -> AnyPublisher<[Sport], NetworkError> {
        return network.request(endpoint: .getSports, headers: nil)
    }
    
    func getOddEvents(for sportKey: String) -> AnyPublisher<[OddEvent], NetworkError> {
        return network.request(endpoint: .getOddEvents(sportKey: sportKey), headers: nil)
    }
    
    func getOddEventDetail(sportKey: String, eventId: String) -> AnyPublisher<OddEventDetail, NetworkError> {
        return network.request(endpoint: .getOddEventDetail(sportKey: sportKey, eventId: eventId), headers: nil)
    }
}
