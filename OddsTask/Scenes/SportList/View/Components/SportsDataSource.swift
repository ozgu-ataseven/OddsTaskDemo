//
//  SportDataSource.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit
import Combine

final class SportDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    private var items: [Sport] = []
    private let selectionSubject = PassthroughSubject<Sport, Never>()
    
    var selectionPublisher: AnyPublisher<Sport, Never> {
        selectionSubject.eraseToAnyPublisher()
    }

    func update(with sports: [Sport]) {
        self.items = sports
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SportCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: items[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sport = item(at: indexPath) else { return }
        selectionSubject.send(sport)
    }
}

extension SportDataSource {
    func item(at indexPath: IndexPath) -> Sport? {
        guard items.indices.contains(indexPath.item) else { return nil }
        return items[indexPath.item]
    }
}
