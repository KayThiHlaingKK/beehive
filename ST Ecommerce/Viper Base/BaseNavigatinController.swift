//
//  BaseNavigatinController.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class BaseNavigatinController: UINavigationController {
    
    init (router: BaseRouter) {
        super.init(nibName: nil, bundle: nil)
        setRootView(router)
        if #available(iOS 13.0, *) {
            navigationBarAppearance()
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(iOS 13.0, *)
    private func navigationBarAppearance() {
        //MARK: - Global Navigation Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemRed
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().prefersLargeTitles = false
    }
}
