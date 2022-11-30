//
//  CustomUserDefaults.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/20/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

class CustomUserDefaults {
    // define all keys needed
    enum DefaultsKey: String, CaseIterable {
        case deliDateTime
        case deliTime
        case deliMode
        case deliDate
        case kbzValue
        case cbValue
        case mpuValue
        case mpgsValue
        case orderLeadTime
        case leadTimeMinute
        case radius
    }
    static let shared = CustomUserDefaults()
    private let defaults = UserDefaults.standard

    init() {}
    // to set value using pre-defined key
    func set(_ value: Any?, key: DefaultsKey) {
        defaults.setValue(value, forKey: key.rawValue)
    }
    // get value using pre-defined key
    func get(key: DefaultsKey) -> Any? {
        return defaults.value(forKey: key.rawValue)
    }
    // check value if exist or nil
    func hasValue(key: DefaultsKey) -> Bool {
        return defaults.value(forKey: key.rawValue) != nil
    }
    // remove all stored values
    func removeAll() {
        for key in DefaultsKey.allCases {
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
