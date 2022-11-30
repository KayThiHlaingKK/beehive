//
//  RestaurantDetailViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 09/07/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import Cosmos
import Alamofire
import CoreLocation
import SwiftLocation

protocol DataPassDelegate {
    func dataPass(DeliDate: DeliveryDate, deliTime: String)
}


class RestaurantDetailViewController: LeadTimeViewController {

    //MARK: - IBOutlets
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableViewFoodsDetails: UITableView!

    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var imageViewRestroBanner: UIImageView!
    @IBOutlet weak var imageViewRestroLogo: UIImageView!
    @IBOutlet weak var labelRestroName: UILabel!

    @IBOutlet weak var collectionViewCuisine : UICollectionView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var collapsingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var spaceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var changeDeliView: UIView!
    @IBOutlet weak var hrLbl: UILabel!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var headerView2: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showDeliLbl: UILabel!
    @IBOutlet weak var openingHourLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    let search = UISearchController(searchResultsController: nil)
    var restaurantID : Int?
    var available_categories : [Available_categories] = [Available_categories]()
    var fromCart = false
    var restroCart : RestroCart?
    var slug: String = ""
    var restaurantSlug: String = ""
    var showDeliDate = ""
    var preDelegate: PreorderDelegate!

//    private var lastContentOffset: CGFloat = 0.0
    var chooseMenu : Available_menus?
    var menuVariants = [Variant]()
    var roomNote = 0

    var deliMode = DeliveryMode.delivery
    var deliDate = DeliveryDate.today
    var clickHeader = false
    var collectionId = -1
    var firstClick = true
    let date = Date()
    var index = 0
    var realOpeningDate = ""
    var currentDateTime = Date()
    var currentTime = Date()


    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.loadReastaurantItems(slug: self.slug)
        
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        isUserLoginOrNot()
        if isAddressChange {
            self.loadReastaurantItems(slug: self.slug)
        }

    }


    //MARK: -- SetupUI
    func setupUI(){
        isUserLoginOrNot()
        titleLbl.isHidden = true
        self.showHud(message: loadingText)
        tableViewFoodsDetails.isHidden = true
        isUserLoginOrNot()
        self.tableViewAndCollectionViewsetUp()

        print("screen width = " , UIScreen.main.bounds.width * 0.3)
        self.collapsingViewHeightConstraint.constant = 250.0 + UIScreen.main.bounds.width * 0.3
        spaceHeightConstraint.constant = 0
        self.view.layoutIfNeeded()
        print("width = " , self.collapsingViewHeightConstraint.constant)

        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(changeDeliTime(tapGestureRecognizer:)))
        deliveryView.isUserInteractionEnabled = true
        deliveryView.addGestureRecognizer(tapGestureRecognizer1)
        cleanPreorder()

    }

    //hideDeliView
    func hideChangeDeliView() {
        changeDeliView.isHidden = true
    }

    //TableViewCollectionView Setup
    private func tableViewAndCollectionViewsetUp(){
        tableViewFoodsDetails.dataSource = self
        tableViewFoodsDetails.delegate = self
        tableViewFoodsDetails.register(UINib(nibName: "Cell_Store_Product_Header", bundle: nil), forCellReuseIdentifier: "Cell_Store_Product_Header")
        collectionViewSetUP()
    }

    //SetData
    func setData(restaurant:RestaurantBranch){
        var imagePathBanner: String? = nil
        var fileName: String? = nil
        if restaurant.restaurant?.covers?.count ?? 0 > 0 {
            imageViewRestroBanner.setIndicatorStyle(.gray)
            imageViewRestroBanner.setShowActivityIndicator(true)

            imagePathBanner = restaurant.restaurant?.covers?[0].url
            fileName = restaurant.restaurant?.covers?[0].file_name
        }
        else if restaurant.restaurant?.images?.count ?? 0 > 0{
            imageViewRestroBanner.setIndicatorStyle(.gray)
            imageViewRestroBanner.setShowActivityIndicator(true)

            imagePathBanner = "\(restaurant.restaurant?.images?[0].url ?? "")?size=medium)"
            fileName = restaurant.restaurant?.images?[0].file_name
        }

        imageViewRestroBanner.downloadImage(url: imagePathBanner, fileName: fileName, size: .medium)

        var imagePathLogo = ""
        if let images = restaurant.restaurant?.images,
           images.count > 0 {
            imagePathLogo = "\(images.first?.url ?? "")?size=thumbnail"
            imageViewRestroLogo.downloadImage(url: imagePathLogo, fileName: images.first?.file_name, size: .xsmall)
        }

        let name = "\(restaurant.restaurant?.name ?? "") (\(restaurant.name ?? ""))"
        labelRestroName.text = name
        titleLbl.text = name.trunc(length: 35)

        Singleton.shareInstance.isFavourite = restaurant.restaurant?.is_favorite ?? false

        hrLbl.text = restaurantBranch?.delivery_time
        let tip: Double = restaurantBranch?.distance ?? 0.0
        let tipText: String = String(format: "%.2f", tip)
        kmLbl.text = "\(tipText) km"
        let rating: Double = restaurantBranch?.restaurant?.rating ?? 0.0
        ratingLabel.text = String(rating)

    }

    func processItemsData(categories:[Available_categories], restroCart:RestroCart){
        self.tableViewFoodsDetails.reloadData()
    }

    //MARK: -- setupOpeningHour UISetup
    private func setupOpeningHourLabel(todayOrTommorrow: String) {
        var openingTimeString = ""

        openingTimeString +=  todayOrTommorrow

        guard let openingHourString = restaurantBranch?.opening_time else { return }
        openingTimeString += getHourString(openingHourString)


        guard let closingHourString = restaurantBranch?.closing_time else { return }
        openingTimeString += " - \(getHourString(closingHourString))"
//        print(getClosingHourString(closingHourString))

        openingHourLabel.text = "Opening Hour : \(openingTimeString)"
    }

    //MARK: -- CheckDeliTime Function

    fileprivate func checkLeadTime() {
        checkDistanceLeadTime()
        guard let openingTime = restaurantBranch?.opening_time,
              let closingTime = restaurantBranch?.closing_time
        else { return }


        let openingDateTime = self.getDateTime(openingTime)
        let closingDateTime = self.getDateTime(closingTime)
        var realCurrentTime = Date()
        
        if self.deliMode == .pickup {
            realCurrentTime = Calendar.current.date(byAdding: .minute, value: 0, to: currentTime) ?? Date()
        }else{
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
            
        }
        
        let currentTime = currentDateTime.addMinute(0) ?? Date()
        let openLeadTime = realCurrentTime <= closingDateTime
        let beforeOpeningTime = currentTime <= openingDateTime
        let afterClosingTime = realCurrentTime >= closingDateTime

        
        checkOrderLeadTime(openLeadTime: openLeadTime,beforeOpeningTime: beforeOpeningTime, afterClosingTime: afterClosingTime)

    }


    //MARK: -- TodayOrderCheckDeliTime function
    fileprivate func checkOrderLeadTime(openLeadTime: Bool,beforeOpeningTime:Bool,afterClosingTime: Bool){
        if beforeOpeningTime{
            todayDeliTimeBeforeOpening()
        }else if afterClosingTime{
            nextDayOrderCheckDeliTime()
        }else{
            todayOrderCheckDeliTime()
        }
    }

   fileprivate func todayOrderCheckDeliTime(){
       checkDistanceLeadTime()
       let date = Date()
       getAfterClosingLeadTime(currentDate: date)
       let curDate = Date.getCurrentDate()
       getTodayLeadTime(currentDate: curDate)
       setupOpeningHourLabel(todayOrTommorrow: "Today ")
       canOrderToday()

    }


    //MARK: -- nextOrderCheckDeliTime function
    fileprivate func nextDayOrderCheckDeliTime(){
        checkDistanceLeadTime()
        let currentDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        getAfterClosingLeadTime(currentDate: currentDay)
        setupOpeningHourLabel(todayOrTommorrow: "Tomorrow ")
        canOrderNextday()
    }

    //MARK: -- BeforeOpeningTime function
    fileprivate func todayDeliTimeBeforeOpening(){
        checkDistanceLeadTime()
        let currentDay = Date()
        getAfterClosingLeadTime(currentDate: currentDay)
        let curDate = Date.getCurrentDate()
        getBeforeOpeningLeadTime(currentDate: curDate)
        setupOpeningHourLabel(todayOrTommorrow: "Today ")
        canOrderBeforeOpening()
    }

   //MARK: -- canOrderTodayUISetup
    func canOrderToday() {
        let date = Date()
        let d = Date.getDateToStringFormat(formatStyle: "MMM dd", formatDate: date)
        if fromCart {
            showDeliLbl.text = showDeliDate
        }else{
            if deliTime == "ASAP"{
                if deliMode == .delivery{
                    showDeliLbl.text = "Delivery : \(deliTime)(45m)"
                    Singleton.shareInstance.showDateTime = "Delivery : \(d) \(deliTime)"
                }else{
                    showDeliLbl.text = "Pickup : \(deliTime)(45m)"
                    Singleton.shareInstance.showDateTime = "Pickup : \(d) \(deliTime)"
                }
            }else{
                if deliMode == .delivery{
                    showDeliLbl.text = "Delivery : \(d) \(deliTime)"
                    Singleton.shareInstance.showDateTime = "Delivery : \(d) \(deliTime)"
                }else{
                    showDeliLbl.text = "Pickup : \(d) \(deliTime)"
                    Singleton.shareInstance.showDateTime = "Pickup : \(d) \(deliTime)"
                }
            }

        }
        
         //"Delivery : ASAP"
        Singleton.shareInstance.deliTime = deliTime
        Singleton.shareInstance.deliDate = DeliveryDate.today
        Singleton.shareInstance.willdeli = DeliveryMode.delivery
    }

    //MARK: -- canOrderBeforeDayUISetup
    func canOrderBeforeOpening() {
        let date = Date()
        let d = Date.getDateToStringFormat(formatStyle: "MMM dd", formatDate: date)

        if fromCart {
            showDeliLbl.text = showDeliDate
        }else{
            if deliMode == .delivery{
                showDeliLbl.text = "Delivery : \(d) \(deliTime)"
                Singleton.shareInstance.showDateTime = "Delivery : \(d) \(deliTime)"
            }else{
                showDeliLbl.text = "Pickup : \(d) \(deliTime)"
                Singleton.shareInstance.showDateTime = "Pickup : \(d) \(deliTime)"
            }
        }
         //"Delivery : ASAP"
        Singleton.shareInstance.deliTime = deliTime
        Singleton.shareInstance.deliDate = DeliveryDate.today
        Singleton.shareInstance.willdeli = DeliveryMode.delivery
    }

    //MARK: -- canOrderNextDayUISetup
    func canOrderNextday() {
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let d = Date.getDateToStringFormat(formatStyle: "MMM dd", formatDate:  nextDay )
        print("DeliTime ======>",deliTime)
        
        if fromCart {
            showDeliLbl.text = showDeliDate
        }else{
            if deliMode == .delivery{
                showDeliLbl.text = "Delivery : \(d) \(deliTime)"
                Singleton.shareInstance.showDateTime = "Delivery : \(d) \(deliTime)"
            }else{
                showDeliLbl.text = "Pickup : \(d) \(deliTime)"
                Singleton.shareInstance.showDateTime = "Pickup : \(d) \(deliTime)"
            }
        }
        Singleton.shareInstance.deliTime = deliTime
        Singleton.shareInstance.deliDate = DeliveryDate.tomorrow
        Singleton.shareInstance.willdeli = DeliveryMode.delivery
    }

    func checkSize(){
        var size = 0
        let count = self.restaurantBranch?.available_categories?.count ?? 0
        for i in 0..<count {
            let menucount = self.restaurantBranch?.available_categories?[i].menus?.count ?? 0
            size = menucount + size
        }
        if size < 3 {
            self.tableViewFoodsDetails.isScrollEnabled = false
        }
    }
    
    //ChangeDeliTime
    @objc func changeDeliTime(tapGestureRecognizer: UITapGestureRecognizer){
        let vc : PreorderViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "PreorderViewController") as! PreorderViewController
        if let deliLbl = showDeliLbl.text?.contains("Delivery") {
            deliLbl == true ? (vc.deliMode = .delivery) : (vc.deliMode = .pickup)
        }
//        vc.deliDate = Singleton.shareInstance.deliDate
        vc.restaurantBranch = self.restaurantBranch
        vc.preDelegate = self
        if fromCart{
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
        }else{
            vc.navigateDeliTime = deliTime
            vc.navigateDeliDate = deliDate
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    

    @IBAction func back(_ sender: UIButton) {
        cleanPreorder()
//        let controllerToBeReached = navigationController!.viewControllers.filter { $0 is VC_Restaurant }.first
//        navigationController!.popToViewController(controllerToBeReached, animated: false)
        self.navigationController?.popViewController(animated: true)
    }

    func cleanPreorder() {
        print("cleanpreorder")
        Singleton.shareInstance.showDateTime = ""
        Singleton.shareInstance.deliDate = DeliveryDate.today
        Singleton.shareInstance.deliTime = ""
        Singleton.shareInstance.willdeli = DeliveryMode.delivery

    }

    @IBAction func cart(_ sender: UIButton) {
        if readLogin() != 0
        {
            guard let vc : CartViewController = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
                return
            }
            vc.cartType = Cart.restaurant
            vc.restaurantBranch = self.restaurantBranch
            vc.cartOption = .navigation
            vc.navigateOption = .cart
            vc.fromHome = false
            vc.isTappedFromStore = true
            vc.isFromStore = false
            vc.fromDetail = true
            vc.delegate = self
            isRemove = false
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            self.showNeedToLoginApp()

        }
    }

    @IBAction func home(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnFavourite(_ sender: UIButton) {

        if readLogin() != 0 {
            if !Singleton.shareInstance.isFavourite {
                favouriteProductApi(method: .post)
            } else {
                favouriteProductApi(method: .delete)
            }

        } else {
            self.showNeedToLoginApp()
        }
    }


    func favouriteProductApi(method: HTTPMethod) {

        let param : [String:Any] = [:]

        let apiStr = "\(APIEndPoint.restaurant.caseValue)\(restaurantSlug)/\(favorites)"

        print(apiStr)
        APIUtils.APICall(postName: apiStr, method: method, parameters: param, controller: nil) { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int

            if status == 200 {
                if method == .post {
                    self.btnFavourite.setImage(#imageLiteral(resourceName: "heart Favourite"), for: .normal)
                } else {
                    self.btnFavourite.setImage(#imageLiteral(resourceName: "heart Unfavourite"), for: .normal)
                }
                Singleton.shareInstance.isFavourite = !Singleton.shareInstance.isFavourite
            } else {
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }

        } onFailure: { (reason, statusCode) in
            self.hideHud()
        }


    }

    func isUserLoginOrNot(){
        if readLogin() != 0 {
           loadRestaurantCart()
        }
        else
        {
           labelCartCount.isHidden = true
       }
   }

   func loadRestaurantCart() {
       let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
       APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in

           let data = response as! NSDictionary
           let status = data.value(forKey: key_status) as? Int
           if status == 200 {

               if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                   APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cart.caseValue, modelName: "Cart", onSuccess: { (anyData) in
                       let cartData = anyData as? CartData

                       var rescount = 0
                       if let menuCount = cartData?.restaurant?.menus?.count, menuCount > 0 {
                           for i in 0..<menuCount {
                               rescount += cartData?.restaurant?.menus?[i].quantity ?? 0
                           }
                       }

                       if rescount > 0 {
                           self.labelCartCount.isHidden = false

                           if rescount > 10{
                               self.labelCartCount.text = "10+"
                           }
                           else {
                               self.labelCartCount.text = "\(rescount)"
                           }
                       }
                       else {
                           self.labelCartCount.isHidden = true
                       }

                   }) { (error, endPoint) in
                       print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                   }
               }

           }else{

           }
       }) { (reason, statusCode) in
       }
   }

    func loadReastaurantItems(slug:String){

        let param : [String:Any] = [:]
        var lat = 0.0
        var long = 0.0

        if Singleton.shareInstance.selectedAddress?.latitude != nil {
            lat = Singleton.shareInstance.selectedAddress?.latitude ?? 0.0
            long = Singleton.shareInstance.selectedAddress?.longitude ?? 0.0
        }
        else {
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantsDetail.caseValue)/\(slug)/\(APIEndPoint.getMenu.caseValue)?lat=\(lat)&lng=\(long)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in

            print("response = ", response)
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int

            if status == 200 {
                if let restaurant = data.value(forKeyPath: "data") as? NSDictionary{
                    APIUtils.prepareModalFromData(restaurant, apiName: APIEndPoint.restaurantsDetail.caseValue, modelName:"Restaurant", onSuccess: { (anyData) in

                        self.hideHud()

                        DispatchQueue.main.async {
                            self.restaurantBranch = anyData as? RestaurantBranch
                            restaurantBranchForCart = anyData as? RestaurantBranch
                            if let restro = self.restaurantBranch{
                                self.checkLeadTime()
                                self.setData(restaurant: restro)
                                self.available_categories = restro.available_categories ?? []
                                if restro.available_categories?.count ?? 0 > 0 {
                                    self.available_categories[0].selected = true
                                }
                                self.tableViewFoodsDetails.isHidden = false
                                self.tableViewFoodsDetails.reloadData()
                                self.collectionViewCuisine.reloadData()
                                self.checkSize()
                            }

                        }

                    }) { (error, endPoint) in
                        self.hideHud()
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }

                }

            }else{
                self.hideHud()
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }

        }) { (reason, statusCode) in
        }

    }



    func getItemsFromCart(){

        let param : [String:Any] = [:]

        APIUtils.APICall(postName: "\(APIEndPoint.cartPathRestro.caseValue)\(APIEndPoint.getItems.caseValue)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in

            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false

            if status{
                if let cart = data.value(forKeyPath: "data.cart") as? NSDictionary{

                    APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cartPathRestro.caseValue, modelName:"RestroCart", onSuccess: { (anyData) in

                        self.restroCart = anyData as? RestroCart ?? nil

                        if let b = self.restroCart{
                            self.processItemsData(categories: self.available_categories, restroCart: b)
                        }

                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }

                }
                else{
                    self.tableViewFoodsDetails.reloadData()
                }

            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }

        }) { (reason, statusCode) in
            self.hideHud()
        }

    }


    func addItemInCart(){
        let vc : AddToCartViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "AddToCartViewController") as! AddToCartViewController
        vc.chooseMenu = chooseMenu
        vc.restaurantBranch = restaurantBranch
        vc.restaurantController = self
        vc.deliDateTime = DeliDateTime(deliDateTime: Singleton.shareInstance.showDateTime, deliTime: deliTime, deliMode: deliMode, deliDate: deliDate)
        self.present(vc, animated: true, completion: nil)
    }

}


//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension RestaurantDetailViewController : UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.available_categories.count
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.available_categories[section].menus?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Restaurant_Details") as! Cell_Restaurant_Details
        cell.selectionStyle = .none
        cell.controller = self

        if let item = self.available_categories[indexPath.section].menus?[indexPath.row]{
            cell.setData(item: item)
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
//        if !clickHeader {
            guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastPath = pathsForVisibleRows.last else { return }

            //compare the section for the header that just disappeared to the section
            //for the bottom-most cell in the table view
            if lastPath.section >= section {
                if clickHeader {
                    print("reach == d " , collectionId)
                    self.collectionViewCuisine.selectItem(at: IndexPath(row: collectionId , section: 0), animated: true, scrollPosition: .left)
                    changeCollectionSelected(id: collectionId)
                }
                else {
                    print("reach == e " , section)
                    self.collectionViewCuisine.selectItem(at: IndexPath(row: section , section: 0), animated: true, scrollPosition: .left)
                    changeCollectionSelected(id: section)
                }
            }

    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        print("section == " , section)
//        if !clickHeader {
            //lets ensure there are visible rows.  Safety first!
            guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
            let firstPath = pathsForVisibleRows.first else { return }

            //compare the section for the header that just appeared to the section
            //for the top-most cell in the table view
            if firstPath.section == section {

                if section != 0 {
                    self.collectionViewCuisine.selectItem(at: IndexPath(row: section - 1 , section: 0), animated: true, scrollPosition: .left)

                }
                else {
                    self.collectionViewCuisine.selectItem(at: IndexPath(row: 0 , section: 0), animated: true, scrollPosition: .left)
                }

                changeCollectionSelected(id: section)
            }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let name = Int(self.available_categories[indexPath.section].menus?[indexPath.row].name?.count ?? 0)
        let des = Int(self.available_categories[indexPath.section].menus?[indexPath.row].description?.count ?? 0)
        let total = name + des
        if total > 60 {
            return 150
        }
        return 120
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Store_Product_Header") as! Cell_Store_Product_Header
        var title = ""
        if self.available_categories.count != 0{
            title = self.available_categories[section].name ?? ""
        }

        cell.labelTitle.text = title
        cell.labelTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cell
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = self.available_categories[indexPath.section].menus?[indexPath.row]{
            checkVarientView(menuslug: item.slug ?? "")
        }
        self.index = indexPath.row
    }

    func checkVarientView(menuslug: String){
        APIClient.fetchMenuDetail(menuSlug: menuslug).execute(onSuccess: { data in
            guard let data = data.data else { return }
            self.chooseMenu = data
            self.menuVariants = data.variants ?? [Variant]()
            if data.variants?.count ?? 0 > 0 || data.menu_toppings?.count ?? 0 > 0 || data.menu_options?.count ?? 0 > 0{
                self.chooseVariation()
            }else{
                self.addItemInCart()
            }
            self.tableViewFoodsDetails.reloadData()
        }, onFailure: { error in
            self.hideHud()
            let message = error.localizedDescription
            self.presentAlert(title: errorText, message: message)
        })
    }

    func changeCollectionSelected(id: Int) {
        print("changeCollectionSelected" , clickHeader)
        print("id == ", id)
        for i in 0..<available_categories.count{
            if i == id{
                available_categories[i].selected = true
            }
            else {
                available_categories[i].selected = false
            }
        }
        self.collectionViewCuisine.reloadData()

        if clickHeader && collectionId != -1 && firstClick {
            firstClick = false
        }
    }

    func chooseVariation() {
        let vc: VC_FoodCustomisation = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "VC_FoodCustomisation") as! VC_FoodCustomisation
        vc.restaurantBranch = self.restaurantBranch
        vc.menu = chooseMenu
        vc.restaurantController = self
        vc.deliDateTime = DeliDateTime(deliDateTime: Singleton.shareInstance.showDateTime, deliTime: deliTime, deliMode: deliMode, deliDate: deliDate)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.clickHeader = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == self.tableViewFoodsDetails {

            if scrollView.contentOffset.y > 0 && self.collapsingViewHeightConstraint.constant == 250.0 + UIScreen.main.bounds.width * 0.3 {
                //Scrolled to bottom
                UIView.animate(withDuration: 1.0) {
                   self.collapsingViewHeightConstraint.constant = 0
                    self.spaceHeightConstraint.constant = 40
                    self.headerView.isHidden = true
                    self.titleLbl.isHidden = false
                    self.view.layoutIfNeeded()

                }

            }
            else if (scrollView.contentOffset.y < 0) && self.collapsingViewHeightConstraint.constant == 0{
                //Scrolling up, scrolled to top
                UIView.animate(withDuration: 1.0) {
                   self.collapsingViewHeightConstraint.constant = 250.0 + UIScreen.main.bounds.width * 0.3
                    self.spaceHeightConstraint.constant = 0
                    self.headerView.isHidden = false
                    self.titleLbl.isHidden = true
                    self.view.layoutIfNeeded()
                }

            }

        }

    }

}


//MARK: - CollectionView Functions
extension RestaurantDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionViewSetUP(){
        collectionViewCuisine.dataSource = self
        collectionViewCuisine.delegate = self

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return available_categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell : CategoryNameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryNameCell", for: indexPath) as! CategoryNameCell
        cell.labelCategory.text = available_categories[indexPath.row].name

        if available_categories[indexPath.row].selected {
            print("selected = " , indexPath.row)
            cell.labelCategory.textColor = UIColor().HexToColor(hexString: "#FFBB00")
            cell.lineView.isHidden = false
        }else {
            cell.labelCategory.textColor = UIColor.darkGray
            cell.lineView.isHidden = true
        }

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.size.width/5
        let height = width/3.1 + 8
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionId = indexPath.row

        let indexPath_ = IndexPath(item: 0, section: indexPath.row)
        self.tableViewFoodsDetails.scrollToRow(at: indexPath_, at: .top, animated: true)

        changeCollectionSelected(id: collectionId)
//        collectionViewCuisine.scrollToItem(at: indexPath, at: .left, animated: true)
        self.collectionViewCuisine.selectItem(at: indexPath, animated: true, scrollPosition: .left)

        clickHeader = true
        print("cliii ", clickHeader)
    }

}

extension RestaurantDetailViewController: PreorderDelegate, PassDataToRestaurantDetail {

    func didChange(data: String, deliMode: DeliveryMode, deliDate: DeliveryDate, deliTime: String) {
        showDeliLbl.text = data
        self.deliTime = deliTime
        self.deliDate = deliDate
        self.deliMode = deliMode

        Singleton.shareInstance.showDateTime = data
        Singleton.shareInstance.deliDate = deliDate
        Singleton.shareInstance.deliTime = deliTime
        Singleton.shareInstance.willdeli = deliMode
        
    }

    func passData(deliDateTime: String,restaurantSlug: String,fromCart: Bool) {
        self.slug = restaurantSlug
        self.fromCart = fromCart
        if self.slug != "" {
            showHud(message: "")
            self.loadReastaurantItems(slug: self.slug)
        }
        self.showDeliDate = deliDateTime
//        showDeliLbl.text = deliDateTime
    }

}


//MARK: -- old code
//        if available_categories[indexPath.section].menus?[indexPath.row].menu_variants?.count ?? 0 > 1 || available_categories[indexPath.section].menus?[indexPath.row].menu_toppings?.count ?? 0 > 0 ||
//            available_categories[indexPath.section].menus?[indexPath.row].menu_options?.count ?? 0 > 0{
//
//            chooseVariation(section: indexPath.section, row: indexPath.row)
//
//        }
//        else {
//            guard let menu = self.available_categories[indexPath.section].menus?[indexPath.row] else {
//                return
//            }
//            chooseMenu = menu
//            addItemInCart()
//        }
