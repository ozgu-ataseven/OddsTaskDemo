//
//  UIView+Extensions.swift
//  OddsTask
//
//  Created by Özgü Ataseven on 17.05.2025.
//

import UIKit

public extension UIView {
    
    static func buildAccessibilityIdentifier() -> String {
        "View.\(String(describing: Self.self).replacingOccurrences(of: "View", with: ""))"
    }

    func constraints(with anchors: [ConstraintAnchors]) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = anchors.map { anchor in
            switch anchor {
            case .height(let constant):
                return heightAnchor.constraint(equalToConstant: constant)
            case .width(let constant):
                return widthAnchor.constraint(equalToConstant: constant)
            case .widthDimension(let dimension, let multiplier):
                return widthAnchor.constraint(equalTo: dimension, multiplier: multiplier ?? 1)
            case .heightDimension(let dimension, let multiplier):
                return heightAnchor.constraint(equalTo: dimension, multiplier: multiplier ?? 1)
            case .left(let anchor, let constant):
                return leftAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .right(let anchor, let constant):
                return rightAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .leading(let anchor, let constant):
                return leadingAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .trailing(let anchor, let constant):
                return trailingAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .top(let anchor, let constant):
                return topAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .bottom(let anchor, let constant):
                return bottomAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .leftWithDistance(let anchor, let constant, let equality):
                switch equality {
                case .greaterThanOrEqualTo:
                    return leftAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant ?? 0)
                case .lessThanOrEqualTo:
                    return leftAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant ?? 0)
                case .none:
                    return NSLayoutConstraint()
                }
            case .rightWithDistance(let anchor, let constant, let equality):
                switch equality {
                case .greaterThanOrEqualTo:
                    return rightAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant ?? 0)
                case .lessThanOrEqualTo:
                    return rightAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant ?? 0)
                case .none:
                    return NSLayoutConstraint()
                }
            case .topWithDistance(let anchor, let constant, let equality):
                switch equality {
                case .greaterThanOrEqualTo:
                    return topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant ?? 0)
                case .lessThanOrEqualTo:
                    return topAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant ?? 0)
                case .none:
                    return NSLayoutConstraint()
                }
            case .bottomWithDistance(let anchor, let constant, let equality):
                switch equality {
                case .greaterThanOrEqualTo:
                    return bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: constant ?? 0)
                case .lessThanOrEqualTo:
                    return bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: constant ?? 0)
                case .none:
                    return NSLayoutConstraint()
                }
            case .centerX(let anchor, let constant):
                return centerXAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .centerY(let anchor, let constant):
                return centerYAnchor.constraint(equalTo: anchor, constant: constant ?? 0)
            case .aspectRatio(let ratio):
                return widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio)
            case .aspectRatioWidthRelativeToSuperView(let ratio):
                guard let superview = superview else { return NSLayoutConstraint() }
                return widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: ratio)
            case .aspectRatioHeightRelativeToSuperView(let ratio):
                guard let superview = superview else { return NSLayoutConstraint() }
                return heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: ratio)
            case .widthAspectHeight(let widthRatio, let heightRatio):
                return widthAnchor.constraint(equalTo: heightAnchor, multiplier: widthRatio / heightRatio)
            case .heightAspectWidth(let heightRatio, let widthRatio):
                return heightAnchor.constraint(equalTo: widthAnchor, multiplier: heightRatio / widthRatio)
            case .widthRelationWithMultiplier(let anchor, let multiplier):
                return widthAnchor.constraint(equalTo: anchor, multiplier: multiplier)
            }
        }

        return constraints
    }

    func hasApearanceChanged(comparedTo previousTraitCollection: UITraitCollection?) -> Bool {
        if #available(iOS 13.0, *),
            let hasUserInterfaceStyleChanged = previousTraitCollection?.hasDifferentColorAppearance(comparedTo: traitCollection),
            hasUserInterfaceStyleChanged {
            return true
        }
        return false
    }

    func addToBottom(of superView: UIView,
                     height: CGFloat = 1,
                     leftPadding: CGFloat = 16,
                     rightPadding: CGFloat = 16) {
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            constraints(with: [
                .left(superView.leftAnchor, leftPadding),
                .right(superView.rightAnchor, -rightPadding),
                .bottom(superView.bottomAnchor, -height),
                .height(height)
            ])
        )
    }

    func addToBottomWithSafeArea(superView: UIView,
                                 height: CGFloat,
                                 leftPadding: CGFloat = 16,
                                 rightPadding: CGFloat = 16,
                                 bottomPadding: CGFloat = 16) {
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            constraints(with: [
                .left(superView.leftAnchor, leftPadding),
                .right(superView.rightAnchor, -rightPadding),
                .height(height),
                .bottom(superView.safeAreaLayoutGuide.bottomAnchor, -bottomPadding)
            ])
        )
    }

    func fitToSafeArea(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
        NSLayoutConstraint.activate(subView.constraints(with: [
            .top(safeAreaLayoutGuide.topAnchor),
            .left(leftAnchor),
            .right(rightAnchor),
            .bottom(safeAreaLayoutGuide.bottomAnchor)
        ]))
    }
    
    func fitToArea(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
        NSLayoutConstraint.activate(subView.constraints(with: [
            .top(topAnchor),
            .left(leftAnchor),
            .right(rightAnchor),
            .bottom(bottomAnchor)
        ]))
    }
    
    func fitSpecificLocation(subView: UIView, anchors: [ConstraintAnchors]) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
        NSLayoutConstraint.activate(subView.constraints(with: anchors))
    }

    func allSubviews<T: UIView>(ofType type: T.Type) -> [T] {
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.allSubviews(ofType: type))
        }
        return result
    }
    
    /// Sadece genişlik constraint'i ekler ve `translatesAutoresizingMaskIntoConstraints`'i false yapar.
    @discardableResult
    func setWidth(_ width: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    /// Sadece yükseklik constraint'i ekler ve `translatesAutoresizingMaskIntoConstraints`'i false yapar.
    @discardableResult
    func setHeight(_ height: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }
}

// MARK: UIAccessibility

public extension UIView {

    func accessibilityForceFocusElements(with elements: [UIView]) {
        guard UIAccessibility.isVoiceOverRunning else {
            return
        }

        accessibilityElements = elements

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(accessibilityForceFocusElementsFocused(notification:)),
            name: UIAccessibility.elementFocusedNotification,
            object: nil
        )
    }

    @objc private func accessibilityForceFocusElementsFocused(notification: Notification) {
        NotificationCenter.default.removeObserver(
            self,
            name: UIAccessibility.elementFocusedNotification,
            object: nil
        )

        accessibilityElements = subviews
    }
}
