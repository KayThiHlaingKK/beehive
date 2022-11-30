//
//  ProductDetails.swift
//  ST Ecommerce
//
//  Created by Necixy on 08/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation

// MARK: - ProductDetails
struct ProductDetails: Codable {
    let product: Product?
    var productSuggestions, youMayAlsoLike: [Product]?
    let reviewCount: Int?
    var viewAll: Bool?
    var reviews: [Review]?

    enum CodingKeys: String, CodingKey {
        case product
        case productSuggestions = "product_suggestions"
        case youMayAlsoLike = "you_may_also_like"
        case reviewCount = "review_count"
        case viewAll, reviews
    }
}

// MARK: ProductDetails convenience initializers and mutators

extension ProductDetails {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ProductDetails.self, from: data)
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
        product: Product?? = nil,
        productSuggestions: [Product]?? = nil,
        youMayAlsoLike: [Product]?? = nil,
        reviewCount: Int?? = nil,
        viewAll: Bool?? = nil,
        reviews: [Review]?? = nil
    ) -> ProductDetails {
        return ProductDetails(
            product: product ?? self.product,
            productSuggestions: productSuggestions ?? self.productSuggestions,
            youMayAlsoLike: youMayAlsoLike ?? self.youMayAlsoLike,
            reviewCount: reviewCount ?? self.reviewCount,
            viewAll: viewAll ?? self.viewAll,
            reviews: reviews ?? self.reviews
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
