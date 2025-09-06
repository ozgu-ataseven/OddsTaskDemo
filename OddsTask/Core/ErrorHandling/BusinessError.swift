//
//  BusinessError.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 7.09.2025.
//

import Foundation

public enum BusinessError: Error, LocalizedError {
    case operationNotAllowed
    case resourceNotFound(String)
    case invalidOperation(String)
    
    public var title: String {
        switch self {
        case .operationNotAllowed:
            return "İşlem Yapılamıyor"
        case .resourceNotFound:
            return "Kaynak Bulunamadı"
        case .invalidOperation:
            return "Geçersiz İşlem"
        }
    }
    
    public var userMessage: String {
        switch self {
        case .operationNotAllowed:
            return "Bu işlem şu anda gerçekleştirilemiyor. Lütfen daha sonra tekrar deneyin."
        case .resourceNotFound(let resource):
            return "\(resource) bulunamadı. Lütfen tekrar deneyin."
        case .invalidOperation(let operation):
            return "\(operation)"
        }
    }
    
    public var errorDescription: String? {
        return userMessage
    }
}
