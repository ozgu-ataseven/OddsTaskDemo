//
//  ThemeManager.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

final class ThemeManager {
    static let shared = ThemeManager()
    private(set) var currentTheme: OddsTheme!

    private init() {}

    func apply(theme: OddsThemeType) {
        switch theme {
        case .dark:
            currentTheme = OddsTheme(
                primary: UIColor(hex: "#11141B"),
                background: UIColor(hex: "#11141B"),
                textPrimary: .white,
                textSecondary: UIColor(hex: "#AAAAAA"),
                button: UIColor(hex: "#6F2B47"),
                error: .systemRed,
                fieldBackground: UIColor(hex: "#1C1F26"),
                fieldBorder: UIColor(hex: "#2C2F36"),
                linkText: UIColor(hex: "#4A90E2"),
                activeFieldBorder: UIColor(hex: "#6F2B47")
            )
        case .light:
            currentTheme = OddsTheme(
                primary: UIColor(hex: "#FFFFFF"),
                background: UIColor(hex: "#F5F5F5"),
                textPrimary: UIColor(hex: "#11141B"),
                textSecondary: UIColor(hex: "#666666"),
                button: UIColor(hex: "#C0396D"),
                error: .systemRed,
                fieldBackground: UIColor(hex: "#FFFFFF"),
                fieldBorder: UIColor(hex: "#CCCCCC"),
                linkText: UIColor(hex: "#007AFF"),
                activeFieldBorder: UIColor(hex: "#C0396D")
            )
        }
        
        UINavigationBar.appearance().barTintColor = currentTheme.primary
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: currentTheme.textPrimary]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: currentTheme.textPrimary]
        UIBarButtonItem.appearance().tintColor = currentTheme.button
        UISwitch.appearance().onTintColor = currentTheme.button
    }
}
