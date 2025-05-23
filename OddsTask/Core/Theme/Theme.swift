//
//  Theme.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

enum OddsThemeType {
    case dark
    case light
}

struct OddsTheme {
    let primary: UIColor
    let background: UIColor
    let textPrimary: UIColor
    let textSecondary: UIColor
    let button: UIColor
    let error: UIColor
    let fieldBackground: UIColor
    let fieldBorder: UIColor
    let linkText: UIColor
    let activeFieldBorder: UIColor
}

struct OddsColor {
    static var primaryColor: UIColor { ThemeManager.shared.currentTheme.primary }
    static var primaryButtonColor: UIColor { ThemeManager.shared.currentTheme.button }
    static var primaryLabelColor: UIColor { ThemeManager.shared.currentTheme.textPrimary }
    static var errorColor: UIColor { ThemeManager.shared.currentTheme.error }
    static var fieldBackground: UIColor { ThemeManager.shared.currentTheme.fieldBackground }
    static var fieldBorder: UIColor { ThemeManager.shared.currentTheme.fieldBorder }
    static var activeFieldBorder: UIColor { ThemeManager.shared.currentTheme.activeFieldBorder }
    static var linkText: UIColor { ThemeManager.shared.currentTheme.linkText }
    static var secondayLabelColor: UIColor { ThemeManager.shared.currentTheme.textSecondary }
}
