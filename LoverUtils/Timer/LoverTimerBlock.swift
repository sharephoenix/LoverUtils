//
//  LoverTimerBlock.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/5.
//

import Foundation

public enum LoverTimerStatus {
    case suspend
    case resume
    case cancel
}

public protocol LoverTimerHandler {
    func bind(target: NSObject?) -> LoverTimerHandler
    func cancel()
    func suspend()
    func resume()
    var timeStatus: LoverTimerStatus { get }
}

class LoverTimerBlock: NSObject, LoverTimerHandler {

    var timeStatus: LoverTimerStatus = .resume

    let identifier = LoverHelperUtils.generalUUID()

    public let dispatchSourceTimer: DispatchSourceTimer
    @LoverAtomic
    private var suspendTimes: Int = 0
    var timerStatus: LoverTimerStatus {
        get {
            if suspendTimes > 0 {
                return .suspend
            }
            if dispatchSourceTimer.isCancelled {
                return .cancel
            }
            return .resume
        }
    }
    private(set) var repeatInterval: TimeInterval
    private var executeBlock: LoverTimerCallbackType
    private var removeExecuteBlock: ((LoverTimerBlock) -> Void)
    var combinBlock: (() -> Bool)?
    var willRemove: Bool {
        return combinBlock?() ?? false
    }

    func autoExecuteBlock() {
        switch executeBlock {
        case .normal(let executeBlock):
            executeBlock()
        case .handler(let executeBlock):
            executeBlock(self)
        case .remindTime(let deadDate, let currentDateBlock, let executeBlock):
            let currentDate = currentDateBlock?() ?? Date()
            let remindSeconds = deadDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
            if remindSeconds < 0 { self.cancel() }
            executeBlock(self, remindSeconds)
        }
    }

    init(repeatInterval: TimeInterval,
         executeImmediately: Bool,
         executeBlock: LoverTimerCallbackType,
         dispatchQueue: DispatchQueue?,
         removeExecuteBlock: @escaping (LoverTimerBlock) -> Void, combinBlock: ( () -> Bool)? = nil) {
        self.dispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: dispatchQueue)
        self.repeatInterval = repeatInterval
        self.executeBlock = executeBlock
        self.removeExecuteBlock = removeExecuteBlock
        self.combinBlock = combinBlock
        super.init()
        dispatchSourceTimer.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            guard !self.willRemove else {
                self.cancel()
                return
            }
            self.autoExecuteBlock()
        }
        dispatchSourceTimer.schedule(deadline: .now() + (executeImmediately ? 0 : repeatInterval), repeating: .milliseconds(Int(repeatInterval * 1000)), leeway: .seconds(0))
        dispatchSourceTimer.resume()
    }

    @discardableResult
    func bind(target: NSObject?) -> LoverTimerHandler {
        combinBlock = { [weak target] in
            return target == nil
        }
        return self
    }

    func cancel() {
        for _ in 0..<suspendTimes {
            resume()
        }
        dispatchSourceTimer.cancel()
        self.removeExecuteBlock(self)
    }

    func resume() {
        guard dispatchSourceTimer.isCancelled else {
            LoverLog("定时器销毁，无法重启")
            return
        }
        guard suspendTimes > 0 else { return }
        guard !dispatchSourceTimer.isCancelled else { return }
        suspendTimes -= 1
        dispatchSourceTimer.resume()
    }

    func suspend() {
        guard dispatchSourceTimer.isCancelled else { return }
        suspendTimes += 1
        dispatchSourceTimer.suspend()
    }
}

public enum LoverTimerCallbackType {
    case normal(() -> Void)
    case handler((LoverTimerHandler) -> Void)
    case remindTime(Date, (() -> Date?)?, ((LoverTimerHandler, TimeInterval) -> Void))
}
