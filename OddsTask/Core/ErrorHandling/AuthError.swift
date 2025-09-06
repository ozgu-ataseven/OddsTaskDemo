//
//  AuthError.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 7.09.2025.
//

import Foundation

public enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case invalidEmail
    case tooManyRequests
    case userDisabled
    case authenticationExpired
    case networkError
    case unknownAuthError(String)
    
    public var title: String {
        switch self {
        case .invalidCredentials:
            return "Giriş Hatası"
        case .userNotFound:
            return "Kullanıcı Bulunamadı"
        case .emailAlreadyInUse:
            return "Email Zaten Kayıtlı"
        case .weakPassword:
            return "Zayıf Şifre"
        case .invalidEmail:
            return "Geçersiz Email"
        case .tooManyRequests:
            return "Çok Fazla Deneme"
        case .userDisabled:
            return "Hesap Devre Dışı"
        case .authenticationExpired:
            return "Oturum Süresi Doldu"
        case .networkError:
            return "İnternet Bağlantısı Yok"
        case .unknownAuthError:
            return "Giriş Hatası"
        }
    }
    
    public var userMessage: String {
        switch self {
        case .invalidCredentials:
            return "Email veya şifre hatalı."
        case .userNotFound:
            return "Kullanıcı bulunamadı."
        case .emailAlreadyInUse:
            return "Bu email adresi zaten kullanımda. Giriş yapmayı deneyin."
        case .weakPassword:
            return "Şifreniz çok zayıf. Lütfen daha güçlü bir şifre seçin."
        case .invalidEmail:
            return "Geçerli bir email adresi girin."
        case .tooManyRequests:
            return "Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin."
        case .userDisabled:
            return "Hesabınız devre dışı bırakılmış."
        case .authenticationExpired:
            return "Oturum süreniz doldu. Lütfen tekrar giriş yapın."
        case .networkError:
            return "İnternet bağlantınızı kontrol edin."
        case .unknownAuthError(let message):
            return message.isEmpty ? "Bilinmeyen giriş hatası." : message
        }
    }
}
