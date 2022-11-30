//
//  Constants.swift
//  SampleShop
//
//  Created Ku Ku Zan on 19/04/2022.
//

import Foundation

var deliDateTimeNavigate = ""
var isRemove = false
var isAddressChange = false
var restaurantBranchForCart : RestaurantBranch?


enum AssetsColor: String {
    case btnTextColor = "BtnTextColor"
    case primaryColor = "PrimaryColor"
    case primaryTextColor = "PrimaryTextColor"
    case secondaryTextColor = "SecondaryTextColor"
    case tertiaryTextColor = "TertiaryTextColor"
    case searchbarBGColor = "SearchBarBGColor"
    case mainColor = "MainColor"
    case paymentLabelTextColor = "PaymentLabelColor"
    case paymentTextColor = "PaymentTextColor"
}

enum ValidationErrors: String {
    case usernameError = "Username is Required!"
    case passwordError = "Password is Required!"
}

struct UserSettingPaymentKey {
    static let kbzpay = "kbzpay"
    static let cbpay = "cbpay"
    static let mpu = "mpu"
    static let visa = "mpgs"
}

