//
//  CreditCardEntity.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 26/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import Foundation


// MARK: - CreditModel
struct CreditCardModel: Codable {
    let status: Int?
    let message: String?
    let data: CreditData?
}

// MARK: - DataClass
struct CreditData: Codable {
    let amount: Double?
    let created_by, updated_by: AtedBy?
    let remaining_amount: Double?
}

// MARK: - AtedBy
struct AtedBy: Codable {
    let slug, username, name, phone_number: String?
}
