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
        var params: [String: Any] = ["apiKey": APIConfiguration.apiKey]
        switch self {
        case .getSports, .getOddEvents:
            break
        case .getOddEventDetail:
            params["regions"] = "eu"
            params["markets"] = "h2h"
            params["dateFormat"] = "iso"
            params["oddsFormat"] = "decimal"
        }
        return params
    }

    public var method: HTTPMethodType {
        return .get
    }

    public var encoding: ParameterEncodingType {
        return .url
    }
}
