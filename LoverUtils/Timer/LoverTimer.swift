//
//  LoverTimer.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/5.
//

import Foundation

public class LoverTimer {
    public static let shared = LoverTimer()
    @LoverAtomic
    private var queue: [String: LoverTimerBlock] = [:]

    private init() { }

    @discardableResult
    public func addMainHanler(interval: TimeInterval, deadInterval: TimeInterval, immediately: Bool = false,
                              currentDate:(() -> Date?)?, block: @escaping (LoverTimerHandler, TimeInterval) -> Void) -> LoverTimerHandler {
        let deadDate = (currentDate?() ?? Date()).addingTimeInterval(deadInterval)
        return addHandler(executeImmediately: immediately, dispatchQueue: .main,
                          eventItem: .remindTime(deadDate, currentDate, block))
    }
    @discardableResult
    public func addGlobalHanler(interval: TimeInterval, deadInterval: TimeInterval, immediately: Bool = false,
                              currentDate:(() -> Date?)?, block: @escaping (LoverTimerHandler, TimeInterval) -> Void) -> LoverTimerHandler {
        let deadDate = (currentDate?() ?? Date()).addingTimeInterval(deadInterval)
        return addHandler(executeImmediately: immediately, dispatchQueue: .global(),
                          eventItem: .remindTime(deadDate, currentDate, block))
    }
    @discardableResult
    public func addMainHanler(interval: TimeInterval, deadDate: Date, immediately: Bool = false,
                              currentDate:(() -> Date?)?, block: @escaping (LoverTimerHandler, TimeInterval) -> Void) -> LoverTimerHandler {
        return addHandler(executeImmediately: immediately, dispatchQueue: .main, eventItem: .remindTime(deadDate, currentDate, block))
    }
    @discardableResult
    public func addGlobalHanler(interval: TimeInterval, deadDate: Date, immediately: Bool = false,
                              currentDate:(() -> Date?)?, block: @escaping (LoverTimerHandler, TimeInterval) -> Void) -> LoverTimerHandler {
        return addHandler(executeImmediately: immediately, dispatchQueue: .global(), eventItem: .remindTime(deadDate, currentDate, block))
    }
    @discardableResult
    public func addMainHandler(interval: TimeInterval, immediately: Bool = false, block: @escaping (() -> Void)) -> LoverTimerHandler {
        return addHandler(executeImmediately: immediately, dispatchQueue: .main, eventItem: .normal(block))
    }
    @discardableResult
    public func addGlobalHandler(interval: TimeInterval, immediately: Bool = false, block: @escaping (() -> Void)) -> LoverTimerHandler {
        return addHandler(executeImmediately: immediately, dispatchQueue: nil, eventItem: .normal(block))
    }
    @discardableResult
    private func addHandler(interval: TimeInterval = 1.0, executeImmediately: Bool, dispatchQueue: DispatchQueue?, eventItem: LoverTimerCallbackType) -> LoverTimerHandler {
        let timerBlock = LoverTimerBlock(repeatInterval: interval,
                                         executeImmediately: executeImmediately,
                                         executeBlock: eventItem,
                                         dispatchQueue: dispatchQueue) { [weak self] timerBlock in
            guard let `self` = self else { return }
            self._queue.atomicBlock() { value in
                value.removeValue(forKey: timerBlock.identifier)
            }
        }
        return timerBlock
    }
}
