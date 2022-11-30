//
//  Announcement.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 05/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct AnnouncementModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: [Announcement]?
    let last_page: Int?
}

struct Announcement: Codable {
    let slug: String?
    let label: String?
    let title: String?
    let promoName: String?
    let targetType: TargetType?
    let value: String?
    let description: String?
    let createdBy: Admin?
    let updatedBy: Admin?
    let createdAt: String?
    let isFavorite: Bool?
    let covers: [Cover]?
    
    enum CodingKeys: String, CodingKey {
        case slug, label, title, targetType = "target_type"
        case description, covers, value
        case createdBy = "created_by", updatedBy = "updated_by"
        case createdAt = "created_at", isFavorite = "is_favorite"
        case promoName = "promo_name"
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Announcement.self, from: data)
    }
}

struct Cover: Codable {
    let slug: String?
    let fileName: String?
    let fileExtension: String?
    let type: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case slug, type, url
        case fileName = "file_name", fileExtension = "extension"
    }
}
