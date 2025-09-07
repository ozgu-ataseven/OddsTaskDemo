# OddsTask

OddsTask is a modern iOS application built with Firebase and Combine that allows users to view betting odds for matches across different sports, add favorite odds to their basket, and calculate potential winnings.

## Features

- Browse matches across different sports categories
- View bookmaker and market details for matches
- Basket system: calculate expected winnings based on odds and stake amount
- User authentication & registration (Firebase Auth)
- Basket synchronization via Firebase Firestore
- Reactive data management with Combine
- MVVM-C (Coordinator) + Factory + Dependency Injection architecture
- Multi-language support (EN, TR)
- Firebase Analytics integration

## Architecture

- **Architecture:** MVVM-C (Model-View-ViewModel-Coordinator) Pattern
- **Navigation:** Pure Coordinator Pattern (AppRouter singleton removed)
- **Dependency Injection:** Custom DI Container (Core.DependencyContainer)
- **Networking:** Alamofire, Combine
- **Local Storage:** UserDefaultsService
- **Remote Storage:** Firebase Firestore
- **Analytics:** Firebase Analytics
- **Testing:** XCTest + Mock Services + Comprehensive unit test coverage
- **Design:** Fully programmatic UI, UIKit + ConstraintAnchors

### Coordinator Pattern Structure

```
AppCoordinator (Root)
├── LoginCoordinator
├── RegisterCoordinator
└── SportListCoordinator
    ├── OddEventListCoordinator
    ├── OddEventDetailCoordinator
    └── BasketCoordinator
```

**Benefits:**
- Removed navigation responsibility from ViewModels
- Clean separation of concerns with dedicated coordinators per scene
- Proper memory management with child coordinator pattern
- Improved testability (coordinators can be mocked)
- Solved UIViewController reference problem

## Project Structure

```
OddsTask/
├── App/                    # Application lifecycle
│   ├── AppDelegate.swift
│   └── AppCoordinator.swift
├── Core/                   # Core infrastructure
│   ├── Base/              # Base classes and protocols
│   ├── DI/                # Dependency Injection container
│   ├── ErrorHandling/     # Custom error types
│   ├── Extensions/        # Swift extensions
│   ├── Helpers/           # Utility classes
│   ├── Networking/        # Network layer
│   └── Services/          # Business services
├── Resources/             # Assets and localization
│   ├── Assets.xcassets/
│   ├── Base.lproj/
│   └── en.lproj/
└── Scenes/               # Feature modules
    ├── Basket/           # Shopping cart functionality
    ├── Login/            # Authentication
    ├── OddEventDetail/   # Event details
    ├── OddEventList/     # Event listing
    ├── Register/         # User registration
    └── SportList/        # Sports categories
```

## Technologies Used

| Layer | Technology |
|-------|-----------|
| Backend | Firebase Auth, Firestore, Firebase Analytics |
| Networking | Alamofire, Combine |
| State Management | Combine |
| Dependency Injection | Custom DI Container |
| UI | UIKit, Custom Layout Helpers |
| Testing | XCTest, Test Plans, Mock Services |
| Navigation | Pure Coordinator Pattern |

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ozgu-ataseven/OddsTaskDemo.git
   cd OddsTaskDemo
   ```

2. Open the project in Xcode:
   ```bash
   open OddsTask.xcodeproj
   ```

3. Firebase configuration:
   - Download `GoogleService-Info.plist` from Firebase Console
   - Add the file to `OddsTask/Resources/` folder

4. Build and run the project (⌘+R)

## Running Tests

```bash
# Run all tests
xcodebuild test -scheme OddsTask -destination 'platform=iOS Simulator,name=iPhone 15'

# Generate test coverage report
xcodebuild test -scheme OddsTask -destination 'platform=iOS Simulator,name=iPhone 15' -enableCodeCoverage YES
```

## Key Architectural Decisions

### Router to Coordinator Migration
- **Problem**: ViewModels required UIViewController references for navigation
- **Solution**: Implemented pure coordinator pattern with delegate protocols
- **Result**: Clean separation of concerns, improved testability, better memory management

### Custom Dependency Injection
- **Approach**: Built custom DI container instead of using third-party frameworks
- **Benefits**: Lightweight, project-specific, easy to understand and maintain
- **Implementation**: Protocol-based service registration and resolution

### Programmatic UI
- **Choice**: 100% programmatic UI using UIKit
- **Advantages**: Better version control, no Storyboard merge conflicts, more precise control
- **Tools**: Custom constraint helpers and layout utilities

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License.

**You are free to:**
- View and study the source code
- Download and use for personal/educational purposes
- Share and distribute the code with proper attribution

**Under the following conditions:**
- **Attribution**: You must give appropriate credit and indicate if changes were made
- **NonCommercial**: You may not use this work for commercial purposes

For commercial licensing inquiries, please contact the author.

© 2024 Özgü Ataseven. All rights reserved.
