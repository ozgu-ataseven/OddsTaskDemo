//
//  NetworkError.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError(message: String)
    case unknown
}
