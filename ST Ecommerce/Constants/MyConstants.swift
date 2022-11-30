//
//  MyConstants.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation
import UIKit

//MARK: - StoryBoards variables
let storyboardSignIn = UIStoryboard(name: "SignIn", bundle: nil)
let storyboardMain = UIStoryboard(name: "Main", bundle: nil)
let storyboardRegister = UIStoryboard(name: "Register", bundle: nil)
let storyboardVerifyOTP = UIStoryboard(name: "VerifyOTP", bundle: nil)

let storyboardHome = UIStoryboard(name: "Home", bundle: nil)
let storyboardStore = UIStoryboard(name: "Store", bundle: nil)
let storyboardStoreSearch = UIStoryboard(name: "StoreSearch", bundle: nil)
let storyboardBrandDetail = UIStoryboard(name: "Brand", bundle: nil)
let storyboardSubcategory = UIStoryboard(name: "Subcategory", bundle: nil)
let storyboardProductDetails = UIStoryboard(name: "ProductDetails", bundle: nil)
let webViewStoryboard = UIStoryboard(name: "WebView", bundle: nil)
let announcementDetailStoryboard = UIStoryboard(name: "Announcement", bundle: nil)
let storyboardRestaurantDetails = UIStoryboard(name: "RestaurantDetails", bundle: nil)
let storyboardFoodsCart = UIStoryboard(name: "FoodsCart", bundle: nil)

let storyboardAccount = UIStoryboard(name: "Account", bundle: nil)

let storyboardCart = UIStoryboard(name: "Cart", bundle: nil)
let storyboardProfile = UIStoryboard(name: "Home", bundle: nil)

let storyboardBuyNow = UIStoryboard(name: "BuyNow", bundle: nil)
let storyboardMyOrders = UIStoryboard(name: "MyOrders", bundle: nil)

let storyboardFoodsMyOrders = UIStoryboard(name: "FoodsMyOrders", bundle: nil)

let storyboardCreditCard = UIStoryboard(name: "CreditCard", bundle: nil)
let storyboardSplash = UIStoryboard(name: "Splash", bundle: nil)
let storyboardAddress = UIStoryboard(name: "Address", bundle: nil)
let storyboardRestaurant = UIStoryboard(name: "Restaurant", bundle: nil)

let storyboardSettings = UIStoryboard(name: "Settings", bundle: nil)

let storyboardRewards = UIStoryboard(name: "Rewards", bundle: nil)

let storyboardDonation = UIStoryboard(name: "Donation", bundle: nil)

let storyboardTrackOrder = UIStoryboard(name: "SB_TrackOrder", bundle: nil)

let SB_Store_Track = UIStoryboard(name: "SB_Store_Track", bundle: nil)


let DEFAULTS = UserDefaults.standard


//MARK: - USer defaults Keys
let UD_role = "role"
let UD_isUserLogin = "isUserLogin"
let UD_isContainAdd = "isContainAdd" // created by karishma
let UD_APITOKEN = "APITOKEN"
let UD_Language = "language"
let UD_Address_Id = "UD_Address_Id"
let UD_Latitude = "UD_Latitude"   // created by karishma
let UD_Longitude = "UD_Longitude"  // created by karishma
let UD_Formatted_User_Address = "UD_Formatted_User_Address"
let UD_Popup = "popup"
let UD_Token = "token"
let UD_Key = "key"
let UD_cbvalue = "cb_value"
let UD_kbzvalue = "kbz_value"
let UD_mpuvalue = "mpu_value"
let UD_mpgsvalue = "mpgs_value"
let UD_DateTime = "DateTime"
let UD_DeliTime = "DeliTime"
let UD_DeliDate = DeliDate.self
let UD_DeliNexTime = "DeliNextTime"
let UD_DeliMode  = false
let UD_Total = "Total"
let BadgeCount = "badgeCount"
let UD_OrderLeadTime = "OrderLeadTime"
let UD_LeadTimeMinute = "LeadTimeMinute"


//MARK: - API keys
let GOOGLE_API_KEY = ""
let key_status = "status"
let key_message = "message"
let key_data = "data"

let currencySymbol = " MMK"

//MARK: - Numbers
let homeCellHeightRatio : CGFloat = 0.636
let storeVCellHeightRatio : CGFloat = 0.675
let homeCellWidthRatio : CGFloat = 2.3
let imageMinLimitNotToCompress : Double = 2
let imageCompressionPercent : CGFloat = 0.5
let dateFormatter = DateFormatter()
let dateFormatterType = "dd MMMM yyyy hh:mm a"


//MARK: - Dummy data
var images : [UIImage] = [#imageLiteral(resourceName: "medical"), #imageLiteral(resourceName: "product"), #imageLiteral(resourceName: "product2"), #imageLiteral(resourceName: "pizza")]
var categories = ["Electronics", "Foods", "Clothes", "Fashion", "Gadgets", "Medical", "Vegetables", "Fruits"]
var productNames = ["Medical", "Electronics", "Clothes", "Fashion", "Watches"]
var ratings = [1,2,3,4,5]
let appColors =  [#colorLiteral(red: 0.9411764706, green: 0.8431372549, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.937254902, blue: 0.7607843137, alpha: 1), #colorLiteral(red: 0.7764705882, green: 0.8901960784, blue: 0.9137254902, alpha: 1), #colorLiteral(red: 0.8549019608, green: 0.9176470588, blue: 0.9882352941, alpha: 1),  #colorLiteral(red: 0.9843137255, green: 0.9803921569, blue: 0.6431372549, alpha: 1)]
let paymentTextColorString = "#D1D1D6"

//MARK: - download image data
let takeAwayImageUrl = "http://159.89.166.234/staging/st-com-food-backend/public/storage/defaults/order/take-away-icon.png"



let trackStoreTimeFormatString = "dd MMMM yyyy h:mm a"
let oneSignalAppId = "7eaea51b-2509-4885-b988-4cd5deb12cc8"
let keyPlayerId = "keyPlayerId"
