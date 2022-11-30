//
//  VC_Cart.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import Sentry
import Cosmos
import SwiftLocation
import CoreLocation
import KBZPayAPPPay

class VC_Cart: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewCart: UITableView!
    @IBOutlet weak var viewCartOptions: UIView!
    @IBOutlet weak var ViewCartOptionsheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightCartOptionsConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintAddItem: NSLayoutConstraint!
    @IBOutlet weak var buttonStoreCart: UIButton!
    @IBOutlet weak var labelAdd: UILabel!
    @IBOutlet weak var buttonFoodCart: UIButton!
    @IBOutlet weak var viewAddProductsContainer: UIView!
    @IBOutlet weak var heightConstraintAddProductContainerView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    var reOrderData: MyOrder?
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    @IBOutlet weak var addTopProductConstraint: NSLayoutConstraint!
    
    @IBOutlet var headerViewRestro: UIView!
    @IBOutlet weak var imageViewRestroLogo: UIImageView!
    @IBOutlet weak var labelResroName: UILabel!
    @IBOutlet weak var labelResroDetails: UILabel!
    @IBOutlet weak var labelResroTimings: UILabel!
    @IBOutlet weak var labelResroAddress: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var heightforRestaurant: NSLayoutConstraint!
    
    @IBOutlet weak var btnDestroy: UIButton!
    
    @IBOutlet weak var emptyView : UIView!
    
    @IBOutlet weak var deliView : UIView!
    @IBOutlet weak var deliLabel: UILabel!
    @IBOutlet weak var backButtonView: UIView!
    
    //MARK: - Varibles
    var cartType:Cart?
    let hud = JGProgressHUD(style: .dark)
    var totalAmount : Double?
    var subTotalAmount : Double?
    var productOrderList : [CartProduct]?
    var foodOrderRestaurant : CartRestaurantBranch?
    var fromHome = false
    var addresses : [Address] = [Address]()
    var primaryAddress : Address_?
    var userProfile : Profile?
    var isGiveAwayOn = false
    var special_instruction = ""
    var paymentMode = PaymentMode.cash
    var index: Int?
    var isFromBuyNow: Bool? = false
    var total: String?
    var isFromStore: Bool = false
    var isTappedFromStore: Bool =  false
    var fromDetail: Bool = false
    
    //for placing order
    var township : [String:Any] = [:]
    var addressItem : [String: Any] = [:]
    var user: [String:Any] = [:]
    var currentDate: String = ""
    
    var foodEmpty = false
    var product_param : [String:Any] = [:]
    var restaurant_param : [String:Any] = [:]
    var nearestAddress: Address?
    var addressStr: String?
    var lat = 0.0
    var long = 0.0
    var promocode = ""
    
    var appliedPromoMenu = false
    var appliedPromoProduct = false
    var kbzPay: PaymentViewController?
    var cartData: CartData?
    let formatter = DateFormatter()
    var showBackButton = true
    
    var restaurantBranch: RestaurantBranch?
    /*
    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        else if UserSessionManager.shared.foodOrder.count > 0 {
//            UserSessionManager.shared.foodOrder[0].promotion = 0
//        }
        
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        
        if isTappedFromStore == true {
            heightTopView.constant = 0
            viewCartOptions.isHidden = true
            buttonFoodCart.isHidden = true
            buttonStoreCart.isHidden = true
        }
        else if isTappedFromStore == false {
            cartType = Cart.store
            heightTopView.constant = 44
            viewCartOptions.isHidden = false
            buttonFoodCart.isHidden = false
            buttonStoreCart.isHidden = false
            loadCartData()
        } else {
            heightTopView.constant = 0
            viewCartOptions.isHidden = true
            buttonFoodCart.isHidden = true
            buttonStoreCart.isHidden = true
        }
 
        lat = Singleton.shareInstance.currentLat
        long = Singleton.shareInstance.currentLong
        
        
    }
    
    func checkDeliTime() {
        
        
        guard let openingTime = restaurantBranch?.opening_time,
              let closingTime = restaurantBranch?.closing_time
        else { return }
        
        let preorder = restaurantBranch?.pre_order ?? true
        let instantOrder = restaurantBranch?.instant_order ?? true
        
        print(instantOrder)
        
        let openingTimeString = removeColmn(string: openingTime)
        let closingTimeString = removeColmn(string: closingTime)
        let currentTimeString = removeColmn(string: getCurrentTime())
        
        let beforeOpeningTime = currentTimeString <= openingTimeString
        let afterClosingTime = currentTimeString >= closingTimeString
        
        print("before = " , beforeOpeningTime)
        print("after = ", afterClosingTime)
        
        if restaurantBranch?.instant_order == false {
            canOrderNextday()
        }
        else {
            if beforeOpeningTime || (!beforeOpeningTime && !afterClosingTime){
                canOrderToday()
            }
            else if afterClosingTime{
                canOrderNextday()
            }
        }
                
    }
    
    func canOrderToday() {
        formatter.dateFormat =  "MMM dd"
        print("it is ", restaurantBranch?.delivery_time)
        if let time = restaurantBranch?.delivery_time {
            print("it is")
            deliLabel.text = "Delivery : \(time)"
            Singleton.shareInstance.deliTime = "ASAP"
            Singleton.shareInstance.deliDate = DeliveryDate.today
            Singleton.shareInstance.willdeli = DeliveryMode.delivery
        }
    }
    
    func canOrderNextday() {
        formatter.dateFormat =  "MMM dd"
        let d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
        formatter.dateFormat =  "HH:mm:ss"
        let openingTime = formatter.date(from: restaurantBranch?.opening_time ?? "0") ?? Date()
        let min = Calendar.current.date(byAdding: .minute, value: 15, to: openingTime) ?? Date()
        formatter.dateFormat =  "hh:mm a"
        let minTime = formatter.string(from: min)
        deliLabel.text = "Delivery : \(d) \(minTime)"
        
        Singleton.shareInstance.deliTime = minTime
        Singleton.shareInstance.deliDate = DeliveryDate.tomorrow
        Singleton.shareInstance.willdeli = DeliveryMode.delivery
    }
    
    @IBAction func changeDeliTime(_ sender: UIButton) {
        let vc : PreorderViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "PreorderViewController") as! PreorderViewController
        vc.restaurantBranch = self.cartData?.restaurant?.restaurant_branch
        vc.preDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableViewSetUP()
        setUpUI()
        
       
        if isFromStore == true {
            buttonStoreCart.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
            buttonStoreCart.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            buttonFoodCart.backgroundColor = #colorLiteral(red: 0.9223576188, green: 0.9175453782, blue: 0.9260684252, alpha: 1)
            buttonFoodCart.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cartType = Cart.store
            self.productOrderList = UserSessionManager.shared.productOrder
            tableViewCart.reloadData()
            resetUI()
            
        } else {
            print("is not from store")
            buttonFoodCart.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
            buttonFoodCart.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            buttonStoreCart.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9176470588, blue: 0.9254901961, alpha: 1)
            buttonStoreCart.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cartType = Cart.restaurant
            loadCartData()
            
        }
       
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableViewSetUP()
        
    }
    
    override func viewWillLayoutSubviews() {
        viewCartOptions.frame.size.height = 0
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Private Functions
    private func tableViewSetUP(){
        
        tableViewCart.dataSource = self
        tableViewCart.delegate = self
        
    }
    
    func hideShowDestroyCart(){
        
        trailingConstraintAddItem.constant = 16
        if storeCart != nil{
            trailingConstraintAddItem.constant = 64
        }
        else if cartData?.restaurant != nil {
            trailingConstraintAddItem.constant = 64
        }
    }
    
    
    
    func setUpUI(){
        self.backButtonView.isHidden = !showBackButton
        if DEFAULTS.bool(forKey: UD_isUserLogin){
            self.loadUserProfile()
//            self.getUserCurrentLocation()
//            self.resetUI()
        }else{
            self.showNeedToLoginApp()
        }
        print("setup table == " , self.tableViewCart.isHidden)
    }
    
    func resetUI(){
        print("resetUI")
        if DEFAULTS.bool(forKey: UD_isUserLogin){
            if let type = self.cartType{
                print(type)
                if type == Cart.store{
                    tableViewCart.tableHeaderView = UIView()
                    labelAdd.text = "Add Products"
                }
                else if type == Cart.restaurant{
                    print("it is cart.restaurant" , self.cartData?.restaurant)
                    labelAdd.text = "Add Items"
                    
                    if self.cartData?.restaurant != nil {
                        
                        if self.cartData?.restaurant?.menus?.count ?? 0 > 0{
                            self.setData(restaurantCart: self.cartData?.restaurant ?? RestaurantCart())
                            viewAddProductsContainer.isHidden = true
                            heightConstraintAddProductContainerView.constant = 0
                            
                            headerViewRestro.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 250)
                            self.tableViewCart.tableHeaderView = headerViewRestro
                        }
                        else {
                            tableViewCart.isHidden = true
                            viewAddProductsContainer.isHidden = false
                            heightConstraintAddProductContainerView.constant = 55
                        }
                        
                        print("showdatetime = " , Singleton.shareInstance.showDateTime)
                        if Singleton.shareInstance.showDateTime == "" {
                            checkDeliTime()
                        }
                        else {
                            deliLabel.text = Singleton.shareInstance.showDateTime
                        }
                    }
                    else {
                        tableViewCart.isHidden = true
                        viewAddProductsContainer.isHidden = false
                        heightConstraintAddProductContainerView.constant = 55
                        
                    }
                }
            }
            viewCartOptions.isHidden = false
        }
        self.hideShowDestroyCart()
        print("is table == " , tableViewCart.isHidden)
        

    }
    
    //MARK: - Action Functions
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func home(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func storeCart(_ sender: UIButton) {
        print("click store cart")
        cartType = Cart.store
        self.productOrderList = UserSessionManager.shared.productOrder
        isFromStore = true
        fromHome = true
        isTappedFromStore = false
        buttonStoreCart.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
        buttonStoreCart.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        buttonFoodCart.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buttonFoodCart.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        //self.loadStoreCartItemsFromServer()
        self.cartData?.restaurant = RestaurantCart()
        resetUI()
        tableViewCart.reloadData()
    }
    
    @IBAction func foodCart(_ sender: UIButton) {
        print("click food cart")
        
        cartType = Cart.restaurant
        isFromStore = false
        fromHome = true
        isTappedFromStore = false
        buttonFoodCart.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
        buttonFoodCart.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        buttonStoreCart.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        buttonStoreCart.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.productOrderList?.removeAll()
        loadCartData()
        resetUI()
        tableViewCart.reloadData()
    }
    
    @IBAction func expandCollapsePromoCode(_ sender: UIButton) {
        print("click click !!")
        let point = sender.convert(CGPoint.zero, to: self.tableViewCart)
        guard let customIndexPath = self.tableViewCart.indexPathForRow(at: point) else {
            return
        }
        let isExpanded = self.productOrderList?[customIndexPath.row].isExpanded ?? false
        self.productOrderList?[customIndexPath.row].isExpanded = !isExpanded
        self.tableViewCart.reloadData()
        
    }
}

/*******************************STORE***************************/

//MARK: - Store Action Functions
extension VC_Cart{
    
    @IBAction func addItem(_ sender: UIButton) {
        
        if let type = self.cartType{
            if type == Cart.store{
                let vc : VC_Store = storyboardStore.instantiateViewController(withIdentifier: "VC_Store") as! VC_Store
                vc.fromCart = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if type == Cart.restaurant{
                
                let vc : VC_Restaurant = storyboardRestaurant.instantiateViewController(withIdentifier: "VC_Restaurant") as! VC_Restaurant
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func destroyStoreCart(_ sender: UIButton) {
        
        self.presentAlertWithTitle(title: warningText, message: destroyCartAlertText, options: "Cancel", yesText) { (option) in
            
            switch(option) {
            case 1:
                if self.cartType == Cart.store && self.productOrderList != nil{
                    self.destroyStoreCart()
                }
                else if self.cartType == Cart.restaurant {
                    self.destroyRestroCart()
                }
                self.changeCartBadgeNumber()
            default:
                break
            }
        }
    }
    
}

//MARK: - API Call Functions STORE
extension VC_Cart{
    
    func loadCartData(){
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        
        APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200 {
                if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                    APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cart.caseValue, modelName: "Cart", onSuccess: { (anyData) in
                        self.cartData = anyData as? CartData
                        self.restaurantBranch = self.cartData?.restaurant?.restaurant_branch
                        UserSessionManager.shared.menuOrder = self.cartData?.restaurant?.menus ?? []
                        self.resetUI()
                        self.changeCartBadgeNumber()
                        self.tableViewCart.reloadData()
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
                
            }else{
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (value) in
//                }
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
        
    }
    
    func changeCartBadgeNumber() {
        let menusOrderCount = UserSessionManager.shared.menuOrder.count
        let productOrderCount = UserSessionManager.shared.productOrder.count
        let totalCount = menusOrderCount + productOrderCount
        
        switch totalCount {
        case 0: tabBarItem?.badgeValue = nil
        case 1...10: tabBarItem?.badgeValue = "\(totalCount)"
        case let x where x > 10: tabBarItem?.badgeValue = "10+"
        default: break
        }
        
    }
    
    func prepareForParam() {
        
        if nearestAddress != nil {
            print("nearest address is not nil")
            //township["slug"] = nearestAddress?.township?.slug
            addressItem["house_number"] = nearestAddress?.house_number
            addressItem["floor"] = nearestAddress?.floor
            addressItem["street_name"] = nearestAddress?.street_name
            addressItem["latitude"] = nearestAddress?.latitude
            addressItem["longitude"] = nearestAddress?.longitude
            //addressItem["township"] = township
        }
        else {
            print("nearest address is nil")
            addressItem["street_name"] = addressStr
            addressItem["latitude"] = "\(lat)"
            addressItem["longitude"] = "\(long)"
        }
        
        let userProfile = Singleton.shareInstance.userProfile
        
        user["customer_name"] = userProfile?.name
        user["phone_number"] = userProfile?.phone_number
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        currentDate = formatter.string(from: date)
        
    }
    
    func placeFoodOrder(){
        print("place food order")
        self.showHud(message: loadingText)
        
        if restaurant_param.isEmpty {
            prepareRestaurantParam(promo: "")
        }
        print("restaurant_param ", restaurant_param)
        
        
        APIUtils.APICall(postName: APIEndPoint.restaurantCheckout.caseValue, method: .post,  parameters: restaurant_param, controller: self, onSuccess: { (response) in
            self.hideHud()
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            let messaages = "We are processing your order"
            
            
            if status == 201 {
                
                Singleton.shareInstance.showDateTime = ""
                Singleton.shareInstance.deliDate = DeliveryDate.today
                Singleton.shareInstance.deliTime = ""
                Singleton.shareInstance.willdeli = DeliveryMode.delivery
                
                    
                    if self.paymentMode == PaymentMode.kbz {
                        
                        print("it is kbz")
                        
                        if let order = data.value(forKeyPath: "data") as? NSDictionary{
                            
                            APIUtils.prepareModalFromData(order, apiName: APIEndPoint.shopOrder.caseValue, modelName:"ShopOrder", onSuccess: { (anyData) in
                                print("object bind")
                                let orderModel = anyData as? Order ?? nil
                                self.goToKBZPay(prepayId: orderModel?.prepay_id ?? "")
                                self.goFoodOrderPage(message: messaages)
                                
                                
                            }) { (error, endPoint) in
                                print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                            }
                        }
                        
                        
                        
                    }
                    else {
                        self.goFoodOrderPage(message: messaages)
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (value) in
                }
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func goFoodOrderPage(message: String) {
        let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
        vc.cartType = Cart.restaurant
        vc.fromHome = false
        self.presentAlertWithTitle(title: "Order Placed", message: message, options: okayText) { (option) in
            switch(option) {
            case 0:
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func placeShopOrder(){
        
        self.showHud(message: loadingText)
        if product_param.isEmpty {
            prepareProductParam(promo: "")
        }
        print("place product order")
        APIUtils.APICall(postName: APIEndPoint.shopOrder.caseValue, method: .post,  parameters: product_param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            
            print("order response " , data)
            
            let status = data.value(forKey: key_status) as? Int
            _ = data.value(forKey: key_message) as? String ?? ""
            let messaages = "We are processing your order"
            
            
            
            if status == 201{
                
                if self.paymentMode == PaymentMode.kbz {
                    
                    print("it is kbz")
                    
                    if let order = data.value(forKeyPath: "data") as? NSDictionary{
                        
                        APIUtils.prepareModalFromData(order, apiName: APIEndPoint.shopOrder.caseValue, modelName:"ShopOrder", onSuccess: { (anyData) in
                            print("object bind")
                            let orderModel = anyData as? Order ?? nil
                            self.goToKBZPay(prepayId: orderModel?.prepay_id ?? "")
                            
                            self.goProductOrderPage(message: messaages)
                            
                        }) { (error, endPoint) in
                            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                        }
                    }
                    
                }
                else {
                    self.goProductOrderPage(message: messaages)
                }
                
                UserSessionManager.shared.productOrder.removeAll()
                
            }else{
                let message = data[key_message] as? String ?? serverError
                
                SentrySDK.capture(message: message)
                self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (value) in
                }
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
        
    }
    
    func goProductOrderPage(message: String) {
        let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
        vc.cartType = Cart.store
        vc.fromHome = false
        self.presentAlertWithTitle(title: "Order Placed", message: message, options: "Ok") { (option) in
            switch(option) {
            case 0:
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func goToKBZPay(prepayId: String) {
        kbzPay = PaymentViewController()
        print("goToKBZPay")
        
        
        #if STAGING
        let MERCHANT_CODE = "200144"
        let APP_ID = "kp8ddaafe77e4b45ba97cff5892ab6b8"
        let APP_KEY = "ef7d003df99dc62c85d2bbd4ff30fbed"
        #else
        let MERCHANT_CODE = "70025502"
        let APP_ID = "kp10a51ac0acb4439898e781409b9f3a"
        let APP_KEY = "43997935d6e5ac4157b4481c9a184f4e"
        _ = "SHA256"
        #endif
        
        let nonceStr = randomString(length: 32)
        let urlScheme = "KBZPayAPPPayDemo"
        let orderString = "appid=\(APP_ID)&merch_code=\(MERCHANT_CODE)&nonce_str=\(nonceStr)&prepay_id=\(prepayId)&timestamp=\(currentTimeInMilliSeconds())"
        
        let signStr = "\(orderString)&key=\(APP_KEY)"
        let sign = signStr.sha256()
        
        print("orderString ", orderString)
        print("sign ", sign)
        print("urlScheme ", urlScheme)
        kbzPay?.startPay(withOrderInfo: orderString, signType: "SHA256", sign: sign, appScheme: urlScheme)
    }
   
    func loadUserProfile(){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        print(BASEURL)
        print(APIEndPoint.userProfile.caseValue)
        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let profile = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                        
                        self.userProfile = anyData as? Profile ?? nil
                        Singleton.shareInstance.userProfile = self.userProfile
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (option) in
                    
                    switch(option) {
                    case 0:
                        print("Okay tapped")
                        break
                    default:
                        break
                    }
                }
            }
            
        }) { (reason, statusCode) in
        }
        
    }
    
    func loadNearestAddress(){
        
        let param : [String:Any] = [:]
        
        print("nearest param \(param)")
        
        
        let api = "\(APIEndPoint.nearestAddress.caseValue)?lat=\(lat)&lng=\(long)"
        print(api)
        APIUtils.APICall(postName: api, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            print(data)
            if status == 200{
                //Success from our server
                if let address = data.value(forKeyPath: "data") as? NSDictionary{
                    print("Nearsttt == " , address)
                    APIUtils.prepareModalFromData(address, apiName: APIEndPoint.nearestAddress.caseValue, modelName:"Address", onSuccess: { (anyData) in
                        
                        let add = anyData as? Address
                        
                        if let address = add{
                            print("there is near address")
                            self.nearestAddress = address
                            self.lat = address.latitude ?? 0.0
                            self.long = address.longitude ?? 0.0
                            self.addressStr = Util.getFormattedAddress(address: address)
                            
                        }
                        else {
                            print("there is no near address")
                            self.getAddressFromLatLon(pdblLatitude: "\(self.lat)", withLongitude: "\(self.long)")
                        }
                        
                        //self.tableViewCart.reloadData()
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
                else {
                    print("there is no near address \(self.lat) \(self.long)")
                    self.getAddressFromLatLon(pdblLatitude: "\(self.lat)", withLongitude: "\(self.long)")
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
        }
        
        
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        
        
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            let lon: Double = Double("\(pdblLongitude)")!
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

            var addressString : String = ""
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = (placemarks ?? nil) as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]

                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }

                        self.addressStr = addressString
                       // self.tableViewCart.reloadData()

                  }
            })
            
        }
    
    
    func destroyStoreCart(){
        
        if UserSessionManager.shared.productOrder.count > 0 {
            UserSessionManager.shared.productOrder.removeAll()
            self.tableViewCart.isHidden = true
        }
        
    }
    
    
   
}

//MARK: - API Call Functions Restaurants
extension VC_Cart{
    
    func removeItemFromRestaurantCart(rowId:String){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.cartPathRestro.caseValue)\(rowId)/\(APIEndPoint.remove.caseValue)", method: .delete,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status{
//                self.getItemsFromRestaurantCart()
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func destroyRestroCart(){
        deleteFoodCart()
//        if UserSessionManager.shared.foodOrder.count > 0 {
//            UserSessionManager.shared.foodOrder.removeAll()
//            tableViewCart.isHidden = true
//        }
    }
   
    func deleteFoodCart() {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantCart.caseValue)", method: .delete,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
                        
            if status == 200{
                
                Singleton.shareInstance.showDateTime = ""
                Singleton.shareInstance.deliDate = DeliveryDate.today
                Singleton.shareInstance.deliTime = ""
                Singleton.shareInstance.willdeli = DeliveryMode.delivery
                
                
                self.loadCartData()
                self.resetUI()
                self.tableViewCart.reloadData()
            }
            else {
                DEFAULTS.set(false, forKey: UD_isContainAdd)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
   
    
//    func alignUIforfood(){
//
//
//        if self.cartData?.restaurant != nil {
//            if self.cartData?.restaurant?.menus?.count ?? 0 > 0 {
////                    self.setData(restaurantBranch: foodOrderRestaurant!)
//                self.productOrderList = nil
//                self.resetUI()
//                self.heightforRestaurant.constant = 200
//                //foodEmpty = false
//            }
//            else {
//                self.ratingView.isHidden = true
//                self.heightforRestaurant.constant = 55
//               // self.tableViewCart.isHidden = true
//                //foodEmpty = true
//            }
//        }
//        else
//        {
//            // self.viewCartOptions.isHidden = true
//            self.ratingView.isHidden = true
//            //self.tableViewCart.isHidden = true
//            self.heightforRestaurant.constant = 55
//            //foodEmpty = true
//        }
//
//
//
//        resetUI()
//        tableViewCart.reloadData()
//        print("get item ", tableViewCart.isHidden)
//    }
    

    
}


extension VC_Cart {
    
    func setData(restaurantCart: RestaurantCart){
                
        var imagePathBanner = ""
        if let images = restaurantCart.restaurant?.images,
            images.count > 0 {
            
            imageViewRestroLogo.setIndicatorStyle(.gray)
            imageViewRestroLogo.setShowActivityIndicator(true)
            imagePathBanner = restaurantCart.restaurant?.images?.first?.url ?? ""
            imageViewRestroLogo.downloadImage(url: imagePathBanner, fileName: images.first?.file_name)
            
        }
        else {
            imageViewRestroLogo.image = UIImage.init(named: "placeholder2")
        }
        
        
        labelResroAddress.text = ""
        if let address = restaurantCart.restaurant_branch?.address{
            //let formattedAddress = Util.getFormattedAddress(address: address)
            labelResroAddress.text = address
        }
        let restname = "\(restaurantCart.restaurant?.name ?? "") \(restaurantCart.restaurant_branch?.name ?? "")"
        labelResroName.text = restname
        //        labelResroDetails.text = restaurant.excerpt ?? ""
        
        labelResroTimings.text = "\(restaurantCart.restaurant_branch?.opening_time ?? "") - \(restaurantCart.restaurant_branch?.closing_time ?? "")"
        
        //ratingView.rating = Double(restaurant.rating ?? 0)
    }
}

//MARK: - Restro Action Functions
extension VC_Cart{
    
    @IBAction func addItemInRestroCart(_ sender: UIButton) {

        if isTappedFromStore && fromDetail {
            _ = navigationController?.popViewController(animated: true)
        }
        else if let type = self.cartType, let restroID = cartData?.restaurant?.restaurant_branch?.slug{
            if type == Cart.restaurant{
                let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
                vc.slug = restroID
                vc.fromCart = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @IBAction func destroyRestroCart(_ sender: UIButton) {
        
        //        let defaults = UserDefaults.standard
        //        defaults.removeObject(forKey: "food")
        //        defaults.synchronize()
        presentAlertWithTitle(title: warningText, message: destroyCartAlertText, options: "Cancel", yesText) { (option) in
            
            switch(option) {
            case 1:
                
                    self.destroyRestroCart()
                
            default:
                break
            }
        }
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        //        let point = sender.location(in: self.tableViewCart)
        //        guard let customIndexPath = self.tableViewCart.indexPathForRow(at: point) else {
        //            return
        //        }
        //        var isExpanded = self.storeCart?.cartProducts?[customIndexPath.row].isExpanded ?? false
        //        self.storeCart?.cartProducts?[customIndexPath.row].isExpanded = !isExpanded
        //        self.tableViewCart.reloadData()
    }
    
    
    
    
}

/**************************************************************/

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_Cart : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        tableView.isHidden = true
        if self.productOrderList != nil && self.productOrderList!.count > 0 && isFromStore {
            tableView.isHidden = false
            return 2
        }else if self.cartData?.restaurant != nil && self.cartData?.restaurant?.menus?.count ?? 0 > 0 && !isFromStore{
            tableView.isHidden = false
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.productOrderList != nil && self.productOrderList!.count > 0 && isFromStore{
            
            if section == 0{
                return self.productOrderList?.count ?? 0
            }
            else if section == 1{
                
                //if self.alsoLikesProducts.count == 0{
                    return 3
                //}
                //                    else{
                //                    return 4
                //                }
                
            }
        }
        else if self.cartData?.restaurant != nil && !isFromStore{
            if section == 0{
                return self.cartData?.restaurant?.menus?.count ?? 0
            }
            else if section == 1{
                print("section 1 = ",  section)
                return 1
            }
            else if section == 2{
                if self.isGiveAwayOn{
                    return 0
                }
                print("section 2 = ",  section)
                return 0//1 actually 1, 0 is to hide address
            }
            else if section == 3{
                print("section 3 = ",  section)
                return 3
            }
            
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.productOrderList != nil && self.productOrderList!.count > 0{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Store_Cart_Product") as! Cell_Store_Cart_Product
                //                print("cellRowHeight is \(cellRowHeight)")
                cell.selectionStyle = .none
                cell.controller_ = self
                cell.containerViewPromoCode.isHidden = true
                cell.heightContainerViewPromocode.constant = 0
                //cell.btnExpandCollaspe.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
                
                //print("proddddddd " , self.productOrderList?[indexPath.row])
                
                if let isSelected = self.productOrderList?[indexPath.row].isExpanded {
                    
                    if isSelected {
                        cell.containerViewPromoCode.isHidden = false
                        cell.heightContainerViewPromocode.constant = 65
                    } else {
                        cell.containerViewPromoCode.isHidden = true
                        cell.heightContainerViewPromocode.constant = 0
                    }
                }
                
                if let item = self.productOrderList?[indexPath.row]{
                    cell.containerViewApplyPromoCode.isHidden = false
                    cell.containerViewAppliedPromoCode.isHidden = true
//                    cell.setData(cartItem: item, index: indexPath.row)
                }
                
                cell.buttonPlus.tag = indexPath.row
                cell.buttonMinus.tag = indexPath.row
                cell.buttonRemoveItem.tag = indexPath.row
                cell.btnRemovePromoCode.tag = indexPath.row
                ///////vcell.btnApplyPromoCode.tag = indexPath.row
                
                return cell
            }
            else if indexPath.section == 1{
                print("")
                if (indexPath.row == 0){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Store_Cart_Billing") as! Cell_Store_Cart_Billing
                    cell.selectionStyle = .none
                    cell.controller_ = self
                    cell.promoDelegate = self
                    
                    if appliedPromoProduct {
                        cell.btnApplyPromoCode.setTitle("Remove Promo Code", for: .normal)
                    }
                    else {
                        cell.btnApplyPromoCode.setTitle("Use Promo Code", for: .normal)
                    }
                    
                    if let items = self.productOrderList{
                        cell.setData(cartItems: items, addressStr: addressStr ?? "")
                    }
                    
                    return cell
                }
                else if (indexPath.row == 1){
                    let cell : Cell_TV_PaymentMode = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_PaymentMode") as! Cell_TV_PaymentMode
                    cell.selectionStyle = .none
                    cell.controller_ = self
                    
                    return cell
                }
                else if (indexPath.row == 2){
                    let cell : Cell_TV_Cart_OrderNow = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Cart_OrderNow") as! Cell_TV_Cart_OrderNow
                    cell.selectionStyle = .none
                    cell.controller_ = self
                    
                    return cell
                }
                

            }
        }
        
        else if self.cartData?.restaurant != nil {
            
            if indexPath.section == 0{
                let cell : Cell_TV_Restro_Cart_Item = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Restro_Cart_Item") as! Cell_TV_Restro_Cart_Item
                cell.selectionStyle = .none
                cell.controller_ = self
                
                if let item = self.cartData?.restaurant?.menus?[indexPath.row]{
                    cell.setData(cartItem: item)
                    cell.menu = item
                    cell.labelItemQty.text = item.quantity?.description
                }
                
                cell.buttonPlus.tag = indexPath.row
                cell.buttonMinus.tag = indexPath.row
                cell.buttonRemoveItem.tag = indexPath.row
                return cell
            }
           
            else if indexPath.section == 1{
                
                if indexPath.row == 0 && self.cartData?.restaurant?.menus?.count ?? 0 > 0{
                    let cell : Cell_TV_Restro_Cart_Billing = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Restro_Cart_Billing") as! Cell_TV_Restro_Cart_Billing
                    cell.selectionStyle = .none
                    cell.controller_ = self
                    cell.promoDelegate = self
                                        
                    if let restroCart = self.cartData?.restaurant{
                        cell.setData(restaurant: restroCart)
                    }
                    if self.appliedPromoMenu {
                        cell.btnApplyPromoCode.setTitle("Remove Promo Code", for: .normal)
                    }
                    else {
                        cell.btnApplyPromoCode.setTitle("Use Promo Code", for: .normal)
                    }
                    
                    return cell
                }
            }
           
            else if indexPath.section == 2{
                
                if (indexPath.row == 0){
                    let cell : Cell_TV_Restro_Address = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Restro_Address") as! Cell_TV_Restro_Address
                    cell.selectionStyle = .none
                    cell.controller_ = self
                    cell.setData(addressStr: addressStr ?? "")
                    return cell
                }
            }
           
            else if indexPath.section == 3{
                
                if indexPath.row == 0{
                    let cell : Cell_TV_PaymentMode = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_PaymentMode") as! Cell_TV_PaymentMode
                    cell.selectionStyle = .none
                    cell.controller_ = self
//                    if let restroCart = self.foodOrderRestaurant{
//                        cell.setData(restroCart: restroCart)
//                    }
                    if isGiveAwayOn == true {
                        cell.labelTotalAmount.text = "\(total ?? "") \(currencySymbol)"
                    } else {
                        cell.labelTotalAmount.text = "\(foodOrderRestaurant?.total.description ?? "")\(currencySymbol)"
                    }
                    return cell
                }
                else if indexPath.row == 1{
                    
                    let cell : Cell_TV_Cart_Restro_Special_Instructions = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Cart_Restro_Special_Instructions") as! Cell_TV_Cart_Restro_Special_Instructions
                    cell.selectionStyle = .none
                    cell.controller_ = self
                    cell.configuretextView()
                    return cell
                }
                else if (indexPath.row == 2){
                    let cell : Cell_TV_Cart_OrderNow = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Cart_OrderNow") as! Cell_TV_Cart_OrderNow
                    cell.selectionStyle = .none
                    cell.controller_ = self
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 1) && (indexPath.row == 3) {
            let width = self.view.frame.size.width/homeCellWidthRatio
            return width/homeCellHeightRatio + 36
        }
        else if self.productOrderList != nil && self.productOrderList!.count > 0 && (indexPath.section == 1) && (indexPath.row == 0) {
            return 300
        }
        else if (indexPath.section == 1) && (indexPath.row == 2){
            return 80
        }
        else if (indexPath.section == 3) && (indexPath.row == 1){
            return 170
        }
        else if (indexPath.section == 3) && (indexPath.row == 2){
            return 80
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 2){
            let cell : Cell_TV_Restro_TakeAway = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Restro_TakeAway") as! Cell_TV_Restro_TakeAway
            cell.selectionStyle = .none
            cell.controller_ = self
//            if self.foodOrderRestaurant != nil{
//                cell.handelUI()
//            }
            
            return cell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 2){
            
            //            if let selfPickup = self.foodOrderRestaurant?.restaurant?.selfPickup{
            //                if selfPickup{
            //                    return 47
            //                }
            //            }
        }
        return 0.001
    }
}


extension VC_Cart : NRCDelegate{
    
    func nrcValidated(buynowData: NSDictionary?) {
        
        if cartType == Cart.store{
//            self.loadStoreCartItemsFromServer()
        }
        else if cartType == Cart.restaurant{
//            self.getItemsFromRestaurantCart()
        }
    }
    func discard() {
        self.tableViewCart.reloadData()
    }
}


extension VC_Cart : PromoProductDelegate {
    func removePromoProduct() {
        self.promocode = ""
        UserSessionManager.shared.productOrder[0].promotion = 0
        self.productOrderList = UserSessionManager.shared.productOrder
        
        self.appliedPromoProduct = false
        
        let indexPath = IndexPath(row: 0, section: 1)
        self.tableViewCart.beginUpdates()
        self.tableViewCart.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        self.tableViewCart.endUpdates()
    }
    
    
    func validatePromoProduct(promo: String) {
        
        prepareProductParam(promo: promo)
        
        validatePromocode(type: "Product")
        
    }
    
    
    
}

extension VC_Cart: PromoRestaurantDelegate {
    
    func validatePromoRestaurant(promo: String) {
        
        prepareRestaurantParam(promo: promo)
        
        applyPromo(promo: promo)
        
        //validatePromocode(type: "Restaurant")
    }
    
}

extension VC_Cart {
    
    func prepareProductParam(promo: String) {
        promocode = promo
        let productOrder = UserSessionManager.shared.productOrder
        var productList: [[String: Any]] = [[:]]
        for i in 0..<productOrder.count {
            productList[i]["slug"] = productOrder[i].slug
            productList[i]["quantity"] = productOrder[i].orderCount
            productList[i]["variant_slug"] = productOrder[i].productVariant?.slug
            
            if i != productOrder.count-1 {
                productList.append([:])
            }
        }
        
        prepareForParam()
        product_param = ["order_date": currentDate,
                          "special_instruction": "",
                          "payment_mode": paymentMode.caseValue,
                          "delivery_mode": "delivery",
                          "customer_info": user,
                          "promo_code": promo,
                          "address": addressItem,
                          "order_items": productList
        ]
        print("param ===== " , product_param)
    }
    
    func prepareRestaurantParam(promo: String) {
        
        promocode = promo
     
        prepareForParam()
        
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd"
        var d = ""
        
        switch Singleton.shareInstance.deliDate {
        case .today:
            d = formatter.string(from: Date())
        case .tomorrow:
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
        case .thedayaftertomorrow:
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())
        }
        print(Date())
        print(formatter.string(from: Date()))
        print("date ==== " , d)
        
        var t = ""
        var orderType = ""
        if Singleton.shareInstance.deliTime == "ASAP" {
            formatter.dateFormat =  "hh:mm:ss"
            t = formatter.string(from: Date())
            orderType = "instant"
        }
        else {
            formatter.dateFormat =  "hh:mm a"
            let temp = formatter.date(from: Singleton.shareInstance.deliTime) ?? Date()
            formatter.dateFormat =  "hh:mm:ss"
            t = formatter.string(from: temp)
            orderType = "schedule"
        }
        
        if Singleton.shareInstance.willdeli != DeliveryMode.delivery {
            orderType = "pickup"
        }
        
//        let deliType = Singleton.shareInstance.willdeli == DeliveryMode.delivery ? "delivery" : "pickup"
        
        let chooseDateTime = "\(d) \(t)"
        print("chooseDateTime ", chooseDateTime)
        print("ordertype = " ,cartData?.restaurant?.restaurant_branch?.instant_order)
        restaurant_param = [
            "customer_slug": Singleton.shareInstance.userProfile?.slug ?? "",
            "order_date": chooseDateTime,
            "special_instruction": special_instruction,
            "payment_mode": paymentMode.caseValue,
            "order_type" : orderType,
            //"promo_code": promo,
            "customer_info": user,
            "address": addressItem,
        ]
        print("param == " , restaurant_param)
    }
    
    func validatePromocode(type: String) {
        var param: [String: Any] = [:]
        param = product_param
        
        APIUtils.APICall(postName: "\(APIEndPoint.validatePromo.caseValue)", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            print(response)
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            
            if status == 200 {
                let promo = data.value(forKey: "data") as! NSDictionary
                let promotion = promo["promocode_amount"] as? Int
                
                UserSessionManager.shared.productOrder[0].promotion = promotion//(promotion as! NSString).integerValue
                self.productOrderList = UserSessionManager.shared.productOrder
                
                self.appliedPromoProduct = true
                
                
//                    UserSessionManager.shared.foodOrder[0].promotion = (promotion as! NSString).integerValue
                
                
                let indexPath = IndexPath(row: 0, section: 1)
                self.tableViewCart.beginUpdates()
                self.tableViewCart.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableViewCart.endUpdates()
                

                
            }
            
            else{
                
                self.product_param.updateValue("", forKey: "promo_code")
                
                let message = data[key_message] as? String
                self.presentAlert(title: errorText, message: message ?? "Invalid Promocode")
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if UserSessionManager.shared.productOrder.count > 0 {
            UserSessionManager.shared.productOrder[0].promotion = 0
        }
        if UserSessionManager.shared.foodOrder.count > 0 {
            UserSessionManager.shared.foodOrder[0].promotion = 0
        }
    }
    
    func applyPromo(promo: String) {
        
        let param: [String: Any] = ["customer_slug": self.userProfile?.slug ?? "", "promo_code" : promo]
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantCart.caseValue)/promocode", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            print(response)
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            
            if status == 200 {
                let promo = data.value(forKey: "data") as! NSDictionary
                let promotion = promo["promo_amount"] as? Double
                let total_amount = promo["total_amount"] as? Double
                
                self.cartData?.restaurant?.promo_amount = promotion
                self.cartData?.restaurant?.total_amount = total_amount//((total_amount ?? "") as NSString).integerValue
                
                self.appliedPromoMenu = true
                
                let indexPath = IndexPath(row: 0, section: 1)
                
                self.tableViewCart.beginUpdates()
                self.tableViewCart.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableViewCart.endUpdates()
                
            }
            
            else{
                
                self.product_param.updateValue("", forKey: "promo_code")
                
                let message = data[key_message] as? String
                self.presentAlert(title: errorText, message: message ?? "Invalid Promocode")
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
    func removePromoMenu() {
        
        self.presentAlertWithTitle(title: "Are You Sure", message: deletePromopromptText, options: noText, yesText) { (option) in

            switch(option) {
                case 1:
                    self.removePromocode()
                default:
                    break
            }
        }
        
        
    }
    
    func removePromocode() {
        let param: [String: Any] = ["customer_slug": self.userProfile?.slug ?? ""]
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantCart.caseValue)/promocode", method: .delete,  parameters: param, controller: self, onSuccess: { (response) in
            
            print(response)
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            
            if status == 200 {
                self.appliedPromoMenu = false
                
                let promo = data.value(forKey: "data") as! NSDictionary
                let promotion = promo["promo_amount"] as? Double
                let total_amount = promo["total_amount"] as? Double
                
                self.cartData?.restaurant?.promo_amount = promotion
                self.cartData?.restaurant?.total_amount = total_amount//((total_amount ?? "") as NSString).integerValue
                                
                
                let indexPath = IndexPath(row: 0, section: 1)
                
                self.tableViewCart.beginUpdates()
                self.tableViewCart.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableViewCart.endUpdates()
                
            }
            
            else{
                
                self.product_param.updateValue("", forKey: "promo_code")
                
                let message = data[key_message] as? String
                self.presentAlert(title: errorText, message: message ?? "Invalid Promocode")
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
}


extension VC_Cart: PreorderDelegate {
    func didChange(data: String, deliMode: DeliveryMode, deliDate: DeliveryDate, deliTime: String) {
        deliLabel.text = data
        Singleton.shareInstance.deliDate = deliDate
        Singleton.shareInstance.deliTime = deliTime
        Singleton.shareInstance.willdeli = deliMode
        Singleton.shareInstance.showDateTime = data
    }*/
    
}
