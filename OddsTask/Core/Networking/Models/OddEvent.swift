//
//   Event.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

public struct OddEvent: Decodable {
    let id: String
    let sportKey: String
    let sportTitle: String
    let commenceTime: String
    let homeTeam: String?
    let awayTeam: String?

    enum CodingKeys: String, CodingKey {
        case id
        case sportKey = "sport_key"
        case sportTitle = "sport_title"
        case commenceTime = "commence_time"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}
