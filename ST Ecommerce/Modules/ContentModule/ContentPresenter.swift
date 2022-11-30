//
//  ContentPresenter.swift
//  ST Ecommerce
//
//  Created Ku Ku Zan on 7/14/22.
//  Copyright © 2022 Shashi. All rights reserved.
//
//

import Foundation
import UIKit

class ContentPresenter {
    
    // MARK: - Private properties
    private unowned var view: ContentPresenterToViewProtocl
    private var interactor: ContentPresentorToInterectorProtocol
    private var router: ContentPresenterToRouterProtocol
    
    // MARK: - Lifecycle
    init(view: ContentPresenterToViewProtocl, interactor: ContentPresentorToInterectorProtocol, router: ContentPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

// MARK: - View to Presenter
extension ContentPresenter: ContentViewToPresenterProtocol {
   
    func started() {
        view.initialControlSetup()
    }
    
    func getItemContentLists(_ itemRequest: ItemContentRequest) {
        interactor.getItemContentAPICall(itemRequest)
    }
    
}

// MARK: - Interactor to Presenter
extension ContentPresenter: ContentInterectorToPresenterProtocol {
    func fetchingStart() {
        view.showLoading()
    }
    
    func itemContentSuccess(_ response: ItemContentModel) {
        view.hideLoading()
        view.setItemContentList(response)
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
    
    
}

