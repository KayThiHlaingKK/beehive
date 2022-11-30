//
//  TrackStoreOrderData.swift
//  ST Ecommerce
//
//  Created by Necixy on 06/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let trackStoreOrderData = try TrackStoreOrderData(json)

import Foundation

// MARK: - TrackStoreOrderData
struct TrackStoreOrderData: Codable {
    var id: Int?
    var orderSerial, status: String?
    var product: ProductTemp?
    var timeline: [Timeline]?

    enum CodingKeys: String, CodingKey {
        case id
        case orderSerial = "order_serial"
        case status, product, timeline
    }
}

// MARK: TrackStoreOrderData convenience initializers and mutators

extension TrackStoreOrderData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrackStoreOrderData.self, from: data)
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
        product: ProductTemp?? = nil,
        timeline: [Timeline]?? = nil
    ) -> TrackStoreOrderData {
        return TrackStoreOrderData(
            id: id ?? self.id,
            orderSerial: orderSerial ?? self.orderSerial,
            status: status ?? self.status,
            product: product ?? self.product,
            timeline: timeline ?? self.timeline
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Timeline
struct Timeline: Codable {
    var status: String?
    var time: Int?
}

// MARK: Timeline convenience initializers and mutators

extension Timeline {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Timeline.self, from: data)
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
        status: String?? = nil,
        time: Int?? = nil
    ) -> Timeline {
        return Timeline(
            status: status ?? self.status,
            time: time ?? self.time
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


/* JSON dat for making model*/

/*
 
 {
         "id": 495,
         "order_serial": "ORD00001145-1",
         "status": "Pending",
         "product": {
             //as previous one used
         },
         "timeline": [
             {
                 "status": "Order Placed",
                 "time": 1604670583
             },
             {
                 "status": "Order Confirmed",
                 "time": 1604670583
             },
             {
                 "status": "Order Ready to Ship",
                 "time": 1604670583
             },
             {
                 "status": "Order Shipped",
                 "time": 1604670583
             },
             {
                 "status": "Order Delivered",
                 "time": 1604670583
             }
         ]
     }
 
 */
