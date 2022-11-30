//
//  RestaurantModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 11/03/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct CategorizedRestaurant : Codable {
    let slug : String?
    let name : String?
    let name_mm : String?
    let restaurant_branches : [RestaurantBranch]?
    let images : [Images]?
    var section: Int?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case name_mm = "name_mm"
        case restaurant_branches = "restaurant_branches"
        case images = "images"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CategorizedRestaurant.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        name_mm = try values.decodeIfPresent(String.self, forKey: .name_mm)
        restaurant_branches = try values.decodeIfPresent([RestaurantBranch].self, forKey: .restaurant_branches)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
    }

}

struct RestaurantBranch : Codable {
    let slug : String?
    let name : String?
    let address : String?
    let contact_number : String?
    let opening_time : String?
    let closing_time : String?
    let township: String?
    let city: String?
    let is_enable : Bool?
    let distance : Double?
    let image_url : String?
    var restaurant : Restaurant?
    let available_menus : [Available_menus]?
    let latitude : Double?
    let longitude : Double?
    let available_categories : [Available_categories]?
    let delivery_time : String?
    let delivery_fee : Int?
    let instant_order : Bool?
    var pre_order : Bool?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case address = "address"
        case contact_number = "contact_number"
        case opening_time = "opening_time"
        case closing_time = "closing_time"
        case is_enable = "is_enable"
        case distance = "distance"
        case image_url = "image_url"
        case restaurant = "restaurant"
        case available_menus = "available_menus"
        case latitude = "latitude"
        case longitude = "longitude"
        case available_categories = "available_categories"
        case delivery_time = "delivery_time"
        case delivery_fee = "delivery_fee"
        case instant_order = "instant_order"
        case pre_order = "pre_order"
        case township = "township"
        case city = "city"
        
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RestaurantBranch.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        contact_number = try values.decodeIfPresent(String.self, forKey: .contact_number)
        opening_time = try values.decodeIfPresent(String.self, forKey: .opening_time)
        closing_time = try values.decodeIfPresent(String.self, forKey: .closing_time)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        restaurant = try values.decodeIfPresent(Restaurant.self, forKey: .restaurant)
        available_menus = try values.decodeIfPresent([Available_menus].self, forKey: .available_menus)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        available_categories = try values.decodeIfPresent([Available_categories].self, forKey: .available_categories)
        delivery_time = try values.decodeIfPresent(String.self, forKey: .delivery_time)
        delivery_fee = try values.decodeIfPresent(Int.self, forKey: .delivery_fee)
        instant_order = try values.decodeIfPresent(Bool.self, forKey: .instant_order)
        pre_order = try values.decodeIfPresent(Bool.self, forKey: .pre_order)
        township = try values.decodeIfPresent(String.self, forKey: .township)
        city = try values.decodeIfPresent(String.self, forKey: .city)
       
    }

}

struct Restaurant : Codable {
    let slug : String?
    let name : String?
    let is_enable : Bool?
    var is_favorite : Bool?
    let rating : Double?
    let images : [Images]?
    let covers : [Images]?
    let available_tags : [Available_tags]?

    enum CodingKeys: String, CodingKey {
        case slug = "slug"
        case name = "name"
        case is_enable = "is_enable"
        case is_favorite = "is_favorite"
        case rating = "rating"
        case images = "images"
        case covers = "covers"
        case available_tags = "available_tags"
    }

    init(data: Data) throws {
        self = try newJSONDecoder().decode(Restaurant.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        is_favorite = try values.decodeIfPresent(Bool.self, forKey: .is_favorite)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        covers = try values.decodeIfPresent([Images].self, forKey: .covers)
        available_tags = try values.decodeIfPresent([Available_tags].self, forKey: .available_tags)
    }

}

struct SearchRestaurant : Codable {
    let status : Int?
    let data : [RestaurantBranch]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchRestaurant.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent([RestaurantBranch].self, forKey: .data)
    }

}



struct Available_menus : Codable {
    var slug : String?
    var name : String?
    var description : String?
    var price : Double?
    var tax : Double?
    var is_enable : Bool?
    var is_available : Bool?
    var images : [Images]?
    var menu_variations : [MenuVariation]?
    var menu_toppings : [MenuTopping]?
    var orderCount : Int = 0
    var discount : Double?
    var variants : [Variant]?
    var menu_variants : [Menu_variants]?
    var menu_options: [MenuOption]?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case description = "description"
        case price = "price"
        case tax = "tax"
        case is_enable = "is_enable"
        case is_available = "is_available"
        case images = "images"
        case menu_variations = "menu_variations"
        case menu_toppings = "menu_toppings"
        case orderCount = "orderCount"
        case discount = "discount"
        case variants = "variants"
        case menu_variants = "menu_variants"
        case menu_options = "menu_options"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        is_available = try values.decodeIfPresent(Bool.self, forKey: .is_available)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        menu_variations = try values.decodeIfPresent([MenuVariation].self, forKey: .menu_variations)
        menu_toppings = try values.decodeIfPresent([MenuTopping].self, forKey: .menu_toppings)
        orderCount = try values.decodeIfPresent(Int.self, forKey: .orderCount) ?? 0
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        variants = try values.decodeIfPresent([Variant].self, forKey: .variants)
        menu_variants = try values.decodeIfPresent([Menu_variants].self, forKey: .menu_variants)
        menu_options = try values.decodeIfPresent([MenuOption].self, forKey: .menu_options)
    }

}

struct Menu_variants : Codable {
    let slug : String?
    let variant : [Variant]?
    let price : Double?
    let tax : Double?
    let discount : Double?
    let extra_charges: [ExtraCharges]?
    let is_enable : Bool?
    var isSelected : Bool = false

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case variant = "variant"
        case price = "price"
        case tax = "tax"
        case discount = "discount"
        case extra_charges = "extra_charges"
        case is_enable = "is_enable"
        case isSelected = "isSelected"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        variant = try values.decodeIfPresent([Variant].self, forKey: .variant)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        extra_charges = try values.decodeIfPresent([ExtraCharges].self, forKey: .extra_charges)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }

}


struct MenuOption: Codable {
    let slug: String?
    let name: String?
    let max_choice: Int?
    let created_by: Admin?
    let updated_by: Admin?
    var options: [VariantOption]?
    
    enum CodingKeys: String, CodingKey {
        case slug = "slug"
        case name = "name"
        case max_choice = "max_choice"
        case created_by = "created_by"
        case updated_by = "updated_by"
        case options = "options"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        max_choice = try values.decodeIfPresent(Int.self, forKey: .max_choice)
        created_by = try values.decodeIfPresent(Admin.self, forKey: .created_by)
        updated_by = try values.decodeIfPresent(Admin.self, forKey: .updated_by)
        options = try values.decodeIfPresent([VariantOption].self, forKey: .options)
    }
}

struct VariantOption: Codable {
    let slug: String?
    let name: String?
    let price: Double?
    let created_by: Admin?
    let updated_by: Admin?
    var selected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case slug = "slug"
        case name = "name"
        case price = "price"
        case created_by = "created_by"
        case updated_by = "updated_by"
        case selected = "selected"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        created_by = try values.decodeIfPresent(Admin.self, forKey: .created_by)
        updated_by = try values.decodeIfPresent(Admin.self, forKey: .updated_by)
        selected = try values.decodeIfPresent(Bool.self, forKey: .selected)
    }
}

struct Available_categories : Codable {
    let slug : String?
    let name : String?
    let images : [Images]?
    let menus : [Available_menus]?
    var selected: Bool = false

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case images = "images"
        case menus = "menus"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        menus = try values.decodeIfPresent([Available_menus].self, forKey: .menus)
        
    }

}

struct Available_tags : Codable {
    let slug : String?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}


struct MenuVariation : Codable {
    let slug : String?
    let name : String?
    var menu_variation_values : [MenuVariationValue]?
    

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case menu_variation_values = "menu_variation_values"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        menu_variation_values = try values.decodeIfPresent([MenuVariationValue].self, forKey: .menu_variation_values)
    }

}

struct MenuVariationValue : Codable, Equatable {
    let slug : String?
    let value : String?
    let price : String?
    let images : [Images]?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case value = "value"
        case price = "price"
        case images = "images"
        case isSelected = "isSelected"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }
    
    static func == (lhs: MenuVariationValue, rhs: MenuVariationValue) -> Bool {
        return lhs.slug == rhs.slug && lhs.isSelected == rhs.isSelected
    }

}

struct MenuTopping : Codable, Equatable {
    
    var slug : String?
    var quantity: Int = 1
    var price : Double?
    var name : String?
    var is_incremental : Bool?
    var max_quantity : Int?
    var images : [Images]?
    
    var isSelected: Bool = false
   
    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case price = "price"
        case is_incremental = "is_incremental"
        case max_quantity = "max_quantity"
        case images = "images"
        case quantity = "quantity"
        case isSelected = "isSelected"
    }

    init() {
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        is_incremental = try values.decodeIfPresent(Bool.self, forKey: .is_incremental)
        max_quantity = try values.decodeIfPresent(Int.self, forKey: .max_quantity)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity) ?? 0
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }
    static func == (lhs: MenuTopping, rhs: MenuTopping) -> Bool {
        return lhs.slug == rhs.slug 
    }

}


struct CartRestaurantBranch : Codable {
    var slug : String?
    var name : String?
    var choose_menus : [CartMenu] = []
    var subTotal : Int = 0
    var total : Int = 0
    var paymentMode: String?
    var opening_time : String?
    var closing_time : String?
    var address : String?
    var restaurant : Restaurant?
    var promotion: Int?
    var preorder: Bool?
    var instantorder: Bool?

    enum CodingKeys: String, CodingKey {
        case slug = "slug"
        case choose_menus = "choose_menus"
        case subTotal = "subTotal"
        case total = "total"
        case paymentMode = "paymentMode"
        case name = "name"
        case address = "address"
        case restaurant = "restaurant"
        case promotion = "promotion"
    }
    init() {

    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CartRestaurantBranch.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        choose_menus = try values.decodeIfPresent([CartMenu].self, forKey: .choose_menus) ?? []
        subTotal = try values.decodeIfPresent(Int.self, forKey: .subTotal) ?? 0
        total = try values.decodeIfPresent(Int.self, forKey: .total) ?? 0
        paymentMode = try values.decodeIfPresent(String.self, forKey: .paymentMode) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        restaurant = try values.decodeIfPresent(Restaurant.self, forKey: .restaurant)
        address = try values.decodeIfPresent(String.self, forKey: .address) ?? ""
        promotion = try values.decodeIfPresent(Int.self, forKey: .promotion) ?? 0
    }

}

struct CartMenu : Codable {
    var slug : String?
    var name : String?
    var price : String?
    var discount : String?
    var tax : Double?
    var menu_variations : [CartMenuVariation]? = []
    var menu_toppings : [CartMenuTopping]? = []
    var orderCount : Int = 0
    var subTotal : Int = 0
    var total : Int = 0
    var images : [Images]?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case price = "price"
        case discount = "discount"
        case tax = "tax"
        case menu_variations = "menu_variations"
        case menu_toppings = "menu_toppings"
        case orderCount = "orderCount"
        case subTotal = "subTotal"
        case images = "images"
        case total = "total"
    }

    init() {

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        menu_variations = try values.decodeIfPresent([CartMenuVariation].self, forKey: .menu_variations)
        menu_toppings = try values.decodeIfPresent([CartMenuTopping].self, forKey: .menu_toppings)
        orderCount = try values.decodeIfPresent(Int.self, forKey: .orderCount) ?? 0
        subTotal = try values.decodeIfPresent(Int.self, forKey: .subTotal) ?? 0
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        total = try values.decodeIfPresent(Int.self, forKey: .total) ?? 0

    }

}


struct CartMenuVariation : Codable, Equatable {

    var slug : String?
    var name : String?
    var choose_values : MenuVariationValue?

    init() {

    }
    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case choose_values = "choose_values"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        choose_values = try values.decodeIfPresent(MenuVariationValue.self, forKey: .choose_values)
    }

    static func == (lhs: CartMenuVariation, rhs: CartMenuVariation) -> Bool {
        return lhs.slug == rhs.slug && lhs.choose_values == rhs.choose_values
    }

}

struct CartMenuTopping : Codable, Equatable {
    var slug : String?
    var name : String?
    var price : String?
    var qty: Int?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case price = "price"
        case qty = "qty"
    }
    init() {

    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
    }

    static func == (lhs: CartMenuTopping, rhs: CartMenuTopping) -> Bool {
        return lhs.slug == rhs.slug && lhs.qty == rhs.qty
    }

}
