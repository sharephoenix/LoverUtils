//
//  UIColor+Extension.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/2.
//

import Foundation
import UIKit

public extension UIColor {
    public class func hex(_ hexStr:String, alpha: CGFloat = 1) -> UIColor? {
        return UIColor.hex(hexStr)?.withAlphaComponent(alpha)
    }

    public class func hex(_ hexStr:String) -> UIColor? {
        let hex = hexStr.hasPrefix("#") ? String(hexStr.dropFirst()) : hexStr
        guard let hexUInt32 = UInt32(hex, radix: 16) else { return nil }

        switch hex.count {
        case 3:
            let r = CGFloat((hexUInt32 & 0xF00) >> 8)
            let g = CGFloat((hexUInt32 & 0x0F0) >> 4)
            let b = CGFloat((hexUInt32 & 0x00F))
            return UIColor(red: r / 15.0, green: g / 15.0, blue: b / 15.0, alpha: 1)
        case 4:
            let r = CGFloat((hexUInt32 & 0xF000) >> 12)
            let g = CGFloat((hexUInt32 & 0x0F00) >> 8)
            let b = CGFloat((hexUInt32 & 0x00F0) >> 4)
            let a = CGFloat((hexUInt32 & 0x000F))
            return UIColor(red: r / 15.0, green: g / 15.0, blue: b / 15.0, alpha: a)
        case 6:
            let r = CGFloat((hexUInt32 & 0xFF0000) >> 16)
            let g = CGFloat((hexUInt32 & 0x00FF00) >> 8)
            let b = CGFloat((hexUInt32 & 0x0000FF))
            return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
        case 8:
            let r = CGFloat((hexUInt32 & 0xFF000000) >> 24)
            let g = CGFloat((hexUInt32 & 0x00FF0000) >> 16)
            let b = CGFloat((hexUInt32 & 0x0000FF00) >> 8)
            let a = CGFloat((hexUInt32 & 0x000000FF))
            return UIColor(red: r / 255.0, green: g / 15.0, blue: b / 255.0, alpha: a)
        default:
            return nil
        }
    }
}
