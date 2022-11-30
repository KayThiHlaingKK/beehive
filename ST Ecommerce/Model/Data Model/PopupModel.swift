//
//  PopupModel.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 12/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//


import Foundation

struct PopupModel: Codable, Equatable {

    let slug: String?
    let searchIndex: Int?
    let label: String?
    let targetType: TargetType?
    let value: String?
    let note: String?
    let type: String?
    let source: String?
    let images: [Image]?
    
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
    
    enum CodingKeys: String, CodingKey {
        case slug, searchIndex = "search_index", label, targetType = "target_type", value, note, type, source, images
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PopupModel.self, from: data)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        searchIndex = try values.decodeIfPresent(Int.self, forKey: .searchIndex)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        targetType = try values.decodeIfPresent(TargetType.self, forKey: .targetType)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        images = try values.decodeIfPresent([Image].self, forKey: .images)
    }
    
    static func == (lhs: PopupModel, rhs: PopupModel) -> Bool {
        return lhs.slug == rhs.slug
    }
    
    
}
