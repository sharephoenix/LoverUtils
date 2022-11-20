//
//  UIView+Lover.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/2.
//

import Foundation
import UIKit

private var identifier = "indentifier"

public class LViewProperty<T: UIView> {
    typealias RealType = T
    private var base: T

    private var customAction: ((UITapGestureRecognizer) -> Void)?
    private var getTapGesture: (() -> UITapGestureRecognizer?)?

    init(_ base: T) {
        self.base = base
    }

    public func action(action: @escaping ((UITapGestureRecognizer) -> Void)) {
        customAction = action
        let tap = UITapGestureRecognizer(target: self, action: #selector(emitEvent))
        base.isUserInteractionEnabled = true
        getTapGesture = { tap }
        base.addGestureRecognizer(tap)
    }

    public func removeAction() {
        getTapGesture?()?.removeTarget(self, action: #selector(emitEvent))
    }

    @objc private func emitEvent(_ button: UITapGestureRecognizer) {
        customAction?(button)
    }
}


public extension LoverCompatible where Self: UIView {
    var lover: LViewProperty<Self> {
        get {
            if let currentValue = objc_getAssociatedObject(self, &identifier) as? LViewProperty<Self> {
                return currentValue
            }
            let newValue = LViewProperty(self)
            objc_setAssociatedObject(self, &identifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newValue
        }
    }
}

extension UIView: LoverCompatible {}
