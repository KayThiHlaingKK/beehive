//
//  Strings.swift
//  ST Ecommerce
//
//  Created by necixy on 07/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation



func getlanguage() -> String{

    if let language = DEFAULTS.value(forKey: UD_Language) as? String{
        return language
    }else{
        return "en"
    }
}

//MARK: - Sign In screen Strings
let enterPhoneNumberAlertText = "Please enter your mobile number.".localized(loc: getlanguage())
let enterValidPhoneNumberAlertText = "Please enter valid phone number.".localized(loc: getlanguage())

//MARK: - Register screen Strings
let enterNameText = "Please enter your name.".localized(loc: getlanguage())
let enterPasswordAlertText = "Please enter your password.".localized(loc: getlanguage())
let enterConfirmPasswordAlertText = "Please enter your confirm password.".localized(loc: getlanguage())
let passwordValidateAlertText = "Password and confirm password must be same.".localized(loc: getlanguage())
let fullNameEmptyAlertText = "Fullname should not be empty.".localized(loc: getlanguage())
let passwordEmptyAlertText = "Password should not be empty.".localized(loc: getlanguage())
let oldPasswordEmptyAlertText = "Password should not be empty.".localized(loc: getlanguage())
let confirmPasswordEmptyAlertText = "Confirm password should not be empty.".localized(loc: getlanguage())
let newPasswordEmptyAlertText = "New password should not be empty.".localized(loc: getlanguage())
let agreeTermsAndConditions = "Please agree to terms and conditions of BeeHive to proceed.".localized(loc: getlanguage())
let incorrectOtpTitle = "Incorrect OTP Code".localized(loc: getlanguage())
let incorrectOtpMessage = "The otp code you just entered is not correct. Please enter correct code.".localized(loc: getlanguage())
//MARK: - Varify screen Strings
let enterOTPAlertText = "Please enter OTP Code".localized(loc: getlanguage())


//MARK: - Home screen
let cartText = "Cart".localized(loc: getlanguage())
let myOrderText = "My Order".localized(loc: getlanguage())
let accountText = "Account".localized(loc: getlanguage())
let settingsText = "Settings".localized(loc: getlanguage())
let rewardsText = "Rewards".localized(loc: getlanguage())
let donationsText = "Donations".localized(loc: getlanguage())
let suggestionProductText = "Suggestions products".localized(loc: getlanguage())
let AnnouncementTitleText = "Announcements".localized(loc: getlanguage())
let suggestionRestaurantText = "Suggestions Restaurant".localized(loc: getlanguage())
let newArrivalProductsText = "New Arrival Products".localized(loc: getlanguage())
let newArrivalRestaurantText = "New Arrival Restaurant".localized(loc: getlanguage())
let offText = "OFF".localized(loc: getlanguage())
let rewardMessageText = "Login to know more information about our new exciting event!".localized(loc: getlanguage())
let unableToFetchLocationText = "Unable to fetch location. Please try again Or go to settings to enable location permission.".localized(loc: getlanguage())
let fetchingLocationText = "We are fetching your location Please wait".localized(loc: getlanguage())
let moreGiftsText = "More gift coming your way".localized(loc: getlanguage())
let helloText = "Hello Beehive Users".localized(loc: getlanguage())
let helloParagrahText = "This app is still under development and some of the functions may not be working yet. Sorry for your inconvenient and we are working hard to make this app even better in upcoming version. \n\n Thank you for using our app".localized(loc: getlanguage())



//MARK: - Store Screens
let storeText = "Shops".localized(loc: getlanguage())
let searchText = "Search...".localized(loc: getlanguage())
let emptyCartAlertText = "Cart is empty, Please add an item.".localized(loc: getlanguage())
let productsText = "Products".localized(loc: getlanguage())
let goToCartText = "Go to Cart".localized(loc: getlanguage())
let addressalertText = "Please select or add address.".localized(loc: getlanguage())
let restaurantsText = "Restaurants".localized(loc: getlanguage())


//MARK: - Store Details/ Product details
let freeText = "FREE".localized(loc: getlanguage())
let soldText = "Sold".localized(loc: getlanguage())
let UsersText = "Users".localized(loc: getlanguage())
let customerReviewsText = "Customer Reviews".localized(loc: getlanguage())
let notAvailableText = "Not Available".localized(loc: getlanguage())
let closedText = "Closed".localized(loc: getlanguage())


//MARK: - Foods Screens
let foodsText = "Restaurants".localized(loc: getlanguage())

//MARK: - More Screens
let moreText = "More".localized(loc: getlanguage())



//MARK: - General
let attentionText = "".localized(loc: getlanguage())
let errorText = "".localized(loc: getlanguage())
let serverError = "Server Error Try again.".localized(loc: getlanguage())
let loadingText = "Loading...".localized(loc: getlanguage())
let no_internet_connection_available = "Please check your internet connection or try again later.".localized(loc: getlanguage())
let sessionExpiredText = "Session Expired".localized(loc: getlanguage())
let logoutText = "Logout".localized(loc: getlanguage())
let okayText = "OK".localized(loc: getlanguage())
let updateText = "Update".localized(loc: getlanguage())
let goBackText = "Cancel".localized(loc: getlanguage())
let successText = "Success".localized(loc: getlanguage())
let comingSoonText = "Coming Soon".localized(loc: getlanguage())
let loginMessageText = "This option needs you to be logged in. Please login to continue.".localized(loc: getlanguage())
let needToLoginText = "Login".localized(loc: getlanguage())
let yesText = "yes".localized(loc: getlanguage())
let noText = "no".localized(loc: getlanguage())
let warningText = "warning".localized(loc: getlanguage())
let warningAlertText = "Warning Alert".localized(loc: getlanguage())
let locationEnableText = "Please go to Settings and enable location services for Beehive.".localized(loc: getlanguage())
let locationPermissionRequiredText = "Enable Location Services".localized(loc: getlanguage())
let privacyPolicy = "Privacy Policy".localized(loc: getlanguage())
let termsAndConditions = "Terms & Conditions".localized(loc: getlanguage())
let updateAppText = "Your application is out of date. Please update your application to get the latest features.".localized(loc: getlanguage())


//MARK: - Address
let changeAddressText = "Change Address".localized(loc: getlanguage())
let addAddressText = "Add Address".localized(loc: getlanguage())
let enterYourNameForAddress = "Please give a name for your address.".localized(loc: getlanguage())
let EditText = "Edit".localized(loc: getlanguage())
let deleteText = "Delete".localized(loc: getlanguage())
let AddText = "Add".localized(loc: getlanguage())
let saveText = "Save & Continue".localized(loc: getlanguage())
let UpdateText = "Update".localized(loc: getlanguage())
let addressDeletePromptText = "Are you sure want to delete address?".localized(loc: getlanguage())
let addressWarningText = "Add township and city in address".localized(loc: getlanguage())
let selectTownShipText = "Please select township".localized(loc: getlanguage())
let selectFloorText = "Please select floor".localized(loc: getlanguage())
let enterYourZipCode = "Please enter your Zip code.".localized(loc: getlanguage())


//MARK: -  Cart
let expectedDeliveryText = "Expected Delivery :".localized(loc: getlanguage())
let removeItemFromCartAlertText = "Are you sure want to remove item from cart?".localized(loc: getlanguage())
let replaceCartAlertText = "There is currently another order in Cart.Do you want to delete previous cart?".localized(loc: getlanguage())
let destroyCartAlertText = "Are you sure want to destroy your cart?".localized(loc: getlanguage())
let removeItemFromCartTitle = "Remove item from cart".localized(loc: getlanguage())
let removeItemFromCartText = "This item has multiple customizations added. Proceed to cart to remove item?".localized(loc: getlanguage())


//MARK: - My Order
let currentOrdersText = "Current Orders".localized(loc: getlanguage())
let deliveredOrdersText = "Delivered Orders".localized(loc: getlanguage())
let PastOrdersText = "Past Orders".localized(loc: getlanguage())
let onTheWayText = "On the way".localized(loc: getlanguage())
let orderNoText = "Order No.".localized(loc: getlanguage())
let deliveredAt = "Delivered at".localized(loc: getlanguage())
let deliveredText = "Delivered".localized(loc: getlanguage())
let orderConfirmText = "We are processing your order".localized(loc: getlanguage())
let orderPlacedText = "Order Placed".localized(loc: getlanguage())


//MARK: - Account screen
let addNewText = "Add New".localized(loc: getlanguage())
let changeText = "Change".localized(loc: getlanguage())

let choose_your_option = "choose_your_option".localized(loc: getlanguage())
let open_camera = "open_camera".localized(loc: getlanguage())
let open_photos = "open_photos".localized(loc: getlanguage())
let open_files = "open_files".localized(loc: getlanguage())
let app_name = "app_name".localized(loc: getlanguage())
let camera_not_available = "camera_not_available".localized(loc: getlanguage())
let denied_gallery_permission_message = "denied_gallery_permission_message".localized(loc: getlanguage())
let cancelText = "cancel".localized(loc: getlanguage())
let denied_camera_permission_message = "denied_camera_permission_message".localized(loc: getlanguage())
let maleText = "Male".localized(loc: getlanguage())
let femaleText = "Female".localized(loc: getlanguage())
let ChangePasswordText = "Change Password".localized(loc: getlanguage())
let PrivacyPolicyText = "Privacy Policy".localized(loc: getlanguage())
let Terms_ConditionsText = "Terms & Conditions".localized(loc: getlanguage())
let PaymentSettingsText = "Payment Settings".localized(loc: getlanguage())
let accountInformationUpdateSuccess = "Your information is successfully updated.".localized(loc: getlanguage())
let HelpDeskText = "Help Desk".localized(loc: getlanguage())
let logoutpromptText = "Do you want to logout?".localized(loc: getlanguage())
let deletePromopromptText = "Do you want to remove promo code?".localized(loc: getlanguage())


//MARK: - Restro Details
let itemNotAvailableText = "Currently item is not available".localized(loc: getlanguage())
let productNotAvailableText = "Currently product is not available".localized(loc: getlanguage())
let productOutOfStockText = "Out Of Stock".localized(loc: getlanguage())
let currentlyNotAccepting = "Currently not accepting orders.".localized(loc: getlanguage())
let freeDeliveryText = "Free Delivery".localized(loc: getlanguage())

//MARK - Restro Order detils
let estimatedDeliveryText = "Estimated Delivery: ".localized(loc: getlanguage())

//MARK:- Product Search screen
let searchProductText = "Search Products".localized(loc: getlanguage())
let doneText = "Done".localized(loc: getlanguage())

//MARK:- Restro Search screen
let searchRestroText = "Search Restaurants".localized(loc: getlanguage())

let favorites = "favorites"


//MARK: - Track order store
let orderPlaced = "Order Placed".localized(loc: getlanguage())
let orderConfirmed = "Order Confirmed".localized(loc: getlanguage())
let orderReadytoShip = "Order Ready to Ship".localized(loc: getlanguage())
let orderShipped = "Order Shipped".localized(loc: getlanguage())
let orderDelivered = "Order Delivered".localized(loc: getlanguage())
let OrderTimeline = "Order Timeline".localized(loc: getlanguage())
