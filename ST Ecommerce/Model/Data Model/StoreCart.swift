//
//  StoreCart.swift
//  ST Ecommerce
//
//  Created by Necixy on 07/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//
/*
// MARK: - StoreCart
struct StoreCart: Codable {
    let cartProducts: [CartProduct]?
    let subtotal, tax, deliveryCharge, deliveredBy: String?
    let total: String?

    enum CodingKeys: String, CodingKey {
        case cartProducts = "cart_products"
        case subtotal, tax
        case deliveryCharge = "delivery_charge"
        case deliveredBy = "delivered_by"
        case total
    }
}

// MARK: StoreCart convenience initializers and mutators
extension StoreCart {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreCart.self, from: data)
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
        cartProducts: [CartProduct]?? = nil,
        subtotal: String?? = nil,
        tax: String?? = nil,
        deliveryCharge: String?? = nil,
        deliveredBy: String?? = nil,
        total: String?? = nil
    ) -> StoreCart {
        return StoreCart(
            cartProducts: cartProducts ?? self.cartProducts,
            subtotal: subtotal ?? self.subtotal,
            tax: tax ?? self.tax,
            deliveryCharge: deliveryCharge ?? self.deliveryCharge,
            deliveredBy: deliveredBy ?? self.deliveredBy,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CartProduct
struct CartProduct: Codable {
    let rowID: String?
    let id: Int?
    let name: String?
    let qty: Int?
    let price, tax, subtotal: String?
    let available: Bool?
    let product: Product?
    let deliveryCharge : String?

    enum CodingKeys: String, CodingKey {
        case rowID = "rowId"
        case id, name, qty, price, tax, subtotal, available, product
        case deliveryCharge = "delivery_charge"
    }
}

// MARK: CartProduct convenience initializers and mutators

extension CartProduct {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CartProduct.self, from: data)
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
        tax: String?? = nil,
        subtotal: String?? = nil,
        available: Bool?? = nil,
        product: Product?? = nil,
        deliveryCharge:String?? = nil
    ) -> CartProduct {
        return CartProduct(
            rowID: rowID ?? self.rowID,
            id: id ?? self.id,
            name: name ?? self.name,
            qty: qty ?? self.qty,
            price: price ?? self.price,
            tax: tax ?? self.tax,
            subtotal: subtotal ?? self.subtotal,
            available: available ?? self.available,
            product: product ?? self.product,
            deliveryCharge: deliveryCharge ?? self.deliveryCharge
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

/*JSON
 {
             "cart_products": [
                 {
                     "rowId": "808821852042d8780b9f862c35c42c68",
                     "id": 7,
                     "name": "White T shirt",
                     "qty": 1,
                     "price": "99.00",
                     "options": [],
                     "tax": "4.95",
                     "coupon": "",
                     "discount": "0.00",
                     "is_fully_used": false,
                     "subtotal": "99.00",
                     "available": true,
                     "delivery_charge": "3000.00",
                     "tax_percentage": "5.00",
                     "total": "3103.95",
                     "product": {
                         "id": 7,
                         "name": "White T shirt",
                         "product_id": "P-1",
                         "subtitle": "full sleeve",
                         "image": "http://159.89.166.234/stdev/public/storage/up/products/c4/1x04zsKDU83nrlBEUEATAh8iaocwSyMuparMdvCE.jpeg",
                         "product_images": [],
                         "description": "Lorem ipsum dolor sit amet consectetur adipisicing elit. Magni et accusamus rem dignissimos! Pariatur sint cumque fugiat corrupti perferendis est voluptatem deserunt adipisci, excepturi non esse cupiditate culpa animi laborum.",
                         "price": "99.00",
                         "original_price": "120.00",
                         "discount": 18,
                         "is_delivery_free": false,
                         "rating": 3,
                         "available": true,
                         "is_favorite": false,
                         "store": {
                             "id": 1,
                             "name": "G Wear",
                             "banner": "http://159.89.166.234/stdev/public/storage/defaults/product/product.jpg"
                         }
                     }
                 }
             ],
             "subtotal": "99.00",
             "coupon": "",
             "discount": "0.00",
             "delivered_by": "09 Nov 2020",
             "delivery_charge": "3000.00",
             "tax_percentage": "5.00",
             "tax": "4.95",
             "total": "3103.95"
         }
 */


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let storeCart = try StoreCart(json)

import Foundation

// MARK: - StoreCart
struct StoreCart: Codable {
    var cartProducts: [CartProduct_]?
    var subtotal, coupon, discount, deliveredBy: String?
    var deliveryCharge, taxPercentage, tax, total: String?

    enum CodingKeys: String, CodingKey {
        case cartProducts = "cart_products"
        case subtotal, coupon, discount
        case deliveredBy = "delivered_by"
        case deliveryCharge = "delivery_charge"
        case taxPercentage = "tax_percentage"
        case tax, total
    }
}

// MARK: StoreCart convenience initializers and mutators

extension StoreCart {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreCart.self, from: data)
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
        cartProducts: [CartProduct_]?? = nil,
        subtotal: String?? = nil,
        coupon: String?? = nil,
        discount: String?? = nil,
        deliveredBy: String?? = nil,
        deliveryCharge: String?? = nil,
        taxPercentage: String?? = nil,
        tax: String?? = nil,
        total: String?? = nil
    ) -> StoreCart {
        return StoreCart(
            cartProducts: cartProducts ?? self.cartProducts,
            subtotal: subtotal ?? self.subtotal,
            coupon: coupon ?? self.coupon,
            discount: discount ?? self.discount,
            deliveredBy: deliveredBy ?? self.deliveredBy,
            deliveryCharge: deliveryCharge ?? self.deliveryCharge,
            taxPercentage: taxPercentage ?? self.taxPercentage,
            tax: tax ?? self.tax,
            total: total ?? self.total
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - CartProduct
struct CartProduct_: Codable {
    var rowID: String?
    var id: Int?
    var name: String?
    var qty: Int?
    var price: String?
    var options: [Options]?
    var tax, coupon, discount: String?
    var userEnteredPromo: String?
    var isFullyUsed: Bool?
    var subtotal: String?
    var available: Bool?
    var deliveryCharge, taxPercentage, total: String?
    var product: ProductTemp?
    var isExpanded: Bool = false

    enum CodingKeys: String, CodingKey {
        case rowID = "rowId"
        case id, name, qty, price, options, tax, coupon, discount
        case isFullyUsed = "is_fully_used"
        case subtotal, available
        case deliveryCharge = "delivery_charge"
        case taxPercentage = "tax_percentage"
        case total, product
    }
}

// MARK: CartProduct convenience initializers and mutators

extension CartProduct_ {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CartProduct_.self, from: data)
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
        coupon: String?? = nil,
        discount: String?? = nil,
        isFullyUsed: Bool?? = nil,
        subtotal: String?? = nil,
        available: Bool?? = nil,
        deliveryCharge: String?? = nil,
        taxPercentage: String?? = nil,
        total: String?? = nil,
        product: ProductTemp?? = nil
    ) -> CartProduct_ {
        return CartProduct_(
            rowID: rowID ?? self.rowID,
            id: id ?? self.id,
            name: name ?? self.name,
            qty: qty ?? self.qty,
            price: price ?? self.price,
            options: options ?? self.options,
            tax: tax ?? self.tax,
            coupon: coupon ?? self.coupon,
            discount: discount ?? self.discount,
            isFullyUsed: isFullyUsed ?? self.isFullyUsed,
            subtotal: subtotal ?? self.subtotal,
            available: available ?? self.available,
            deliveryCharge: deliveryCharge ?? self.deliveryCharge,
            taxPercentage: taxPercentage ?? self.taxPercentage,
            total: total ?? self.total,
            product: product ?? self.product
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
