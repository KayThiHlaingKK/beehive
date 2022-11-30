

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let buyNow = try BuyNow(json)

import Foundation

// MARK: - BuyNow

// MARK: - BuyNow
struct BuyNow: Codable {
    var product: ProductTemp?
    var options: [Option]?
    var variationID: Int?
    var subtotal, coupon, discount, tax: String?
    var taxPercentage, deliveryCharge, deliveredBy, total: String?

    enum CodingKeys: String, CodingKey {
        case product, options
        case variationID = "variation_id"
        case subtotal, coupon, discount, tax
        case taxPercentage = "tax_percentage"
        case deliveryCharge = "delivery_charge"
        case deliveredBy = "delivered_by"
        case total
    }
}

// MARK: BuyNow convenience initializers and mutators

extension BuyNow {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(BuyNow.self, from: data)
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
        product: ProductTemp?? = nil,
        options: [Option]?? = nil,
        variationID: Int?? = nil,
        subtotal: String?? = nil,
        coupon: String?? = nil,
        discount: String?? = nil,
        tax: String?? = nil,
        taxPercentage: String?? = nil,
        deliveryCharge: String?? = nil,
        deliveredBy: String?? = nil,
        total: String?? = nil
    ) -> BuyNow {
        return BuyNow(
            product: product ?? self.product,
            options: options ?? self.options,
            variationID: variationID ?? self.variationID,
            subtotal: subtotal ?? self.subtotal,
            coupon: coupon ?? self.coupon,
            discount: discount ?? self.discount,
            tax: tax ?? self.tax,
            taxPercentage: taxPercentage ?? self.taxPercentage,
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

