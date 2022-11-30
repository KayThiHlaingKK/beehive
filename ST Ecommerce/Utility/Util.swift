//
//  Util.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SystemConfiguration
import LanguageManager_iOS
import CoreLocation
import SwiftLocation
import AVFoundation
import Photos
import QuickLook
import Sentry

class Util {

    class func shared() -> Util {
        return sharedDataModel
    }

    private static var sharedDataModel: Util = {
        let dataModel = Util()
        return dataModel
    }()

    static func makeSignInRootController(){

        let controller = storyboardSignIn.instantiateViewController(withIdentifier: "VC_Login")
        self.makeRootController(controller: controller)

    }



    static func makeHomeRootController(){

        let controller = storyboardHome.instantiateViewController(withIdentifier: "TBC_Main")
//        let controller = storyboardHome.instantiateViewController(withIdentifier: "VC_Home")

        self.makeRootController(controller: controller)
    }

    static func makeSplashRootController(){

        //        let controller = storyboardHome.instantiateViewController(identifier: "TBC_Home")
        let controller = storyboardSplash.instantiateViewController(withIdentifier: "VC_Splash")
        self.makeRootController(controller: controller)
    }

    static func makeRegisterRootController(){

        let controller = storyboardRegister.instantiateViewController(withIdentifier: "VC_Register")
        self.makeRootController(controller: controller)

    }

    static func navigateToLoginRootController(toastMessage: String){
        let controller = storyboardSignIn.instantiateViewController(withIdentifier: "VC_Login")

        let navc = UINavigationController(rootViewController: controller)

        navc.navigationBar.isHidden = true
        navc.showToast(message: toastMessage, font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))

        UIApplication.shared.windows.first?.rootViewController = navc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    static func navigateToHomeRootController(toastMessage: String){
        let controller = storyboardHome.instantiateViewController(withIdentifier: "TBC_Main")

        let navc = UINavigationController(rootViewController: controller)

        navc.navigationBar.isHidden = true
        navc.showToast(message: toastMessage, font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))

        UIApplication.shared.windows.first?.rootViewController = navc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    static func goShopOrder() {
        let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
        vc.cartType = Cart.store
        vc.fromHome = false
        let nav = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        nav.pushViewController(vc, animated: true)
    }

    static func goRestaurantOrder() {
        let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
        vc.cartType = Cart.restaurant
        vc.fromHome = false
        let nav = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        nav.pushViewController(vc, animated: true)
    }

    static func goShopOrderDetail(slug: String) {
        let vc : VC_Store_MyOrders_Detail = storyboardMyOrders.instantiateViewController(withIdentifier: "VC_Store_MyOrders_Detail") as! VC_Store_MyOrders_Detail
        vc.productSlug = slug
        let nav = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        nav.pushViewController(vc, animated: true)
    }

    static func goRestaurantOrderDetail(slug: String) {
        let vc = storyboardMyOrders.instantiateViewController(withIdentifier: "VC_Store_MyOrders_Detail") as! VC_Store_MyOrders_Detail
        vc.restaurantSlug = slug
        vc.isProductOrder = false
        vc.isfromNotification = true
        let nav = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        nav.pushViewController(vc, animated: true)
    }
    
    static func goProductDetail(slug: String) {
        let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.slug = slug
        let nav = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        nav.pushViewController(vc, animated: true)

    }
    
    static func goRestaurantDetail(slug: String) {
        let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.slug = slug
        let nav = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        nav.pushViewController(vc, animated: true)

    }
    
    static func goShopDetail(slug: String) {
        let vc : ShopViewController = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as! ShopViewController
        vc.shopSlug = slug
        let nav = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
        nav.pushViewController(vc, animated: true)

    }

    static func makeOrderRootController(cartType: Cart){

        let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
        if cartType == Cart.restaurant {
            vc.cartType = Cart.restaurant
            vc.isFromStore = false
        }
        else {
            vc.cartType = Cart.store
            vc.isFromStore = true
        }
        vc.fromHome = false
        self.makeRootController(controller: vc)

    }

    static func createFirebaseToken(fcmToken: String){
        let controller = storyboardHome.instantiateViewController(withIdentifier: "VC_Home")
        let param : [String:Any] = ["token" : fcmToken]

        print("fcm token = ", fcmToken)
        APIUtils.APICall(postName: APIEndPoint.createToken.caseValue, method: .post,  parameters: param, controller: controller, onSuccess: { (response) in
            print("create token = ", response)
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int

        }) { (reason, statusCode) in
        }
    }

    static func makeRootController(controller:UIViewController){

        let navc = UINavigationController(rootViewController: controller)

        navc.navigationBar.isHidden = true

        UIApplication.shared.windows.first?.rootViewController = navc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if key != UD_Language{
                defaults.removeObject(forKey: key)
            }

        }

        //LanguageManager.shared.currentLanguage = .en
        LanguageManager.shared.defaultLanguage = .en
        LanguageManager.shared.setLanguage(language: Languages.en)
    }

    static func getStoreBillingPricingCartproducts(cartItems:[CartProduct_]) -> (deliveryCharge:Double, tax:Double, price:Double ,subTotal:Double, grandTotal:Double){

        var price : Double = 0
        var tax : Double = 0
        var subTotal : Double = 0
        var delivery : Double = 0
        var qty : Int = 0
        var grandTotal : Double = 0

        for cartItem in cartItems{

            qty =  cartItem.qty ?? 0
            let temp = (Double(cartItem.price ?? "") ?? 0) * Double(qty)
            price += temp
            print("price test \(price)")
            tax += Double(cartItem.tax ?? "") ?? 0
            subTotal += Double(cartItem.subtotal ?? "") ?? 0
            delivery += Double(cartItem.deliveryCharge ?? "") ?? 0
        }

        grandTotal = subTotal + tax + delivery

        return (delivery, tax, price, subTotal, grandTotal)

    }

    static func getAddressFromLatLng(lat:Double,long:Double,onSuccess success: @escaping (_ address: Address_) -> Void)  {

        let sing = Singleton.shareInstance

        var address = Address_(id: 0, title: "", address1: "", address2: "", city: "", state: "", country: "", zipcode: "", latitude: "\(sing.userCurrentCoordinates.latitude)", longitude: "\(sing.userCurrentCoordinates.longitude)", isPrimary: false)


        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if placeMark == nil {
                return
            }
//            if let postalAddress = placeMark.postalAddress as? String {
//                address.postalAddress = postalAddress
//            }
            if let country = placeMark.postalAddress?.country as? String {
                sing.country = country
                address.country = country

                if let city = placeMark.postalAddress?.city as? String {
                    sing.city = city
                    address.city = city

                    if let state = placeMark.postalAddress?.state as? String{
                        sing.state = state
                        address.state = state

                        if let street = placeMark?.postalAddress?.street as? String {
                            sing.street = street
                            address.address1 = street
                            let str = street
                            let streetNumber = str.components(
                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")

                            sing.streetNumber = street

                            if let zip = placeMark.postalAddress?.postalCode as? String{
                                sing.zip = zip
                                address.zipcode = zip

                                if let locationName = placeMark?.postalAddress as? String {
                                    print("Location Name :- \(locationName)")
                                    sing.locationName = locationName
                                    address.title = locationName
                                    // Street address
                                    if let thoroughfare = placeMark?.thoroughfare as? NSString {
                                        print("Thoroughfare :- \(thoroughfare)")
                                        sing.currentAddress = thoroughfare as String

                                    }
                                }
                            }
                        }
                    }
                }
            }

            success(address)
        })
    }

    static func getFormattedAddress(address:Address) -> String{
        var strAdrress = String()

        //        if address.address1 != "" {
        //            strAdrress = address.address1 ?? ""
        //        }
        //        if address.address2 != "" {
        //            strAdrress = strAdrress + ", \(address.address2 ?? "")"
        //        }
        //        if address. != ""{
        //            strAdrress = strAdrress + ", \(address.city ?? "")"
        //        }
        //        if address.state != "" {
        //                   strAdrress = strAdrress + ", \(address.state ?? "")"
        //        }
        //        if address.country != "" {
        //            strAdrress = strAdrress + ", \(address.country ?? "")"
        //        }
        //        if address.zipcode != "" {
        //                   strAdrress = strAdrress + ", \(address.zipcode ?? "")"
        //        }
        if address.house_number != nil {
            strAdrress = "\(address.house_number ?? ""), "
        }

        strAdrress = "\(strAdrress)\(Singleton.shareInstance.floors[address.floor ?? 0].name), \(address.street_name ?? "")"
        return strAdrress
    }


    static func getDateFrom(timeStampInString:String, format:String) -> String{

        var dateString = ""
        guard let timeStamp = Double(timeStampInString) else { return "" }

        let formatter = DateFormatter()
        formatter.dateFormat = format
        let exactDate = NSDate.init(timeIntervalSince1970: timeStamp)
        dateString = formatter.string(from: exactDate as Date)
        return dateString
    }

    static func getDateFrom(timeStampInString:String) -> Date{

        let timeStamp = Double(timeStampInString) ?? 0
        return NSDate.init(timeIntervalSince1970: timeStamp) as Date
    }

    static func configureTopViewPosition(heightConstraint:NSLayoutConstraint, bottomConstraint:NSLayoutConstraint){
        heightConstraint.constant = 70
        bottomConstraint.constant = 8
        if DeviceUtils.isDeviceIphoneXOrlatter(){
            heightConstraint.constant = 90
            bottomConstraint.constant = 8
        }
    }

    static func configureTopViewPosition(heightConstraint:NSLayoutConstraint){
        heightConstraint.constant = 70

        if DeviceUtils.isDeviceIphoneXOrlatter(){
            heightConstraint.constant = 90
        }
    }


    static func getAttributedStringApplyVerticalLineSpacing(spacing:Int, string:String) -> NSAttributedString{

        let attributedString = NSMutableAttributedString(string: string)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        return attributedString
    }
}

class APIUtils {

    static func prepareModalFromData(_ data: Any, apiName : String, modelName:String, onSuccess success: @escaping (_ JSON: Any) -> Void, onFailure failure: @escaping (_ error: Error?, _ reason: String) -> Void) {

        if data is NSDictionary{

            let dict = data as! NSDictionary
            if let JSONData = try?  JSONSerialization.data(
                withJSONObject: dict,
                options: .prettyPrinted
            )
            {
                do {
                    if apiName == APIEndPoint.product.caseValue {
                        if modelName == "ProductDetails"{
                            let modalData = try Product(data: JSONData)
                            success(modalData)
                        }
                    }
                    else if apiName == APIEndPoint.stores.caseValue{
                        if modelName == "AllProduct" {
                            let modalData = try ShopProduct(data: JSONData)
                            success(modalData)
                        }
                    }

                    else if apiName == APIEndPoint.appVersion.caseValue{
                        let modalData = try AppVersionData(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.brands.caseValue {
                        let modalData  = try Brand(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.cart.caseValue{
                        let modalData = try CartData(data: JSONData)
                        success(modalData)
                    }

                    else if apiName == APIEndPoint.restaurantMenuCart.caseValue {
                        let modalData = try RestaurantCart(data: JSONData)
                        success(modalData)
                    }

                    else if apiName == APIEndPoint.productCart.caseValue {
                        let modalData = try ShopCart(data: JSONData)
                        success(modalData)
                    }

                    else if apiName == APIEndPoint.Address.caseValue{
                        let modalData = try Address(data: JSONData)
                        success(modalData)
                    }

                    else if apiName == APIEndPoint.nearestAddress.caseValue{
                        let modalData = try Address(data: JSONData)
                        success(modalData)
                    }

                    else if apiName == APIEndPoint.getAddresses.caseValue{
                        let modalData = try Address_(data: JSONData)
                        success(modalData)
                    }

                    else if apiName == APIEndPoint.orderDetails.caseValue{
                        if modelName == "RateOrder"{
                            let modalData = try RateOrder(data: JSONData)
                            success(modalData)
                        }

                    }
                    else if apiName == APIEndPoint.homeSuggestions.caseValue{
                        let modalData = try HomeData(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.newArrival.caseValue{
                        let modalData = try HomeData(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.homeSearch.caseValue{
                        let modalData = try HomeData(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.favouriteProductList.caseValue {
                        let modalData = try Favourites(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.favouriteRestaurantList.caseValue {
                        let modalData  = try Favourites(data: JSONData)
                        success(modalData)
                    }


                    else if apiName == APIEndPoint.userProfile.caseValue {
                        if modelName == "ProfileData" {
                            let modalData = try Profile(data: JSONData)
                            success(modalData)
                        } else if modelName == "Address"{
                            let modalData = try Address(data: JSONData)
                            success(modalData)
                        }
                    }

                    else if apiName == APIEndPoint.getCartItemsStore.caseValue{
                        let modalData = try StoreCart(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.getRestaurantsSliders.caseValue{
                        let modalData = try RestroSlider(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.restaurants.caseValue{
                        let modalData = try RestaurantBranch(data: JSONData)
                        success(modalData)
                    }
                    else if apiName == APIEndPoint.cartPathRestro.caseValue{
                        if modelName == "RestroCart"{
                            let modalData = try RestroCart(data: JSONData)
                            success(modalData)
                        }

                    }
                    // rate food order
                    else if apiName == APIEndPoint.rate.caseValue{
                        if modelName == "FoodOrderRate"{
                            let modalData = try FoodOrderRate(data: JSONData)
                            success(modalData)
                        }

                    }
                    //SearchProducts
                    else if apiName == APIEndPoint.productSearchStore.caseValue {
                        if modelName == "SearchProducts"{
                            let modalData = try SearchProduct(data: JSONData)
                            success(modalData)
                        }

                    }
                    else if apiName == APIEndPoint.productByCategory.caseValue {
                        if modelName == "SearchProducts"{
                            let modalData = try SearchProduct(data: JSONData)
                            success(modalData)
                        }

                    }


                    else if apiName == APIEndPoint.product.caseValue {
                        if modelName == "BuyNow" {
                            let modalData = try BuyNow(data: JSONData)
                            success(modalData)
                        }
                    }
                    //category product
                    else if apiName == APIEndPoint.productCategory.caseValue {
                        if modelName == "SearchProducts"{
                            let modalData = try SearchProducts(data: JSONData)
                            success(modalData)
                        }

                    }
                    else if apiName == APIEndPoint.categories.caseValue{
                        if modelName == "myCategoryData" {
                            let modalData = try MyCategoryData(data: JSONData)
                            success(modalData)
                        }
                    }

                    //Search Restro
                    else if apiName == APIEndPoint.searchRestaurant.caseValue{
                        if modelName == "SearchRestro"{
                            let modalData = try SearchRestaurant(data: JSONData)
                            success(modalData)
                        }
                    }
                    //My order data
                    else if apiName == APIEndPoint.foodOrder.caseValue{
                        if modelName == "MyOrderData"{
                            let modalData = try RestaurantOrderModel(data: JSONData)
                            success(modalData)
                        }
                        if modelName == "RestroOrderDetails"{
                            let modalData = try RestaurantOrder(data: JSONData)
                            success(modalData)
                        }
                    }
                    else if apiName == APIEndPoint.shopOrder.caseValue{
                        if modelName == "ShopOrder"{
                            let modalData = try Order(data: JSONData)
                            success(modalData)
                        }
                        if modelName == "MyOrderData"{
                            let modalData = try ProductOrderModel(data: JSONData)
                            success(modalData)
                        }

                    }

                    else if apiName == APIEndPoint.trackOrder.caseValue{
                        if modelName == "TrackOrder"{
                            let modalData = try TrackOrder(data: JSONData)
                            success(modalData)
                        }
                    }
                    else if apiName == APIEndPoint.trackOrderStore.caseValue{
                        if modelName == "TrackStoreOrderData"{
                            let modalData = try TrackStoreOrderData(data: JSONData)
                            success(modalData)
                        }
                    }
                    else if apiName == APIEndPoint.applyPromoCode.caseValue{
                        if modelName == "PromoCode"{
                            let modalData = try PromoCode(data: JSONData)
                            success(modalData)
                        }
                    }
                    else if apiName == APIEndPoint.shopCategories.caseValue {
                        if modelName == "ShopCategory" {
                            let modalData = try ShopCategory(data: JSONData)
                            success(modalData)
                        }
                    }
                    else if apiName == APIEndPoint.shops.caseValue{
                        if modelName == "Shop"{
                            let modalData = try Shop(data: JSONData)
                            success(modalData)
                        }
                    }

                    else if apiName == APIEndPoint.notificationData.caseValue {
                        if modelName == "NotificationData" {
                            let modalData = try NotificationData(data: JSONData)
                            success(modalData)
                        }
                    }
                    else if apiName == APIEndPoint.check_in.caseValue {
                        if modelName == "DailyCheckIn" {
                            let modelData = try DailyCheckIn(data: JSONData)
                            success(modelData)
                        }
                    }
                    else if apiName == APIEndPoint.rewards.caseValue {
                        if modelName == "Rewards" {
                            let modelData = try Rewards(data: JSONData)
                            success(modelData)
                        }
                    }
                    else if apiName == APIEndPoint.serviceAnnouncement.caseValue {
                        if modelName == "ServiceAnnouncement" {
                            let modelData = try ServiceAnnouncement(data: JSONData)
                            success(modelData)
                        }
                    }

                    else if apiName == APIEndPoint.shopAllSearch.caseValue{
                        if modelName == "Shop"{
                            let modelData = try Shop(data: JSONData)
                            success(modelData)
                        }
                    }

                    else if apiName == APIEndPoint.userSetting.caseValue{
                        if modelName == "UserSetting" {
                            let modelData = try UserSetting(data: JSONData)
                            success(modelData)
                        }
                    }
                    
                    else if apiName == APIEndPoint.restaurantsDetail.caseValue{
                        let modalData = try RestaurantBranch(data: JSONData)
                        success(modalData)
                    }
                    
                    else{
                        print("\(apiName) not matched")
                    }


                }catch let error as NSError {
                    // error
                    print("error \(error)")
                    failure(error, apiName)
                }
            }

        }
        else if data is NSArray{

            let decoder = JSONDecoder()
            let array = data as! NSArray
            var modalArray = [Any]()
            for item in array{

                let vac = item as! NSDictionary

                if let JSONData = try?  JSONSerialization.data(
                    withJSONObject: vac,
                    options: .prettyPrinted
                ){
                    do {
                        if (apiName == APIEndPoint.homeSuggestions.caseValue) || (apiName == APIEndPoint.newArrival.caseValue) || (apiName == APIEndPoint.productSearchStore.caseValue) || (apiName == APIEndPoint.productCategory.caseValue) || (apiName == APIEndPoint.product.caseValue) ||  (apiName.contains(APIEndPoint.shops.caseValue)) || (apiName.contains(APIEndPoint.brands.caseValue)) ||
                            (apiName == APIEndPoint.shopSubcategory.caseValue) || (apiName == APIEndPoint.restaurantsRecommendations.caseValue) || (apiName == APIEndPoint.restaurants.caseValue) || (apiName == APIEndPoint.searchHistory.caseValue) {

                            if modelName == "Product" && (apiName.contains(APIEndPoint.moreFromThisShop.caseValue) && apiName.contains("products")) {
                                let modalData = try Product(data: JSONData)
                                modalArray.append(modalData)
                            }else if modelName == "Product"{
                                let modalData = try Product(data: JSONData)
                                modalArray.append(modalData)
                            }else if modelName == "Restaurants"{
                                let modalData = try Restaurant_(data: JSONData)
                                modalArray.append(modalData)
                            } else if apiName == APIEndPoint.searchHistory.caseValue {
                                let modelData = try SearchHistory(data: JSONData)
                                success(modelData)
                            }
                            else if apiName.contains(APIEndPoint.shops.caseValue) {
                                let modalData  = try Shop(data: JSONData)
                                success(modalData)
                            }
                            else if apiName.contains(APIEndPoint.brands.caseValue) {

                                let modalData  = try Brand(data: JSONData)
                                success(modalData)
                            }
                            else if apiName == APIEndPoint.shopSubcategory.caseValue {
                                let modalData  = try Product(data: JSONData)
                                success(modalData)
                            }

                        }

                        else if apiName == APIEndPoint.recommendProduct.caseValue {
                            if modelName == "Product"{
                                let modalData = try Product(data: JSONData)
                                success(modalData)
                            }

                        }

                        else if apiName == APIEndPoint.getCartItemsStore.caseValue{
                            if modelName == "Product"{
                                let modalData = try ProductTemp(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }


                        else if apiName == APIEndPoint.moreFromThisShop.caseValue {
                            let modalData  = try Product(data: JSONData)
                            success(modalData)
                        }

                        else if apiName == APIEndPoint.favouriteRestaurantList.caseValue {
                            let modalData  = try RestaurantBranch(data: JSONData)
                            success(modalData)
                        }

                        else if apiName == APIEndPoint.favouriteProductList.caseValue {
                            let modalData  = try Product(data: JSONData)
                            success(modalData)
                        }



                        if apiName == APIEndPoint.home_banner_sliders.caseValue{
                            let modalData = try Banner(data: JSONData)
                            success(modalData)
                        }
                        else if apiName == APIEndPoint.home_banner_popup.caseValue{
                            let modalData = try PopupModel(data: JSONData)
                            success(modalData)
                        }

                        else if apiName == APIEndPoint.restaurantsRecommendations.caseValue {
                            let modalData = try RestaurantBranch(data: JSONData)
                            success(modalData)
                        }

                        else if apiName == APIEndPoint.restaurants.caseValue {
                            let modalData = try RestaurantBranch(data: JSONData)
                            success(modalData)
                        }
                        else if apiName == APIEndPoint.announcements.caseValue {
                            let modalData = try Announcement(data: JSONData)
                            success(modalData)
                        }
                        else if apiName == APIEndPoint.promotions.caseValue {
                            let modalData = try Promotion(data: JSONData)
                            success(modalData)
                        }
                        else if apiName == APIEndPoint.product.caseValue{
                            if modelName == "Product"{
                                let modalData = try Banner(data: JSONData)
                                success(modalData)
                            }
                            else if modelName == "ShopProduct"{
                                let modalData = try Product(data: JSONData)
                                success(modalData)
                            }
                        }
                        else if apiName == APIEndPoint.townships.caseValue{
                            let modalData = try Township(data: JSONData)
                            modalArray.append(modalData)
                        }
                        else if apiName == APIEndPoint.cities.caseValue{
                            let modalData = try City(data: JSONData)
                            modalArray.append(modalData)
                        }
                        else if apiName == APIEndPoint.shopCategories.caseValue{
                            let modalData = try ShopCategory(data: JSONData)
                            modalArray.append(modalData)
                        }
                        else if apiName == APIEndPoint.categoryList.caseValue {
                            let modelData = try ShopCategoryMenu(data: JSONData)
                            modalArray.append(modelData)
                        }
                        else if apiName == APIEndPoint.categorizedProduct.caseValue{
                            print("bind herreee")
                            let modalData = try CategorizedProduct(data: JSONData)
                            modalArray.append(modalData)

                        }
                        else if apiName == APIEndPoint.rating.caseValue{

                            if modelName == "Review"{
                                let modalData = try Review(data: JSONData)
                                modalArray.append(modalData)
                            }

                        }
                        else if apiName == APIEndPoint.getCartItemsStore.caseValue{
                            if modelName == "Product"{
                                let modalData = try ProductTemp(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }


                        else if apiName == APIEndPoint.getAllAddresses.caseValue{
                            if modelName == "Address"{
                                let modalData = try Address(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }
                        else if apiName == APIEndPoint.productsPath.caseValue{
                            if modelName == "Product"{
                                let modalData = try ProductTemp(data: JSONData)
                                modalArray.append(modalData)
                            }

                        }

                        else if apiName == APIEndPoint.getRestaurantsCategorywise.caseValue{
                            if modelName == "CategorizedRestaurant"{
                                let modalData = try CategorizedRestaurant_(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }
                        else if apiName.contains(APIEndPoint.brands.caseValue) {
                            if modelName == "ShopCategory"{
                                let modalData = try ShopCategory(data: JSONData)
                                success(modalData)
                            }
                            if modelName == "Shop"{
                                let modalData = try Shop(data: JSONData)
                                modalArray.append(modalData)
                            }
                            if modelName == "Product" {
                                let modalData = try Product(data: JSONData)
                                success(modalData)
                            }
                        }
                        else if apiName == APIEndPoint.restaurants.caseValue{
                            if modelName == "RestaurantCategoriesedItem"{
                                let modalData = try RestaurantCategoriesedItem(data: JSONData)
                                modalArray.append(modalData)
                            } else if modelName == "RestaurantList"{
                                let modalData = try RestaurantBranch(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }
                        else if apiName ==  APIEndPoint.supports.caseValue {
                            if modelName == "SupportElement"{
                                let modalData = try Supports(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }

                        else if apiName == APIEndPoint.shopAllSearch.caseValue{
                            if modelName == "Shop"{
                                let modalData = try Shop(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }
                        else if apiName == APIEndPoint.userSetting.caseValue{
                            if modelName == "UserSetting"{
                                let modalData = try UserSetting(data: JSONData)
                                modalArray.append(modalData)
                            }
                        }
                        
                        else if apiName == APIEndPoint.restaurantsDetail.caseValue {
                            let modalData = try RestaurantBranch(data: JSONData)
                            success(modalData)
                        }
                        
                        else{
                            print("array \(apiName) not matched")
                        }

                    }catch let error as NSError {
                        // error
                        print("error \(error)")
                        failure(error, apiName)
                    }
                
                }

            }

            if !modalArray.isEmpty{
                success(modalArray)
            }
        }
    }

    static func APICall(postName:String, method: HTTPMethod, parameters:[String:Any], controller:UIViewController? = nil, onSuccess success: @escaping (_ JSON: Any) -> Void, onFailure failure: @escaping (_ reason: String, _ statusCode:Int) -> Void) {

        if !NetworkUtils.isNetworkReachable(){
            failure(no_internet_connection_available, 0)
            controller?.presentAlert(title: attentionText, message: no_internet_connection_available)
        }

        print("BASEURL ", BASEURL)

        if ((
              postName == APIEndPoint.cart.caseValue
             || postName == APIEndPoint.restaurantCheckout.caseValue) && method == HTTPMethod.post)
            || postName.contains( APIEndPoint.restaurantCart.caseValue)
            || postName.contains(APIEndPoint.restaurantMenuCart.caseValue)
            || (postName.contains("\(APIEndPoint.restaurants.caseValue)?lat=") && method == HTTPMethod.get && !postName.contains("/favorites") && !postName.contains("/recommendations"))
            || postName.contains(APIEndPoint.foodOrder.caseValue)
            || postName.contains(APIEndPoint.shopOrder.caseValue)
            || postName == APIEndPoint.appVersion.caseValue
            || postName == APIEndPoint.brands.caseValue
            || postName.contains(APIEndPoint.brands.caseValue)
            || postName.contains(APIEndPoint.getMenu.caseValue)
            || postName.contains(APIEndPoint.categoryList.caseValue)
            || postName.contains(APIEndPoint.shopSubcategory.caseValue)
            || postName.contains(APIEndPoint.searchRestaurant.caseValue)
            || postName.contains(APIEndPoint.getMenu.caseValue)
            || postName == APIEndPoint.shops.caseValue
            || (postName.contains(APIEndPoint.shops.caseValue) && postName.contains(APIEndPoint.categories.caseValue) && !postName.contains (APIEndPoint.shopCategories.caseValue))
            || postName.contains(APIEndPoint.productNewArrival.caseValue)
            || postName.contains(APIEndPoint.productDiscount.caseValue)
            || postName.contains("/restaurants/branches?filter=")
            || postName.contains(APIEndPoint.getMenu.caseValue)
            || postName.contains(APIEndPoint.searchHistory.caseValue)
            || postName.contains("\(APIEndPoint.clearHistory.caseValue)")
           // || postName.contains("\(APIEndPoint.product.caseValue)?filter=")
            || postName.contains("\(APIEndPoint.favouriteRestaurantList.caseValue)")
            || postName == APIEndPoint.validatePromo.caseValue
            || postName.contains(APIEndPoint.productCart.caseValue)
            || postName == APIEndPoint.productCheckout.caseValue
            || postName == APIEndPoint.productPromo.caseValue
            || postName == APIEndPoint.shopOrder.caseValue
            || postName == APIEndPoint.restaurantsRecommendations.caseValue
            || postName == APIEndPoint.checkCredit.caseValue
            || postName == APIEndPoint.serviceAnnouncement.caseValue
            || postName.contains(APIEndPoint.recommendProduct.caseValue)
            || (postName.contains(APIEndPoint.moreFromThisShop.caseValue) && postName.contains("/products"))
            || postName == APIEndPoint.createToken.caseValue
            || postName.contains(APIEndPoint.foodOrder.caseValue)

            || postName.contains(APIEndPoint.shopAllSearch.caseValue)

            || postName.contains(APIEndPoint.userSetting.caseValue)

        {
            print("v2 to v3")
            BASEURL = BASEURL.replacingOccurrences(of: "v2", with: "v3").replacingOccurrences(of: "v4", with: "v3")
        }
        else if postName.contains("\(APIEndPoint.product.caseValue)?search=") || postName.contains("\(APIEndPoint.product.caseValue)")  {
            BASEURL = BASEURL.replacingOccurrences(of: "v2", with: "v4").replacingOccurrences(of: "v3", with: "v4")
        }
    
        else {
            print("v3 to v2")
            BASEURL = BASEURL.replacingOccurrences(of: "v3", with: "v2").replacingOccurrences(of: "v4", with: "v2")
        }
        let urlStr = "\(BASEURL)\(postName)"
        print("urlStr = " , urlStr)
        if let  encodedURL = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedURL) {

            print("url = " , url)

            var headers = HTTPHeaders([ "content-type": "application/json",
                                        "Accept":"application/json"])

            if DEFAULTS.value(forKey: UD_APITOKEN) != nil {
                let token = "Bearer " + "\(UserDefaults.standard.value(forKey: UD_APITOKEN) as? String ?? "")"
                headers.add(name: "Authorization", value: token)
            }

            print("headers token == " , UserDefaults.standard.value(forKey: UD_APITOKEN))

            if postName == APIEndPoint.logout.caseValue {
                let deviceId =  UIDevice.current.identifierForVendor?.uuidString
                headers.add(name: "deviceid", value: deviceId ?? "")
            }
            else if postName.contains("\(APIEndPoint.home_banner_sliders.caseValue)") || postName.contains("\(APIEndPoint.home_banner_popup.caseValue)") {
                headers.add(name: "X-APP-TYPE", value: "ios")
                headers.add(name: "X-APP-VERSION", value: "2.6.2")
            }


            debugPrint("headers \(headers)")

            if method == HTTPMethod.get {

                AF.request(url, method:method, /*parameters: parameters,*/ encoding: JSONEncoding.default, headers: headers).responseJSON { response in

                    switch(response.result) {

                    case .success(_):
                        if let data = response.value
                        {
                            let statusCode = response.response?.statusCode ?? 0

                            print("status code === ", postName , statusCode)

                            DispatchQueue.main.async {
                                success(data)
                            }

                        }
                        break
                    case .failure(_):


                        if response.error != nil
                        {
                            let statusCode = response.response?.statusCode ?? 0
                            failure(serverError, statusCode)
                        }
                        break
                    }
                }
            }

            if method == HTTPMethod.delete{

                AF.request(url, method:method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    switch(response.result) {

                    case .success(_):
                        if let data = response.value
                        {
                            let statusCode = response.response?.statusCode ?? 0
                            if statusCode == 401{

                                //Handel session expired work
//                                APIUtils.handelSessionExpired(data: data, controller: controller!)
                                failure(sessionExpiredText, statusCode)

                            }else{
                                DispatchQueue.main.async {
                                    success(data)
                                }
                            }

                        }
                        break
                    case .failure(let error):

                        if let data = response.error
                        {
                            print(response.value as Any)
                            let statusCode = response.response?.statusCode ?? 0
                            failure(serverError, statusCode)
                        }
                        break
                    }
                }
            }

            else{
                AF.request(url, method:method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

                    print("Response ====== \(url) ", response)

                    switch(response.result) {

                    case .success(_):
                        if let data = response.value
                        {
                            //print(response.value as Any)
                            let statusCode = response.response?.statusCode ?? 0
                            print("status code = " , statusCode)
                            if statusCode == 401{
                                if postName == APIEndPoint.login.caseValue {
//                                    APIUtils.warningShow(data: data, controller: controller!)
                                    failure(sessionExpiredText, statusCode)
                                }
                                else if postName.contains(APIEndPoint.productCart.caseValue) || postName.contains( APIEndPoint.restaurantMenuCart.caseValue) {
                                    print("adddreesssssss !!!!")
                                    controller?.showNeedToLoginApp()
//                                    APIUtils.warningShow(data: data, controller: controller!)
//                                    failure(loginMessageText, statusCode)
                                }

                            }
                            else{
                                DispatchQueue.main.async {
                                    success(data)
                                }
                            }
                        }
                        break
                    case .failure(_):
                        if postName == APIEndPoint.cart.caseValue {
                            controller?.showNeedToLoginApp()
                        }

                        if response.error != nil
                        {
                            let statusCode = response.response?.statusCode ?? 0
                            failure(serverError, statusCode)
                        }
                        break
                    }
                }
            }
        }

        else {
            print("invalid url ")
        }

    }

    static func APICallWithImageUpload(imageData:Data, postName:String, method: HTTPMethod, parameters:[String:Any], controller:UIViewController, onSuccess success: @escaping (_ JSON: Any) -> Void, onFailure failure: @escaping (_ reason: String, _ statusCode:Int) -> Void){

        if !NetworkUtils.isNetworkReachable(){
            failure(no_internet_connection_available, 0)
            controller.presentAlert(title: attentionText, message: no_internet_connection_available)
        }

        let url = URL(string:BASEURL+postName)

        var urlRequest = URLRequest(url: (url?.appendingPathComponent(BASEURL+postName))!)
        urlRequest.httpMethod = "post"


        //For file upload make send content-type  multipart
        let headers = HTTPHeaders([ "content-type": "multipart/form-data",
                                    "Authorization": "Bearer " + "\(UserDefaults.standard.value(forKey: UD_APITOKEN) as? String ?? "")",
                                    "Accept":"application/json"])
        print("url \(url?.absoluteString ?? "")")

        AF.upload(multipartFormData: { multiPart in
            for (key, value) in parameters {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(imageData, withName: "profile_pic", fileName: "profile_pic.png", mimeType: "image/png")
        }, to: url!, method: method, headers: headers)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")

            if Int(progress.fractionCompleted) == 100{
            }
        })
        .responseJSON(completionHandler: { response in
            //Do what ever you want to do with response
            switch(response.result) {

            case .success(_):
                if let data = response.value
                {
                    print(response.value as Any)
                    let statusCode = response.response?.statusCode ?? 0
                    if statusCode == 401{
                        //Handel session expired work
                        APIUtils.handelSessionExpired(data: data, controller: controller)
                        failure(sessionExpiredText, statusCode)
                    }else{
                        DispatchQueue.main.async {
                            success(data)
                        }
                    }
                }
                break
            case .failure(_):
                if let data = response.error
                {
                    print(response.value as Any)
                    let statusCode = response.response?.statusCode ?? 0
                    failure(serverError, statusCode)
                }
                break
            }

        })



    }

    static func handelSessionExpired(data:Any, controller:UIViewController){

        var displayMessage = serverError
        if let message = data as? NSDictionary{
            displayMessage = message.value(forKey: key_message) as? String ?? serverError
        }

        controller.presentAlertWithTitle(title: sessionExpiredText, message: displayMessage, options: logoutText) { (option) in

            switch(option) {
            case 0:
                //Util.resetDefaults()
                DEFAULTS.set(false, forKey: UD_isUserLogin)
                UserDefaults.standard.removeObject(forKey: UD_APITOKEN)
                Util.makeSignInRootController()
                break
            default:
                break
            }
        }
    }

    static func warningShow(data:Any, controller:UIViewController){

        var displayMessage = serverError
        if let message = data as? NSDictionary{
            displayMessage = message.value(forKey: key_message) as? String ?? serverError
        }

        controller.presentAlertWithTitle(title: errorText, message: displayMessage, options: okayText) { (option) in

            switch(option) {
            case 0:
                //Util.resetDefaults()
                DEFAULTS.set(false, forKey: UD_isUserLogin)
                UserDefaults.standard.removeObject(forKey: UD_APITOKEN)
//                Util.makeSignInRootController()
                break
            default:
                break
            }
        }
    }


    static func updatePushToken(){

        if let playerId = DEFAULTS.value(forKey: keyPlayerId) as? String, let deviceId = UIDevice.current.identifierForVendor?.uuidString{
            let param = ["player_id":playerId,
                         "device_id":deviceId,
                         "device_type":"ios"]

            APIUtils.APICall(postName: "\(APIEndPoint.updatePushToken.caseValue)", method: .post, parameters: param, controller: UIViewController(), onSuccess: { (response) in
                print("response ppp ", response)
                let data = response as! NSDictionary
                let status = data[key_status] as? Bool ?? false

                if status{

                }else{

                    let message = data[key_message] as? String ?? serverError
                    print("getting address error \(message)")
                }

            }) { (reason, statusCode) in

            }
        }
    }

}

class NetworkUtils{

    static func isNetworkReachable() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret
    }
}

class DeviceUtils{

    static func isDeviceIphoneXOrlatter() -> Bool{

        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return false

            case 1334:
                return false

            case 1920, 2208:
                return false

            case 2436:
                return true

            case 2688:
                return true

            case 1792:
                return true

            default:
                return false
            }
        }
        return false
    }
}


//MARK: Open Image Picker
class GalleryUtil{

    static func presentActionSheetImagePicker(viewController:UIViewController) {

        let alertController = UIAlertController(title: choose_your_option, message: nil, preferredStyle: .actionSheet)

        let takePhotoAction = UIAlertAction(title: open_camera, style: .default, handler: { action in
            // Open Camera method calling
            GalleryUtil.requestCameraPermissionsIfNeeded(viewController: viewController)
        })
        let chooseFromLibraryAction = UIAlertAction(title: open_photos, style: .default, handler: { action in
            //Open Library method calling
            GalleryUtil.requestLibraryPermissionsIfNeeded(viewController: viewController)

        })
        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: { action in

        })
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibraryAction)
        alertController.addAction(cancelAction)

        //V3.3 crash fix
        //if iPhone
        if UI_USER_INTERFACE_IDIOM() == .phone {
            viewController.present(alertController, animated: true)
        } else {
            // Change Rect to position Popover
            alertController.modalPresentationStyle = .popover
            let popPresenter = alertController.popoverPresentationController
            popPresenter?.sourceView = viewController.view
            popPresenter?.sourceRect = CGRect(x: viewController.view.center.x, y: viewController.view.center.y, width: 0, height: 0)
            viewController.present(alertController, animated: true)
        }
    }

    static func requestCameraPermissionsIfNeeded(viewController:UIViewController) {

        // check camera authorization status
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            GalleryUtil.openCamera(viewController: viewController)
        case .notDetermined:

            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                DispatchQueue.main.async(execute: {

                    if granted {
                        GalleryUtil.openCamera(viewController: viewController)
                    } else {
                        GalleryUtil.notifyUserOfCameraAccessDenial(viewController: viewController)
                    }
                })
            })
        case .restricted, .denied:
            DispatchQueue.main.async(execute: {
                GalleryUtil.notifyUserOfCameraAccessDenial(viewController: viewController)

            })
        default:
            break
        }
    }

    static func requestLibraryPermissionsIfNeeded(viewController:UIViewController) {
        weak var weakSelf = viewController
        let status = PHPhotoLibrary.authorizationStatus()

        if status == .authorized {
            GalleryUtil.openLibrary(viewController: weakSelf!)
        } else if status == .denied {
            GalleryUtil.notifyUserOfLibraryAccessDenial(viewController: weakSelf ?? UIViewController())
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ status in

                if status == .authorized {

                    GalleryUtil.openLibrary(viewController: weakSelf ?? UIViewController() )
                } else {
                    GalleryUtil.notifyUserOfLibraryAccessDenial(viewController: weakSelf ?? UIViewController())
                }
            })
        } else if status == .restricted {
            GalleryUtil.notifyUserOfLibraryAccessDenial(viewController: weakSelf ?? UIViewController())
        }
    }

    static func notifyUserOfCameraAccessDenial(viewController:UIViewController) {
        let accessDescription = Bundle.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") as? String
        let alertController = UIAlertController(title: accessDescription, message: denied_camera_permission_message, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let settingsAction = UIAlertAction(title: settingsText, style: .default, handler: { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        alertController.addAction(settingsAction)

        viewController.present(alertController, animated: true)


    }

    static func notifyUserOfLibraryAccessDenial(viewController:UIViewController) {
        let accessDescription = Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") as? String
        let alertController = UIAlertController(title: accessDescription, message: denied_gallery_permission_message, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        let settingsAction = UIAlertAction(title: settingsText, style: .default, handler: { action in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        alertController.addAction(settingsAction)

        viewController.present(alertController, animated: true, completion: nil)
    }

    static  func openCamera(viewController:UIViewController)  {

        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
            picker.allowsEditing = false
            picker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            viewController.present(picker, animated: true)
        }
        else
        {
            let alertController = UIAlertController(title: app_name, message: camera_not_available, preferredStyle: .alert)


            let okAction = UIAlertAction(title: okayText, style: .cancel, handler: { action in

            })

            alertController.addAction(okAction)
            if UI_USER_INTERFACE_IDIOM() == .phone {
                viewController.present(alertController, animated: true)
            } else {
                alertController.modalPresentationStyle = .popover
                let popPresenter = alertController.popoverPresentationController
                popPresenter?.sourceView = viewController.view
                popPresenter?.sourceRect = CGRect(x: viewController.view.center.x, y: viewController.view.center.y, width: 0, height: 0)
                viewController.present(alertController, animated: true)
            }
        }

    }

    static func openLibrary(viewController:UIViewController) {

        DispatchQueue.main.async {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            picker.allowsEditing = false
            viewController.present(picker, animated: true)
        }
    }

    static func openSettings(){

        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    static func calculateSizeInMB(image:UIImage) -> Double{

        let imageSize : Int = image.pngData()?.count ?? 0
        let imageSizeKB = Double(imageSize) / 1000.0
        let imageSizeMB = imageSizeKB / 1024.0
        return imageSizeMB
    }

    static func calculateDataSizeInMB(data:Data) -> Double{

        let dataSize : Int = data.count
        let imageSizeKB = Double(dataSize) / 1000.0
        let imageSizeMB = imageSizeKB / 1024.0
        return imageSizeMB
    }

    static func getCurrentViewController() -> UIViewController? {
        if let navigationController = getNavigationController() {
            return navigationController.visibleViewController
        }
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController

            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
    static func getNavigationController() -> UINavigationController? {
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
            return navigationController as? UINavigationController
        }
        return nil
    }

    static func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }

        return presentViewController
    }

}
