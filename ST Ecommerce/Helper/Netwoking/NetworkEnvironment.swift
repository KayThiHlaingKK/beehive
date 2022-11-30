//
//  NetworkEnvironment.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

struct NetworkEnvironment {
    struct ProductionServer {
        #if STAGING
        static let baseURLStage = "https://beehive-api.hivestage.com/api/v3"
        static let baseURLV4Stage = "https://beehive-api.hivestage.com/api/v4"
        #else
        static let baseURLProduction = "https://api.beehivemm.com/api/v3"
        static let baseURLV4Production = "https://api.beehivemm.com/api/v4"
        #endif
    }
    
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
