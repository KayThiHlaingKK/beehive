//
//  ContentEntity.swift
//  ST Ecommerce
//
//  Created Ku Ku Zan on 7/14/22.
//  Copyright © 2022 Shashi. All rights reserved.


import Foundation

struct ItemContentRequest {
    var slug: String = ""
    var size : String = ""
    var page : String = ""
}

struct ItemContentModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: [Product]?
    let last_page: Int?
}

