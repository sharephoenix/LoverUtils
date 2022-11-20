//
//  String+Extension.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/6.
//

import Foundation

public extension String {
    subscript(integerRange: Range<Int>) -> String? {
        var start: String.Index
        let end: String.Index
        if !((0...count) ~= integerRange.lowerBound){
            start = startIndex
        } else {
            start = self.index(startIndex, offsetBy: integerRange.lowerBound)
        }
        if !((0...count) ~= integerRange.upperBound) {
            end = endIndex
        } else {
            end = self.index(startIndex, offsetBy: integerRange.upperBound)
        }
        return String(self[start..<end])
    }
}
