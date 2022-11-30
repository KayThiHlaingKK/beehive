//
//  AddAddressPresenter.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 7/27/22.
//  Copyright © 2022 Shashi. All rights reserved.
//


import Foundation
import UIKit

class AddAddressPresenter {
    
    // MARK: - Private properties
    private unowned var view: AddAddressPresenterToViewProtocl
    private var interactor: AddAddressPresentorToInterectorProtocol
    private var router: AddAddressPresenterToRouterProtocol
    
    // MARK: - Lifecycle
    init(view: AddAddressPresenterToViewProtocl, interactor: AddAddressPresentorToInterectorProtocol, router: AddAddressPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - View to Presenter
extension AddAddressPresenter: AddAddressViewToPresenterProtocol {
    
    func updateShopAddress(request: UpdateAddressRequest) {
        interactor.updateShopAddressAPICall(request: request)
    }
    
    func createAddress(request: AddressRequest) {
        interactor.createAddressAPICall(request: request)
    }
    
    func updateAddress(request: AddressRequest) {
        interactor.updateAddressAPICall(request: request)
    }
    
    func getOneAddress(slug: String) {
        interactor.getOneAddressAPICall(slug: slug)
    }
    
    func getCity() {
        interactor.getUserCityAPICall()
    }
    
    func started() {
        view.initialControlSetup()
    }
    
    func getTownShip(citySlug: String) {
        interactor.getUserTownShipAPICall(citySlug: citySlug)
    }
    

}

// MARK: - Interactor to Presenter
extension AddAddressPresenter: AddAddressInterectorToPresenterProtocol {
    
    func fetchShopUpdate(data: ShopUpdateAddressModel) {
        view.hideLoading()
        view.setUpdateShopAddressData(data: data)
    }
    
    func successUpdateAddress(response: AddressModel) {
        view.hideLoading()
        view.setUpdateAddressData(data: response)
    }
    
    func successCreateAddress(response: AddressModel) {
        view.hideLoading()
        view.setCreateAddressData(data: response)
    }
    
    func successGetOneAddress(response: AddressModel) {
        view.hideLoading()
        view.setGetOneAddressData(data: response)
    }
    
    func successGetCity(data: CityTownShipModel) {
        view.hideLoading()
        view.setCity(data: data)
    }

    func successGetTownShip(data: CityTownShipModel) {
        view.hideLoading()
        view.setTownShip(data: data)
    }
    
    
    func fetchingStart() {
        view.showLoading()
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
    
    func failAlert(title: String, message: String) {
        view.hideLoading()
        view.failAddressAlert(title: title, message: message)
    }
    
}

