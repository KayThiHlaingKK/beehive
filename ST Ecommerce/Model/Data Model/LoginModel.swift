//
//  LoginModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation Dev on 9/6/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

struct LoginAuthentication {
    var phoneNumber: String = ""
    var password: String = ""
}

struct LoginModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: LoginData?
}

struct LoginData: Codable {
    let token: String?
}
