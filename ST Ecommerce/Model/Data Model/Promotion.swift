//
//  Promotion.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 06/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation
                
struct Promotion: Codable {
    let slug: String?
    let title: String?
    let targetType: TargetType
    let value: String?
    let createdAt: String?
    let isFavorite: Bool?
    let promocodeId: Int?
    let images: [Image]?
    let promoCode: Promo?
    
    enum CodingKeys: String, CodingKey {
        case slug, title, targetType = "target_type", value, images
        case promoCode = "promocode"
        case createdAt = "created_at", isFavorite = "is_favorite"
        case promocodeId = "promocode_id"
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Promotion.self, from: data)
    }
}

enum TargetType: String, Codable {
    case product, restaurant, restaurantBranch = "restaurant_branch", shop, brand, link, menu, emptyString = "", collection = "collection"
}

struct Image: Codable {
    let slug: String?
    let fileName: String?
    let fileExtension: String?
    let type: String?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case slug, type, url
        case fileName = "file_name", fileExtension = "extension"
    }
}

struct Promo: Codable {
    let slug: String?
    let code: String?
    let description: String?
    let amount: Int?
    let type: String?
    let usage: String?
    let createdBy: Admin?
    let updatedBy: Admin?
    let walkIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case slug, code, description, amount, type, usage
        case createdBy = "created_by", updatedBy = "updated_by"
        case walkIn = "walk_in"
    }
}

struct Admin: Codable {
    let slug: String?
    let username: String?
    let name: String?
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case slug, username, name
        case phoneNumber = "phone_number"
    }
    
    
}
