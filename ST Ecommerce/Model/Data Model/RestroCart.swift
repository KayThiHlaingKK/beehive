//
//  RestroCart.swift
//  ST Ecommerce
//
//  Created by Necixy on 07/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation

/*
 // MARK: - RestroCart
 struct RestroCart: Codable {
     let restaurant: Restaurant?
     let cartItems: [CartItem]?
     let subtotal, tax, deliveryCharge, total: String?
     let deliveredBy: String?

     enum CodingKeys: String, CodingKey {
         case restaurant
         case cartItems = "cart_items"
         case subtotal, tax
         case deliveryCharge = "delivery_charge"
         case total
         case deliveredBy = "delivered_by"
     }
 }

 // MARK: RestroCart convenience initializers and mutators

 extension RestroCart {
     init(data: Data) throws {
         self = try newJSONDecoder().decode(RestroCart.self, from: data)
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
         restaurant: Restaurant?? = nil,
         cartItems: [CartItem]?? = nil,
         subtotal: String?? = nil,
         tax: String?? = nil,
         deliveryCharge: String?? = nil,
         total: String?? = nil,
         deliveredBy: String?? = nil
     ) -> RestroCart {
         return RestroCart(
             restaurant: restaurant ?? self.restaurant,
             cartItems: cartItems ?? self.cartItems,
             subtotal: subtotal ?? self.subtotal,
             tax: tax ?? self.tax,
             deliveryCharge: deliveryCharge ?? self.deliveryCharge,
             total: total ?? self.total,
             deliveredBy: deliveredBy ?? self.deliveredBy
         )
     }

     func jsonData() throws -> Data {
         return try newJSONEncoder().encode(self)
     }

     func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
         return String(data: try self.jsonData(), encoding: encoding)
     }
 }


 // MARK: - CartItem
 struct CartItem: Codable {
     let rowID: String?
     let id: Int?
     let name: String?
     let qty: Int?
     let price: String?
     let options: [JSONAny]?
     let tax, subtotal: String?
     let available: Bool?
     let total: String?
     let item: Item?

     enum CodingKeys: String, CodingKey {
         case rowID = "rowId"
         case id, name, qty, price, options, tax, subtotal, available, total, item
     }
 }

 // MARK: CartItem convenience initializers and mutators

 extension CartItem {
     init(data: Data) throws {
         self = try newJSONDecoder().decode(CartItem.self, from: data)
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
         rowID: String?? = nil,
         id: Int?? = nil,
         name: String?? = nil,
         qty: Int?? = nil,
         price: String?? = nil,
         options: [JSONAny]?? = nil,
         tax: String?? = nil,
         subtotal: String?? = nil,
         available: Bool?? = nil,
         total: String?? = nil,
         item: Item?? = nil
     ) -> CartItem {
         return CartItem(
             rowID: rowID ?? self.rowID,
             id: id ?? self.id,
             name: name ?? self.name,
             qty: qty ?? self.qty,
             price: price ?? self.price,
             options: options ?? self.options,
             tax: tax ?? self.tax,
             subtotal: subtotal ?? self.subtotal,
             available: available ?? self.available,
             total: total ?? self.total,
             item: item ?? self.item
         )
     }

     func jsonData() throws -> Data {
         return try newJSONEncoder().encode(self)
     }

     func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
         return String(data: try self.jsonData(), encoding: encoding)
     }
 }


 */


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let restroCart = try RestroCart(json)

import Foundation

// MARK: - RestroCart
struct RestroCart: Codable {
    var restaurant: Restaurant_?
    var cartItems: [CartItem]?
    var subtotal, coupon, discount, deliveryCharge: String?
    var taxPercentage, tax, total, deliveredBy: String?

    enum CodingKeys: String, CodingKey {
        case restaurant
        case cartItems = "cart_items"
        case subtotal, coupon, discount
        case deliveryCharge = "delivery_charge"
        case taxPercentage = "tax_percentage"
        case tax, total
        case deliveredBy = "delivered_by"
    }
}

// MARK: RestroCart convenience initializers and mutators

extension RestroCart {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RestroCart.self, from: data)
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
        restaurant: Restaurant_?? = nil,
        cartItems: [CartItem]?? = nil,
        subtotal: String?? = nil,
        coupon: String?? = nil,
        discount: String?? = nil,
        deliveryCharge: String?? = nil,
        taxPercentage: String?? = nil,
        tax: String?? = nil,
        total: String?? = nil,
        deliveredBy: String?? = nil
    ) -> RestroCart {
        return RestroCart(
            restaurant: restaurant ?? self.restaurant,
            cartItems: cartItems ?? self.cartItems,
            subtotal: subtotal ?? self.subtotal,
            coupon: coupon ?? self.coupon,
            discount: discount ?? self.discount,
            deliveryCharge: deliveryCharge ?? self.deliveryCharge,
            taxPercentage: taxPercentage ?? self.taxPercentage,
            tax: tax ?? self.tax,
            total: total ?? self.total,
            deliveredBy: deliveredBy ?? self.deliveredBy
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CartItem
struct CartItem: Codable {
    var rowID: String?
    var id: Int?
    var name: String?
    var qty: Int?
    var price: String?
    var options: [Options]?
    var tax, subtotal: String?
    var available: Bool?
    var total: String?
    var item: Item?
    var custom_options: String?

    enum CodingKeys: String, CodingKey {
        case rowID = "rowId"
        case id, name, qty, price, options, tax, subtotal, available, total, item
        case custom_options = "custom_options"
    }
}

// MARK: CartItem convenience initializers and mutators

extension CartItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CartItem.self, from: data)
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
        rowID: String?? = nil,
        id: Int?? = nil,
        name: String?? = nil,
        qty: Int?? = nil,
        price: String?? = nil,
        options: [Options]?? = nil,
        tax: String?? = nil,
        subtotal: String?? = nil,
        available: Bool?? = nil,
        total: String?? = nil,
        item: Item?? = nil,
        custom_options: String?? = nil
    ) -> CartItem {
        return CartItem(
            rowID: rowID ?? self.rowID,
            id: id ?? self.id,
            name: name ?? self.name,
            qty: qty ?? self.qty,
            price: price ?? self.price,
            options: options ?? self.options,
            tax: tax ?? self.tax,
            subtotal: subtotal ?? self.subtotal,
            available: available ?? self.available,
            total: total ?? self.total,
            item: item ?? self.item,
            custom_options: custom_options ?? self.custom_options
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

/*JSON used
 
 {
             "restaurant": {
                 "id": 1,
                 "name": "Pizza Hut",
                 "excerpt": "Pizza, Small Pizza, Family Pizza, etc.",
                 "is_open": true,
                 "opening_time": "08:00:00",
                 "closing_time": "09:00:00",
                 "rating": 4,
                 "banner": "http://159.89.166.234/stdev/public/storage/up/restaurants/banner_1/3urVOXCtH9PkVEaYOicokZrbE218MOvqcckiWg8D.jpeg",
                 "logo": "http://159.89.166.234/stdev/public/storage/up/restaurants/profile_1/tx1feTJjID9aZUTeVzgL9X3aaRLNNcumlR3RR8cn.jpeg",
                 "banner_logo": "http://159.89.166.234/stdev/public/storage/up/restaurants/banner_logo_1/mdqouUmdkbh3gWEUisGaJfAvD0A60vtn3clDayAA.jpeg",
                 "website": "https://pizzahut.com",
                 "discount": 20,
                 "price_level": "$$",
                 "price_level_text": "Medium Price",
                 "is_delivery_free": false,
                 "cuisine": [
                     {
                         "id": 1,
                         "name": "South Indian Food"
                     },
                     {
                         "id": 2,
                         "name": "Vietnamese"
                     },
                     {
                         "id": 3,
                         "name": "Korean"
                     },
                     {
                         "id": 4,
                         "name": "German"
                     },
                     {
                         "id": 5,
                         "name": "Mongolian"
                     },
                     {
                         "id": 6,
                         "name": "Afghan"
                     },
                     {
                         "id": 7,
                         "name": "Rajasthani"
                     },
                     {
                         "id": 8,
                         "name": "Indonesian Indian"
                     },
                     {
                         "id": 9,
                         "name": "Thai"
                     }
                 ],
                 "self_pickup": true,
                 "contact_no": "91987654321",
                 "is_favorite": true,
                 "address": {
                     "address_1": "49, Chhatrasal Nagar",
                     "address_2": "Nandpuri Colony, Malviya Nagar",
                     "city": "Jaipur",
                     "state": "Rajasthan",
                     "country": "India",
                     "zipcode": "302017",
                     "latitude": "26.853745",
                     "longitude": "75.805002"
                 }
             },
             "cart_items": [
                 {
                     "rowId": "027c91341fd5cf4d2579b49c4b6a90da",
                     "id": 1,
                     "name": "Veggy Loaded Pizza",
                     "qty": 1,
                     "price": "173.00",
                     "options": [],
                     "tax": "0.00",
                     "subtotal": "173.00",
                     "available": true,
                     "total": "173.00",
                     "item": {
                         "id": 1,
                         "name": "Veggy Loaded Pizza",
                         "subtitle": "fully loaded vegetables like capsicum, onion, tomato",
                         "image": "http://159.89.166.234/stdev/public/storage/up/products/c5/h4DPAjjGC5IZyafIgtL6R3IAHuw8XTzYhnwQ2zGf.jpeg",
                         "description": "A pizza that decidedly staggers under an overload of golden corn, exotic black olives, crunchy onions, crisp capsicum, succulent mushrooms, juicy fresh tomatoes and jalapeno - with extra cheese to go all around.",
                         "price": "173.00",
                         "original_price": "200.00",
                         "discount": 14,
                         "rating": 4,
                         "available": true
                     }
                 },
                 {
                     "rowId": "370d08585360f5c568b18d1f2e4ca1df",
                     "id": 2,
                     "name": "Cheese Pizza",
                     "qty": 1,
                     "price": "147.00",
                     "options": [],
                     "tax": "0.00",
                     "subtotal": "147.00",
                     "available": true,
                     "total": "147.00",
                     "item": {
                         "id": 2,
                         "name": "Cheese Pizza",
                         "subtitle": "Cheesy delectable pizza",
                         "image": "http://159.89.166.234/stdev/public/storage/up/products/c5/cr6qgylk99kBNLiourtE6h2hPgd9gurQXbv7SIPQ.png",
                         "description": "A delectable combination of cheese and juicy tomato",
                         "price": "147.00",
                         "original_price": "0.00",
                         "discount": 0,
                         "rating": 5,
                         "available": true
                     }
                 }
             ],
             "subtotal": "320.00",
             "coupon": "test9875",
             "discount": "50.00",
             "delivery_charge": "2000.00",
             "tax_percentage": "5.00",
             "tax": "13.50",
             "total": "2283.50",
             "delivered_by": "45 Min"
         }
 */
