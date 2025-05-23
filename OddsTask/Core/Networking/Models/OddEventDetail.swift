//
//  OddEventDetail.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 20.05.2025.
//

import Foundation

public struct OddEventDetail: Decodable {
    let id: String
    let sportKey: String
    let sportTitle: String
    let commenceTime: String
    let homeTeam: String
    let awayTeam: String
    let bookmakers: [Bookmaker]

    enum CodingKeys: String, CodingKey {
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case bookmakers
    }
}

struct Bookmaker: Decodable {
    let key: String
    let title: String
    let markets: [Market]
}

struct Market: Decodable {
    let key: String
    let lastUpdate: String
    let outcomes: [Outcome]

    enum CodingKeys: String, CodingKey {
        case key
        case lastUpdate = "last_update"
        case outcomes
    }
}

struct Outcome: Decodable {
    let name: String
    let description: String?
    let price: Double
    let point: Double?
}
