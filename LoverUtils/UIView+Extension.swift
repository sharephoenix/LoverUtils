//
//  LExtension.swift
//  LoverCommonUI
//
//  Created by phoenix on 2022/10/30.
//

import Foundation
import UIKit

public extension UIView {
    @discardableResult
    func resetCorner(_ value: CGFloat) -> Self {
        layer.cornerRadius = value
        return self
    }
}
