//
//  ConfirmPlaceOrderRouter.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 8/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit
import Foundation

class ConfirmPlaceOrderRouter: BaseRouter {
    
    // MARK: - Private properties
    private let storyboard = UIStoryboard(name: "ConfirmPlaceOrder", bundle: nil)
    
    // MARK: Module Setup
    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: ConfirmPlaceOrderViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = ConfirmPlaceOrderInteractor()
        let presenter = ConfirmPlaceOrderPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }

    
    init(cartType: Cart,orderType: OrderType,productOrderCart: [ProductCart],productOrder: ShopCart) {
        let moduleViewController = storyboard.instantiateViewController(ofType: ConfirmPlaceOrderViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = ConfirmPlaceOrderInteractor()
        let presenter = ConfirmPlaceOrderPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        moduleViewController.cartType = cartType
        moduleViewController.orderType = orderType
        moduleViewController.productCartList = productOrderCart
        moduleViewController.productOrder = productOrder
        interactor.presenter = presenter
    }
    
    init(cartType: Cart,orderType: OrderType,restaurantOrder: RestaurantCart) {
        let moduleViewController = storyboard.instantiateViewController(ofType: ConfirmPlaceOrderViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = ConfirmPlaceOrderInteractor()
        let presenter = ConfirmPlaceOrderPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        moduleViewController.cartType = cartType
        moduleViewController.orderType = orderType
        moduleViewController.restaurantOrder = restaurantOrder
        interactor.presenter = presenter
    }
    
}

// MARK: - Presenter to Wireframe Interface
extension ConfirmPlaceOrderRouter: ConfirmPlaceOrderPresenterToRouterProtocol {
    
    func navigate(to option: ConfirmPlaceOrderNavigationOption) {
        switch option {
        case .addAddreessView:
            navigationController?.pushView(AddAddressRouter())
        }
        
    }
    
}
