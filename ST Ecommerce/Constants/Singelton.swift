//
//  Singelton.swift
//  ST Ecommerce
//
//  Created by necixy on 15/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
protocol FavoriteListener: class {
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool)
}

final class Singleton {
    static let shareInstance = Singleton()
    private init() {}
    
    var userCurrentCoordinates = CLLocationCoordinate2D()
    
    //address
    var country = ""
    var state = ""
    var city = ""
    var street = ""
    var streetNumber = ""
    var zip = ""
    var locationName = ""
    
    var currentLat: Double = 0.0
    var currentLong: Double = 0.0
    var currentAddress = ""
    var instatnOrder = true
    var isBack = false
    var addressChange = false
    var isPromoUse = false
    var promoCode = ""
   
    
    //var userAddress : Address_?
    var userProfile: Profile?
    var address: [Address]?
    var RateOrder: RateRestaurant?
    var foodRateOrders: FoodRateOrders?
    var products: ProductTemp?
    var productOrder: ShopCart?
    var restaurant: Restaurant_?
    var isFavourite: Bool = false
//    var defaultAddress: Address?
//    var nearestAddress: Address?
    var selectedAddress: Address?
        
    var floors : [Floor] = [Floor]()
    
    var popupDate = ""
    
    var willdeli = DeliveryMode.delivery
    var deliDate = DeliveryDate.today
    var orderType = OrderType.instant
    var deliTime = ""    
    var showDateTime = ""
    var totalAmount = ""
    
}
