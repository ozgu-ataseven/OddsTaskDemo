//
//  BasketItem.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 22.05.2025.
//

import Foundation

public struct BasketItem: Identifiable, Equatable, Codable {
    public let id: String
    let homeTeam: String
    let awayTeam: String
    let outcomeName: String
    let price: Double
    let amount: Double?
    let bookmakerTitle: String
}
