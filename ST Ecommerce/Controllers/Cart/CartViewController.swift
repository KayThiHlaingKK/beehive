//
//  CartViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 03/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD
import Sentry
import Cosmos
import SwiftLocation
import CoreLocation
import KBZPayAPPPay
import Toast_Swift
import Alamofire

enum CartNavigationType{
    case navigation
    case root
}

protocol PassDataToRestaurantDetail{
    func passData(deliDateTime: String,restaurantSlug: String,fromCart: Bool)
}

class CartViewController: LeadTimeViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableViewCart: UITableView!
    @IBOutlet weak var trailingConstraintAddItem: NSLayoutConstraint!
    @IBOutlet weak var buttonStoreCart: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelAdd: UILabel!
    @IBOutlet weak var buttonFoodCart: UIButton!
    @IBOutlet weak var viewAddProductsContainer: UIView!
    @IBOutlet weak var heightConstraintAddProductContainerView: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    @IBOutlet weak var heightTopView: NSLayoutConstraint!

    @IBOutlet weak var cartTypeStackView: UIStackView!

    @IBOutlet var headerViewRestro: UIView!
    @IBOutlet weak var imageViewRestroLogo: UIImageView!
    @IBOutlet weak var labelResroName: UILabel!
    @IBOutlet weak var labelResroDetails: UILabel!
    @IBOutlet weak var labelResroTimings: UILabel!
    @IBOutlet weak var labelResroAddress: UILabel!

    @IBOutlet weak var ratingView: CosmosView!

    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var contiuneShopBtn: UIButton!

    @IBOutlet weak var emptyView : UIView!
    @IBOutlet weak var noItemView: UIView!

    @IBOutlet weak var deliView : UIView!
    @IBOutlet weak var deliLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalAmtLbl: UILabel!
    @IBOutlet weak var BgView: UIView!
    @IBOutlet weak var storeBgView: UIView!
    @IBOutlet weak var foodBgView: UIView!
    @IBOutlet weak var confirmAddressView: GradientView!


    //MARK: - Varibles
    var cartType:Cart?
    var cartOption: CartNavigationType?
    let hud = JGProgressHUD(style: .dark)
    var totalAmount : Double?
    var subTotalAmount : Double?
    var delegate: PassDataToRestaurantDetail?

    var fromHome = false
    var addresses : [Address] = [Address]()
    var cartAddress : Address?
    var restaurantAddress: Address?
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
    var preDelegate: PreorderDelegate!

    //for placing order
    var township : [String:Any] = [:]
    var addressItem : [String: Any] = [:]
    var user: [String:Any] = [:]
    var currentDate: String = ""

    var foodEmpty = false
    var product_param : [String:Any] = [:]
    var restaurant_param : [String:Any] = [:]

    var addressStr: String?
    var lat = 0.0
    var long = 0.0
    var promocode = ""
    var resPromocode = ""
    var shopPoromocode = ""

    var appliedPromoMenu = false
    var appliedPromoProduct = false

    let formatter = DateFormatter()
    var showBackButton = true
    var promoUse = false

    var cartData: CartData?
    var restaurantCart: RestaurantCart?
    var restaurantBranchCart: RestaurantBranch?
    var productCartList: [ProductCart] = []

    var chooseDateTime = ""
    var currentTime = Date()
    var currentDateTime = Date()

    var orderType = OrderType.instant
    var deliDateTime = ""
   

    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        backButton.isHidden = !showBackButton
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        setData()
        setupUI()
        getDeliType()
        loadCartData()
        
    }


    override func viewDidAppear(_ animated: Bool) {
        self.tableViewSetUP()

    }

    
    //MARK: - Private Functions
    fileprivate func checkLeadTime() {
//        checkDistanceLeadTime()
//        print(self.cartData?.restaurant?.distance ?? 0.0)
//        //        checkCurrentLeadTime()
//        guard let openingTime = restaurantBranch?.opening_time,
//              let closingTime = restaurantBranch?.closing_time
//        else { return }
//
//        let openingDateTime = self.getDateTime(openingTime)
//        let closingDateTime = self.getDateTime(closingTime)
//        distance = self.cartData?.restaurant?.distance ?? 0.0
//
//        var realCurrentTime = Calendar.current.date(byAdding: .minute, value: -45, to: currentTime) ?? Date()
//        if distance > radius {
//            if let leadTimeMinute = CustomUserDefaults.shared.get(key: .leadTimeMinute) as? String {
//                leadTime = Int(leadTimeMinute) ?? 0
//                realCurrentTime = currentDateTime.addMinute(leadTime) ?? Date()
//            }
//            
//        }else{
//            if let leadTimeMinute = CustomUserDefaults.shared.get(key: .orderLeadTime) as? String {
//                leadTime = Int(leadTimeMinute) ?? 0
//                realCurrentTime = currentDateTime.addMinute(leadTime) ?? Date()
//            }
//        }
//        
//        let openLeadTime = realCurrentTime <= closingDateTime
//        let beforeOpeningTime = realCurrentTime <= openingDateTime
//        let afterClosingTime = realCurrentTime >= closingDateTime
//        checkOrderLeadTime(openLeadTime: openLeadTime,beforeOpeningTime: beforeOpeningTime, afterClosingTime: afterClosingTime)
        
        checkDistanceLeadTime()
        guard let openingTime = restaurantBranch?.opening_time,
              let closingTime = restaurantBranch?.closing_time
        else { return }


        let openingDateTime = self.getDateTime(openingTime)
        let closingDateTime = self.getDateTime(closingTime)
        var realCurrentTime = Date()
        
        realCurrentTime = Calendar.current.date(byAdding: .minute, value: -15, to: currentTime) ?? Date()
        if distance > radius {
            if let leadTimeMinute = CustomUserDefaults.shared.get(key: .leadTimeMinute) as? String {
                leadTime = Int(leadTimeMinute) ?? 0
                realCurrentTime = currentDateTime.addMinute(leadTime) ?? Date()
            }
            
        }else{
            if let leadTimeMinute = CustomUserDefaults.shared.get(key: .orderLeadTime) as? String {
                leadTime = Int(leadTimeMinute) ?? 0
                realCurrentTime = currentDateTime.addMinute(leadTime) ?? Date()
            }
        }
        
        let currentTime = currentDateTime.addMinute(0) ?? Date()
        let openLeadTime = realCurrentTime <= closingDateTime
        let beforeOpeningTime = currentTime <= openingDateTime
        let afterClosingTime = realCurrentTime >= closingDateTime

        
        checkOrderLeadTime(openLeadTime: openLeadTime,beforeOpeningTime: beforeOpeningTime, afterClosingTime: afterClosingTime)

    }
    
    fileprivate func setData() {
        
        if let deliDateTime = CustomUserDefaults.shared.get(key: .deliDateTime) as? String{
            self.deliDateTime = deliDateTime
        }
        lat = Singleton.shareInstance.currentLat
        long = Singleton.shareInstance.currentLong
    }

    
    fileprivate func setupUI() {
        
        if cartOption == .navigation{
            cartTypeStackView.isHidden = true
            heightTopView.constant = 20
        }else{
            cartTypeStackView.isHidden = false
            heightTopView.constant = 60
        }
        if isFromStore == true {
            isStoreOrFood(type: .store, isFood: true, isStore: false)
            tableViewCart.reloadData()

        } else {
            print("is not from store")
            isStoreOrFood(type: .restaurant, isFood: false, isStore: true)
            tableViewCart.reloadData()
        }
        self.tableViewSetUP()
        guard readLogin() != 0 else {
            showNeedToLoginApp()
            return
        }

    }

    fileprivate func isStoreOrFood(type: Cart,isFood: Bool,isStore:Bool){
        cartType = type
        foodBgView.isHidden = isFood
        storeBgView.isHidden = isStore
        if cartType == .store{
            contiuneShopBtn.setTitle("Continue Shops", for: .normal)
        }else{
            contiuneShopBtn.setTitle("Continue Foods", for: .normal)
        }
    }



    //MARK: -- TodayOrderCheckDeliTime function
    fileprivate func checkOrderLeadTime(openLeadTime: Bool,beforeOpeningTime:Bool,afterClosingTime: Bool){
        if beforeOpeningTime{
            canOrderBeforeOpening()
        }else if afterClosingTime{
            canOrderNextDay()
        }else{
            canOrderToday()
        }
    }


    func canOrderToday() {
        let date = Date()
        let d = Date.getDateToStringFormat(formatStyle: "MMM dd", formatDate: date)
        getAfterClosingLeadTime(currentDate: date)
        let curDate = Date.getCurrentDate()
        getTodayLeadTime(currentDate: curDate)
        
        if Singleton.shareInstance.addressChange {
            
            deliLabel.text = "Delivery : \(d) \(deliTime)"
        }else{
            if let deliDateTime = CustomUserDefaults.shared.get(key: .deliDateTime)as? String {
                deliLabel.text = deliDateTime
            }else{
                deliLabel.text = "Delivery : \(d) \(deliTime)"
            }
        }
       
    }

    //MARK: -- canOrderBeforeDayUISetup
    func canOrderBeforeOpening() {
        let date = Date()
        let d = Date.getDateToStringFormat(formatStyle: "MMM dd", formatDate: date)
        let currentDay = Date()
        getAfterClosingLeadTime(currentDate: currentDay)
        let curDate = Date.getCurrentDate()
        getBeforeOpeningLeadTime(currentDate: curDate)
        if Singleton.shareInstance.addressChange {
            deliLabel.text = "Delivery : \(d) \(deliTime)"
        }else{
            if let deliDateTime = CustomUserDefaults.shared.get(key: .deliDateTime)as? String {
                deliLabel.text = deliDateTime
            }else{
                deliLabel.text = "Delivery : \(d) \(deliTime)"
            }
        }

    }

    //MARK: -- canOrderNextDayUISetup
    func canOrderNextDay() {
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let d = Date.getDateToStringFormat(formatStyle: "MMM dd", formatDate:  nextDay )
        let currentDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        getLeadTimeArray.removeAll()
        getAfterClosingLeadTime(currentDate: currentDay)
        print("DeliTime ======>",deliTime)
        if Singleton.shareInstance.addressChange {
            deliLabel.text = "Delivery : \(d) \(deliTime)"
        }else{
            if let deliDateTime = CustomUserDefaults.shared.get(key: .deliDateTime)as? String {
                deliLabel.text = deliDateTime
            }else{
                deliLabel.text = "Delivery : \(d) \(deliTime)"
            }
        }
    }

    private func tableViewSetUP(){
        tableViewCart.dataSource = self
        tableViewCart.delegate = self
    }

    func hideShowDestroyCart(){
        trailingConstraintAddItem.constant = 8
        if cartData?.shop != nil {
            trailingConstraintAddItem.constant = 8
        }
        else if cartData?.restaurant != nil {
            trailingConstraintAddItem.constant = 8
        }
    }

    fileprivate func checkOrderType() {
        if let deliMode = CustomUserDefaults.shared.get(key: .deliMode) as? String {
            if deliMode == "delivery" {
                if deliDateTime == "ASAP" {
                    Singleton.shareInstance.orderType = .instant
                    orderType = .instant
                }else{
                    Singleton.shareInstance.orderType = .schedule
                    orderType = .schedule
                }
            }else{
                Singleton.shareInstance.orderType = .pickup
                orderType = .pickup
            }
        }
    }

    fileprivate func shopUIConfigure() {
        tableViewCart.tableHeaderView = UIView()
        if self.productCartList.count > 0 {
            confirmAddressView.isHidden = false
            totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.shop?.total_amount ?? 0))\(currencySymbol)"
            tableViewCart.isHidden = false
            emptyView.isHidden = true
            btnContinue.backgroundColor = .appColor(.mainColor)
            btnContinue.isUserInteractionEnabled = true
            headerViewRestro.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80)
            self.tableViewCart.tableHeaderView = headerViewRestro
            buttonEdit.isHidden = true
            Singleton.shareInstance.selectedAddress?.township_slug = self.cartData?.shop?.address?.township_slug ?? ""
//            self.checkAddressAlert()
        }
        else {
            confirmAddressView.isHidden = true
            totalAmtLbl.text = "0 MMK"
            tableViewCart.isHidden = true
            emptyView.isHidden = false
            btnContinue.backgroundColor = UIColor.lightGray
            btnContinue.isUserInteractionEnabled = false
            noItemView.dropShadow()
            
        }
        deliLabel.text = "Within 48 hrs"
    }
    
    
    fileprivate func foodUIConfigure() {
        if self.cartData?.restaurant != nil {
            confirmAddressView.isHidden = false
            if self.cartData?.restaurant?.menus?.count ?? 0 > 0{
                totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.restaurant?.total_amount ?? 0.0))\(currencySymbol)"
                headerViewRestro.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80)
                self.tableViewCart.tableHeaderView = headerViewRestro
                buttonEdit.isHidden = false
                buttonEdit.isUserInteractionEnabled = true
                confirmAddressView.isHidden = false
                emptyView.isHidden = true
                btnContinue.backgroundColor = .appColor(.mainColor)
                btnContinue.isUserInteractionEnabled = true
                navigateOption = .cart
                cartDistance = self.cartData?.restaurant?.distance ?? 0.0
                checkOrderType()
                checkLeadTime()
            }
            else {
                confirmAddressView.isHidden = true
                totalAmtLbl.text = "0 MMK"
                tableViewCart.isHidden = true
                emptyView.isHidden = false
                btnContinue.backgroundColor = UIColor.lightGray
                btnContinue.isUserInteractionEnabled = false
                noItemView.dropShadow()
            }
        }
    }
    
    //MARK: -- ResetUI
    func resetUI(){
        print("resetUI")
        if readLogin() != 0 {
            if let type = self.cartType{
                type == .store ? shopUIConfigure() : foodUIConfigure()
            }
        }
    }

    //MARK: - Action Functions
    fileprivate func navigateToPreOrderView() {
        let vc : PreorderViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "PreorderViewController") as! PreorderViewController
        vc.restaurantBranch = self.cartData?.restaurant?.restaurant_branch
        vc.restaurantCart = self.cartData?.restaurant
        vc.preDelegate = self
        vc.promoDelegate = self
        vc.navigateOption = .cart
        vc.isFromCart = true
        vc.cartDistance = self.cartData?.restaurant?.distance ?? 0.0
        if let deliTime = CustomUserDefaults.shared.get(key: .deliTime)as? String {
            vc.navigateDeliTime = deliTime
        }
        if let deliDate = CustomUserDefaults.shared.get(key: .deliDate)as? String {
            if deliDate == "today"{
                vc.navigateDeliDate = .today
            }else if deliDate == "tomorrow"{
                vc.navigateDeliDate = .tomorrow
            }else{
                vc.navigateDeliDate = .thedayaftertomorrow
            }
        }
        if let deliLbl = deliLabel.text?.contains("Delivery") {
            deliLbl == true ? (vc.deliMode = .delivery) : (vc.deliMode = .pickup)
        }
        self.present(vc, animated: true, completion: nil)
    }

    func checkConfirmBtnAction() {
        navigateToPaymentView()
//        if isFromStore {
//            checkAddressNavigate()
//        }else{
//            navigateToPaymentView()
//        }

    }

    func addressAlertAction() {
        self.presentAlertWithTitle(title: warningText, message: addressWarningText, options: cancelText, yesText) { (option) in

            switch(option) {
            case 1:
                if let address = Singleton.shareInstance.selectedAddress {
                    if address.slug == nil {
                        self.navigationController?.pushView(AddAddressRouter())
                    }else{
                        let clLocation = CLLocationCoordinate2D(latitude: Double(address.latitude ?? 0.0), longitude: Double(address.longitude ?? 0.0))
                        let vc = AddAddressRouter.init(userCoordinate: clLocation, address: address, profileData: self.userProfile, slug: address.slug ?? "", fromEdit: true)
                        self.navigationController?.pushView(vc)
                    }
                }else{
                    self.navigationController?.pushView(AddAddressRouter())
                }
                
            default:
                break
            }
        }
    }

    fileprivate func checkAddressNavigate() {
        if Singleton.shareInstance.selectedAddress?.township_slug == ""  {
            addressAlertAction()
        }else{
            navigateToPaymentView()
        }
    }
    
    fileprivate func checkAddressAlert() {
        if self.isFromStore == true{
            if Singleton.shareInstance.selectedAddress?.township_slug == ""  {
                addressAlertAction()
            }
        }
    }


    fileprivate func getDeliDateOption() {
        if let deliDate = CustomUserDefaults.shared.get(key: .deliDate)as? String {
            switch deliDate {
            case "tomorrow":
                Singleton.shareInstance.deliDate = .tomorrow
            case "thedayaftertomorrow":
                Singleton.shareInstance.deliDate = .thedayaftertomorrow
            default:
                Singleton.shareInstance.deliDate = .today
            }
        }
    }
    
    func navigateToPaymentView() {
        Singleton.shareInstance.isBack = false
        if cartType == .restaurant {
            getDeliType()
            getDeliDateOption()
            checkOrderType()
            if let deliTime = CustomUserDefaults.shared.get(key: .deliTime)as? String {
                Singleton.shareInstance.deliTime = deliTime
            }
            print(orderType)
            let vc = ConfirmPlaceOrderRouter(cartType: .restaurant, orderType: orderType,restaurantOrder: cartData?.restaurant ?? RestaurantCart())
            self.navigationController?.pushView(vc)
        }else{
            let vc = ConfirmPlaceOrderRouter(cartType: .store, orderType: .instant,productOrderCart: productCartList,productOrder: self.cartData?.shop ?? ShopCart())
            self.navigationController?.pushView(vc)
        }
        
    }

    @IBAction func changeDeliTime(_ sender: UIButton) {
        navigateToPreOrderView()
    }

    @IBAction func ContinuePaymentViewController(_ sender: UIButton) {
        checkConfirmBtnAction()
    }

    
    @IBAction func back(_ sender: UIButton) {
        delegate?.passData(deliDateTime: deliLabel.text ?? "", restaurantSlug: cartData?.restaurant?.restaurant_branch?.slug ?? "", fromCart: true)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func home(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func storeCart(_ sender: UIButton) {
        cartType = Cart.store
        isFromStore = true
        fromHome = true
        isTappedFromStore = false
        orderType = .instant
        isStoreOrFood(type: .store, isFood: true, isStore: false)
        loadCartData()
        tableViewCart.reloadData()
    }

    @IBAction func foodCart(_ sender: UIButton) {
        cartType = Cart.restaurant
        isFromStore = false
        fromHome = true
        isTappedFromStore = false
        isStoreOrFood(type: .restaurant, isFood: false, isStore: true)
        loadCartData()
        tableViewCart.reloadData()
    }

}

/*******************************STORE***************************/

//MARK: - Store Action Functions
extension CartViewController{
    

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

   
}

//MARK: - API Call Functions STORE
extension CartViewController{
    
    func loadCartData() {
        APIClient.fetchViewCart().execute { data in
            if data.status == 200 {
                self.cartData = data.data as? CartData
                //restaurant
                self.restaurantCart = self.cartData?.restaurant
                self.resPromocode = self.cartData?.restaurant?.promocode ?? ""
                self.restaurantBranchCart = self.cartData?.restaurant?.restaurant_branch
                self.restaurantBranch = self.cartData?.restaurant?.restaurant_branch
              
                
                //product
                let shopCart = self.cartData?.shop
                self.cartAddress = shopCart?.address
                self.shopPoromocode = self.cartData?.shop?.promocode ?? ""
                Singleton.shareInstance.promoCode = self.shopPoromocode
                self.productCartList = []

                if let shopCount = shopCart?.shops?.count , shopCount > 0 {
                    for i in 0..<shopCount{
                        if let productCartCount = shopCart?.shops?[i].productCarts?.count , productCartCount > 0 {
                            for j in 0..<productCartCount {
                                var productCart = shopCart?.shops?[i].productCarts?[j]
                                productCart?.shopName = shopCart?.shops?[i].name
                                productCart?.shopSlug = shopCart?.shops?[i].slug
                                self.productCartList.append(productCart ?? ProductCart())
                            }
                        }

                    }
                }

                print("product cart list count = " , self.productCartList.count)
                self.resetUI()
                self.changeCartBadgeNumber()
                self.tableViewCart.reloadData()
            }else{
                if data.message == "Unauthenticated." {
                    self.unAuthenticatedOptoin(toastMessage: data.message ?? "")
                }else{
                    self.presentAlert(title: "Warning!", message: data.message ?? "")
                }
            }
        } onFailure: { error in
            print(error.localizedDescription)
        }

    }

    func changeCartBadgeNumber() {
        var menusOrderCount = 0
        if let menuCount = cartData?.restaurant?.menus?.count, menuCount > 0 {
            for i in 0..<menuCount {
                menusOrderCount += cartData?.restaurant?.menus?[i].quantity ?? 0
            }
        }

        var productOrderCount = 0
        if let shopcount = cartData?.shop?.shops?.count, shopcount > 0 {
            for i in 0..<shopcount {
                let product = cartData?.shop?.shops?[i].productCarts
                for j in 0..<Int(product?.count ?? 0) {
                    productOrderCount += product?[j].quantity ?? 0
                }

            }
        }

        let totalCount = menusOrderCount + productOrderCount

        switch totalCount {
        case 0: tabBarItem?.badgeValue = nil
        case 1...10: tabBarItem?.badgeValue = "\(totalCount)"
        case let x where x > 10: tabBarItem?.badgeValue = "10+"
        default: break
        }

    }

    func prepareForParam() {

        if Singleton.shareInstance.selectedAddress != nil {
            print("nearest address is not nil")
            addressItem["house_number"] = Singleton.shareInstance.selectedAddress?.house_number
            addressItem["floor"] = Singleton.shareInstance.selectedAddress?.floor
            addressItem["street_name"] = Singleton.shareInstance.selectedAddress?.street_name
            addressItem["latitude"] = Singleton.shareInstance.selectedAddress?.latitude
            addressItem["longitude"] = Singleton.shareInstance.selectedAddress?.longitude
        }


        userProfile = Singleton.shareInstance.userProfile

        user["customer_name"] = userProfile?.name
        user["phone_number"] = userProfile?.phone_number

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currentDate = Date.getCurrentDateTime()

        formatter.dateFormat =  "yyyy-MM-dd"
        var d = ""

        switch Singleton.shareInstance.deliDate {
        case .today:
            formatter.calendar = Calendar(identifier: .gregorian)
            d = formatter.string(from: Date())
        case .tomorrow:
            formatter.calendar = Calendar(identifier: .gregorian)
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
        case .thedayaftertomorrow:
            formatter.calendar = Calendar(identifier: .gregorian)
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())
        }

        let t = getTimeFormat(deliTime: Singleton.shareInstance.deliTime)

        if Singleton.shareInstance.willdeli != DeliveryMode.delivery {
            orderType = OrderType.pickup
        }
        
        chooseDateTime = "\(d) \(t)"

        print("current date = " , currentDate)
        print("choose date = ", chooseDateTime)

    }
    
    
    func getDeliType() {
        if deliDateTime.contains("Pick up") {
            Singleton.shareInstance.willdeli = .pickup
        }else{
            Singleton.shareInstance.willdeli = .delivery
        }
        
    }
    

}

//MARK: - API Call Functions Restaurants
extension CartViewController{

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
            }
            else {
                DEFAULTS.set(false, forKey: UD_isContainAdd)
            }

        }) { (reason, statusCode) in
            self.hideHud()
        }
    }

}


//MARK: - Restro Action Functions
extension CartViewController{

    func addItemInRestroCart() {

        let type = self.cartType

        if isTappedFromStore && fromDetail {
            _ = navigationController?.popViewController(animated: true)
        }
        else if type == Cart.restaurant , let restroID = cartData?.restaurant?.restaurant_branch?.slug{
            let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
            vc.slug = restroID
            vc.fromCart = true
            vc.showDeliDate = deliDateTime
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else {
            let vc : VC_Store = storyboardStore.instantiateViewController(withIdentifier: "VC_Store") as! VC_Store
            vc.fromCart = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func destroyRestroCart(_ sender: UIButton) {

        presentAlertWithTitle(title: warningText, message: destroyCartAlertText, options: "Cancel", yesText) { (option) in

            switch(option) {
            case 1:
                self.destroyRestroCart()
            default:
                break
            }
        }

    }

    @IBAction func continueShoppingTap(_ sender: UIButton){
        if isFromStore == true{
            chooseShopOption()
        }else{
            chooseFoodOption()
        }
    }

}


extension CartViewController: ChooseOpationDelegate {
    func chooseFoodOption() {
        let vc : VC_Restaurant = storyboardRestaurant.instantiateViewController(withIdentifier: "VC_Restaurant") as! VC_Restaurant
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func chooseShopOption() {
        let vc : VC_Store = storyboardStore.instantiateViewController(withIdentifier: "VC_Store") as! VC_Store
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

/**************************************************************/

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension CartViewController : UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {

        tableView.isHidden = true

        if self.productCartList.count > 0 && isFromStore {
            tableView.isHidden = false
            return 4
        }else if self.cartData?.restaurant != nil && self.cartData?.restaurant?.menus?.count ?? 0 > 0 && !isFromStore{
            tableView.isHidden = false
            return 4
        }
        else {
            emptyView.isHidden = false
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.productCartList.count > 0 && isFromStore{

            if section == 0{
                print("product cart list = ", productCartList.count)
                return self.productCartList.count
            }
            else {
                return 1
            }
        }
        else if self.cartData?.restaurant != nil && !isFromStore{
            if section == 0{
                return self.cartData?.restaurant?.menus?.count ?? 0
            }
            else {
                return 1
            }

        }


        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.productCartList.count > 0 && isFromStore{

            if indexPath.section == 0{

                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Store_Cart_Product") as! Cell_Store_Cart_Product
                cell.selectionStyle = .none
                cell.controller = self
                cell.setData(productCart: productCartList[indexPath.row])

                cell.buttonPlus.tag = indexPath.row
                cell.buttonMinus.tag = indexPath.row
                cell.buttonRemoveItem.tag = indexPath.row
                return cell
            }
            else if indexPath.section == 1{
                if (indexPath.row == 0){
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Store_Cart_Billing") as! Cell_Store_Cart_Billing
                    cell.selectionStyle = .none
                    cell.controller = self
                    cell.setData(shopCart: self.cartData?.shop ?? ShopCart())
                    return cell
                }
            }
        }

        else if self.cartData?.restaurant != nil && !isFromStore {

            if indexPath.section == 0{

                let cell : Cell_TV_Restro_Cart_Item = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Restro_Cart_Item") as! Cell_TV_Restro_Cart_Item
                cell.selectionStyle = .none
                cell.controller = self
                cell.deleteDelegate = self
                cell.labelRestname.text = self.cartData?.restaurant?.restaurant?.name

                if let item = self.cartData?.restaurant?.menus?[indexPath.row]{
                    cell.setData(cartItem: item)
                    cell.menu = item
                    cell.labelItemQty.text = item.quantity?.description
                }

                if indexPath.row == 0 {
                    cell.headerView.isHidden = false
                }
                else {
                    cell.headerView.isHidden = true
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
                    cell.controller = self
                    cell.promoDelegate = self
                    cell.totalDelegate = self

                    if let restroCart = self.cartData?.restaurant{
                        cell.setData(restaurant: restroCart)
                    }

                    return cell
                }
            }

        }
        if indexPath.section == 2{

            if (indexPath.row == 0){
                let cell : Cell_TV_Continue = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Continue") as! Cell_TV_Continue
                cell.controller = self
                cell.selectionStyle = .none
                return cell
            }
        }

        else if indexPath.section == 3{

            if (indexPath.row == 0){
                let cell : Cell_TV_Promo = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Promo") as! Cell_TV_Promo
                cell.controller = self
                cell.isStore = productCartList.count > 0 && isFromStore
                cell.configuretextField()
                cell.checkPromo(resPromoCode: resPromocode, shopPromoCode: shopPoromocode)
                cell.selectionStyle = .none
                return cell
            }
        }

        return UITableViewCell()
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.cartData?.restaurant != nil && !isFromStore &&  indexPath.section == 0 {
//            return calculateHeightForResturantItemCell(at: indexPath)
//        }
        return UITableView.automaticDimension
    }

    private func calculateHeightForResturantItemCell(at indexPath: IndexPath) -> CGFloat {
        let extraChargeCount = self.cartData?.restaurant?.menus?[indexPath.row].variant?.extra_charges
        var height = 0.0
        if extraChargeCount?.count ?? 0 > 1{
            height = 200
        }else{
            height = 150
        }
        var totalHeight: CGFloat = height
        let item = self.cartData?.restaurant?.menus?[indexPath.row]

        var textForVariant = ""
        if let itemVariant = item?.variant?.variant {
            let variants = itemVariant.compactMap { $0.value }
            let variantText = variants.joined(separator: "\n")
            textForVariant += variantText
        }
        if let itemTopinngs = item?.toppings,
           itemTopinngs.count > 0 {
            textForVariant += "\n"
            let toppings = itemTopinngs.compactMap{ $0.name }
            let toppingText = toppings.joined(separator: ", ")
            textForVariant += toppingText
        }
        if let menuOptions = item?.options,
           menuOptions.count > 0 {
            textForVariant += "\n"
            let options = menuOptions.compactMap{ $0.name }
            let optionsText = options.joined(separator: ", ")
            textForVariant += optionsText
        }

        let cellHeight = textForVariant.height(withConstrainedWidth: UIScreen.main.bounds.width - 48, font: UIFont(name: "Lexend-Regular", size: 15)!)

        if textForVariant != "" {
            totalHeight += cellHeight + 16
        }

        if indexPath.row == 0 {
            totalHeight += 50
        }

        return totalHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}



extension CartViewController : PromoProductDelegate {

    func validatePromoProduct(promo: String, completion: @escaping (Bool) -> Void) {
        prepareProductParam(promo: promo)
        applyPromo(promo: promo, completion: completion)
    }


}

extension CartViewController: PromoRestaurantDelegate {

    func validatePromoRestaurant(promo: String, completion: @escaping (Bool) -> Void) {
        prepareRestaurantParam(promo: promo)
        applyPromo(promo: promo, completion: completion)
    }

    func validatePromoRestaurantNoAlert(promo: String, completion: @escaping (Bool) -> Void) {
        prepareRestaurantParam(promo: promo)
        checkPromo(promo: promo, completion: completion)
    }

}


extension CartViewController {

    func prepareProductParam(promo: String) {

        promocode = promo

        prepareForParam()

        product_param = ["customer_slug": userProfile?.slug ?? "",
                         "order_date": currentDate,
                          "special_instruction": special_instruction,
                          "payment_mode": paymentMode.caseValue,
                          "delivery_mode": "delivery",
                         "order_type" : orderType.caseValue,
                          "promo_code": promo,
                          "address": addressItem,
                          "customer_info": user,
                         "source": "ios",
        ]
    }

    func prepareRestaurantParam(promo: String) {

        promocode = promo

        prepareForParam()

        restaurant_param = [
            "customer_slug": userProfile?.slug ?? "",
            "order_date": chooseDateTime,
            "special_instruction": special_instruction,
            "payment_mode": paymentMode.caseValue,
            "order_type" : orderType.caseValue,
            "customer_info": user,
            "address": addressItem,
            "source": "ios",

        ]
        print("param == " , restaurant_param)
    }

    func applyPromo(promo: String,  completion: @escaping (Bool) -> Void) {

        let param: [String: Any] = ["customer_slug": self.userProfile?.slug ?? "", "promo_code" : promo,"order_type": orderType.caseValue]

        print(param)
        let url = isFromStore ? APIEndPoint.productPromo.caseValue : APIEndPoint.restaurantPromo.caseValue

        APIUtils.APICall(postName: "\(url)", method: .post,  parameters: param, controller: self, onSuccess: { (response) in

            print(response)

            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int


            if status == 200 {
                let promo = data.value(forKey: "data") as! NSDictionary
                let promotion = promo["promo_amount"] as? Double
                let total_amount = promo["total_amount"] as? Double

                if self.isFromStore {
                    self.cartData?.shop?.promo_amount = promotion
                    self.cartData?.shop?.total_amount = total_amount
                    self.totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.shop?.total_amount ?? 0))\(currencySymbol)"
                }
                else {
                    self.cartData?.restaurant?.promo_amount = promotion
                    self.cartData?.restaurant?.total_amount = total_amount
                    self.totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.restaurant?.total_amount ?? 0))\(currencySymbol)"
                }

                self.appliedPromoMenu = true

                let indexPath = IndexPath(row: 0, section: 1)
                self.loadCartData()
                self.tableViewCart.beginUpdates()
                self.tableViewCart.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableViewCart.endUpdates()

                self.promoUse = true
                completion(true)
                var style = ToastStyle()
                // this is just one of many style options
                style.messageColor = .white
                style.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                self.view.makeToast("You use promocode.", duration: 1.0, position: .center,style: style)

            }
            else{
                let message = data[key_message] as? String
                completion(false)
                self.presentAlert(title: errorText, message: message ?? "Invalid Promocode")
            }

        }) { (reason, statusCode) in
            self.hideHud()
        }
    }

    func checkPromo(promo: String,  completion: @escaping (Bool) -> Void){
        let param: [String: Any] = ["customer_slug": self.userProfile?.slug ?? "", "promo_code" : promo,"order_type": orderType.caseValue]


        let url = isFromStore ? APIEndPoint.productPromo.caseValue : APIEndPoint.restaurantPromo.caseValue

        APIUtils.APICall(postName: "\(url)", method: .post,  parameters: param, controller: self, onSuccess: { (response) in

            print(response)

            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int


            if status == 200 {
                let promo = data.value(forKey: "data") as! NSDictionary
                let promotion = promo["promo_amount"] as? Double
                let total_amount = promo["total_amount"] as? Double

                if self.isFromStore {
                    self.cartData?.shop?.promo_amount = promotion
                    self.cartData?.shop?.total_amount = total_amount
                    self.totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.shop?.total_amount ?? 0))\(currencySymbol)"
                }
                else {
                    self.cartData?.restaurant?.promo_amount = promotion
                    self.cartData?.restaurant?.total_amount = total_amount
                    self.totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.restaurant?.total_amount ?? 0))\(currencySymbol)"
                }

                self.appliedPromoMenu = true

                let indexPath = IndexPath(row: 0, section: 1)
                self.loadCartData()
                self.tableViewCart.beginUpdates()
                self.tableViewCart.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableViewCart.endUpdates()

                self.promoUse = true
                completion(true)
            }
            else{
                completion(false)
            }

        }) { (reason, statusCode) in
            self.hideHud()
        }
    }

    func removePromoWithNoAlert(isStore: Bool, completion: @escaping (Bool) -> Void){
        self.removePromocode(isStore: isStore, completion: completion)
    }

    func removePromoMenu(isStore: Bool, completion: @escaping (Bool) -> Void) {
        self.presentAlertWithTitle(title: "Are You Sure", message: deletePromopromptText, options: noText, yesText) { (option) in
            switch(option) {
                case 1:
                self.removePromocode(isStore: isStore, completion: completion)
                default:
                    break
            }
        }

    }


    func removePromocode(isStore: Bool, completion: @escaping (Bool) -> Void) {
        let param: [String: Any] = ["customer_slug": self.userProfile?.slug ?? ""]
        let api = isStore ? "\(APIEndPoint.productPromo.caseValue)": "\(APIEndPoint.restaurantCart.caseValue)/promocode"

        APIUtils.APICall(postName: api, method: .delete,  parameters: param, controller: self, onSuccess: { (response) in

            print(response)

            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int


            if status == 200 {
                self.appliedPromoMenu = false

                let promo = data.value(forKey: "data") as! NSDictionary
                let promotion = promo["promo_amount"] as? Double
                let total_amount = promo["total_amount"] as? Double
                if isStore {
                    self.cartData?.shop?.promo_amount = promotion
                    self.cartData?.shop?.total_amount = total_amount
                    self.totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.shop?.total_amount ?? 0))\(currencySymbol)"
                } else {
                    self.cartData?.restaurant?.promo_amount = promotion
                    self.cartData?.restaurant?.total_amount = total_amount//((total_amount ?? "") as NSString).integerValue
                    self.totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.restaurant?.total_amount ?? 0))\(currencySymbol)"
                }

                let indexPath = IndexPath(row: 0, section: 1)
                self.loadCartData()
                self.tableViewCart.beginUpdates()
                self.tableViewCart.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableViewCart.endUpdates()
                self.promoUse = false
                completion(true)
            }

            else{

                self.product_param.updateValue("", forKey: "promo_code")

                let message = data[key_message] as? String
                self.presentAlert(title: errorText, message: message ?? "Invalid Promocode")
                completion(false)
            }

        }) { (reason, statusCode) in
            self.hideHud()
        }
    }

}

//MARK: -- Delegat
extension CartViewController: PreorderDelegate ,PromoDelegate,TotalDelegate {

    func didChange(data: String, deliMode: DeliveryMode, deliDate: DeliveryDate, deliTime: String) {
        deliLabel.text = data
        deliDateTime = data
        Singleton.shareInstance.deliDate = deliDate
        Singleton.shareInstance.deliTime = deliTime
        Singleton.shareInstance.willdeli = deliMode
        Singleton.shareInstance.showDateTime = data
        self.saveToUserDefault(deliTime: deliTime, deliDateTime: data, deliMode: deliMode, deliDate: deliDate)

        tableViewCart.reloadSections(IndexSet(integer: 1), with: .none)

        if Singleton.shareInstance.willdeli == DeliveryMode.pickup {
            let new = Double(self.cartData?.restaurant?.total_amount ?? 0) - Double(self.cartData?.restaurant?.delivery_fee ?? 0)
            self.totalAmtLbl.text = "\(self.priceFormat(pricedouble: new))\(currencySymbol)"
            self.tableViewCart.reloadSections(IndexSet(integer: 3), with: .none)

        }
        else {
            totalAmtLbl.text = "\(self.priceFormat(pricedouble: self.cartData?.restaurant?.total_amount ?? 0.0))\(currencySymbol)"

        }
        if Singleton.shareInstance.willdeli == DeliveryMode.pickup && !isFromStore{
            validatePromoRestaurantNoAlert(promo: resPromocode) { success in
                print(success)
                self.loadCartData()
                self.tableViewCart.reloadSections(IndexSet(integer: 3), with: .none)
            }
        }else{
            self.orderType = .instant
            self.loadCartData()
            self.tableViewCart.reloadSections(IndexSet(integer: 3), with: .none)
        }
    }

    func getTotal(totalAmt: String) {
        totalAmtLbl.text = totalAmt
    }

}

extension CartViewController: DeleteSuccessOptionDelegate {
    
    func deleteSucess(option: Bool) {
        if option == true {
            self.loadCartData()
            self.resetUI()
            self.tableViewCart.reloadData()
            self.totalAmtLbl.text = "0 MMK"
        }
    }
    
    
}
