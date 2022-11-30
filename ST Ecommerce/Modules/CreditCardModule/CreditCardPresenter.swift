//
//  CreditCardPresenter.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 26/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import Foundation
import UIKit

class CreditCardPresenter {
    
    // MARK: - Private properties
    private unowned var view: CreditCardPresenterToViewProtocl
    private var interactor: CreditCardPresentorToInterectorProtocol
    private var router: CreditCardPresenterToRouterProtocol
    
    // MARK: - Lifecycle
    init(view: CreditCardPresenterToViewProtocl, interactor: CreditCardPresentorToInterectorProtocol, router: CreditCardPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - View to Presenter
extension CreditCardPresenter: CreditCardViewToPresenterProtocol {
    
    
    func started() {
        view.initialControlSetup()
    }
    
    func getUserCredit() {
        interactor.getCreditAPICall()
    }
    
    
    
}

// MARK: - Interactor to Presenter
extension CreditCardPresenter: CreditCardInterectorToPresenterProtocol {
    
    func fetchingStart() {
        view.showLoading()
    }
    
    func success(_ response: CreditCardModel) {
        view.hideLoading()
        view.setUserCreditData(response)
    }
    
    func fail(error: Error) {
        view.hideLoading()
        debugPrint(error)
        if let error = error as? APIError {
            router.showAlert(with: "Error!", message: error.localizedDescription)
            return
        }
        router.showAlert(with: "Error!", message: error.localizedDescription)
    }
    
    
}

