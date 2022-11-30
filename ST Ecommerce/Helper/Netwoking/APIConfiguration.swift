//
//  APIConfiguration.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation


protocol DictionaryConvertible {
    var keyMappingDict: [String: String] { get }
}

extension DictionaryConvertible {
    var asDictionary : [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.map({ (key: String?, value: Any) -> (String, Any)? in
            guard let key = key, key != "keyMappingDict", let dictKey = keyMappingDict[key] else { return nil }
            return (dictKey, value)
        }).compactMap { $0 })
        return dict
    }
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        forEach({ output += "\($0.key)=\($0.value)&" })
        output = String(output.dropLast())
        return output
    }
}
