//
//  LoverLog.swift
//  LoverCommonUI
//
//  Created by phoenix on 2022/10/30.
//

import Foundation

public enum LoverLogType {
    case info
    case network
    case error
}

public enum LoverLogMessageType {
    case simple
    case middle
    case all
}

public func LoverLog(_ info: Any?, type: LoverLogType = .info, messageType: LoverLogMessageType = .simple, file: String = #fileID, line: Int = #line, fun: String = #function) {
    #if DEBUG
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss.SSS"
    let dateString = dateFormatter.string(from: date)

    switch messageType {
    case .simple:
        print("log(\(type)): ")
    case .middle:
        print("log(\(type)): \(dateString)")
    case .all:
        print("log(\(type)): \(dateString)")
        print("\(fun), \(file), \(line)")
    }
    print(info ?? "")
    #endif
}
