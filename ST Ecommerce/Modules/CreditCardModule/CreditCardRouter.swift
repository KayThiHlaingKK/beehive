//
//  CreditCardRouter.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 26/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import UIKit
import Foundation

class CreditCardRouter: BaseRouter {
    
    // MARK: - Private properties
    private let storyboard = UIStoryboard(name: "CreditCardScreen", bundle: nil)
    
    // MARK: Module Setup
    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: CreditCardViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = CreditCardInteractor()
        let presenter = CreditCardPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }
    
}

// MARK: - Presenter to Wireframe Interface
extension CreditCardRouter: CreditCardPresenterToRouterProtocol {
    
    func navigate(to option: CreditCardNavigationOption) {
        // ...
    }
    
}
