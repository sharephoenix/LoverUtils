//
//  CacheUtils.swift
//  LoverUtils
//
//  Created by phoenix on 2022/11/5.
//

import Foundation
import Darwin

public extension Encodable {
    /// Converting object to postable JSON
    func toDic(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any] {
        guard let data = try? encoder.encode(self),
              let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let json = object as? [String: Any] else { return [:] }
        return json
    }

    func toJsonString() throws ->  String {
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(self)
        let str = String(decoding: encoded, as: UTF8.self)
        return str
    }

    func toJsonData() throws ->  Data {
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(self)
        let str = String(decoding: encoded, as: UTF8.self)
        let jsonData = str.data(using: .utf8)!
        return jsonData
    }
}

public class LoverHelperUtils {
    public static func generalUUID() -> String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let ref: CFString = CFUUIDCreateString(kCFAllocatorDefault, uuid)
        return String(ref)
    }
}

public extension Collection {
    subscript(lover index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
