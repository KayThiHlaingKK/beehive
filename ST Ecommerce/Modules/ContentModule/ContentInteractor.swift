//
//  ContentInteractor.swift
//  ST Ecommerce
//
//  Created Ku Ku Zan on 7/14/22.
//  Copyright © 2022 Shashi. All rights reserved.
//


import Foundation

class ContentInteractor {
    
    // MARK: Delegate initialization
    var presenter: ContentInterectorToPresenterProtocol?
    
    // MARK: - Call Service
    func getItemContentAPICall(_ itemRequest: ItemContentRequest) {
        presenter?.fetchingStart()
        APIClient.fetchItemByContent(itemRequest: itemRequest).execute(onSuccess: { data in
            self.presenter?.itemContentSuccess(data)
        }, onFailure: { error in
            self.presenter?.fail(error: error)
        })
    }
}

// MARK: - Presenter to Interactor
extension ContentInteractor: ContentPresentorToInterectorProtocol {
    
    
    
}
