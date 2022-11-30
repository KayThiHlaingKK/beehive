//
//  APIRouter.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter : URLRequestConvertible{
    
    case login(request: LoginAuthentication)
    case getMyShopOrder(MyOrderRequest)
    case getMyFoodOrder(MyOrderRequest)
    case getUserCredit
    case getUserMenuDetail(menu_slug: String)
    case getItemByContent(ItemContentRequest)
    case getUserCity
    case getUserTownShip(citySlug: String)
    case createAddress(request: AddressRequest)
    case updateAddress(request: AddressRequest)
    case getOneAddress(addressSlug: String)
    case getAddress
    case shopUpdateAddress(request: UpdateAddressRequest)
    case foodUpdateAddress(request: UpdateAddressRequest)
    case getNearest(lat: Double,long: Double)
    case getUserSetting
    case getRestaurantCheckOut(request: ConfirmOrderRequest)
    case getShopCheckOut(request: ConfirmOrderRequest)
    case getViewCart
    case getAnnouncement
    case getUserProfile
    case updateUserProfile(request: UpdateUserProfile)
    case deleteAccount
    
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self{
        case .createAddress,.getRestaurantCheckOut,.getShopCheckOut,.getViewCart,.login:
            return .post
        case .updateAddress,.shopUpdateAddress,.foodUpdateAddress,.updateUserProfile:
            return .put
        case .deleteAccount:
            return .delete
        default:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/user/login"
        case .getMyShopOrder:
            return "/user/shop-orders"
        case .getMyFoodOrder:
            return "/user/restaurant-orders"
        case .getUserCredit:
            return "/user/credits"
        case .getUserMenuDetail(let menu_slug):
            return "/user/menus/\(menu_slug)"
        case .getItemByContent(let request):
            return "/announcements/\(request.slug)/items"
        case .getUserCity:
            return "/user/cities"
        case .getUserTownShip(let citySlug):
            return "/user/cities/\(citySlug)/townships"
        case .createAddress:
            return "/user/addresses"
        case .updateAddress(let request):
            return "/user/addresses/\(request.addressSlug)"
        case .getOneAddress(let addressSlug):
            return "/user/addresses/\(addressSlug)"
        case .getAddress:
            return "/user/addresses"
        case .shopUpdateAddress:
            return "/shops/carts/address"
        case .foodUpdateAddress:
            return "/restaurants/carts/address"
        case .getNearest:
            return "/user/addresses/nearest"
        case .getUserSetting:
            return "/user/settings"
        case .getRestaurantCheckOut:
            return "/restaurants/carts/checkout"
        case .getShopCheckOut:
            return "/shops/carts/checkout"
        case .getViewCart:
            return "/carts"
        case .getAnnouncement:
            return "/user/announcements"
        case .getUserProfile:
            return "/user/profile"
        case .updateUserProfile:
            return "/user/profile"
        case .deleteAccount:
            return "/user/account"
        }
    }
    
    // MARK: - Query
    private var queryItem: Parameters?{
        switch self {
        case .getMyShopOrder(let request),.getMyFoodOrder(let request):
           return ["size": request.size ,"page": request.page]
        case .getItemByContent(let request):
            return ["size": request.size ,"page": request.page]
        case .getNearest(let lat, let long) :
            return ["lat": lat, "lng": long]
        default:
            return nil
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self{
        case .login(let request):
            return [
                "phone_number": request.phoneNumber,
                "password": request.password
            ]
        case .createAddress(let request),.updateAddress(let request):
            return [
                "house_number": request.house_number,
                "street_name": request.street_name,
                "township_slug": request.township_slug,
                "floor": request.floor,
                "latitude": request.latitude,
                "longitude": request.longitude,
                "label": request.label
                ]
        case .shopUpdateAddress(let request):
            return [
                "customer_slug": request.customer_slug,
                "address": [
                    "house_number": request.house_number,
                    "floor": request.floor,
                    "street_name": request.street_name,
                    "latitude": request.latitude,
                    "longitude": request.longitude,
                    "township_slug": request.township_slug
                ]
            ]
        case .foodUpdateAddress(let request):
            return [
                "customer_slug": request.customer_slug,
                "address": [
                    "house_number": request.house_number,
                    "floor": request.floor,
                    "street_name": request.street_name,
                    "latitude": request.latitude,
                    "longitude": request.longitude
                ]
            ]
        case .getRestaurantCheckOut(let request):
            return [
                "order_date": request.order_date,
                "payment_mode": request.payment_mode,
                "order_type": request.order_type,
                "special_instruction": request.special_instruction,
                "source": request.source,
                "version": request.version,
                "customer_info": [
                    "customer_name": request.customer_name,
                    "phone_number": request.phone_number
                ],
                "address": [
                    "house_number": request.house_number,
                    "floor": request.floor,
                    "street_name": request.street_name,
                    "latitude": request.latitude,
                    "longitude": request.longitude
                ]
            ]
        case .getShopCheckOut(let request):
            return [
                "order_date": request.order_date,
                "payment_mode": request.payment_mode,
                "order_type": request.order_type,
                "special_instruction": request.special_instruction,
                "source": request.source,
                "version": request.version,
                "customer_info": [
                    "customer_name": request.customer_name,
                    "phone_number": request.phone_number
                ],
                "address": [
                    "house_number": request.house_number,
                    "floor": request.floor,
                    "street_name": request.street_name,
                    "latitude": request.latitude,
                    "longitude": request.longitude,
                    "township_slug": request.township_slug
                ]
            ]
        case .updateUserProfile(let request):
            return [
                "email": request.email,
                "name": request.name,
                "gender": request.gender,
                "date_of_birth": request.date_of_birth,
                "image_slug": request.image_slug
            ]
        case .getViewCart:
            return [
                "customer_slug": Singleton.shareInstance.userProfile?.slug ?? ""
            ]
        default:
            return nil
        }
    
    }
    
    
    func asURLRequest() throws -> URLRequest {
        #if STAGING
        var url = try NetworkEnvironment.ProductionServer.baseURLStage.asURL()
        switch self {
        case .getUserCity,.getUserTownShip,.createAddress,.updateAddress,.getOneAddress,.getAddress,.getNearest,.getAnnouncement,.login,.getUserProfile,.updateUserProfile,.deleteAccount:
            url = try NetworkEnvironment.ProductionServer.baseURLV4Stage.asURL()
        default:
            url = try NetworkEnvironment.ProductionServer.baseURLStage.asURL()
        }
        #else
        var url = try NetworkEnvironment.ProductionServer.baseURLProduction.asURL()
        switch self{
        case .getAnnouncement,.getUserCity,.getUserTownShip,.createAddress,.updateAddress,.getOneAddress,.getAddress,.getNearest,.login,.getUserProfile,.updateUserProfile,.deleteAccount:
           url = try NetworkEnvironment.ProductionServer.baseURLV4Production.asURL()
        default:
            url = try NetworkEnvironment.ProductionServer.baseURLProduction.asURL()
        }
        #endif
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        

        // Common Headers
        if DEFAULTS.value(forKey: UD_APITOKEN) != nil {
            let token = "Bearer " + "\(UserDefaults.standard.value(forKey: UD_APITOKEN) as? String ?? "")"
            urlRequest.setValue(token, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
        
        //QueryString
        if let queryItems = queryItem{
            do{
                urlRequest = try URLEncoding.default.encode(urlRequest, with: queryItems)
            }catch{
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                let body = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                urlRequest.httpBody = body
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            case .post:
                return JSONEncoding.default
            case .put:
                return JSONEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        NetworkLogger.log(request: urlRequest)
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    

}


