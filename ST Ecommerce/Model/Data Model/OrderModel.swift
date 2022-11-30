//
//  OrderModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 07/04/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation

struct OrderModel : Codable {
    let status : Int?
    let data : Order?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OrderModel.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent(Order.self, forKey: .data)
    }
}

struct Order : Codable {
    
    let slug : String?
    let order_date : String?
    let prepay_id : String?
    
    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case order_date = "order_date"
        case prepay_id = "prepay_id"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Order.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        order_date = try values.decodeIfPresent(String.self, forKey: .order_date)
        prepay_id = try values.decodeIfPresent(String.self, forKey: .prepay_id)
    }
}
    

struct RestaurantOrderModel : Codable {
    let status : Int?
    let data : [RestaurantOrder]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RestaurantOrderModel.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent([RestaurantOrder].self, forKey: .data)
    }

}

struct OrderReview: Codable {
    let target_id: Int?
    let target_type: String?
    let source_id: Int?
    let source_type: String?
    let rating: Double?
    let review: String?
}

struct RestaurantOrder : Codable {
    
    let slug : String?
    let order_date : String?
    let order_type: String?
    let special_instruction : String?
    let payment_mode : String?
    let payment_status: String?
    let delivery_mode : String?
    let invoice_id : String?
    let restaurant_branch_info : RestaurantBranch?
    let order_status : String?
    let promocode_id : Int?
    let promocode : String?
    let driver: Driver?
    let review: [OrderReview]?
    let promocode_amount : Double?
    let delivery_time: String?
    let total_amount : Double?
    let restaurant_order_contact : Restaurant_order_contact?
    let restaurant_order_items : [Restaurant_Order_Item]?
    let created_by : OrderCreator?
    let updated_by : OrderCreator?
    let amount : Double?
    let discount: Double?
    let tax : Double?
    let extra_charges: [ExtraCharges]?
    let delivery_fee : Double?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case order_date = "order_date"
        case order_type = "order_type"
        case invoice_id = "invoice_id"
        case discount = "discount"
        case special_instruction = "special_instruction"
        case payment_mode = "payment_mode"
        case payment_status = "payment_status"
        case delivery_mode = "delivery_mode"
        case restaurant_branch_info = "restaurant_branch_info"
        case order_status = "order_status"
        case driver = "driver"
        case review = "review"
        case promocode_id = "promocode_id"
        case promocode = "promocode"
        case promocode_amount = "promocode_amount"
        case total_amount = "total_amount"
        case restaurant_order_contact = "restaurant_order_contact"
        case restaurant_order_items = "restaurant_order_items"
        case created_by = "created_by"
        case updated_by = "updated_by"
        case amount = "amount"
        case tax = "tax"
        case extra_charges = "extra_charges"
        case delivery_fee = "delivery_fee"
        case delivery_time = "delivery_time"
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RestaurantOrder.self, from: data)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        order_date = try values.decodeIfPresent(String.self, forKey: .order_date)
        order_type = try values.decodeIfPresent(String.self, forKey: .order_type)
        special_instruction = try values.decodeIfPresent(String.self, forKey: .special_instruction)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        promocode = try values.decodeIfPresent(String.self, forKey: .promocode)
        delivery_time = try values.decodeIfPresent(String.self, forKey: .delivery_time)
        promocode_amount = try values.decodeIfPresent(Double.self, forKey: .promocode_amount)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        delivery_mode = try values.decodeIfPresent(String.self, forKey: .delivery_mode)
        driver = try values.decodeIfPresent(Driver.self, forKey: .driver)
        review = try values.decodeIfPresent([OrderReview].self, forKey: .review)
        restaurant_branch_info = try values.decodeIfPresent(RestaurantBranch.self, forKey: .restaurant_branch_info)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        promocode_id = try values.decodeIfPresent(Int.self, forKey: .promocode_id)
        total_amount = try values.decodeIfPresent(Double.self, forKey: .total_amount)
        restaurant_order_contact = try values.decodeIfPresent(Restaurant_order_contact.self, forKey: .restaurant_order_contact)
        restaurant_order_items = try values.decodeIfPresent([Restaurant_Order_Item].self, forKey: .restaurant_order_items)
        created_by = try values.decodeIfPresent(OrderCreator.self, forKey: .created_by)
        updated_by = try values.decodeIfPresent(OrderCreator.self, forKey: .updated_by)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        delivery_fee = try values.decodeIfPresent(Double.self, forKey: .delivery_fee)
        extra_charges = try values.decodeIfPresent([ExtraCharges].self, forKey: .extra_charges)
        payment_status = try values.decodeIfPresent(String.self, forKey: .payment_status)
        
    }

}

struct Restaurant_order_contact : Codable {
    let customer_name : String?
    let phone_number : String?
    let house_number : String?
    let floor : Int?
    let street_name : String?
    let latitude : Double?
    let longitude : Double?
    let township : Township?

    enum CodingKeys: String, CodingKey {

        case customer_name = "customer_name"
        case phone_number = "phone_number"
        case house_number = "house_number"
        case floor = "floor"
        case street_name = "street_name"
        case latitude = "latitude"
        case longitude = "longitude"
        case township = "township"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
        house_number = try values.decodeIfPresent(String.self, forKey: .house_number)
        floor = try values.decodeIfPresent(Int.self, forKey: .floor)
        street_name = try values.decodeIfPresent(String.self, forKey: .street_name)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        township = try values.decodeIfPresent(Township.self, forKey: .township)
    }

}

struct Restaurant_Order_Item : Codable {
    let menu_name : String?
    let quantity : Int?
    let amount : Double?
    let tax : Double?
    let discount : Double?
    let extracharges: [ExtraCharges]?
    let variations : [Variations]?
    let toppings : [Toppings]?
    let options: [VariantOption]?
    let is_deleted : Bool?
    let images : [Images]?

    enum CodingKeys: String, CodingKey {

        case menu_name = "menu_name"
        case quantity = "quantity"
        case amount = "amount"
        case tax = "tax"
        case discount = "discount"
        case extracharges = "extra_charges"
        case variations = "variations"
        case options = "options"
        case toppings = "toppings"
        case is_deleted = "is_deleted"
        case images = "images"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        menu_name = try values.decodeIfPresent(String.self, forKey: .menu_name)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        variations = try values.decodeIfPresent([Variations].self, forKey: .variations)
        toppings = try values.decodeIfPresent([Toppings].self, forKey: .toppings)
        is_deleted = try values.decodeIfPresent(Bool.self, forKey: .is_deleted)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        options = try values.decodeIfPresent([VariantOption].self, forKey: .options)
        extracharges = try values.decodeIfPresent([ExtraCharges].self, forKey: .extracharges)
    }
    
    func concatToppingsAndVariations() -> String {
        var textForVariant = ""
        if let itemVariant = self.variations {
            let variants = itemVariant.compactMap { $0.name }
            let variantText = variants.joined(separator: "\n")
            textForVariant += variantText
        }
        
        if variations?.count ?? 0 > 0 && toppings?.count ?? 0 > 0 {
            textForVariant += "\n"
        }
        
        if let itemTopings = self.toppings , itemTopings.count > 0 {
            let toppings = itemTopings.compactMap{ $0.name }
            let toppingText = toppings.joined(separator: ", ")
            textForVariant += toppingText
        }
        
        if toppings?.count ?? 0 > 0 && options?.count ?? 0 > 0 {
            textForVariant += "\n"
        }
        
        if let menuOptions = self.options , menuOptions.count > 0 {
            let options = menuOptions.compactMap{ $0.name }
            let optionsText = options.joined(separator: ", ")
            textForVariant += optionsText
        }
        return textForVariant
    }

}

struct Variations : Codable {
    let name : String?
    let value : String?
    let price : Double?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case value = "value"
        case price = "price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
    }

}

struct Toppings : Codable {
    let name : String?
    let value : Int?
    let price : Double?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case value = "value"
        case price = "price"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
    }

}

struct ProductOrderModel : Codable {
    let status : Int?
    let data : [ProductOrder]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductOrderModel.self, from: data)
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        data = try values.decodeIfPresent([ProductOrder].self, forKey: .data)
    }

}

struct Contact: Codable {
    let customer_name: String?
    let phone_number: String?
    let house_number: String?
    let floor: String?
    let street_name: String?
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case customer_name, phone_number, house_number, floor, street_name, latitude, longitude
    }
    
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Contact.self, from: data)
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
        house_number = try values.decodeIfPresent(String.self, forKey: .house_number)
        floor = try values.decodeIfPresent(String.self, forKey: .floor)
        street_name = try values.decodeIfPresent(String.self, forKey: .street_name)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
    }
}

struct ProductOrder : Codable {
    
    let slug : String?
    let order_date : String?
    let special_instruction : String?
    let payment_mode : String?
    let payment_status: String?
    let delivery_mode : String?
    let promocode : String?
    let driver: Driver?
    let promocode_amount : Double?
    let delivery_fee: Double?
    let customer_id : Int?
    let order_status : String?
    let created_by : OrderCreator?
    let updated_by : OrderCreator?
    let items : [Shop_Order_Item]?
    let invoice_id : String?
    let total_amount : Double?
    let prepay_id : String?
    let amount : Double?
    let review: [OrderReview]?
    let tax : Double?
    let discount : Double?
    let contact: Contact?
   
    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case driver = "driver"
        case order_date = "order_date"
        case special_instruction = "special_instruction"
        case payment_mode = "payment_mode"
        case payment_status = "payment_status"
        case delivery_mode = "delivery_mode"
        case promocode = "promocode"
        case promocode_amount = "promocode_amount"
        case customer_id = "customer_id"
        case order_status = "order_status"
        case created_by = "created_by"
        case updated_by = "updated_by"
        case items = "items"
        case review = "review"
        case invoice_id = "invoice_id"
        case total_amount = "total_amount"
        case prepay_id = "prepay_id"
        case amount = "amount"
        case tax = "tax"
        case discount = "discount"
        case contact = "contact"
        case delivery_fee = "delivery_fee"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        driver = try values.decodeIfPresent(Driver.self, forKey: .driver)
        order_date = try values.decodeIfPresent(String.self, forKey: .order_date)
        special_instruction = try values.decodeIfPresent(String.self, forKey: .special_instruction)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        review = try values.decodeIfPresent([OrderReview].self, forKey: .review)
        delivery_mode = try values.decodeIfPresent(String.self, forKey: .delivery_mode)
        promocode = try values.decodeIfPresent(String.self, forKey: .promocode)
        promocode_amount = try values.decodeIfPresent(Double.self, forKey: .promocode_amount)
        customer_id = try values.decodeIfPresent(Int.self, forKey: .customer_id)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        created_by = try values.decodeIfPresent(OrderCreator.self, forKey: .created_by)
        updated_by = try values.decodeIfPresent(OrderCreator.self, forKey: .updated_by)
        items = try values.decodeIfPresent([Shop_Order_Item].self, forKey: .items)
        invoice_id = try values.decodeIfPresent(String.self, forKey: .invoice_id)
        total_amount = try values.decodeIfPresent(Double.self, forKey: .total_amount)
        prepay_id = try values.decodeIfPresent(String.self, forKey: .prepay_id)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        contact = try values.decodeIfPresent(Contact.self, forKey: .contact)
        payment_status = try values.decodeIfPresent(String.self, forKey: .payment_status)
        delivery_fee = try values.decodeIfPresent(Double.self, forKey: .delivery_fee)
    }
    

}

struct Shop_Order_Item : Codable {
    
    let slug: String?
    let product_name : String?
    let quantity : Int?
    let amount : Double?
    let tax : Double?
    let discount : Double?
    let variations : [ProductVariation]?
    let shop : Shop?
    let images : [Images]?
    let order_status : String?
    let total_amount : Double?
    let review: OrderReview?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case product_name = "product_name"
        case quantity = "quantity"
        case amount = "amount"
        case review = "review"
        case tax = "tax"
        case discount = "discount"
        case variations = "variations"
        case shop = "shop"
        case images = "images"
        case order_status = "order_status"
        case total_amount = "total_amount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        product_name = try values.decodeIfPresent(String.self, forKey: .product_name)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        review = try values.decodeIfPresent(OrderReview.self, forKey: .review)
        tax = try values.decodeIfPresent(Double.self, forKey: .tax)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        variations = try values.decodeIfPresent([ProductVariation].self, forKey: .variations)
        shop = try values.decodeIfPresent(Shop.self, forKey: .shop)
        images = try values.decodeIfPresent([Images].self, forKey: .images)
        order_status = try values.decodeIfPresent(String.self, forKey: .order_status)
        total_amount = try values.decodeIfPresent(Double.self, forKey: .total_amount)
    }

}

struct OrderCreator : Codable {
    let slug : String?
    let username : String?
    let name : String?
    let phone_number : String?

    enum CodingKeys: String, CodingKey {

        case slug = "slug"
        case username = "username"
        case name = "name"
        case phone_number = "phone_number"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        slug = try values.decodeIfPresent(String.self, forKey: .slug)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phone_number = try values.decodeIfPresent(String.self, forKey: .phone_number)
    }

}
