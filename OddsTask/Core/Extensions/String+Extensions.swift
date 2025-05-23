//
//  String+Extensions.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 18.05.2025.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}

extension String {
    func toFormattedDateString(
        inputFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ",
        outputFormat: String = "d MMM yyyy, HH:mm"
    ) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = inputFormat

        guard let date = formatter.date(from: self) else {
            return nil
        }

        formatter.dateFormat = outputFormat
        return formatter.string(from: date)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
