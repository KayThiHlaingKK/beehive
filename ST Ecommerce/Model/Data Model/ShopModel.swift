//
//  ShopModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 14/03/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct Product : Codable {
    var search_index : Int?
    var slug : String?
    var name : String?
    var description : String?
    var price : Double?
    var is_enable : Bool?
    var is_favorite : Bool?
    var images : [Images]?
    var content_name: String?
    var covers : [Images]?
    var shop : Shop?
    var shop_category : ShopCategory?
    var brand : Brand?
    var shop_sub_category : ShopSubCategory?
    var product_variations : [ProductVariation]?
    var orderCount: Int?
    var tax : Double?
    var discount : Double?
    var rating : String?
    var variants : [Variants]?
    var product_variants : [ProductVariant]?
    
    
    enum CodingKeys: String, CodingKey {

        case search_index = "search_index"
        case slug = "slug"
        case name = "name"
        case description = "description"
        case price = "price"
        case is_enable = "is_enable"
        case is_favorite = "is_favorite"
        case images = "images"
        case content_name = "content_name"
        case covers = "covers"
        case shop = "shop"
        case shop_category = "shop_category"
        case brand = "brand"
        case shop_sub_category = "shop_sub_category"
        case product_variations = "product_variations"
        case orderCount = "orderCount"
        case tax = "tax"
        case discount = "discount"
        case rating = "rating"
        case variants = "variants"
        case product_variants = "product_variants"
    }
    init() {
        
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Product.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        search_index = try values.decodeIfPresent(Int.self, forKey: .search_index)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        is_favorite = try values.decodeIfPresent(Bool.self, forKey: .is_favorite)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        content_name = try values.decodeIfPresent(String.self, forKey: .content_name)
        covers = try values.decodeIfPresent([Images].self, forKey: .covers)
        shop = try values.decodeIfPresent(Shop.self, forKey: .shop)
        shop_category = try values.decodeIfPresent(ShopCategory.self, forKey: .shop_category)
        brand = try values.decodeIfPresent(Brand.self, forKey: .brand)
        shop_sub_category = try values.decodeIfPresent(ShopSubCategory.self, forKey: .shop_sub_category)
        product_variations = try values.decodeIfPresent([ProductVariation].self, forKey: .product_variations)
        orderCount = try values.decodeIfPresent(Int.self, forKey: .orderCount) ?? 0
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        variants = try values.decodeIfPresent([Variants].self, forKey: .variants)
        product_variants = try values.decodeIfPresent([ProductVariant].self, forKey: .product_variants)
    }

}

struct DefaultVariant : Codable , Equatable{
    var name: String?
    var value: String?

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}


struct ProductVariant : Codable {
    var slug : String?
//    var variant : [Variant]?
    var variant: [DefaultVariant]?
    var price : Double?
    var tax : Double?
    var discount : Double?
    var is_enable : Bool?
    var qty: Int?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case variant = "variant"
        case price = "price"
        case tax = "tax"
        case discount = "discount"
        case is_enable = "is_enable"
        case qty = "qty"
    }

    init() {
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        variant = try values.decodeIfPresent([DefaultVariant].self, forKey: .variant)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
    }
//    static func == (lhs: ProductVariant, rhs: ProductVariant) -> Bool {
//        return lhs.slug == rhs.slug && lhs.variant == rhs.variant && lhs.price == rhs.price
//    }

}

public struct Variant : Codable, Equatable {
    let variant: [Variant]?
    public let name : String?
    public let value : String?
    var isSelected: Bool = false //for product
    
   
    enum CodingKeys: String, CodingKey {
        case variant = "variant"
        case name = "name"
        case value = "value"
        case isSelected = "isSelected"
    }

    public init(variant: [Variant],name: String,value: String,isSelected: Bool) {
        self.variant = variant
        self.name = name
        self.value = value
        self.isSelected = isSelected
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        variant = try values.decodeIfPresent([Variant].self, forKey: .variant)
    }
    
    public static func == (lhs: Variant, rhs: Variant) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value && lhs.isSelected == rhs.isSelected && lhs.variant == rhs.variant
    }

}
struct Variants : Codable, Equatable {
    var name : String?
    var values_ : [Values_]?
    var ui : String?
    var selectedValue : String?
    var qty: Int?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case values_ = "values"
        case ui = "ui"
        case selectedValue = "selectedValue"
        case qty = "qty"
    }

    init() {
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        values_ = try values.decodeIfPresent([Values_].self, forKey: .values_)
        ui = try values.decodeIfPresent(String.self, forKey: .ui)
        selectedValue = try values.decodeIfPresent(String.self, forKey: .selectedValue)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
    }
    
    static func == (lhs: Variants, rhs: Variants) -> Bool {
        return lhs.name == rhs.name && lhs.selectedValue == rhs.selectedValue
    }

}

struct Values_ : Codable {
    let value : String?
    let image_slug : String?

    enum CodingKeys: String, CodingKey {

        case value = "value"
        case image_slug = "image_slug"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        image_slug = try values.decodeIfPresent(String.self, forKey: .image_slug)
    }

}

struct Images : Codable {
    let slug : String?
    let file_name : String?
    let image_extension : String?
    let type : String?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case file_name = "file_name"
        case image_extension = "extension"
        case type = "type"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        file_name = try values.decodeIfPresent(String.self, forKey: .file_name)
        image_extension = try values.decodeIfPresent(String.self, forKey: .image_extension)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

struct Shop : Codable {
    var slug : String?
    var name : String?
    var is_official : Bool?
    var is_enable : Bool?
    var address : String?
    var contact_number : String?
    var opening_time : String?
    var closing_time : String?
    var latitude : Double?
    var longitude : Double?
    var rating : Double?
    var images : [Images]?
    var order_status : String?
    var items : [Shop_Order_Item]?
    var productCarts : [ProductCart]?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case is_official = "is_official"
        case is_enable = "is_enable"
        case address = "address"
        case contact_number = "contact_number"
        case opening_time = "opening_time"
        case closing_time = "closing_time"
        case latitude = "latitude"
        case longitude = "longitude"
        case rating = "rating"
        case images = "images"
        case order_status = "order_status"
        case items = "items"
        case productCarts = "products"
    }
    
    init(){
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Shop.self, from: data)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        is_official = try values.decodeIfPresent(Bool.self, forKey: .is_official)
        is_enable = try values.decodeIfPresent(Bool.self, forKey: .is_enable)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        contact_number = try values.decodeIfPresent(String.self, forKey: .contact_number)
        opening_time = try values.decodeIfPresent(String.self, forKey: .opening_time)
        closing_time = try values.decodeIfPresent(String.self, forKey: .closing_time)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        items = try values.decodeIfPresent([Shop_Order_Item].self, forKey: .items)
        productCarts = try values.decodeIfPresent([ProductCart].self, forKey: .productCarts)
    }

}
struct ShopSubCategory : Codable {
    let search_index: Int?
    let code: String?
    let slug: String?
    let name: String?
    let images: [Image]?

    enum CodingKeys: String, CodingKey {

        case search_index = "search_index"
        case code = "code"
        case slug = "slug"
        case name = "name"
        case images = "images"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        search_index = try values.decodeIfPresent(Int.self, forKey: .search_index)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        images = try values.decodeIfPresent([Image].self, forKey: .images)
    }

}

struct ProductVariation : Codable {
    var slug : String?
    var name : String?
    //var product_variation_values : [ProductVariationValue]?
    var firstTime : Bool = true

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        //case product_variation_values = "product_variation_values"
        case firstTime = "firstTime"
    }
    
    init() {
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        //product_variation_values = try values.decodeIfPresent([ProductVariationValue].self, forKey: .product_variation_values)
        firstTime = try values.decodeIfPresent(Bool.self, forKey: .firstTime) ?? true
    }
    

}

struct ProductCart : Codable {
    var key : String?
    var slug : String?
    var name : String?
    var description : String?
    var amount : Double?
    var tax : Double?
    var discount : Double?
    var quantity : Int?
    var variant : Variant?
    var images : [Images]?
    var shopName: String?
    var shopSlug: String?

    enum CodingKeys: String, CodingKey {

        case key = "key"
        case slug = "slug"
        case name = "name"
        case description = "description"
        case amount = "amount"
        case tax = "tax"
        case discount = "discount"
        case quantity = "quantity"
        case variant = "variant"
        case images = "images"
    }
    
    init() {
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        variant = try values.decodeIfPresent(Variant.self, forKey: .variant)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
    }

}

struct CartProductVariation : Codable, Equatable {
    var slug : String?
    var name : String?
    var choose_values : Variant?
    var price : String?
    var tax : String?
    var discount : String?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case choose_values = "variant"
        case price = "price"
        case tax = "tax"
        case discount = "discount"
    }

    init() {
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        choose_values = try values.decodeIfPresent(Variant.self, forKey: .choose_values)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        tax = try values.decodeIfPresent(String.self, forKey: .tax)
    }
    static func == (lhs: CartProductVariation, rhs: CartProductVariation) -> Bool {
        return lhs.slug == rhs.slug && lhs.choose_values == rhs.choose_values
    }

}

struct ProductVariationValue : Codable, Equatable {
    let slug : String?
    let value : String?
    let price : Double?
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case value = "value"
        case price = "price"
        case isSelected = "isSelected"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        isSelected = try values.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }
    static func == (lhs: ProductVariationValue, rhs: ProductVariationValue) -> Bool {
        return lhs.slug == rhs.slug && lhs.isSelected == rhs.isSelected
    }

}
struct ShopCategory : Codable {
    let id : Int?
    let search_index: Int?
    let code: String?
    let slug : String?
    let name : String?
    let images : [Images]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case slug = "slug"
        case name = "name"
        case images = "images"
        case search_index = "search_index"
        case code = "code"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ShopCategory.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        search_index = try values.decodeIfPresent(Int.self, forKey: .search_index)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        
    }

}

struct ShopCategoryMenu: Codable {
    let slug: String?
    let name: String?
    let code: String?
    let search_index: Int?
    let images: [Image]?
    let shop_categories: [CategorizedProduct]?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case code = "code"
        case search_index = "search_index"
        case images = "images"
        case shop_categories = "shop_categories"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ShopCategoryMenu.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        search_index = try values.decodeIfPresent(Int.self, forKey: .search_index)
        images = try values.decodeIfPresent([Image].self, forKey: .images)
        shop_categories = try values.decodeIfPresent([CategorizedProduct].self, forKey: .shop_categories)
    }
}

struct CategorizedProduct : Codable {
    let id: Int?
    let slug: String?
    let code: String?
    let name: String?
    let products : [Product]?
    let search_index: Int?
    let images: [Image]?
    let shop_sub_categories : [ShopSubCategory]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case slug = "slug"
        case name = "name"
        case code = "code"
        case search_index = "search_index"
        case products = "products"
        case images = "images"
        case shop_sub_categories = "shop_sub_categories"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CategorizedProduct.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        search_index = try values.decodeIfPresent(Int.self, forKey: .search_index)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
        images = try values.decodeIfPresent([Image].self, forKey: .images)
        shop_sub_categories = try values.decodeIfPresent([ShopSubCategory].self, forKey: .shop_sub_categories)
    }

}

struct Brand : Codable {
    let slug : String?
    let name : String?
    let images : [Images]?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case images = "images"
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Brand.self, from: data)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
    }

}

struct SearchProduct : Codable {
    let status : Int?
    var data : [Product]?
    let lastPage : Int?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case lastPage = "last_page"
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchProduct.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent([Product].self, forKey: .data)
        lastPage = try values.decodeIfPresent(Int.self, forKey: .lastPage)
    }

}


struct CartProduct : Codable {
    var slug : String?
    var name : String?
    var price : String?
    var discount : String?
    var tax: Double?
    var images : [Images]?
    var shop : Shop?
    var productVariant : ProductVariant?
    var orderCount: Double?
    var isExpanded: Bool? = false
    var subTotal: Double? = 0 // ( price + variation + topping - discount )
    var total: Double? = 0
    var promotion: Int? = 0

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case name = "name"
        case price = "price"
        case discount = "discount"
        case tax = "tax"
        case images = "images"
        case shop = "shop"
        case orderCount = "orderCount"
        case isExpanded = "isExpanded"
        case subTotal = "subTotal"
        case total = "total"
        case promotion = "promotion"
        case productVariant = "productVariant"
    }
    
    init() {
        
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CartProduct.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        discount = try values.decodeIfPresent(String.self, forKey: .discount)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        shop = try values.decodeIfPresent(Shop.self, forKey: .shop)
        orderCount = try values.decodeIfPresent(Double.self, forKey: .orderCount) ?? 0
        isExpanded = try values.decodeIfPresent(Bool.self, forKey: .isExpanded)
        subTotal = try values.decodeIfPresent(Double.self, forKey: .subTotal)
        total = try values.decodeIfPresent(Double.self, forKey: .total)
        promotion = try values.decodeIfPresent(Int.self, forKey: .promotion)
        productVariant = try values.decodeIfPresent(ProductVariant.self, forKey: .productVariant)
    }
    

}


struct ShopProduct : Codable {
    let products : [Product]?
    let total : Int?
    let join_date : String?

    enum CodingKeys: String, CodingKey {

        case products = "products"
        case total = "total"
        case join_date = "join_date"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ShopProduct.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        join_date = try values.decodeIfPresent(String.self, forKey: .join_date)
    }

}
