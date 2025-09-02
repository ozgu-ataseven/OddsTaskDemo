//
//  SportsEndpoint.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation
import Combine

public protocol OddsAPIServiceProtocol {
    func getAllSports() -> AnyPublisher<[Sport], NetworkError>
    func getOddEvents(for sportKey: String) -> AnyPublisher<[OddEvent], NetworkError>
    func getOddEventDetail(sportKey: String, eventId: String) -> AnyPublisher<OddEventDetail, NetworkError>
}

final class OddsAPIService: OddsAPIServiceProtocol {
    private let network: NetworkServiceProtocol

    init(network: NetworkServiceProtocol) {
        self.network = network
    }

    func getAllSports() -> AnyPublisher<[Sport], NetworkError> {
        return network.request(endpoint: OddsAPIEndpoint.getSports, headers: nil)
    }
    
    func getOddEvents(for sportKey: String) -> AnyPublisher<[OddEvent], NetworkError> {
        return network.request(endpoint: OddsAPIEndpoint.getOddEvents(sportKey: sportKey), headers: nil)
    }
    
    func getOddEventDetail(sportKey: String, eventId: String) -> AnyPublisher<OddEventDetail, NetworkError> {
        return network.request(endpoint: OddsAPIEndpoint.getOddEventDetail(sportKey: sportKey, eventId: eventId), headers: nil)
    }
}
