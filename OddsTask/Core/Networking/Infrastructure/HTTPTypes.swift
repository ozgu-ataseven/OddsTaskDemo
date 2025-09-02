//
//  HTTPTypes.swift
//  OddsTask
//
//  Created by Assistant on 02.09.2025.
//

import Foundation

public enum HTTPMethodType {
    case get
    case post
    case put
    case delete
    case patch
}

public enum ParameterEncodingType {
    case url
    case json
}

public protocol Endpoint {
    var path: String { get }
    var method: HTTPMethodType { get }
    var parameters: [String: Any]? { get }
    var encoding: ParameterEncodingType { get }
}
