//
//  ConstraintAnchors.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

public enum ConstraintAnchorsDistance {
    case lessThanOrEqualTo
    case greaterThanOrEqualTo
}

public enum ConstraintAnchors {
    case height(CGFloat)
    case width(CGFloat)
    case widthDimension(NSLayoutDimension, CGFloat? = nil)
    case heightDimension(NSLayoutDimension, CGFloat? = nil)
    case left(NSLayoutXAxisAnchor, CGFloat? = nil)
    case right(NSLayoutXAxisAnchor, CGFloat? = nil)
    case leading(NSLayoutXAxisAnchor, CGFloat? = nil)
    case trailing(NSLayoutXAxisAnchor, CGFloat? = nil)
    case top(NSLayoutYAxisAnchor, CGFloat? = nil)
    case bottom(NSLayoutYAxisAnchor, CGFloat? = nil)
    case leftWithDistance(NSLayoutXAxisAnchor, CGFloat? = nil, ConstraintAnchorsDistance? = .none)
    case rightWithDistance(NSLayoutXAxisAnchor, CGFloat? = nil, ConstraintAnchorsDistance? = .none)
    case topWithDistance(NSLayoutYAxisAnchor, CGFloat? = nil, ConstraintAnchorsDistance? = .none)
    case bottomWithDistance(NSLayoutYAxisAnchor, CGFloat? = nil, ConstraintAnchorsDistance? = .none)
    case centerX(NSLayoutXAxisAnchor, CGFloat? = nil)
    case centerY(NSLayoutYAxisAnchor, CGFloat? = nil)
    case aspectRatio(CGFloat)
    case aspectRatioWidthRelativeToSuperView(CGFloat)
    case aspectRatioHeightRelativeToSuperView(CGFloat)
    case widthAspectHeight(CGFloat, CGFloat)
    case heightAspectWidth(CGFloat, CGFloat)
    case widthRelationWithMultiplier(NSLayoutDimension, CGFloat)
}
