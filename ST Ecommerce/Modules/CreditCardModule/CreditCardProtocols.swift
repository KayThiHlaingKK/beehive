//
//  CreditCardProtocols.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 26/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import Foundation
import UIKit

// MARK: - Navigation Option
enum CreditCardNavigationOption {
    /**
     - example usage
     */
}

// MARK: - Presenter -> View
protocol CreditCardPresenterToViewProtocl: BaseViewProtocol {
    func initialControlSetup()
    func setUserCreditData(_ data: CreditCardModel)
    
}

// MARK: - View -> Presenter
protocol CreditCardViewToPresenterProtocol: AnyObject {
    func started()
    func getUserCredit()
}

// MARK: - Interactor -> Presenter
protocol CreditCardInterectorToPresenterProtocol: AnyObject {
    func fetchingStart()
    func success(_ response: CreditCardModel)
    func fail(error: Error)
}

// MARK: - Presenter -> Interactor
protocol CreditCardPresentorToInterectorProtocol: AnyObject {
    func getCreditAPICall()
}

// MARK: - Presenter -> Router or WireFrame
protocol CreditCardPresenterToRouterProtocol: BaseRouterProtocol {
    func navigate(to option: CreditCardNavigationOption)
}


