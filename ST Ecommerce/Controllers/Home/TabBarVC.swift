//
//  TabBarVC.swift
//  ST Ecommerce
//
//  Created by necixy on 16/10/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Sentry

class TabBarVC: UITabBarController {
    
    
    // MARK: - Properties
    
    private var resCartCount = 0
    private var productCartCount = 0
    private var popups = [PopupModel]()
    private let popupView = PopupView()
    private var firstTime = true
    var fromLogin = false
    
    
    // MARK: - LifeCycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        insertCartVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarBorder()
        checkToRequest()
        delegate = self
        var dict = [String: Any]()
        dict.updateValue(0, forKey: "badgeCount")
        UserDefaults.standard.register(defaults: dict)
        if !firstTime {
            loadRestaurantCart()
        }
        if fromLogin {
            loadUserProfile()
        }
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard readLogin() == 0
        else { return true }
        let tag = viewController.tabBarItem.tag

        if tag == 1 || tag == 2 {
            showNeedToLoginApp()
            return false
        } else if tag == 3 {
            let vc = storyboardHome.instantiateViewController(withIdentifier: "VC_AccountNotLoggedIn") as! VC_AccountNotLoggedIn
            present(vc, animated: true)
            return false
        } else {
            return true
        }
    }
    
    private func setupTabBarBorder() {
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.clipsToBounds = true
    }
    
    // MARK: - CartVC Setup
    
    
    private func insertCartVC() {
        //HomeTab
        let homeVC : VC_Home = storyboardHome.instantiateViewController(withIdentifier: "VC_Home") as! VC_Home
        homeVC.tabBarItem.image = UIImage(named: "tab_home")
        homeVC.tabBarItem.title = ""
        homeVC.tabBarItem.tag = 0

        //OrderTab
        let orderVC  = MyOrderScreenRouter(.orderTab, .store).viewController
        let orderTabBarItem = UITabBarItem()
        orderTabBarItem.title = ""
        orderTabBarItem.tag = 1
        orderTabBarItem.image = UIImage(named: "tab_order")
        orderVC.tabBarItem = orderTabBarItem
        
        //CartTab
        let cartVC : CartViewController = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        cartVC.showBackButton = false
//        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
//        let cartVC = storyboard.instantiateViewController(ofType: CartListViewController.self)
//        cartVC.showBackButton = false
        let tabBarItem = UITabBarItem()
        tabBarItem.title = ""
        tabBarItem.tag = 2
        tabBarItem.badgeColor = .systemRed
        tabBarItem.badgeValue = nil
        tabBarItem.image = UIImage(named: "tab_cart")
        cartVC.tabBarItem = tabBarItem
        
        //profileTab
        let profileVC: VC_Profile = storyboardHome.instantiateViewController(withIdentifier: "VC_Profile") as! VC_Profile
        profileVC.tabBarItem.image = UIImage(named: "tab_profile")
        profileVC.tabBarItem.title = ""
        profileVC.tabBarItem.tag = 3
        
        viewControllers = [homeVC, orderVC , cartVC, profileVC]
        self.selectedIndex = 0
        
    }
    

    // MARK: - Utility Functions
    
    private func handleError(data: NSDictionary, title: APIEndPoint) {
        let message = data[key_message] as? String ?? serverError
//        self.presentAlertWithTitle(title: title.caseValue, message: message, options: okayText) { (option) in
            
//        }
    }
    
    private func calculateCartCount(){
        let totalCount = resCartCount + productCartCount
        print("totalcount = " , totalCount)
        let cartVCTabBarItem = self.viewControllers?[2].tabBarItem
        switch totalCount {
        case 0: cartVCTabBarItem?.badgeValue = nil
        case 1...10: cartVCTabBarItem?.badgeValue = "\(totalCount)"
        case let x where x > 10: cartVCTabBarItem?.badgeValue = "10+"
        default: break
        }
    }
    
}


extension TabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NotificationCenter.default.post(name: Notification.Name("DidChangeTab"), object: nil)
    }
}



// MARK: - UserProfile Fetching Function

extension TabBarVC {
    private func loadUserProfile(){
        let param : [String:Any] = [:]

        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { [unowned self] (response) in
            self.handleUserProfileResponse(response: response)
        }) { (reason, statusCode) in
            
        }
    }
    
    private func handleUserProfileResponse(response: Any) {
        
        let data = response as! NSDictionary
        let status = data.value(forKey: key_status) as? Int
        
        status == 200 ? decodeUserProfile(data: data): handleError(data: data, title: APIEndPoint.userProfile)
    }
    
    private func decodeUserProfile(data: NSDictionary) {
        if let profile = data.value(forKeyPath: "data") as? NSDictionary{
            APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { [unowned self] (anyData) in
                
                let profile = anyData as? Profile
                Singleton.shareInstance.userProfile = profile
                
                let user = User()
                user.userId = profile?.slug ?? ""
                SentrySDK.setUser(user)
                
                self.loadRestaurantCart()
            }) { (error, endPoint) in
                print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
            }
        }
    }
}

// MARK: - Cart Data Fetching Function

extension TabBarVC {
    
    private func loadRestaurantCart() {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { [weak self] (response) in
            self?.handleRestaurantCartResponse(response: response)
        }) { (reason, statusCode) in
            
        }
    }
    
    private func handleRestaurantCartResponse(response: Any) {
        
        let data = response as! NSDictionary
        let status = data.value(forKey: key_status) as? Int
        status == 200 ? decodeRestaurantCart(data: data): handleError(data: data, title: APIEndPoint.cart)
    }
    
    private func decodeRestaurantCart(data: NSDictionary) {
        if let cart = data.value(forKeyPath: "data") as? NSDictionary{
            APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cart.caseValue, modelName: "Cart", onSuccess: { [unowned self] (anyData) in
                let cartData = anyData as? CartData
                self.resCartCount = 0
                if let menuCount = cartData?.restaurant?.menus?.count, menuCount > 0 {
                    for i in 0..<menuCount {
                        self.resCartCount += cartData?.restaurant?.menus?[i].quantity ?? 0
                    }
                }
                
                print("resCartCount = ", resCartCount)
                self.productCartCount = 0
                if let shopcount = cartData?.shop?.shops?.count, shopcount > 0 {
                    for i in 0..<shopcount {
                        let product = cartData?.shop?.shops?[i].productCarts
                        for j in 0..<Int(product?.count ?? 0) {
                            self.productCartCount += product?[j].quantity ?? 0
                        }
                        
                    }
                }
                
                print("productCartCount = ", productCartCount)
                
                
            }) { (error, endPoint) in
                print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
            }
        }
        self.calculateCartCount()
    }
}



// MARK: - Popup Functions

extension TabBarVC {
    
    private func fetchPopups() {
        APIUtils.APICall(postName: APIEndPoint.home_banner_popup.caseValue, method: .get, parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            
            if status == 200 {
                if let home_popups = data.value(forKeyPath: "data") as? NSArray{
                    
                    APIUtils.prepareModalFromData(home_popups, apiName: APIEndPoint.home_banner_popup.caseValue, modelName: "PopupModel", onSuccess: { (anyData) in
                        if let popupData = anyData as? PopupModel {
                            DispatchQueue.main.async {
                                self.popups.append(popupData)
                            }
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                    DispatchQueue.main.async {
                        self.popupView.superVC = self
                        self.popupView.constraintTo(superView: self.view, popupsData: self.popups)
                    }
                }
            }
        }) { (reason, statusCode) in
            
        }
    }
    
    private func checkToRequest() {
        
        print("checkToRequest")
//        if readLogin() {
//            UserDefaults.standard.set(readToken(), forKey: UD_APITOKEN)
//        }
//        
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dMMyyyy"
        let currentDateString = dateFormatter.string(from: date)
        
        if currentDateString != UserDefaults.standard.string(forKey: UD_Popup) {
            UserDefaults.standard.set(currentDateString, forKey: UD_Popup)
            fetchPopups()
        }
        
        if readLogin() != 0 {
            if currentDateString != UserDefaults.standard.string(forKey: UD_Token) {
                UserDefaults.standard.set(currentDateString, forKey: UD_Token)
                refreshToken()
            }
            else {
                DEFAULTS.set(readToken(), forKey: UD_APITOKEN)
                loadUserProfile()
            }
        }
      
        firstTime = false
        
    }
    
    private func refreshToken(){
        
        print("call refresh token !!!")
        
        let param : [String:Any] = [:]
        
        showHud(message: loadingText)
        
        APIUtils.APICall(postName: APIEndPoint.refreshToken.caseValue, method: .post, parameters: param, controller: self, onSuccess: { (response) in
            
            let response = response as? [String:Any] ?? [:]
            let status = response["status"] as? Int
            let data = response["data"] as? [String:Any] ?? [:]
            
            if status == 200{
                if let token = data["token"] as? String {
                    UserDefaults.standard.set(token, forKey: UD_APITOKEN)
                    self.writeToken(token: token)
                    self.changeLoginState(newState: 1)
                    self.loadUserProfile()
                }
            }
            else {
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlert(title: APIEndPoint.refreshToken.caseValue, message: message)
            }
            
        }) { (reason, statusCode)  in
        }
    }
    
}
