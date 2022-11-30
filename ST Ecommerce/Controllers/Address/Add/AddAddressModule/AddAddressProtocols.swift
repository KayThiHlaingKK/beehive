//
//  AddAddressProtocols.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 7/27/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Navigation Option
enum AddAddressNavigationOption {
    /**
     - example usage
     */
}

// MARK: - Presenter -> View
protocol AddAddressPresenterToViewProtocl: BaseViewProtocol {
    func initialControlSetup()
    func setCreateAddressData(data: AddressModel)
    func setUpdateAddressData(data: AddressModel)
    func setGetOneAddressData(data: AddressModel)
    func setUpdateShopAddressData(data: ShopUpdateAddressModel)
    func setCity(data: CityTownShipModel)
    func setTownShip(data: CityTownShipModel)
    func failAddressAlert(title: String, message: String)
}

// MARK: - View -> Presenter
protocol AddAddressViewToPresenterProtocol: AnyObject {
    func started()
    func createAddress(request: AddressRequest)
    func updateAddress(request: AddressRequest)
    func getOneAddress(slug: String)
    func updateShopAddress(request: UpdateAddressRequest)
    func getCity()
    func getTownShip(citySlug: String)
}

// MARK: - Interactor -> Presenter
protocol AddAddressInterectorToPresenterProtocol: AnyObject {
    func fetchingStart()
    func successCreateAddress(response: AddressModel)
    func successUpdateAddress(response: AddressModel)
    func successGetOneAddress(response: AddressModel)
    func successGetCity(data: CityTownShipModel)
    func successGetTownShip(data: CityTownShipModel)
    func fetchShopUpdate(data: ShopUpdateAddressModel)
    func fail(error: Error)
    func failAlert(title: String, message: String)
    
}

// MARK: - Presenter -> Interactor
protocol AddAddressPresentorToInterectorProtocol: AnyObject {
    func createAddressAPICall(request: AddressRequest)
    func updateAddressAPICall(request: AddressRequest)
    func getOneAddressAPICall(slug: String)
    func getUserCityAPICall()
    func getUserTownShipAPICall(citySlug: String)
    func updateShopAddressAPICall(request: UpdateAddressRequest)
    
}

// MARK: - Presenter -> Router or WireFrame
protocol AddAddressPresenterToRouterProtocol: BaseRouterProtocol {
    func navigate(to option: AddAddressNavigationOption)
}


