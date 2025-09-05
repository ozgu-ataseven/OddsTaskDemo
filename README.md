# OddsTask

OddsTask, kullanıcıların farklı spor dallarındaki maçlar için oran bilgilerini görebildiği, favori oranları sepetine ekleyerek değerlendirme yapabildiği, Firebase ve Combine tabanlı modern bir iOS uygulamasıdır.

## Özellikler

- Farklı spor kategorileri altında maç listeleme
- Maçlara ait bookmaker ve market detayları
- Sepet sistemi (basket): oran + tutar üzerinden beklenen kazanç hesaplama
- Kullanıcı girişi & kayıt işlemleri (Firebase Auth)
- Firebase Firestore üzerinden sepet senkronizasyonu
- Combine ile reaktif veri yönetimi
- MVVM + Factory + Dependency Injection mimarisi
- Çoklu dil desteği (EN, TR)
- Firebase Analytics entegrasyonu

## Mimarî

- **Architecture:** MVVM + Dependency Injection (Core.DependencyContainer)
- **Networking:** Alamofire, Combine
- **Local Storage:** UserDefaultsService
- **Remote Storage:** Firebase Firestore
- **Analytics:** Firebase Analytics
- **Testing:** XCTest + Mock Services + %100 unit test coverage hedefi
- **Design:** Tamamen programatik UI, UIKit + ConstraintAnchors

## Kullanılan Teknolojiler

| Katman | Teknoloji |
|-------|-----------|
| Backend | Firebase Auth, Firestore, Firebase Analytics |
| Networking | Alamofire, Combine |
| State Management | Combine |
| Dependency Injection | Custom DI Container |
| UI | UIKit, Custom Layout Helpers |
| Testing | XCTest, Test Plans, Mock Services |

## Kurulum

1. Repository'yi klonlayın:
   ```bash
   git clone https://github.com/ozgu-ataseven/OddsTaskDemo.git
   cd OddsTask
