//
//  UserProfileModel.swift
//  ST Ecommerce
//
//  Created by Hive Innovation Dev on 9/6/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

// MARK: - UserProfileModel
struct UserProfileModel: Codable {
    let success: Bool?
    let message: String?
    let status: Int?
    let data: UserProfileData?
}

// MARK: - DataClass
struct UserProfileData: Codable {
    let slug: String?
    let email: String?
    let name, phoneNumber, gender, dateOfBirth: String?
    let primaryAddress: Address?
    let image: Image?
    let addresses: [Address]?

    enum CodingKeys: String, CodingKey {
        case slug, email, name
        case phoneNumber = "phone_number"
        case gender
        case dateOfBirth = "date_of_birth"
        case primaryAddress = "primary_address"
        case image, addresses
    }
}


