//
//  Sports.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation

public struct Sport: Decodable {
    let key: String
    let group: Group
    let title: String
    let active: Bool
    let description: String
    let hasOutrights: Bool

    public enum Group: String, Decodable {
        case americanFootball = "American Football"
        case aussieRules = "Aussie Rules"
        case baseball = "Baseball"
        case basketball = "Basketball"
        case boxing = "Boxing"
        case cricket = "Cricket"
        case golf = "Golf"
        case iceHockey = "Ice Hockey"
        case lacrosse = "Lacrosse"
        case mma = "Mixed Martial Arts"
        case politics = "Politics"
        case rugbyLeague = "Rugby League"
        case soccer = "Soccer"
        case unknown
    }

    enum CodingKeys: String, CodingKey {
        case key
        case group
        case title
        case active
        case description
        case hasOutrights = "has_outrights"
    }
    
    // MARK: - Manuel init
    public init(
        key: String,
        group: Group = .unknown,
        title: String,
        active: Bool = true,
        description: String = "",
        hasOutrights: Bool = false
    ) {
        self.key = key
        self.group = group
        self.title = title
        self.active = active
        self.description = description
        self.hasOutrights = hasOutrights
    }
    

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.key = try container.decode(String.self, forKey: .key)
        self.group = Group(rawValue: (try container.decodeIfPresent(String.self, forKey: .group) ?? "")) ?? .unknown
        self.title = try container.decode(String.self, forKey: .title)
        self.active = try container.decodeIfPresent(Bool.self, forKey: .active) ?? true
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.hasOutrights = try container.decodeIfPresent(Bool.self, forKey: .hasOutrights) ?? false
    }
}
