//
//  APIClient.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import Alamofire
import PromisedFuture

enum APIError: Error{
    case forbidden          //Status code 403
    case notFound           //Status code 404
    case conflict           // Status code 409
    case internalServerError //Status code 500
    case invalid
    case noData
}

class APIClient {
    
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIRouter, decoder: JSONDecoder = JSONDecoder()) -> Future<T, APIError> {
        return Future(operation: { completion in
            AF.request(route).responseDecodable(decoder: decoder, completionHandler: { (response: DataResponse<T, AFError>) in
                guard let responseData = response.data else {
                    completion(.failure(APIError.noData))
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                    debugPrint(json)
                } catch {
                    completion(.failure(APIError.noData))
                }
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(_):
                    switch response.response?.statusCode {
                    case 403:
                        completion(.failure(APIError.forbidden))
                    case 404:
                        completion(.failure(APIError.notFound))
                    case 409:
                        completion(.failure(APIError.conflict))
                    case 500:
                        completion(.failure(APIError.internalServerError))
                    default:
                        completion(.failure(APIError.invalid))
                    }
                }
            })
        })
    }
    
    static func fetchLogin(request: LoginAuthentication) -> Future<LoginModel,APIError> {
        return performRequest(route: .login(request: request))
    }
    
    static func fetchShopOrderList(requestModel: MyOrderRequest) -> Future<ShopOrderModel,APIError>{
        return performRequest(route: .getMyShopOrder(requestModel))
    }
    
    static func fetchFoodOrderList(requestModel: MyOrderRequest) -> Future<FoodOrderModel,APIError>{
        return performRequest(route: .getMyFoodOrder(requestModel))
    }
    
    static func fetchUserCredit() -> Future<CreditCardModel,APIError>{
        return performRequest(route: .getUserCredit)
    }
    
    static func fetchMenuDetail(menuSlug: String) -> Future<MenuDetailModel,APIError>{
        return performRequest(route: .getUserMenuDetail(menu_slug: menuSlug))
    }
    
    static func fetchItemByContent(itemRequest: ItemContentRequest) -> Future <ItemContentModel,APIError>{
        return performRequest(route: .getItemByContent(itemRequest))
    }
    
    static func fetchUserCity() -> Future<CityTownShipModel,APIError> {
        return performRequest(route: .getUserCity)
    }
    
    static func fetchUserTownShip(citySlug: String) -> Future<CityTownShipModel,APIError> {
        return performRequest(route: .getUserTownShip(citySlug: citySlug))
    }
    
    static func fetchCreateAddress(request: AddressRequest) -> Future<AddressModel,APIError> {
        return performRequest(route: .createAddress(request: request))
    }
    
    static func fetchUpdateAddress(request: AddressRequest) -> Future<AddressModel,APIError> {
        return performRequest(route: .updateAddress(request: request))
    }
    
    static func fetchGetOneAddress(slug: String) -> Future<AddressModel,APIError> {
        return performRequest(route: .getOneAddress(addressSlug: slug))
    }
    
    static func fetchGetAddress() -> Future<GetAddressModel,APIError> {
        return performRequest(route: .getAddress)
    }
    
    static func fetchShopUpdateAddress(request: UpdateAddressRequest) -> Future<ShopUpdateAddressModel,APIError> {
        return performRequest(route: .shopUpdateAddress(request: request))
    }
    
    static func fetchFoodUpdateAddress(request: UpdateAddressRequest) -> Future<FoodUpdateAddressModel,APIError> {
        return performRequest(route: .foodUpdateAddress(request: request))
    }
    
    static func fetchNearestAddress(lat: Double,long: Double) -> Future<AddressModel,APIError> {
        return performRequest(route: .getNearest(lat: lat, long: long))
    }
    
    static func fetchUserSetting() -> Future<UserSettingModel,APIError> {
        return performRequest(route: .getUserSetting)
    }
    
    static func fetchRestaurantCheckOut(request: ConfirmOrderRequest) -> Future<CheckOutModel,APIError>{
        return performRequest(route: .getRestaurantCheckOut(request: request))
    }
    
    static func fetchShopCheckOut(request: ConfirmOrderRequest) -> Future<CheckOutModel,APIError>{
        return performRequest(route: .getShopCheckOut(request: request))
    }
    
    static func fetchViewCart() -> Future<ViewCartModel,APIError> {
        return performRequest(route: .getViewCart)
    }
    
    static func fetchAnnouncement() -> Future<AnnouncementModel,APIError> {
        return performRequest(route: .getAnnouncement)
    }
    
    static func fetchUserProfile() -> Future<UserProfileModel,APIError> {
        return performRequest(route: .getUserProfile)
    }
    
    static func fetchUpdateUserProfile(request: UpdateUserProfile) -> Future <UpdateAddressModel,APIError> {
        return performRequest(route: .updateUserProfile(request: request))
    }
    
    static func fetchDeleteAccount() -> Future <DeleteAccountModel,APIError> {
        return performRequest(route: .deleteAccount)
    }
    
}

enum Result<T>{
    case success(T)
    case failure(String)
}
