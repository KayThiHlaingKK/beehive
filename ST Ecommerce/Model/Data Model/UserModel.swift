//
//  UserModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 12/03/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct Township : Codable {
    var slug : String?
    let name : String?
    let city : City?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case city = "city"
    }

    init(data: Data) throws {
        self = try newJSONDecoder().decode(Township.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        city = try values.decodeIfPresent(City.self, forKey: .city)
    }

}

struct City : Codable {
    let slug : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(City.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}


struct Address : Codable {
    
    var slug : String?
    var label : String?
    var house_number : String?
    var street_name : String?
    var latitude : Double?
    var longitude : Double?
    var is_primary : Bool?
    var floor : Int?
    var township_name: String?
    var township_slug: String?
    var township : Township?
    var distance : Double?
    

    enum CodingKeys: String, CodingKey {

        case label = "label"
        case slug = "slug"
        case house_number = "house_number"
        case floor = "floor"
        case street_name = "street_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case is_primary = "is_primary"
        case township = "township"
        case distance = "distance"
        case township_name = "township_name"
        case township_slug = "township_slug"
    }
    
    init() {
        
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Address.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        house_number = try values.decodeIfPresent(String.self, forKey: .house_number)
        floor = try values.decodeIfPresent(Int.self, forKey: .floor)
        street_name = try values.decodeIfPresent(String.self, forKey: .street_name)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        is_primary = try values.decodeIfPresent(Bool.self, forKey: .is_primary)
        township = try values.decodeIfPresent(Township.self, forKey: .township)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        township_name = try values.decodeIfPresent(String.self, forKey: .township_name)
        township_slug = try values.decodeIfPresent(String.self, forKey: .township_slug)
    }

}

struct Profile : Codable {
    let id : Int?
    let slug : String?
    let email : String?
    let name : String?
    let phone_number : String?
    let gender : String?
    let date_of_birth : String?
    let is_enable : Bool?
    let addresses : [Address]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case slug = "slug"
        case email = "email"
        case name = "name"
        case phone_number = "phone_number"
        case gender = "gender"
        case date_of_birth = "date_of_birth"
        case is_enable = "is_enable"
        case addresses = "addresses"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Profile.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        date_of_birth = try values.decodeIfPresent(String.self, forKey: .date_of_birth)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        addresses = try values.decodeIfPresent([Address].self, forKey: .addresses)
    }

}


