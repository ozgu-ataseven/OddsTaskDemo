//
//  OddsAPIEndpoint.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation

public enum OddsAPIEndpoint: Endpoint {
    case getSports
    case getOddEvents(sportKey: String)
    case getOddEventDetail(sportKey: String, eventId: String)

    public var path: String {
        switch self {
        case .getSports:
            return "sports"
        case .getOddEvents(let sportKey):
            return "sports/\(sportKey)/events"
        case .getOddEventDetail(let sportKey, let eventId):
            return "sports/\(sportKey)/events/\(eventId)/odds"
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .getSports, .getOddEvents:
            return nil
        case .getOddEventDetail:
            return [
                "regions": "eu",
                "markets": "h2h",
                "dateFormat": "iso",
                "oddsFormat": "decimal"
            ]
        }
    }

    public var method: HTTPMethodType {
        return .get
    }

    public var encoding: ParameterEncodingType {
        return .url
    }
}
