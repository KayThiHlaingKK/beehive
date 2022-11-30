//
//  SearchHistory.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 08/12/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct SearchHistory: Codable {
    let keyword: String?
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchHistory.self, from: data)
    }
}
