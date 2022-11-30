//
//  MyOrderScreenRouter.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//
//

import UIKit
import Foundation

class MyOrderScreenRouter: BaseRouter {
    
    // MARK: - Private properties
    private let storyboard = UIStoryboard(name: "MyOrderScreen", bundle: nil)
    
    // MARK: Module Setup
    init(_ isFromHome: isFromHome, _ cartType: Cart) {
        let moduleViewController = storyboard.instantiateViewController(ofType: MyOrderScreenViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = MyOrderScreenInteractor()
        let presenter = MyOrderScreenPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.isFromHome = isFromHome
        moduleViewController.cartType = cartType
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }
    
}

// MARK: - Presenter to Wireframe Interface
extension MyOrderScreenRouter: MyOrderScreenPresenterToRouterProtocol {
    
    func navigate(to option: MyOrderScreenNavigationOption) {
        // ...
    }
    
}
