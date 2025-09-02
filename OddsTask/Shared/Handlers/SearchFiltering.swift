//
//  SearchFiltering.swift
//  OddsTask
//
//  Created by Assistant on 02.09.2025.
//

import Foundation

// MARK: - Sports Filtering

protocol SportsSearchFiltering {
    func filter(_ sports: [Sport], with query: String) -> [Sport]
}

struct ContainsSportsSearchFiltering: SportsSearchFiltering {
    func filter(_ sports: [Sport], with query: String) -> [Sport] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return sports }
        let lowercased = trimmedQuery.lowercased()
        return sports.filter { $0.title.lowercased().contains(lowercased) }
    }
}

// MARK: - Odds Filtering

protocol OddsSearchFiltering {
    func filter(_ odds: [OddEvent], with query: String) -> [OddEvent]
}

struct ContainsOddsSearchFiltering: OddsSearchFiltering {
    func filter(_ odds: [OddEvent], with query: String) -> [OddEvent] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return odds }
        let lowercased = trimmedQuery.lowercased()
        return odds.filter { item in
            let home = item.homeTeam?.lowercased() ?? ""
            let away = item.awayTeam?.lowercased() ?? ""
            return home.contains(lowercased) || away.contains(lowercased)
        }
    }
}


