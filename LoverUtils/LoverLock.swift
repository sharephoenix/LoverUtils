//
//  LoverLock.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/5.
//

import Foundation
protocol LoverLock {
    func lock()
    func unlock()
}

extension LoverLock {
    func around<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try closure()
    }

    func around(_ closure: () throws -> Void) rethrows {
        lock()
        defer { unlock() }
        try closure()
    }
}

final class LoverUnfairLock: LoverLock {

    private let unfairLock: os_unfair_lock_t

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}

@propertyWrapper
final public class LoverAtomic<T> {
    private var lock: LoverLock = LoverUnfairLock()
    private var value: T

    public var wrappedValue: T {
        get {
            lock.around { value }
        }
        set {
            lock.around { value = newValue }
        }
    }

    public init(wrappedValue: T) {
        self.value = wrappedValue
    }
}

public extension LoverAtomic {
    func atomicBlock(_ callback: (inout T) -> Void) {
        lock.around {
            callback(&value)
        }
    }
}

