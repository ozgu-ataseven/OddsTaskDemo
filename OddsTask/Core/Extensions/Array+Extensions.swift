//
//  Array+Extensions.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

extension Array {

    public struct IndexOutOfBoundsError: Error { }

    public func element(at index: Int) throws -> Element {
        guard index >= 0 && index < self.count else {
            throw IndexOutOfBoundsError()
        }
        return self[index]
    }

    public mutating func move(from oldIndex: Index, to newIndex: Index) {
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}

extension Array where Element: Hashable {
    public var unique: Array {
        Array(Set(self))
    }
}

extension Array where Element == String {

    public func getDataFromBase64() -> NSData? {
        NSData(base64Encoded: self.joined(), options: .ignoreUnknownCharacters)
    }
}

