//
//  NetworkLogger.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation

struct NetworkLogger {
    static func logJSON(data: Data, prefix: String = "📦 JSON") {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            print("❌ Failed to parse JSON")
            return
        }
        print("🔽 \(prefix):\n\(prettyString)")
    }
}
