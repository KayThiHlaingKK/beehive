//
//  HomeModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 09/03/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct HomeData : Codable {
    let restaurant_branches : [RestaurantBranch]?
    let products : [Product]?

    enum CodingKeys: String, CodingKey {

        case restaurant_branches = "restaurant_branches"
        case products = "products"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(HomeData.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        restaurant_branches = try values.decodeIfPresent([RestaurantBranch].self, forKey: .restaurant_branches)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
    }

}

struct BannerData : Codable {
    let status : Int?
    let data : [Banner]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent([Banner].self, forKey: .data)
    }

}
struct Banner : Codable {
    let slug: String
    let label: String?
    let targetType: TargetType?
    let value: String?
    let images: [Images]?
    let source: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case slug, label, targetType = "target_type", value, images, source, type
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Banner.self, from: data)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        slug = try values.decodeIfPresent(String.self, forKey: .slug)!
        label = try values.decodeIfPresent(String.self, forKey: .label)
        targetType = try values.decodeIfPresent(TargetType.self, forKey: .targetType)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}

struct AppVersionData : Codable {
    let ios_version : Ios_version?

    enum CodingKeys: String, CodingKey {

        case ios_version = "ios_version"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AppVersionData.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ios_version = try values.decodeIfPresent(Ios_version.self, forKey: .ios_version)
    }

}

struct Ios_version : Codable {
    let major : Int?
    let minor : Int?
    let patch : Int?

    enum CodingKeys: String, CodingKey {

        case major = "major"
        case minor = "minor"
        case patch = "patch"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        major = try values.decodeIfPresent(Int.self, forKey: .major)
        minor = try values.decodeIfPresent(Int.self, forKey: .minor)
        patch = try values.decodeIfPresent(Int.self, forKey: .patch)
    }

}


struct AlgoSearchData: Codable {
  let name: String
}
