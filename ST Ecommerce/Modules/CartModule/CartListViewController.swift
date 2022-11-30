//
//  CartListViewController.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 8/29/22.
//  Copyright © 2022 Shashi. All rights reserved.
//
//  This file was generated by Zin Lin Htet Naing.
//

import Foundation
import UIKit

class CartListViewController: UIViewController {
    
    // MARK: Delegate initialization
    var presenter: CartListViewToPresenterProtocol?
    
    // MARK: Outlets
    
    
    // MARK: Custom initializers go here
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.started()
    }
    
    // MARK: User Interaction - Actions & Targets
    
    
    // MARK: Additional Helpers
    
}

// MARK: - Extension
/**
 - Documentation for purpose of extension
 */
extension CartListViewController {
    
}

// MARK: - Presenter to View
extension CartListViewController: CartListPresenterToViewProtocl {
    
    func initialControlSetup() {
        // ...
    }
    
}
