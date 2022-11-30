//
//  LocalStore.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 13/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

class LocalStore {
    public static let shared = LocalStore()
    private let defaults = UserDefaults.standard
    
    var popupDateString: String? {
        get {
            return defaults.string(forKey: "popupDate") ?? ""
        }
        set {
            defaults.set(newValue, forKey: "popupDate")
        }
    }
}
