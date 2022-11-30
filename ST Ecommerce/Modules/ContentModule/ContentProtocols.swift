//
//  ContentProtocols.swift
//  ST Ecommerce
//
//  Created Ku Ku Zan on 7/14/22.
//  Copyright © 2022 Shashi. All rights reserved.
//


import Foundation
import UIKit

// MARK: - Navigation Option
enum ContentNavigationOption {
    /**
     - example usage
     */
}

// MARK: - Presenter -> View
protocol ContentPresenterToViewProtocl: BaseViewProtocol {
    func initialControlSetup()
    func setItemContentList(_ data: ItemContentModel)
}

// MARK: - View -> Presenter
protocol ContentViewToPresenterProtocol: AnyObject {
    func started()
    func getItemContentLists(_ itemRequest: ItemContentRequest)
}

// MARK: - Interactor -> Presenter
protocol ContentInterectorToPresenterProtocol: AnyObject {
    func fetchingStart()
    func itemContentSuccess(_ response: ItemContentModel)
    func fail(error: Error)
    
}

// MARK: - Presenter -> Interactor
protocol ContentPresentorToInterectorProtocol: AnyObject {
    func getItemContentAPICall(_ itemRequest: ItemContentRequest)
    
}

// MARK: - Presenter -> Router or WireFrame
protocol ContentPresenterToRouterProtocol: BaseRouterProtocol {
    func navigate(to option: ContentNavigationOption)
}


