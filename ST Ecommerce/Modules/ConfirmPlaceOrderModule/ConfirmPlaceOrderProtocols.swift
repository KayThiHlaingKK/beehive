//
//  ConfirmPlaceOrderProtocols.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 8/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Navigation Option
enum ConfirmPlaceOrderNavigationOption {
    case addAddreessView
}

// MARK: - Presenter -> View
protocol ConfirmPlaceOrderPresenterToViewProtocl: BaseViewProtocol {
    func initialControlSetup()
    func setUserSetting(data: UserSettingModel)
    func setCheckOutData(data: CheckOutModel)
    func navigateToMPUVisaView(payment: PaymentMode)
    func goOrderPage(message: String)
    func setUserCreditData(_ data: CreditCardModel)
    func orderTypePaymentModeOption()
    func setUpdateAddress(data: AddressModel)
    func setShopUpdateAddress(data: ShopUpdateAddressModel)
    func setFoodUpdateAddress(data: FoodUpdateAddressModel)
    func setViewCartData(data: CartData)
    func addressAlertAction()
    func presentAlertPromo(title: String, message: String)
    
}

// MARK: - View -> Presenter
protocol ConfirmPlaceOrderViewToPresenterProtocol: AnyObject {
    func started()
    func fetchUserSetting()
    func fetchCBPay(reference: String)
    func fetchKBZPay(prepayId: String,randomString: String,currentTimeMilliSeconds: Int)
    func fetchOrderConfirm(cartType: Cart,request: ConfirmOrderRequest)
    func getUserCredit()
    func fetchUpdateAddressData(request: AddressRequest)
    func shopUpdateAddress(request: UpdateAddressRequest)
    func foodUpdateAddress(request: UpdateAddressRequest)
    func fetchViewCart()
    func getAddressFromLatLong(pdblLatitude: String, withLongitude pdblLongitude: String,addressTitle: UILabel,addressLabel: UILabel,cartType: Cart,cartAddress: Address)
    
}

// MARK: - Interactor -> Presenter
protocol ConfirmPlaceOrderInterectorToPresenterProtocol: AnyObject {
    func fetchingStart()
    func setUserSetting(data: UserSettingModel)
    func setCheckOutData(data: CheckOutModel)
    func setUpdateAddressData(data: AddressModel)
    func failUpdateAddress()
    func failShopUpdateAddress(title: String,message: String)
    func setShopUpdateAddress(data: ShopUpdateAddressModel)
    func setFoodUpdateAddress(data: FoodUpdateAddressModel)
    func setViewCartData(data: CartData)
    func fail(error: Error)
    func urlFail(errorMessage: String)
    func success(_ response: CreditCardModel)
    
}

// MARK: - Presenter -> Interactor
protocol ConfirmPlaceOrderPresentorToInterectorProtocol: AnyObject {
    func userSettingAPICall()
    func kbzPayAPICall(prepayId: String,randomString: String,currentTimeMilliSeconds: Int)
    func cbPayAPICall(reference: String)
    func restaurantCheckOutAPICall(request: ConfirmOrderRequest)
    func shopCheckOutAPICall(request: ConfirmOrderRequest)
    func confirmPlaceOrderAPICall(cartType: Cart,request: ConfirmOrderRequest)
    func getCreditAPICall()
    func updateAddressAPICall(request: AddressRequest)
    func shopUpdateAddressAPICall(request: UpdateAddressRequest)
    func foodUpdateAddressAPICall(request: UpdateAddressRequest)
    func getAddressFromLatLong(pdblLatitude: String, withLongitude pdblLongitude: String,addressTitle: UILabel,addressLabel: UILabel,cartType: Cart,cartAddress: Address)
    func getViewCartAPICall()
}

// MARK: - Presenter -> Router or WireFrame
protocol ConfirmPlaceOrderPresenterToRouterProtocol: BaseRouterProtocol {
    func navigate(to option: ConfirmPlaceOrderNavigationOption)
}


