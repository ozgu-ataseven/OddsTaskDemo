//
//  NetworkError.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import Foundation

public enum NetworkError: Error, LocalizedError {
    case networkUnavailable
    case noInternetConnection
    case requestTimeout
    case invalidURL
    case invalidResponse
    case configurationError
    case serverError(statusCode: Int, message: String)
    case decodingError
    case unknownError(String)
    
    public var title: String {
        switch self {
        case .networkUnavailable:
            return "Ağ Hatası"
        case .noInternetConnection:
            return "İnternet Bağlantısı Yok"
        case .requestTimeout:
            return "Zaman Aşımı"
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz Yanıt"
        case .configurationError:
            return "Yapılandırma Hatası"
        case .serverError:
            return "Sunucu Hatası"
        case .decodingError:
            return "Veri Hatası"
        case .unknownError:
            return "Bilinmeyen Hata"
        }
    }
    
    public var userMessage: String {
        switch self {
        case .networkUnavailable:
            return "Ağ bağlantısı mevcut değil. Lütfen bağlantınızı kontrol edin."
        case .noInternetConnection:
            return "İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin."
        case .requestTimeout:
            return "İstek zaman aşımına uğradı. Lütfen tekrar deneyin."
        case .invalidURL:
            return "Geçersiz URL adresi."
        case .invalidResponse:
            return "Sunucudan geçersiz yanıt alındı."
        case .configurationError:
            return "Uygulama yapılandırma hatası."
        case .serverError(let statusCode, let message):
            return "Sunucu hatası (\(statusCode)): \(message)"
        case .decodingError:
            return "Veri işleme hatası oluştu."
        case .unknownError(let message):
            return "Bilinmeyen hata: \(message)"
        }
    }
    
    public var errorDescription: String? {
        return userMessage
    }
}
