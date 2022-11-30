//
//  MyOrderScreenProtocols.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import Foundation
import UIKit

// MARK: - Navigation Option
enum MyOrderScreenNavigationOption {
    /**
     - example usage
     */
}

// MARK: - Presenter -> View
protocol MyOrderScreenPresenterToViewProtocl: BaseViewProtocol {
    func initialControlSetup()
    func setShopData(_ data: ShopOrderModel)
    func setFoodData(_ data: FoodOrderModel)
    func fialAuthenticateStatus(_ message: String)
    func failStatus(_ message: String)
    
    var isFromHome: isFromHome? { get set }
}

// MARK: - View -> Presenter
protocol MyOrderScreenViewToPresenterProtocol: AnyObject {
    func started()
    func getOrderShopLists(_ data: MyOrderRequest)
    func getOrderFoodLists(_ data: MyOrderRequest)
}

// MARK: - Interactor -> Presenter
protocol MyOrderScreenInterectorToPresenterProtocol: AnyObject {
    func fetchingStart()
    func shopSuccess(_ response: ShopOrderModel)
    func foodSuccess(_ response: FoodOrderModel)
    func fail(error: Error)
    func failAuthenticateStatus(message: String)
    func failStatus(message: String)
    
}

// MARK: - Presenter -> Interactor
protocol MyOrderScreenPresentorToInterectorProtocol: AnyObject {
    func getShopOrdersAPICall(_ data: MyOrderRequest)
    func getFoodOrderAPICall(_ data: MyOrderRequest)
}

// MARK: - Presenter -> Router or WireFrame
protocol MyOrderScreenPresenterToRouterProtocol: BaseRouterProtocol {
    func navigate(to option: MyOrderScreenNavigationOption)
}


