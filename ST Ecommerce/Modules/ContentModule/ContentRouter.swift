//
//  ContentRouter.swift
//  ST Ecommerce
//
//  Created Ku Ku Zan on 7/14/22.
//  Copyright © 2022 Shashi. All rights reserved.
//
//

import UIKit
import Foundation

class ContentRouter: BaseRouter {
    
    // MARK: - Private properties
    private let storyboard = UIStoryboard(name: "Content", bundle: nil)
    
    // MARK: Module Setup
    init(slug: String,announcement: Announcement) {
        let moduleViewController = storyboard.instantiateViewController(ofType: ContentViewController.self)
        super.init(viewController: moduleViewController)
        let interactor = ContentInteractor()
        let presenter = ContentPresenter(view: moduleViewController, interactor: interactor, router: self)
        moduleViewController.presenter = presenter
        moduleViewController.itemSlug = slug
        moduleViewController.announcement = announcement
        interactor.presenter = presenter
    }
    
}

// MARK: - Presenter to Wireframe Interface
extension ContentRouter: ContentPresenterToRouterProtocol {
    
    func navigate(to option: ContentNavigationOption) {
        // ...
    }
    
}
