//
//  LButtonproperty.swift
//  LoverCommonUI
//
//  Created by phoenix on 2022/10/30.
//

import Foundation
import UIKit

private var identifier = "indentifier"

public class LButtonProperty<T: UIButton> {
    typealias RealType = T
    private var base: T

    private var customAction: ((UIButton) -> Void)?

    init(_ base: T) {
        self.base = base
    }

    public func action(action: @escaping ((UIButton) -> Void)) {
        customAction = action
        base.addTarget(self, action: #selector(emitEvent), for: .touchUpInside)
    }

    public func removeAction() {
        base.removeTarget(self, action: #selector(emitEvent), for: .touchUpInside)
    }

    @objc private func emitEvent(_ button: UIButton) {
        customAction?(button)
    }
}

public extension LoverCompatible where Self: UIButton {
    var lover: LButtonProperty<Self> {
        get {
            if let currentValue = objc_getAssociatedObject(self, &identifier) as? LButtonProperty<Self> {
                return currentValue
            }
            let newValue = LButtonProperty(self)
            objc_setAssociatedObject(self, &identifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return newValue
        }
    }
}
