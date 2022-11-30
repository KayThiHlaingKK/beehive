//
//  AddAddressRouter.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 7/27/22.
//  Copyright © 2022 Shashi. All rights reserved.
//


import UIKit
import Foundation
import CoreLocation

class AddAddressRouter: BaseRouter {
    
    // MARK: - Private properties
    private let storyboard = UIStoryboard(name: "AddAddress", bundle: nil)
    
    // MARK: Module Setup
    init() {
        let moduleViewController = storyboard.instantiateViewController(ofType: AddAddressViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = AddAddressInteractor()
        let presenter = AddAddressPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        interactor.presenter = presenter
    }
    
    init(slug: String) {
        let moduleViewController = storyboard.instantiateViewController(ofType: AddAddressViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = AddAddressInteractor()
        let presenter = AddAddressPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        moduleViewController.slug = slug
        interactor.presenter = presenter
    }
    
    init(userCoordinate:CLLocationCoordinate2D,address: Address, profileData: Profile?, slug: String, fromEdit: Bool) {
        let moduleViewController = storyboard.instantiateViewController(ofType: AddAddressViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = AddAddressInteractor()
        let presenter = AddAddressPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        moduleViewController.userCoordinates = userCoordinate
        moduleViewController.address = address
        moduleViewController.profileData = profileData
        moduleViewController.slug = slug
        moduleViewController.fromEdit = fromEdit
        interactor.presenter = presenter
    }
    
}

// MARK: - Presenter to Wireframe Interface
extension AddAddressRouter: AddAddressPresenterToRouterProtocol {
    
    func navigate(to option: AddAddressNavigationOption) {
        // ...
    }
    
}
