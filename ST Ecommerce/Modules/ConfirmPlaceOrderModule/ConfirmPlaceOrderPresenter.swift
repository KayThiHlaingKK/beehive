//
//  ConfirmPlaceOrderPresenter.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 8/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit

class ConfirmPlaceOrderPresenter {
    
    // MARK: - Private properties
    private unowned var view: ConfirmPlaceOrderPresenterToViewProtocl
    private var interactor: ConfirmPlaceOrderPresentorToInterectorProtocol
    private var router: ConfirmPlaceOrderPresenterToRouterProtocol
    
    // MARK: - Lifecycle
    init(view: ConfirmPlaceOrderPresenterToViewProtocl, interactor: ConfirmPlaceOrderPresentorToInterectorProtocol, router: ConfirmPlaceOrderPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - View to Presenter
extension ConfirmPlaceOrderPresenter: ConfirmPlaceOrderViewToPresenterProtocol {
    
    func started() {
        view.initialControlSetup()
    }
    
    func fetchUserSetting() {
        interactor.userSettingAPICall()
    }
    
    func fetchKBZPay(prepayId: String, randomString: String, currentTimeMilliSeconds: Int) {
        interactor.kbzPayAPICall(prepayId: prepayId, randomString: randomString, currentTimeMilliSeconds: currentTimeMilliSeconds)
    }
    
    func fetchCBPay(reference: String) {
        interactor.cbPayAPICall(reference: reference)
    }
    
    func fetchOrderConfirm(cartType: Cart,request: ConfirmOrderRequest) {
        interactor.confirmPlaceOrderAPICall(cartType: cartType, request: request)
    }

    func getUserCredit() {
        interactor.getCreditAPICall()
    }
    
    func fetchUpdateAddressData(request: AddressRequest) {
        interactor.updateAddressAPICall(request: request)
    }
    
    func getAddressFromLatLong(pdblLatitude: String, withLongitude pdblLongitude: String, addressTitle: UILabel, addressLabel: UILabel, cartType: Cart,cartAddress: Address) {
        interactor.getAddressFromLatLong(pdblLatitude: pdblLatitude, withLongitude: pdblLongitude, addressTitle: addressTitle, addressLabel: addressLabel, cartType: cartType, cartAddress: cartAddress)
    }
    
    func shopUpdateAddress(request: UpdateAddressRequest) {
        interactor.shopUpdateAddressAPICall(request: request)
    }
    
    func foodUpdateAddress(request: UpdateAddressRequest) {
        interactor.foodUpdateAddressAPICall(request: request)
    }
    
    func fetchViewCart() {
        interactor.getViewCartAPICall()
    }
    
}

// MARK: - Interactor to Presenter
extension ConfirmPlaceOrderPresenter: ConfirmPlaceOrderInterectorToPresenterProtocol {
    
    func setViewCartData(data: CartData) {
        view.hideLoading()
        view.setViewCartData(data: data)
    }
    
    func setShopUpdateAddress(data: ShopUpdateAddressModel) {
        view.hideLoading()
        view.setShopUpdateAddress(data: data)
    }
    
    func setFoodUpdateAddress(data: FoodUpdateAddressModel) {
        view.hideLoading()
        view.setFoodUpdateAddress(data: data)
    }
    
    func setUpdateAddressData(data: AddressModel) {
        view.hideLoading()
        view.setUpdateAddress(data: data)
    }
    
    func failUpdateAddress() {
        view.hideLoading()
        view.addressAlertAction()
    }
    
    func failShopUpdateAddress(title: String,message: String) {
        view.hideLoading()
        view.presentAlertPromo(title: title, message: message)
    }
    
    func fetchingStart() {
        view.showLoading()
    }
    
    func setUserSetting(data: UserSettingModel) {
        view.hideLoading()
        view.setUserSetting(data: data)
    }
    
    func setCheckOutData(data: CheckOutModel) {
        view.hideLoading()
        view.setCheckOutData(data: data)
    }
    
    func goToOrderPage() {
        view.hideLoading()
        
    }
    
    func success(_ response: CreditCardModel) {
        view.hideLoading()
        view.setUserCreditData(response)
    }
    
    func fail(error: Error) {
        view.hideLoading()
        debugPrint(error)
        if !NetworkUtils.isNetworkReachable(){
            router.showAlert(with: "", message: no_internet_connection_available)
        }
        if let error = error as? APIError {
            router.showAlert(with: "Error!", message: error.localizedDescription)
            return
        }
        router.showAlert(with: "Error!", message: error.localizedDescription)
    }
    
    func urlFail(errorMessage: String) {
        view.hideLoading()
        router.showAlert(with: "Error!", message: errorMessage)
    }
}

