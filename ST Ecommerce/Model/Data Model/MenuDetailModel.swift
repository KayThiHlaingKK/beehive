//
//  MenuDetailModel.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 6/9/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation

struct MenuDetailModel: Codable{
    var success: Bool?
    var message: String?
    var status: Int?
    var data: Available_menus?
}

struct MenuDetailData: Codable{
    var slug: String?
    var name: String?
    var price: Double?
    var tax: Int?
    var discount: Double?
    var images: [Images]?
    var description: String?
    var menu_variants: [Menu_variants]?
    var variants: [MenuDetailVariants]?
    var menu_toppings: [MenuTopping]?
    var menu_options: [MenuOption]?
}
        
struct MenuDetailVariants: Codable{
    var name: String?
    var values: [String]?
}
