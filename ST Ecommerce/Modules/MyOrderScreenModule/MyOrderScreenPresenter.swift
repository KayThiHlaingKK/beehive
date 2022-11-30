//
//  MyOrderScreenPresenter.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//
//

import Foundation
import UIKit

class MyOrderScreenPresenter {
    
    // MARK: - Private properties
    private unowned var view: MyOrderScreenPresenterToViewProtocl
    private var interactor: MyOrderScreenPresentorToInterectorProtocol
    private var router: MyOrderScreenPresenterToRouterProtocol
    
    // MARK: - Lifecycle
    init(view: MyOrderScreenPresenterToViewProtocl, interactor: MyOrderScreenPresentorToInterectorProtocol, router: MyOrderScreenPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - View to Presenter
extension MyOrderScreenPresenter: MyOrderScreenViewToPresenterProtocol {
    
    func started() {
        view.initialControlSetup()
    }
    
    func getOrderShopLists(_ data: MyOrderRequest) {
        interactor.getShopOrdersAPICall(data)
    }
    
    func getOrderFoodLists(_ data: MyOrderRequest) {
        interactor.getFoodOrderAPICall(data)
    }
    
  
}

// MARK: - Interactor to Presenter
extension MyOrderScreenPresenter: MyOrderScreenInterectorToPresenterProtocol {
    
    
    
    func fetchingStart() {
        view.showLoading()
    }
    
    func shopSuccess(_ response: ShopOrderModel) {
        view.hideLoading()
        view.setShopData(response)
    }
    
    func foodSuccess(_ response: FoodOrderModel) {
        view.hideLoading()
        view.setFoodData(response)
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
    
    func failStatus(message: String) {
        view.hideLoading()
        view.failStatus(message)
    }
    
    func failAuthenticateStatus(message: String) {
        view.hideLoading()
        view.fialAuthenticateStatus(message)
    }
    
}

