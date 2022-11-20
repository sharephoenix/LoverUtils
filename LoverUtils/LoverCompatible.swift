//
//  LoverCompatible.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/2.
//

import Foundation
import UIKit

public protocol LoverCompatible {}

public extension LoverCompatible {
    public static var lover: Lover<Self>.Type {
        get { Lover<Self>.self}
        set {}
    }

    public var lover: Lover<Self> {
        get { Lover(self) }
        set {}
    }
}

public struct Lover<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
