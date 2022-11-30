//
//  CreditCardInteractor.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 26/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import Foundation

class CreditCardInteractor {
    
    // MARK: Delegate initialization
    var presenter: CreditCardInterectorToPresenterProtocol?
    
    // MARK: - Call Service
    func getCreditAPICall() {
        APIClient.fetchUserCredit().execute(onSuccess: { data in
            self.presenter?.success(data)
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
    
}

// MARK: - Presenter to Interactor
extension CreditCardInteractor: CreditCardPresentorToInterectorProtocol {
    
    
}
