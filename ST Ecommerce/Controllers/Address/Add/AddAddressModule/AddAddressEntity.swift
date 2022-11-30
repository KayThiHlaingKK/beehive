//
//  AddAddressEntity.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 7/27/22.
//  Copyright © 2022 Shashi. All rights reserved.
//


import Foundation

struct UpdateAddressRequest {
    var customer_slug: String
    var house_number: String
    var floor: Int
    var street_name: String
    var latitude: Double
    var longitude: Double
    var township_slug: String
}

struct AddressRequest {
    var label: String = ""
    var house_number: String = ""
    var street_name: String = ""
    var floor: Int = 0
    var township_slug: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var addressSlug: String = ""
}

struct AddressModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: Address?
}

struct GetAddressModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: [Address]?
}

struct CityTownShipModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: [CityTownShipData]?
}

struct CityTownShipData: Codable {
    let slug: String?
    let name: String?
}

struct UpdateAddressModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: UpdateAddressData?
}

struct ShopUpdateAddressModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: ShopCart?
}


struct FoodUpdateAddressModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: RestaurantCart?
}

struct UpdateAddressData: Codable {
    let slug: String?
    let temp_order_slug: String?
    let restaurant: Restaurant?
    let restaurant_branch: RestaurantBranch?
    let extra_charges: [ExtraCharges]?
    let menus: [MenusCart]?
    let address: Address?
    let delivery_fee: Double?
    let promocode: String?
    let sub_total: Double?
    let total_tax: Double?
    let promo_amount: Int?
    let total_amount: Double?
    let shops: [Shop]?
}
