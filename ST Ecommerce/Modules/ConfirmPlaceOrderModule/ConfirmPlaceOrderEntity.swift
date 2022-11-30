//
//  ConfirmPlaceOrderEntity.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 8/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//


import Foundation

struct UserSettingModel: Codable{
    let success: Bool?
    let message: String?
    let status: Int?
    let data: [UserSettingData]?
}

struct UserSettingData: Codable{
    let key: String?
    let value: String?
    let group_name: String?
}

struct ConfirmOrderRequest {
    var order_date: String
    var payment_mode: String
    var order_type: String
    var special_instruction: String
    var source: String
    var version: String
    var customer_name: String
    var phone_number: String
    var house_number: String
    var floor: Int
    var street_name: String
    var latitude: Double
    var longitude: Double
    var township_slug: String
}

struct CheckOutModel: Codable{
    let status: Int?
    let message: String?
    let data: OrderData?
}

struct ViewCartModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: CartData?
}

struct PaymentOption {
    var kbzValue = ""
    var cbValue = ""
    var mpuValue = ""
    var mpgsValue = ""
    var credit = ""
}
