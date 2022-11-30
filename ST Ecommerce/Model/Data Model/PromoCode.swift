// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let promoCode = try PromoCode(json)

import Foundation

// MARK: - PromoCode
struct PromoCode: Codable {
    var promoCode, discount: String?
    var nrcRequired: Bool?
    var validDate: String?

    enum CodingKeys: String, CodingKey {
        case promoCode = "promo_code"
        case discount
        case nrcRequired = "nrc_required"
        case validDate = "valid_date"
    }
}

// MARK: PromoCode convenience initializers and mutators

extension PromoCode {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PromoCode.self, from: data)
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
        promoCode: String?? = nil,
        discount: String?? = nil,
        nrcRequired: Bool?? = nil,
        validDate: String?? = nil
    ) -> PromoCode {
        return PromoCode(
            promoCode: promoCode ?? self.promoCode,
            discount: discount ?? self.discount,
            nrcRequired: nrcRequired ?? self.nrcRequired,
            validDate: validDate ?? self.validDate
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
