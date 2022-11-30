//
//  MyModel.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation
import UIKit


struct MyCustomization {
    var id = 0
    var option_type = ""
    var text = ""
}

//MARK: - Self Made
struct MoreOptions {

    var image = UIImage()
    var title = ""
    var subTitle = ""
    var color = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)

    init(image:UIImage, title:String, subTitle:String, color:UIColor) {
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.color = color
    }

}

struct HomeOption {

    var image = UIImage()
    var title = ""
    var color = UIColor()

    init(image:UIImage, title:String, color:UIColor) {
        self.image = image
        self.title = title
        self.color = color
    }

}

struct SettingOption {

    var image = UIImage()
    var title = ""
    var color = UIColor()

    init(title:String, image: UIImage) {
        self.title = title
        self.image = image
    }

}

struct Floor {

    var name = ""
    var value = 0
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profileData = try ProfileData(json)

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

//MARK: - Notification

struct NotificationData: Codable {
    let type: String?
    let orderId: Int?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case type, status
        case orderId = "order_id"

    }
}

// MARK: Notification convenience initializers and mutators

extension NotificationData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NotificationData.self, from: data)
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
        type: String??  = nil,
        orderId: Int?? =  nil,
        status: String?? = nil
    ) -> NotificationData {
        return NotificationData(
            type: type ?? self.type,
            orderId: orderId ?? self.orderId,
            status: status ?? self.status

        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - TownShip
struct TownShip: Codable {
    let id: Int?
    let township: String?
}

// MARK: TownShip convenience initializers and mutators

extension TownShip {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TownShip.self, from: data)
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
        township: String?? = nil
    ) -> TownShip {
        return TownShip(
            id: id ?? self.id,
            township: township ?? self.township
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Help and Suppport

struct Supports: Codable {
    var name, number: String?
}

// MARK: - Help and Support convenience initializers and mutators

extension Supports {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Supports.self, from: data)
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
        name: String?? = nil,
        number: String?? = nil
    ) -> Supports {
        return Supports(
            name: name ?? self.name,
            number: number ?? self.number
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - Review
struct Review: Codable {
    let id: Int?
    let rating, review: String?
    let createdAt: Int?
    let user: User_?

    enum CodingKeys: String, CodingKey {
        case id, rating, review
        case createdAt = "created_at"
        case user
    }
}

// MARK: Review convenience initializers and mutators

extension Review {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Review.self, from: data)
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
        rating: String?? = nil,
        review: String?? = nil,
        createdAt: Int?? = nil,
        user: User_?? = nil
    ) -> Review {
        return Review(
            id: id ?? self.id,
            rating: rating ?? self.rating,
            review: review ?? self.review,
            createdAt: createdAt ?? self.createdAt,
            user: user ?? self.user
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - ProfileData
struct ProfileData: Codable {
    var id: Int?
    var name, countryCode, phone: String?
    var profilePic: String?
    var gender, dob: String?
    var isEmailVerified, isPhoneVerified: Bool?
    var registeredAt: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case countryCode = "country_code"
        case phone
        case profilePic = "profile_pic"
        case gender, dob
        case isEmailVerified = "is_email_verified"
        case isPhoneVerified = "is_phone_verified"
        case registeredAt = "registered_at"
    }
}

// MARK: ProfileData convenience initializers and mutators

extension ProfileData {

    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProfileData.self, from: data)
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
        countryCode: String?? = nil,
        phone: String?? = nil,
        profilePic: String?? = nil,
        gender: String?? = nil,
        dob: String?? = nil,
        isEmailVerified: Bool?? = nil,
        isPhoneVerified: Bool?? = nil,
        registeredAt: Int?? = nil
    ) -> ProfileData {
        return ProfileData(
            id: id ?? self.id,
            name: name ?? self.name,
            countryCode: countryCode ?? self.countryCode,
            phone: phone ?? self.phone,
            profilePic: profilePic ?? self.profilePic,
            gender: gender ?? self.gender,
            dob: dob ?? self.dob,
            isEmailVerified: isEmailVerified ?? self.isEmailVerified,
            isPhoneVerified: isPhoneVerified ?? self.isPhoneVerified,
            registeredAt: registeredAt ?? self.registeredAt
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let product = try Product(json)

import Foundation

// MARK: - Category
struct Category: Codable {
    let id: Int?
    let name: String?
    let image: String?
}

// MARK: Category convenience initializers and mutators

extension Category {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Category.self, from: data)
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
        image: String?? = nil
    ) -> Category {
        return Category(
            id: id ?? self.id,
            name: name ?? self.name,
            image: image ?? self.image
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Store
struct Store: Codable {
    let id: Int?
    let name: String?
    let banner, website: String?
    let address1, address2, city, state: String?
    let country: String?
    let zipcode: Int?
    let latitude, longitude: String?
    let storeAssured: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, banner, website
        case address1 = "address_1"
        case address2 = "address_2"
        case storeAssured = "beehive_assured"
        case city, state, country, zipcode, latitude, longitude
    }
}

// MARK: Store convenience initializers and mutators

extension Store {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Store.self, from: data)
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
        banner: String?? = nil,
        website: String?? = nil,
        address1: String?? = nil,
        address2: String?? = nil,
        city: String?? = nil,
        state: String?? = nil,
        country: String?? = nil,
        zipcode: Int?? = nil,
        latitude: String?? = nil,
        longitude: String?? = nil,
        storeAssured: Bool?? = nil
    ) -> Store {
        return Store(
            id: id ?? self.id,
            name: name ?? self.name,
            banner: banner ?? self.banner,
            website: website ?? self.website,
            address1: address1 ?? self.address1,
            address2: address2 ?? self.address2,
            city: city ?? self.city,
            state: state ?? self.state,
            country: country ?? self.country,
            zipcode: zipcode ?? self.zipcode,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            storeAssured: storeAssured ?? self.storeAssured
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productCategoryWise = try ProductCategoryWise(json)

import Foundation

// MARK: - ProductCategoryWise
struct ProductCategoryWise: Codable {
    let id: Int?
    let name, cellType: String?
    let productsCount: Int?
    let image: String?
    var products: [ProductTemp]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case cellType = "cell_type"
        case productsCount = "products_count"
        case image, products
    }
}

// MARK: ProductCategoryWise convenience initializers and mutators

extension ProductCategoryWise {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductCategoryWise.self, from: data)
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
        cellType: String?? = nil,
        productsCount: Int?? = nil,
        image: String?? = nil,
        products: [ProductTemp]?? = nil
    ) -> ProductCategoryWise {
        return ProductCategoryWise(
            id: id ?? self.id,
            name: name ?? self.name,
            cellType: cellType ?? self.cellType,
            productsCount: productsCount ?? self.productsCount,
            image: image ?? self.image,
            products: products ?? self.products
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - Options
struct Options: Codable {
    var option, value: String?
}

// MARK: Options convenience initializers and mutators

extension Options {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Options.self, from: data)
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
        option: String?? = nil,
        value: String?? = nil
    ) -> Options {
        return Options(
            option: option ?? self.option,
            value: value ?? self.value
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let address = try Address(json)

import Foundation

// MARK: - Address
struct Address_: Codable {
    var id: Int?
    var title, address1, address2, city: String?
    var state, country, zipcode, latitude: String?
    var longitude: String?
    var isPrimary: Bool?
    var townshipId : Int?
    var floor : Int?
    var postalAddress: String?


    enum CodingKeys: String, CodingKey {
        case id, title
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, country, zipcode, latitude, longitude,floor
        case isPrimary = "is_primary"
        case townshipId = "township_id"
    }
}

// MARK: Address convenience initializers and mutators

extension Address_ {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Address_.self, from: data)
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
        title: String?? = nil,
        address1: String?? = nil,
        address2: String?? = nil,
        city: String?? = nil,
        state: String?? = nil,
        country: String?? = nil,
        zipcode: String?? = nil,
        latitude: String?? = nil,
        longitude: String?? = nil,
        isPrimary: Bool?? = nil,
        townshipId : Int? = nil,
        floor : Int? = nil
    ) -> Address_ {
        return Address_(
            id: id ?? self.id,
            title: title ?? self.title,
            address1: address1 ?? self.address1,
            address2: address2 ?? self.address2,
            city: city ?? self.city,
            state: state ?? self.state,
            country: country ?? self.country,
            zipcode: zipcode ?? self.zipcode,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            isPrimary: isPrimary ?? self.isPrimary,
            townshipId: townshipId ?? self.townshipId,
            floor: floor ?? self.floor
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let myOrder = try MyOrder(json)

import Foundation

/*
JSON
 {
     "id": 12,
     "order_serial": "ORD00000012",
     "transaction_id": "tr_9yCqtQ1HY7UB0iQA",
     "amount": "1.00",
     "special_instruction": "",
     "order_type": "Store",
     "status": "Pending",
     "store": "G Wear",
     "rating": 1,
     "created_at": "22 Jul 2020",
     "delivered_at": ""
 }
*/
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let myOrder = try MyOrder(json)
// MARK: - MyOrder
struct MyOrder: Codable {
    var id: Int?
    let orderSerial, transactionID, amount, specialInstruction: String?
    var orderType, status, ratingStatus, store, items: String?
    let rating, driverRating, foodRating : Int?
    let deliveredBy : String?
    let createdAt, deliveredAt,cancelledAt: Int?
    let selfPickup:Bool?
    let cancelOrder,trackOrder: Bool?
    let restaurantDetails: RestaurantDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case orderSerial = "order_serial"
        case transactionID = "transaction_id"
        case amount
        case specialInstruction = "special_instruction"
        case orderType = "order_type"
        case status
        case ratingStatus = "rating_status"
        case store, rating
        case createdAt = "created_at"
        case deliveredBy = "delivered_by"
        case deliveredAt = "delivered_at"
        case selfPickup = "self_pickup"
        case cancelOrder = "can_cancel"
        case restaurantDetails = "restaurant"
        case items = "items"
        case driverRating = "driver_rating"
        case foodRating = "food_rating"
        case cancelledAt = "cancelled_at"
        case trackOrder = "trackable"
    }

}

// MARK: MyOrder convenience initializers and mutators

extension MyOrder {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MyOrder.self, from: data)
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

//    func with(
//        id: Int?? = nil,
//        orderSerial: String?? = nil,
//        transactionID: String?? = nil,
//        amount: String?? = nil,
//        specialInstruction: String?? = nil,
//        orderType: String?? = nil,
//        status: String?? = nil,
//        ratingStatus: String?? = nil,
//        store: String?? = nil,
//        rating: Int?? = nil,
//        createdAt: String?? = nil,
//        deliveredBy: String?? = nil,
//        deliveredAt: String?? = nil,
//        selfPickup : Bool?? = nil,
//        cancelOrder : Bool?? = nil,
//        restaurantDetails: RestaurantDetails?? = nil
//    ) -> MyOrder {
//        return MyOrder(
//            id: id ?? self.id,
//            orderSerial: orderSerial ?? self.orderSerial,
//            transactionID: transactionID ?? self.transactionID,
//            amount: amount ?? self.amount,
//            specialInstruction: specialInstruction ?? self.specialInstruction,
//            orderType: orderType ?? self.orderType,
//            status: status ?? self.status,
//            ratingStatus: ratingStatus ?? self.ratingStatus,
//            store: store ?? self.store,
//            rating: rating ?? self.rating,
//            createdAt: createdAt ?? self.createdAt,
//            deliveredBy: deliveredBy ?? self.deliveredBy,
//            deliveredAt: deliveredAt ?? self.deliveredAt,
//            selfPickup: selfPickup ?? self.selfPickup,
//            cancelOrder: cancelOrder ?? self.cancelOrder,
//            restaurantDetails: restaurantDetails ?? self.restaurantDetails
//        )
//    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let orderDetails = try OrderDetails(json)





// MARK: - IngAddress
struct IngAddress: Codable {
    let countryCode, phone, contactPerson, address1: String?
    let address2, city, state, country: String?
    let zipcode: Int?

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case phone
        case contactPerson = "contact_person"
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, country, zipcode
    }
}

// MARK: IngAddress convenience initializers and mutators

extension IngAddress {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(IngAddress.self, from: data)
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
        countryCode: String?? = nil,
        phone: String?? = nil,
        contactPerson: String?? = nil,
        address1: String?? = nil,
        address2: String?? = nil,
        city: String?? = nil,
        state: String?? = nil,
        country: String?? = nil,
        zipcode: Int?? = nil
    ) -> IngAddress {
        return IngAddress(
            countryCode: countryCode ?? self.countryCode,
            phone: phone ?? self.phone,
            contactPerson: contactPerson ?? self.contactPerson,
            address1: address1 ?? self.address1,
            address2: address2 ?? self.address2,
            city: city ?? self.city,
            state: state ?? self.state,
            country: country ?? self.country,
            zipcode: zipcode ?? self.zipcode
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - User
struct User_: Codable {
    var latitude, longitude, name: String?
    var profilePic: String?
    var id : Int?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude, id, name
        case profilePic = "profile_pic"
    }
}

// MARK: User convenience initializers and mutators

extension User_ {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(User_.self, from: data)
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
        latitude: String?? = nil,
        longitude: String?? = nil,
        name: String?? = nil,
        profilePic: String?? = nil,
        id: Int?? = nil
    ) -> User_ {
        return User_(
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            name: name ?? self.name,
            profilePic: profilePic ?? self.profilePic,
            id: id ?? self.id
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let storeCart = try StoreCart(json)

import Foundation



// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let product = try Product(json)

import Foundation

import Foundation





// MARK: - ProductImage
struct ProductImage: Codable {
    let url: String?
    let isPrimary: Int?

    enum CodingKeys: String, CodingKey {
        case url
        case isPrimary = "is_primary"
    }
}

// MARK: ProductImage convenience initializers and mutators

extension ProductImage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductImage.self, from: data)
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
        url: String?? = nil,
        isPrimary: Int?? = nil
    ) -> ProductImage {
        return ProductImage(
            url: url ?? self.url,
            isPrimary: isPrimary ?? self.isPrimary
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//24th July
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let suggestions = try Suggestions(json)

import Foundation


// MARK: - Suggestions
struct Suggestions: Codable {
    let products: [ProductTemp]?
    let restaurants: [Restaurant_]?
}

// MARK: Suggestions convenience initializers and mutators

extension Suggestions {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Suggestions.self, from: data)
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
        products: [ProductTemp]?? = nil,
        restaurants: [Restaurant_]?? = nil
    ) -> Suggestions {
        return Suggestions(
            products: products ?? self.products,
            restaurants: restaurants ?? self.restaurants
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newArrivals = try NewArrivals(json)

import Foundation

// MARK: - NewArrivals
struct NewArrivals: Codable {
    let products: [ProductTemp]?
    let restaurants: [Restaurant_]?
}

// MARK: NewArrivals convenience initializers and mutators

extension NewArrivals {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(NewArrivals.self, from: data)
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
        products: [ProductTemp]?? = nil,
        restaurants: [Restaurant_]?? = nil
    ) -> NewArrivals {
        return NewArrivals(
            products: products ?? self.products,
            restaurants: restaurants ?? self.restaurants
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//29 July 20020


// MARK: - RateOrder
struct RateOrder: Codable {
    let id: Int?
    let orderSerial: String?
    var rateProducts: [RateProduct]?

    enum CodingKeys: String, CodingKey {
        case id
        case orderSerial = "order_serial"
        case rateProducts = "rate_products"
    }
}

// MARK: RateOrder convenience initializers and mutators

extension RateOrder {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RateOrder.self, from: data)
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
        orderSerial: String?? = nil,
        rateProducts: [RateProduct]?? = nil
    ) -> RateOrder {
        return RateOrder(
            id: id ?? self.id,
            orderSerial: orderSerial ?? self.orderSerial,
            rateProducts: rateProducts ?? self.rateProducts
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RateProduct
struct RateProduct: Codable {
    let id: Int?
    let name, subtitle, orderSerial: String?
    let image: String?
    let store: Store?
    var rating: Int?
    var review: String?

    enum CodingKeys: String, CodingKey {
        case id, name, subtitle
        case orderSerial = "order_serial"
        case image, store, rating, review
    }
}

// MARK: RateProduct convenience initializers and mutators

extension RateProduct {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RateProduct.self, from: data)
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
        subtitle: String?? = nil,
        orderSerial: String?? = nil,
        image: String?? = nil,
        store: Store?? = nil,
        rating: Int?? = nil,
        review: String?? = nil
    ) -> RateProduct {
        return RateProduct(
            id: id ?? self.id,
            name: name ?? self.name,
            subtitle: subtitle ?? self.subtitle,
            orderSerial: orderSerial ?? self.orderSerial,
            image: image ?? self.image,
            store: store ?? self.store,
            rating: rating ?? self.rating,
            review: review ?? self.review
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


/**************************************Food***************************************************/



// MARK: - CategorizedRestaurant
struct CategorizedRestaurant_: Codable {
    let id: Int?
    let name: String?
    var section: Int?
    let restaurants: [Restaurant_]?
}

// MARK: CategorizedRestaurant convenience initializers and mutators

extension CategorizedRestaurant_ {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CategorizedRestaurant_.self, from: data)
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
        section: Int?? = nil,
        restaurants: [Restaurant_]?? = nil
    ) -> CategorizedRestaurant_ {
        return CategorizedRestaurant_(
            id: id ?? self.id,
            name: name ?? self.name,
            section: section ?? self.section,
            restaurants: restaurants ?? self.restaurants
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - Restaurant
struct Restaurant_: Codable {
    var id: Int?
    var name, excerpt: String?
    var isOpen: Bool?
    var isDeliverable: Bool?
    var openingTime, closingTime: String?
    var rating: Int?
    var banner, logo, bannerLogo: String?
    var website: String?
    var discount: Int?
    var priceLevel, priceLevelText: String?
    var isDeliveryFree: Bool?
    var cuisine: [Cuisine]?
    var selfPickup: Bool?
    var contactNo: String?
    var isFavorite: Bool?
    var address: Address_?
    var latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case id, name, excerpt
        case isOpen = "is_open"
        case isDeliverable = "deliverable"
        case openingTime = "opening_time"
        case closingTime = "closing_time"
        case rating, banner, logo
        case bannerLogo = "banner_logo"
        case website, discount
        case priceLevel = "price_level"
        case priceLevelText = "price_level_text"
        case isDeliveryFree = "is_delivery_free"
        case cuisine
        case selfPickup = "self_pickup"
        case contactNo = "contact_no"
        case isFavorite = "is_favorite"
        case address, latitude, longitude
    }
}

// MARK: Restaurant convenience initializers and mutators

extension Restaurant_ {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Restaurant_.self, from: data)
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
        excerpt: String?? = nil,
        isOpen: Bool?? = nil,
        isDeliverable: Bool?? = nil,
        openingTime: String?? = nil,
        closingTime: String?? = nil,
        rating: Int?? = nil,
        banner: String?? = nil,
        logo: String?? = nil,
        bannerLogo: String?? = nil,
        website: String?? = nil,
        discount: Int?? = nil,
        priceLevel: String?? = nil,
        priceLevelText: String?? = nil,
        isDeliveryFree: Bool?? = nil,
        cuisine: [Cuisine]?? = nil,
        selfPickup: Bool?? = nil,
        contactNo: String?? = nil,
        isFavorite: Bool?? = nil,
        address: Address_?? = nil,
        latitude: String?? = nil,
        longitude: String?? = nil
    ) -> Restaurant_ {
        return Restaurant_(
            id: id ?? self.id,
            name: name ?? self.name,
            excerpt: excerpt ?? self.excerpt,
            isOpen: isOpen ?? self.isOpen,
            isDeliverable: isDeliverable ?? self.isDeliverable,
            openingTime: openingTime ?? self.openingTime,
            closingTime: closingTime ?? self.closingTime,
            rating: rating ?? self.rating,
            banner: banner ?? self.banner,
            logo: logo ?? self.logo,
            bannerLogo: bannerLogo ?? self.bannerLogo,
            website: website ?? self.website,
            discount: discount ?? self.discount,
            priceLevel: priceLevel ?? self.priceLevel,
            priceLevelText: priceLevelText ?? self.priceLevelText,
            isDeliveryFree: isDeliveryFree ?? self.isDeliveryFree,
            cuisine: cuisine ?? self.cuisine,
            selfPickup: selfPickup ?? self.selfPickup,
            contactNo: contactNo ?? self.contactNo,
            isFavorite: isFavorite ?? self.isFavorite,
            address: address ?? self.address,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//// MARK: - User Check_in
//struct DailyCheckIn: Codable {
//   let user: User
//   let checkIn: [CheckIn]
//
//    enum CodingKeys: String, CodingKey {
//        case user
//        case checkIn = "check_ins"
//    }
//}
//
//struct CheckIn: Codable {
//    let day: Int
//    let date: String
//    let checkedIn, today: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case day, date
//        case checkedIn = "checked_in"
//        case today
//    }
//}
//
//struct Users: Codable {
//    let id: Int
//    let name: String
//    let profilePic: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name, profilePic
//    }
//}
//
////  MARK: - Rewards
//

// MARK: - Cuisine
struct Cuisine: Codable {
    let id: Int?
    let name: String?
}

// MARK: Cuisine convenience initializers and mutators

extension Cuisine {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Cuisine.self, from: data)
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
        name: String?? = nil
    ) -> Cuisine {
        return Cuisine(
            id: id ?? self.id,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - RestroSlider
struct RestroSlider: Codable {
    let restaurantSliders: [String]?

    enum CodingKeys: String, CodingKey {
        case restaurantSliders = "restaurant_sliders"
    }
}

// MARK: RestroSlider convenience initializers and mutators

extension RestroSlider {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RestroSlider.self, from: data)
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
        restaurantSliders: [String]?? = nil
    ) -> RestroSlider {
        return RestroSlider(
            restaurantSliders: restaurantSliders ?? self.restaurantSliders
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}




// MARK: - RestaurantCategoriesedItem
struct RestaurantCategoriesedItem: Codable {
    let id: Int?
    let name: String?
    let image: String?
    var items: [Item]?
}

// MARK: RestaurantCategoriesedItem convenience initializers and mutators

extension RestaurantCategoriesedItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RestaurantCategoriesedItem.self, from: data)
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
        image: String?? = nil,
        items: [Item]?? = nil
    ) -> RestaurantCategoriesedItem {
        return RestaurantCategoriesedItem(
            id: id ?? self.id,
            name: name ?? self.name,
            image: image ?? self.image,
            items: items ?? self.items
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - Item
struct Item: Codable {
    let id: Int?
    let name, subtitle: String?
    let image: String?
    let itemDescription, price, originalPrice: String?
    var discount, rating, qty: Int?
    let available: Bool?
    var subtotal: String?
    var customizable: Bool?
    var variation: [Variation]
    var addons: [Addon]
    var toppings: [Topping]

    enum CodingKeys: String, CodingKey {
        case id, name, subtitle, image
        case itemDescription = "description"
        case price
        case originalPrice = "original_price"
        case discount, rating, qty, available
        case subtotal
        case customizable
        case variation
        case addons
        case toppings
    }
}

// MARK: Item convenience initializers and mutators

extension Item {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Item.self, from: data)
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
        subtitle: String?? = nil,
        image: String?? = nil,
        itemDescription: String?? = nil,
        price: String?? = nil,
        originalPrice: String?? = nil,
        discount: Int?? = nil,
        rating: Int?? = nil,
        qty: Int?? = nil,
        available: Bool?? = nil,
        subtotal: String?? = nil,
        customizable: Bool?? = nil,
        variation: [Variation]?? = nil,
        addons: [Addon]?? = nil,
        toppings: [Topping]?? = nil
    ) -> Item {
        return Item(
            id: id ?? self.id,
            name: name ?? self.name,
            subtitle: subtitle ?? self.subtitle,
            image: image ?? self.image,
            itemDescription: itemDescription ?? self.itemDescription,
            price: price ?? self.price,
            originalPrice: originalPrice ?? self.originalPrice,
            discount: discount ?? self.discount,
            rating: rating ?? self.rating,
            qty: qty ?? self.qty,
            available: available ?? self.available,
            subtotal: subtotal ?? self.subtotal,
            customizable: customizable ?? self.customizable,
            variation: (variation ?? self.variation) ?? [],
            addons: (addons ?? self.addons) ?? [],
            toppings: (toppings ?? self.toppings) ?? []
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Variation
struct Variation: Codable {
    var id: Int?
    var name: String?
    var type: String?
    var values: [Values]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case values
    }
}

// MARK: Variation convenience initializers and mutators

extension Variation {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Variation.self, from: data)
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
        type: String?? = nil,
        values: [Values]?? = nil
    ) -> Variation {
        return Variation(
            id: id ?? self.id,
            name: name ?? self.name,
            type: type ?? self.type,
            values: (values ?? self.values)!
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Addon
struct Addon: Codable {
    var id: Int?
    var name: String?
    var type: String?
    var values: [Values]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case values
    }
}

// MARK: Addon convenience initializers and mutators

extension Addon {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Addon.self, from: data)
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
        type: String?? = nil,
        values: [Values]?? = nil
    ) -> Addon {
        return Addon(
            id: id ?? self.id,
            name: name ?? self.name,
            type: type ?? self.type,
            values: (values ?? self.values)!
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Topping
struct Topping: Codable {
    var id: Int?
    var name: String?
    var type: String?
    var is_incremental: Bool?
    var amount: String?
    var qty: Int?

    enum CodingKeys: String, CodingKey{
        case id
        case name
        case type
        case is_incremental
       case amount
        case qty
    }
}

// MARK: Topping convenience initializers and mutators

extension Topping {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Topping.self, from: data)
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
        type: String?? = nil,
        is_incremental: Bool?? = nil,
        amount: String?? = nil,
        qty: Int?? = nil
    ) -> Topping {
        return Topping(
            id: id ?? self.id,
            name: name ?? self.name,
            type: type ?? self.type,
            is_incremental: is_incremental ?? self.is_incremental,
            amount: amount ?? self.amount,
            qty: qty ?? self.qty

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
struct Values: Codable {
    var id: Int?
    var valueName, amount: String?
    var is_incremental: Bool?
    var is_Selected: Bool?
    var qty: Int?

    enum CodingKeys: String, CodingKey {

        case id
        case valueName = "value_name"
        case amount
        case is_incremental
        case is_Selected
        case qty
    }
}

// MARK: Value convenience initializers and mutators

extension Values {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Values.self, from: data)
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
        valueName: String?? = nil,
        amount: String?? = nil,
        is_incremental: Bool?? = nil,
        is_Selected: Bool?? = nil,
        qty: Int?? = nil
    ) -> Values {
        return Values (
            id: id ?? self.id,
            valueName: valueName ?? self.valueName,
            amount: amount ?? self.amount,
            is_incremental: is_incremental ?? self.is_incremental,
            is_Selected: is_Selected ?? self.is_Selected,
            qty: qty ?? self.qty
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Driver
struct Driver: Codable {
    let id: Int?
    let slug: String?
    let name, phone: String?
    let phone_number: String?
    let profilePic: String?
    let image: Image?
    let rating: Int?
    let latitude : String?
    let longitude : String?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, image, slug
        case profilePic = "profile_pic"
        case phone_number
        case rating
        case latitude, longitude
    }
}

// MARK: Driver convenience initializers and mutators

extension Driver {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Driver.self, from: data)
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
        slug: String?? = nil,
        name: String?? = nil,
        phone: String?? = nil,
        image: Image?? = nil,
        phone_number: String?? = nil,
        profilePic: String?? = nil,
        rating: Int?? = nil,
        latitude: String?? = nil,
        longitude: String?? = nil
    ) -> Driver {
        return Driver(
            id: id ?? self.id,
            slug: slug ?? self.slug,
            name: name ?? self.name,
            phone: phone ?? self.phone,
            phone_number: phone_number ?? self.phone_number,
            profilePic: profilePic ?? self.profilePic,
            image: image ?? self.image,
            rating: rating ?? self.rating,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - OrderItem
struct OrderItem: Codable {
    let id: Int?
    let amount, tax, netAmount: String?
    let quantity: Int?
    let orderSerial: String?
    let item: Item?
    let custom_option: String?

    enum CodingKeys: String, CodingKey {
        case id, amount, tax
        case netAmount = "net_amount"
        case quantity
        case orderSerial = "order_serial"
        case item
        case custom_option = "custom_option"
    }
}

// MARK: OrderItem convenience initializers and mutators

extension OrderItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(OrderItem.self, from: data)
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
        amount: String?? = nil,
        tax: String?? = nil,
        netAmount: String?? = nil,
        quantity: Int?? = nil,
        orderSerial: String?? = nil,
        item: Item?? = nil,
        custom_option: String?? = nil
    ) -> OrderItem {
        return OrderItem(
            id: id ?? self.id,
            amount: amount ?? self.amount,
            tax: tax ?? self.tax,
            netAmount: netAmount ?? self.netAmount,
            quantity: quantity ?? self.quantity,
            orderSerial: orderSerial ?? self.orderSerial,
            item: item ?? self.item,
            custom_option: custom_option ?? self.custom_option
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



// MARK: - FoodOrderRate
struct FoodOrderRate: Codable {
    let id: Int?
    let orderSerial: String?
    var rateItems: [RateItem]?
    var rateRestaurant: RateRestaurant?
    var rateDriver: RateDriver?

    enum CodingKeys: String, CodingKey {
        case id
        case orderSerial = "order_serial"
        case rateItems = "rate_items"
        case rateRestaurant = "rate_restaurant"
        case rateDriver = "rate_driver"
    }
}

// MARK: FoodOrderRate convenience initializers and mutators

extension FoodOrderRate {

    init(data: Data) throws {
        self = try newJSONDecoder().decode(FoodOrderRate.self, from: data)
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
        orderSerial: String?? = nil,
        rateItems: [RateItem]?? = nil,
        rateRestaurant: RateRestaurant?? = nil,
        rateDriver: RateDriver?? = nil
    ) -> FoodOrderRate {
        return FoodOrderRate(
            id: id ?? self.id,
            orderSerial: orderSerial ?? self.orderSerial,
            rateItems: rateItems ?? self.rateItems,
            rateRestaurant: rateRestaurant ?? self.rateRestaurant,
            rateDriver: rateDriver ?? self.rateDriver
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RateDriver
struct RateDriver: Codable {
    let id: Int?
    let name, phone: String?
    let profilePic: String?
    var rating: Int?
    var review: String?

    enum CodingKeys: String, CodingKey {
        case id, name, phone
        case profilePic = "profile_pic"
        case rating, review
    }
}

// MARK: RateDriver convenience initializers and mutators

extension RateDriver {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RateDriver.self, from: data)
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
        phone: String?? = nil,
        profilePic: String?? = nil,
        rating: Int?? = nil,
        review: String?? = nil
    ) -> RateDriver {
        return RateDriver(
            id: id ?? self.id,
            name: name ?? self.name,
            phone: phone ?? self.phone,
            profilePic: profilePic ?? self.profilePic,
            rating: rating ?? self.rating,
            review: review ?? self.review
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RateItem
struct RateItem: Codable {
    let id: Int?
    let name, subtitle, orderSerial: String?
    let image: String?
    var rating: Int?
    var review: String?

    enum CodingKeys: String, CodingKey {
        case id, name, subtitle
        case orderSerial = "order_serial"
        case image, rating, review
    }
}

// MARK: RateItem convenience initializers and mutators

extension RateItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RateItem.self, from: data)
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
        subtitle: String?? = nil,
        orderSerial: String?? = nil,
        image: String?? = nil,
        rating: Int?? = nil,
        review: String?? = nil
    ) -> RateItem {
        return RateItem(
            id: id ?? self.id,
            name: name ?? self.name,
            subtitle: subtitle ?? self.subtitle,
            orderSerial: orderSerial ?? self.orderSerial,
            image: image ?? self.image,
            rating: rating ?? self.rating,
            review: review ?? self.review
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - RateRestaurant
struct RateRestaurant: Codable {
    let id: Int?
    let name, excerpt: String?
    let logo: String?
    var rating: Int?
    var review: String?
}

// MARK: RateRestaurant convenience initializers and mutators

extension RateRestaurant {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RateRestaurant.self, from: data)
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
        excerpt: String?? = nil,
        logo: String?? = nil,
        rating: Int?? = nil,
        review: String?? = nil
    ) -> RateRestaurant {
        return RateRestaurant(
            id: id ?? self.id,
            name: name ?? self.name,
            excerpt: excerpt ?? self.excerpt,
            logo: logo ?? self.logo,
            rating: rating ?? self.rating,
            review: review ?? self.review
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// Search Product Model by Rishabh-start
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchProducts = try SearchProducts(json)

import Foundation

// MARK: - SearchProducts
struct SearchProducts: Codable {
    let status: Bool?
    var data: DataClass?
    let meta: Meta?
    let link: Link?
}

// MARK: SearchProducts convenience initializers and mutators

extension SearchProducts {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchProducts.self, from: data)
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
        status: Bool?? = nil,
        data: DataClass?? = nil,
        meta: Meta?? = nil,
        link: Link?? = nil
    ) -> SearchProducts {
        return SearchProducts(
            status: status ?? self.status,
            data: data ?? self.data,
            meta: meta ?? self.meta,
            link: link ?? self.link
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    var products: [ProductTemp]?
}

// MARK: DataClass convenience initializers and mutators

extension DataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataClass.self, from: data)
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
        products: [ProductTemp]?? = nil
    ) -> DataClass {
        return DataClass(
            products: products ?? self.products
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



enum Name: String, Codable {
    case gWear = "G Wear"
    case jeanFurniture = "Jean Furniture"
    case johnsonJohnson = "Johnson & Johnson"
}

// MARK: - Link
struct Link: Codable {
    let next, prev: Bool?
}

// MARK: Link convenience initializers and mutators

extension Link {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Link.self, from: data)
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
        next: Bool?? = nil,
        prev: Bool?? = nil
    ) -> Link {
        return Link(
            next: next ?? self.next,
            prev: prev ?? self.prev
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalPage, currentPage, totalItem, perPage: Int?

    enum CodingKeys: String, CodingKey {
        case totalPage = "total_page"
        case currentPage = "current_page"
        case totalItem = "total_item"
        case perPage = "per_page"
    }
}

// MARK: Meta convenience initializers and mutators

extension Meta {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Meta.self, from: data)
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
        totalPage: Int?? = nil,
        currentPage: Int?? = nil,
        totalItem: Int?? = nil,
        perPage: Int?? = nil
    ) -> Meta {
        return Meta(
            totalPage: totalPage ?? self.totalPage,
            currentPage: currentPage ?? self.currentPage,
            totalItem: totalItem ?? self.totalItem,
            perPage: perPage ?? self.perPage
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//Search Product Model by Rishabh- end


//restro search model by Rishabh - start

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchRestro = try SearchRestro(json)


// MARK: - SearchRestro
struct SearchRestro: Codable {
    let status: Bool?
    let data: DataClassRestro?
    let meta: Meta?
    let link: Link?
}

// MARK: SearchRestro convenience initializers and mutators

extension SearchRestro {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchRestro.self, from: data)
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
        status: Bool?? = nil,
        data: DataClassRestro?? = nil,
        meta: Meta?? = nil,
        link: Link?? = nil
    ) -> SearchRestro {
        return SearchRestro(
            status: status ?? self.status,
            data: data ?? self.data,
            meta: meta ?? self.meta,
            link: link ?? self.link
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataClass
struct DataClassRestro: Codable {
    var restaurants: [Restaurant_]?
}

// MARK: DataClass convenience initializers and mutators

extension DataClassRestro {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataClassRestro.self, from: data)
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
        restaurants: [Restaurant_]?? = nil
    ) -> DataClassRestro {
        return DataClassRestro(
            restaurants: restaurants ?? self.restaurants
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//restro search model by Rishabh - ends



//MyorderData model by Rishabh - start

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchRestro = try SearchRestro(json)


// MARK: - MyOrderData
struct MyorderData: Codable {
    let status: Bool?
    let data: DataClassOrders?
    let meta: Meta?
    let link: Link?
}

// MARK: SearchRestro convenience initializers and mutators

extension MyorderData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MyorderData.self, from: data)
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
        status: Bool?? = nil,
        data: DataClassOrders?? = nil,
        meta: Meta?? = nil,
        link: Link?? = nil
    ) -> MyorderData {
        return MyorderData(
            status: status ?? self.status,
            data: data ?? self.data,
            meta: meta ?? self.meta,
            link: link ?? self.link
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataClass
struct DataClassOrders: Codable {
    var orders: [MyOrder]?
}

// MARK: DataClass convenience initializers and mutators

extension DataClassOrders {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataClassOrders.self, from: data)
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
        order: [MyOrder]?? = nil
    ) -> DataClassOrders {
        return DataClassOrders(
            orders: orders ?? self.orders
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

//My order by Rishabh - ends

//   let myRestroDetails = try MyRestroDetails(json)

struct RestaurantDetails: Codable {
    let id: Int?
    let name: String?
    let logo: String?
}



struct FoodRateOrders {
    var driverDeliveryReviewText: String?
    var driverDeliveryReviewStar: Int?
    var foodDeliveryReviewText: String?
    var foodDeliveryReviewStar: Int?

}

struct Favourites: Codable {
    let products: [ProductTemp]?
    let restaurants: [Restaurant_]?
}

extension Favourites {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Favourites.self, from: data)
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
        products: [ProductTemp]?? = nil,
        restaurants: [Restaurant_]?? = nil
    ) -> Favourites {
        return Favourites(
            products: products ?? self.products,
            restaurants: restaurants ?? self.restaurants
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let trackOrder = try TrackOrder(json)

import Foundation

// MARK: - TrackOrder
struct TrackOrder: Codable {
    var id: Int?
    var orderSerial, status: String?
    var user: User_?
    var restaurant: Restaurant_?
    var driver: Driver?

    enum CodingKeys: String, CodingKey {
        case id
        case orderSerial = "order_serial"
        case status, user, restaurant, driver
    }
}

// MARK: TrackOrder convenience initializers and mutators

extension TrackOrder {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrackOrder.self, from: data)
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
        orderSerial: String?? = nil,
        status: String?? = nil,
        user: User_?? = nil,
        restaurant: Restaurant_?? = nil,
        driver: Driver?? = nil
    ) -> TrackOrder {
        return TrackOrder(
            id: id ?? self.id,
            orderSerial: orderSerial ?? self.orderSerial,
            status: status ?? self.status,
            user: user ?? self.user,
            restaurant: restaurant ?? self.restaurant,
            driver: driver ?? self.driver
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


struct MyCategoryData: Codable {
    let status: Bool?
    let data: DataClassCategories?
    let meta: Meta?
    let link: Link?
}

// MARK: SearchRestro convenience initializers and mutators

extension MyCategoryData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MyCategoryData.self, from: data)
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
        status: Bool?? = nil,
        data: DataClassCategories?? = nil,
        meta: Meta?? = nil,
        link: Link?? = nil
    ) -> MyCategoryData {
        return MyCategoryData(
            status: status ?? self.status,
            data: data ?? self.data,
            meta: meta ?? self.meta,
            link: link ?? self.link
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - DataClass
struct DataClassCategories: Codable {
    var categories: [Category]?
}

// MARK: DataClass convenience initializers and mutators

extension DataClassCategories {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(DataClassCategories.self, from: data)
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
        order: [Category]?? = nil
    ) -> DataClassCategories {
        return DataClassCategories(
            categories: categories ?? self.categories
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
