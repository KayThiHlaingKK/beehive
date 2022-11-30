//
//  CartModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 27/08/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct CartData : Codable {
    var restaurant : RestaurantCart?
    var shop : ShopCart?

    enum CodingKeys: String, CodingKey {

        case restaurant = "restaurant"
        case shop = "shop"
    }
    init() {

    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CartData.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        restaurant = try values.decodeIfPresent(RestaurantCart.self, forKey: .restaurant)
        shop = try values.decodeIfPresent(ShopCart.self, forKey: .shop)
    }

}

struct ShopCart : Codable {
    var slug : String?
    var address: Address?
    var promocode : String?
    var sub_total : Double?
    var total_tax : Double?
    var promo_amount : Double?
    var total_amount : Double?
    var delivery_fee: Double?
    var shops : [Shop]?
    var extra_charges: [ExtraCharges]?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case address = "address"
        case promocode = "promocode"
        case sub_total = "sub_total"
        case total_tax = "total_tax"
        case promo_amount = "promo_amount"
        case total_amount = "total_amount"
        case shops = "shops"
        case delivery_fee = "delivery_fee"
        case extra_charges = "extra_charges"
    }

    init() {

    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ShopCart.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
        promocode = try values.decodeIfPresent(String.self, forKey: .promocode)
        sub_total = try values.decodeIfPresent(Double.self, forKey: .sub_total)
        total_tax = try values.decodeIfPresent(Double.self, forKey: .total_tax)
        promo_amount = try values.decodeIfPresent(Double.self, forKey: .promo_amount)
        total_amount = try values.decodeIfPresent(Double.self, forKey: .total_amount)
        delivery_fee = try values.decodeIfPresent(Double.self, forKey: .delivery_fee)
        shops = try values.decodeIfPresent([Shop].self, forKey: .shops)
        extra_charges = try values.decodeIfPresent([ExtraCharges].self, forKey: .extra_charges)
    }

}

struct ExtraCharges: Codable {
    var key: String?
    var name: String?
    var value: String?
}

struct RestaurantCart : Codable {
    var slug : String?
    var restaurant : Restaurant?
    var restaurant_branch : RestaurantBranch?
    var address: Address?
    var distance: Double?
    var promocode : String?
    var sub_total : Double?
    var total_tax : Double?
    var promo_amount : Double?
    var total_amount : Double?
    var menus : [MenusCart]?
    var delivery_fee : Double?
    var extra_charges: [ExtraCharges]?


    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case restaurant = "restaurant"
        case restaurant_branch = "restaurant_branch"
        case distance = "distance"
        case promocode = "promocode"
        case sub_total = "sub_total"
        case total_tax = "total_tax"
        case promo_amount = "promo_amount"
        case total_amount = "total_amount"
        case menus = "menus"
        case delivery_fee = "delivery_fee"
        case extra_charges = "extra_charges"
        case address = "address"
    }
    init() {

    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RestaurantCart.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        restaurant = try values.decodeIfPresent(Restaurant.self, forKey: .restaurant)
        restaurant_branch = try values.decodeIfPresent(RestaurantBranch.self, forKey: .restaurant_branch)
        promocode = try values.decodeIfPresent(String.self, forKey: .promocode)
        sub_total = try values.decodeIfPresent(Double.self, forKey: .sub_total)
        total_tax = try values.decodeIfPresent(Double.self, forKey: .total_tax)
        promo_amount = try values.decodeIfPresent(Double.self, forKey: .promo_amount)
        total_amount = try values.decodeIfPresent(Double.self, forKey: .total_amount)
        menus = try values.decodeIfPresent([MenusCart].self, forKey: .menus)
        delivery_fee = try values.decodeIfPresent(Double.self, forKey: .delivery_fee)
        extra_charges = try values.decodeIfPresent([ExtraCharges].self, forKey: .extra_charges)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
    }

}


struct MenusCart : Codable {
    let slug : String?
    let key : String?
    let name : String?
    let description : String?
    let amount : Double?
    let tax : Double?
    let discount : Double?
    let quantity : Int?
    let specialInstruction: String?
    let variant : Menu_variants?
    let toppings : [MenuTopping]?
    let options: [VariantOption]?
    let images : [Images]?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case key = "key"
        case name = "name"
        case description = "description"
        case amount = "amount"
        case tax = "tax"
        case discount = "discount"
        case quantity = "quantity"
        case variant = "variant"
        case toppings = "toppings"
        case images = "images"
        case options = "options"
        case specialInstruction = "special_instruction"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        variant = try values.decodeIfPresent(Menu_variants.self, forKey: .variant)
        toppings = try values.decodeIfPresent([MenuTopping].self, forKey: .toppings)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        options = try values.decodeIfPresent([VariantOption].self, forKey: .options)
        specialInstruction = try values.decodeIfPresent(String.self, forKey: .specialInstruction)
    }

}
