//
//  ServiceAnnounncement.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 04/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

struct ServiceAnnouncement: Codable {
    var announcement: String?
    var announcement_mm: String?
    var announcement_service: Bool?
    var restaurant_service: Bool?
    var shop_service: Bool?
    
    enum CodingKeys: String, CodingKey {
        case announcement, announcement_mm, announcement_service, restaurant_service, shop_service
    }
    
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ServiceAnnouncement.self, from: data)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        announcement = try values.decodeIfPresent(String.self, forKey: .announcement)
        announcement_mm = try values.decodeIfPresent(String.self, forKey: .announcement_mm)
        announcement_service = try values.decodeIfPresent(Bool.self, forKey: .announcement_service)
        restaurant_service = try values.decodeIfPresent(Bool.self, forKey: .restaurant_service)
        shop_service = try values.decodeIfPresent(Bool.self, forKey: .shop_service)
    }
}



struct UserSetting: Codable{
    var key: String?
    var value: String?
    
}

extension UserSetting {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserSetting.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        key: String?? = nil,
        value: String?? = nil
    ) -> UserSetting {
        return UserSetting(
            key: key ?? self.key,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

