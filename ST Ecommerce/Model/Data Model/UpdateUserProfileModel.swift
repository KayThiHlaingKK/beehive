//
//  UpdateUserProfileModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation Dev on 9/6/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation


struct UpdateUserProfile {
    var email : String
    var name : String
    var gender : String
    var date_of_birth : String
    var image_slug : String
}

struct UpdateUserProfileModel: Codable {
    let success: Bool?
    let status: Int?
    let message: String?
}
