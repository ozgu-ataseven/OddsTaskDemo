//
//  Sports.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation

public struct Sport: Decodable {
    let key: String
    let group: String
    let title: String
    let active: Bool

    init(key: String, group: String = "", title: String, active: Bool = true) {
        self.key = key
        self.group = group
        self.title = title
        self.active = active
    }
}
