//
//  MarketViewCollectionViewDataSource.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 21.05.2025.
//

import UIKit
import Combine

final class MarketViewCollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    private var outcomes: [Outcome] = []
    
    let outcomeSelectedSubject = PassthroughSubject<Outcome, Never>()
    var outcomeSelectedPublisher: AnyPublisher<Outcome, Never> {
        outcomeSelectedSubject.eraseToAnyPublisher()
    }

    func update(with newOutcomes: [Outcome]) {
        self.outcomes = newOutcomes
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return outcomes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarketViewCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: outcomes[indexPath.item])
        return cell
    }
    
    func outcome(at indexPath: IndexPath) -> Outcome {
        outcomes[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let outcome = outcomes[indexPath.item]
        outcomeSelectedSubject.send(outcome)
    }
}

extension MarketViewCollectionViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let outcome = outcome(at: indexPath)

        let font = UIFont.systemFont(ofSize: 14)
        let padding: CGFloat = 24 // horizontal padding inside the cell

        let textWidth = outcome.name.size(withAttributes: [.font: font]).width
        let width = ceil(textWidth) + padding

        return CGSize(width: width, height: 60)
    }
}
