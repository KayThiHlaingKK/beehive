//
//  MyOrderScreenEntity.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//
//

import Foundation

struct MyOrderRequest{
    var size : String = ""
    var page : String = ""
}

struct ShopOrderModel : Decodable{
    var status: Int?
    var message: String?
    var data:[OrderData]?
    var last_page: Int?
}

struct FoodOrderModel: Codable{
    var status: Int?
    var message: String?
    var data: [OrderData]?
    var last_page: Int?
}

struct OrderData: Codable{
    var slug: String?
    var prepay_id: String?
    var generate_ref_order: String?
    var customer_id: Int?
    var order_date: String?
    var order_status: String?
    var payment_status: String?
    var payment_mode: String?
    var delivery_fee: Double?
    var commission: Double?
    var items:[MyOrderItems]?
    var restaurant_order_items: [MyOrderItems]?
    var restaurant_branch_info: OrderBranchInfo?
    var invoice_id: String?
    var order_no: String?
    var amount: Double?
    var tax: Double?
    var discount: Double?
    var total_amount: Double?
}

struct MyOrderItems: Codable{
    var id: Int?
    var product_id: Int?
    var product_name: String?
    var amount: Double?
    var quantity: Int?
    var order_status: String?
    var images: [OrderImages]?
}

struct OrderImages: Codable{
    var slug: String?
    var file_name: String?
    var url: String?
}

struct OrderBranchInfo: Codable{
    var name: String?
    var township: String?
    var restaurant: OrderRestaurant?
}

struct OrderRestaurant: Codable{
    var name: String?
    var images: [OrderImages]?
}









