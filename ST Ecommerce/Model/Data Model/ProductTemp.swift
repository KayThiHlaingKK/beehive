//
//  Product.swift
//  ST Ecommerce
//
//  Created by Necixy on 08/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation

// MARK: - Product
struct ProductTemp: Codable {
    var id: Int?
    var name, productID, subtitle: String?
    var image: String?
    var productImages: [ProductImage]?
    var quantity: Int?
    var productDescription, price, originalPrice: String?
    var discount: Int?
    var isDeliveryFree: Bool?
    var category: Category?
    var deliveryCharge, deliveredBy: String?
    var available: Bool?
    var rating, soldCount: Int?
    var isFavorite, primary: Bool?
    var options: [Option]?
    var store: Store?

    enum CodingKeys: String, CodingKey {
        case id, name
        case productID = "product_id"
        case subtitle, image
        case productImages = "product_images"
        case productDescription = "description"
        case price
        case originalPrice = "original_price"
        case discount
        case isDeliveryFree = "is_delivery_free"
        case category
        case deliveryCharge = "delivery_charge"
        case deliveredBy = "delivered_by"
        case available, rating
        case soldCount = "sold_count"
        case isFavorite = "is_favorite"
        case options, store, primary
        case quantity
    }
}

// MARK: Product convenience initializers and mutators

extension ProductTemp {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductTemp.self, from: data)
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
        id: Int?? = nil,
        name: String?? = nil,
        productID: String?? = nil,
        subtitle: String?? = nil,
        image: String?? = nil,
        productImages: [ProductImage]?? = nil,
        productDescription: String?? = nil,
        price: String?? = nil,
        originalPrice: String?? = nil,
        discount: Int?? = nil,
        isDeliveryFree: Bool?? = nil,
        category: Category?? = nil,
        deliveryCharge: String?? = nil,
        deliveredBy: String?? = nil,
        available: Bool?? = nil,
        rating: Int?? = nil,
        soldCount: Int?? = nil,
        isFavorite: Bool?? = nil,
        primary: Bool?? = nil,
        options: [Option]?? = nil,
        store: Store?? = nil,
        quantity: Int?? = nil
    ) -> ProductTemp {
        return ProductTemp(
            id: id ?? self.id,
            name: name ?? self.name,
            productID: productID ?? self.productID,
            subtitle: subtitle ?? self.subtitle,
            image: image ?? self.image,
            productImages: productImages ?? self.productImages,
            productDescription: productDescription ?? self.productDescription,
            price: price ?? self.price,
            originalPrice: originalPrice ?? self.originalPrice,
            discount: discount ?? self.discount,
            isDeliveryFree: isDeliveryFree ?? self.isDeliveryFree,
            category: category ?? self.category,
            deliveryCharge: deliveryCharge ?? self.deliveryCharge,
            deliveredBy: deliveredBy ?? self.deliveredBy,
            available: available ?? self.available,
            rating: rating ?? self.rating,
            soldCount: soldCount ?? self.soldCount,
            isFavorite: isFavorite ?? self.isFavorite,
            primary: primary ?? self.primary,
            options: options ?? self.options,
            store: store ?? self.store
//            quantity: quantity ?? self.quantity
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - Option
struct Option: Codable {
    var optionType, name, option, value: String?
    var values: [Value]?

    enum CodingKeys: String, CodingKey {
        case optionType = "option_type"
        case name, option, value, values
    }
}

// MARK: Option convenience initializers and mutators

extension Option {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Option.self, from: data)
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
        optionType: String?? = nil,
        name: String?? = nil,
        option: String?? = nil,
        value: String?? = nil,
        values: [Value]?? = nil
    ) -> Option {
        return Option(
            optionType: optionType ?? self.optionType,
            name: name ?? self.name,
            option: option ?? self.option,
            value: value ?? self.value,
            values: values ?? self.values
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Value
struct Value: Codable {
    var text, type: String?
    var value: String?
    var selected: Bool?
}

// MARK: Value convenience initializers and mutators

extension Value {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Value.self, from: data)
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
        text: String?? = nil,
        type: String?? = nil,
        value: String?? = nil,
        selected: Bool?? = nil
    ) -> Value {
        return Value(
            text: text ?? self.text,
            type: type ?? self.type,
            value: value ?? self.value,
            selected: selected ?? self.selected
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


/*Json used for Product
 {
             "id": 55,
             "name": "Test Product 2",
             "product_id": "T6yst5t8",
             "subtitle": "Women's Net Semi-stitched, Lehenga Choli",
             "image": "http://159.89.166.234/stdev/public/storage/up/products/p55/bgVYH4nGhUAewPNNWDMojThtJjUt0TXAvRMVV0mw.jpeg",
             "product_images": [
                 {
                     "url": "http://159.89.166.234/stdev/public/storage/up/products/p55/bgVYH4nGhUAewPNNWDMojThtJjUt0TXAvRMVV0mw.jpeg",
                     "is_primary": 1
                 },
                 {
                     "url": "http://159.89.166.234/stdev/public/storage/up/products/p55/vL72bl1ZZ56eqQkHddk3s7Ru52cdPJ2o9uTDLb3o.jpeg",
                     "is_primary": 0
                 },
                 {
                     "url": "http://159.89.166.234/stdev/public/storage/up/products/p55/anq3kiwa1M8YLzqqRkFfOerNSP1pcTaQ63coEqhQ.jpeg",
                     "is_primary": 0
                 },
                 {
                     "url": "http://159.89.166.234/stdev/public/storage/up/products/p55/jXhNbevInHqllpITtJZIib2qd4APF2YODk7u0WxQ.png",
                     "is_primary": 1
                 },
                 {
                     "url": "http://159.89.166.234/stdev/public/storage/up/products/p55/opQutGkjJNzUL8lUJgIVhR35FCLoHUeoobHqZ5rQ.png",
                     "is_primary": 0
                 }
             ],
             "description": "<p>HI</p>",
             "price": "100.00",
             "original_price": "200.00",
             "discount": 50,
             "is_delivery_free": false,
             "category": {
                 "id": 3,
                 "name": "Girls Wear",
                 "image": "http://159.89.166.234/stdev/public/storage/up/categories/EYdYgpRUfOQp4TlgcRMh8gv0jkZfhu357OXSoMhC.jpeg"
             },
             "delivery_charge": "0.00",
             "delivered_by": "11 Nov 2020",
             "available": true,
             "rating": 0,
             "sold_count": 3,
             "is_favorite": true,
             "options": [
                 {
                     "option_type": "primary",
                     "name": "Size",
                     "values": [
                         {
                             "text": "Small",
                             "type": "text",
                             "value": null,
                             "selected": true
                         },
                         {
                             "text": "Large",
                             "type": "text",
                             "value": null,
                             "selected": false
                         }
                     ]
                 },
                 {
                     "option_type": "secondary",
                     "name": "Color",
                     "values": [
                         {
                             "text": "Black",
                             "type": "image",
                             "value": "http://159.89.166.234/stdev/public/storage/up/products/p55/eGOQQCSXijN1bBNlPfmfDnxZgNswWA5p2iOFaDS6.jpeg",
                             "selected": true
                         },
                         {
                             "text": "Blue",
                             "type": "image",
                             "value": "http://159.89.166.234/stdev/public/storage/up/products/p55/nRrdPQ8qENRx6cnqzyalfBt4cHL5a1Gi0Nv6W10K.png",
                             "selected": false
                         }
                     ]
                 }
             ],
             "store": {
                 "id": 3,
                 "name": "Johnson & Johnson",
                 "banner": "http://159.89.166.234/stdev/public/storage/defaults/store/default.png"
             }
         }
 */
