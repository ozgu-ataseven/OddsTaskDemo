//
//  AdaptiveGridLayout.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 19.05.2025.
//

import UIKit
 
protocol AdaptiveGridLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

final class AdaptiveGridLayout: UICollectionViewLayout {
    
    weak var delegate: AdaptiveGridLayoutDelegate?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 8

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }

        let columnWidth = (contentWidth - CGFloat(numberOfColumns - 1) * cellPadding) / CGFloat(numberOfColumns)
        let xOffset: [CGFloat] = (0..<numberOfColumns).map { CGFloat($0) * (columnWidth + cellPadding) }
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        var column = 0

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let width = columnWidth
            let itemHeight = delegate?.collectionView(collectionView, heightForItemAt: indexPath, with: width) ?? 44
            let height = itemHeight + cellPadding

            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: height)
            let insetFrame = frame.insetBy(dx: 0, dy: cellPadding / 2)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] += height

            column = (column + 1) % numberOfColumns
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }

    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        contentHeight = 0
    }
}
