//
//  VC_Home.swift
//  ST Ecommerce
//
//  Created by necixy on 02/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import Lottie
import CoreLocation
import SwiftLocation
import KBZPayAPPPay
import MapKit
import CoreLocation
import Sentry
import FBSDKCoreKit
import Alamofire




class VC_Home: UIViewController, FavoriteListener {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableviewHome: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var collectioViewCtegory: UICollectionView!
    
    @IBOutlet weak var serviceAnnouncementLabel: UILabel!
    @IBOutlet weak var serviceAnnouncementLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var downImgView: UIImageView!
    @IBOutlet var showAddView: UIView!
    @IBOutlet var changeAddView: UIView!
    @IBOutlet var backgroundView: UIView!
    
    
    private var xOffsets: [Int: CGFloat] = [:]
    private let refreshControl = UIRefreshControl()
    private var lat = 0.0
    private var long = 0.0
    
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var homeOptions : [HomeOption] = [HomeOption]()
    var suggestionsProducts : [Product] = [Product]()
    var suggestionsRestaurants : [RestaurantBranch] = [RestaurantBranch]()
    var newArrivalProducts : [Product] = [Product]()
    var banner = [Banner]()
    var announcements = [Announcement]()
    var promotions = [Promotion]()
    var newArrivalRestaurants : [RestaurantBranch] = [RestaurantBranch]()
    var categories :[ShopCategory] = [ShopCategory]()
    let param : [String:Any] = [:]
    var favouritesProducts = [Product]()
    private var serviceAnnouncement: ServiceAnnouncement?
    var favouriteRestaurants = [RestaurantBranch]()
    var product: Product?
    var disalert: Bool = UserDefaults.standard.bool(forKey: "disalert");
    var resCartCount = 0
    var alreadyShown = false
    
    private let dispatchGroup = DispatchGroup()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if readLogin() != 0 {
            print("read login == ", readLogin())
            DEFAULTS.set(readToken(), forKey: UD_APITOKEN)
            loadUserProfile()
            
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(fromLogin(_:)), name: Notification.Name(rawValue: "loginNoti"), object: nil)
        
//        loadServiceAnnouncement()
        changeLocation()
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startimer()
        
        
    }
   
    
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        AppEvents.logEvent(AppEvents.Name("openDashboard"))
        setupSearchBar()
        tableviewSetUp()
        dataSourceSetUp()
        serviceAnnouncementLabelHeight.constant = 0
        
        floorDataSource()
        setupRefreshControl()
        fetchAllData()

        if #available(iOS 12.0, *) {
            searchBar.contentVerticalAlignment = .center
        }

        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showAddress))
        self.changeAddView.isUserInteractionEnabled = true
        self.changeAddView.addGestureRecognizer(gesture)
        
        showAddView.isHidden = true
        backgroundView.isHidden = true
        
        
    }
    
    
    
    private func setupRefreshControl() {
        refreshControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        refreshControl.addTarget(self, action: #selector(self.fetchAllData), for: .valueChanged)
        tableviewHome.addSubview(refreshControl)
    }
    
    @objc func fetchAllData() {
        showHud(message: "Loading...")
        getAddress()
        
        
//        loadStoreCategoriesFromServer()
        loadHomeSliderFromServer()
        getAnnouncementAPICall()
//        getAnnouncements()
        getPromotions()
        loadFavoriteProducts()
        loadFavouriteRestaurants(needToAlign: true)
        
        self.performSelector(onMainThread: #selector(loadingIndicator), with: nil, waitUntilDone: false)
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            self.tableviewHome.reloadData()
            self.refreshControl.endRefreshing()
            self.hideHud()
            self.updateUIForServiceAnnouncement()
        }
    }
    
    @objc func fromLogin(_ notification: Notification) {
        print("discounnectpaxi")
        loadUserProfile()
        fetchAllData()
        
    }
    
    @objc func showAddress(sender : UITapGestureRecognizer) {
        print("show address")
        
        if !alreadyShown {
            UIView.transition(with: showAddView, duration: 0.4,
                  options: .curveEaseOut,
                  animations: {
                    self.showAddView.isHidden = false
              })
            
            
            backgroundView.isHidden = false
            
        }
        else {
            self.showAddView.isHidden = true
            backgroundView.isHidden = true
        }
        
        alreadyShown = !alreadyShown
    }
    
    
    
    func loadHomeSliderFromServer(){
//        self.dispatchGroup.enter()
        
        APIUtils.APICall(postName: APIEndPoint.home_banner_sliders.caseValue, method: .get,  parameters: param, controller: self, onSuccess: {  [unowned self] (response) in
            print("bonds response = ", response)
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            self.banner = []
            if status == 200 {
                print("status 200")
                if let home_sliders = data.value(forKeyPath: "data") as? NSArray{
                    APIUtils.prepareModalFromData(home_sliders, apiName: APIEndPoint.home_banner_sliders.caseValue, modelName: "Banner", onSuccess: { (anyData) in
                        if let bannerData = anyData as? Banner{
                            if bannerData.images?.count ?? 0 > 0 {
                                if let url = bannerData.images?[0].url {
                                    self.banner.append(bannerData)
                                    self.tableviewHome.reloadData()
//                                    self.hideHud()
                                }
                            }
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            }else{
            }
            
//            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
        }
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    
    //MARK: - Supporting Functions
    func dataSourceSetUp(){

        homeOptions.append(HomeOption(image: #imageLiteral(resourceName: "New Project (5)"), title: storeText, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        homeOptions.append(HomeOption(image: #imageLiteral(resourceName: "New Project (4)"), title: foodsText, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        
 
    }
   
    func setupSearchBar() {
        searchBar.delegate = self
        addDoneButtonOnKeyboard()
    }
 
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {

        switch productType {
        case .suggestionsProduct:
            self.suggestionsProducts[index!].is_favorite = isFavourite
        case .newArrivalsProduct:
            self.newArrivalProducts[index!].is_favorite = isFavourite
        case .favouriteProducts:
            self.favouritesProducts[index!].is_favorite = isFavourite
        default:
            break
        }
    }
    
    @objc func loadingIndicator(){
        self.showHud(message: loadingText)
    }
    
    @objc func fetchData(){
        let api = "\(APIEndPoint.homeSuggestions.caseValue)?lat=\(lat)&lng=\(long)"
        APIUtils.APICall(postName: api, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let suggestions = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(suggestions, apiName: APIEndPoint.homeSuggestions.caseValue, modelName: "Suggestions", onSuccess: { (anyData) in
                        if let suggestionsData = anyData as? HomeData{
                            self.suggestionsProducts = []// suggestionsData.products ?? []
                            self.suggestionsRestaurants = []// suggestionsData.restaurant_branches ?? []
                           
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
                
            }else{
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlert(title: APIEndPoint.homeSuggestions.caseValue, message: message)
            }
            
        }) { (reason, statusCode) in
        }
    }
    
    //MARK: - API Call Functions
    func loadHomeSuggestionsFromServer(){
       
//        self.performSelector(onMainThread: #selector(loadingIndicator), with: nil, waitUntilDone: false)
        
        self.performSelector(inBackground:  #selector(fetchData), with: nil)
    }
    
    func loadFavouriteRestaurants(needToAlign: Bool = false) {
        let address = Singleton.shareInstance.selectedAddress
        if let address = address {
            lat = address.latitude ?? 0.0
            long = address.longitude ?? 0.0
        } else {
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
        let apiStr = "\(APIEndPoint.favouriteRestaurantList.caseValue)?lat=\(lat)&lng=\(long)&size=10&page=1"
        
        if needToAlign {
            self.dispatchGroup.enter()
        }
        
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any]() , controller: self) { [unowned self] (response) in
            
            if let data = response as? NSDictionary {
                print("ffff = ", data)
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.favouriteRestaurants = []
                if status == 200 {
                    
                    self.favouriteRestaurants = []
                    if let favourites = data.value(forKey: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.favouriteRestaurantList.caseValue, modelName: "Favourites", onSuccess: { (anyData) in
                            
                            if let favorite = anyData as? RestaurantBranch {
                                print("favou ----- " , favorite)
                                self.favouriteRestaurants.append(favorite)
                            }
                            if !needToAlign {
                                self.tableviewHome.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
                            }
                            
                            self.hideHud()
                            
                        }) { (errror, reason) in
                            print("error \(String(describing: errror)), reason \(reason)")
                        }
                    }
                } else {
                    let _ = data[key_message] as? String ?? serverError
                }
            }
            
            if needToAlign {
                self.dispatchGroup.leave()
            }
        } onFailure: { (reason, statusCode) in
        }
    }
    
    func loadFavoriteProducts() {
        guard readLogin()  != 0 else { return }
        
        let apiStr = "\(APIEndPoint.favouriteProductList.caseValue)?size=10&page=1"
        dispatchGroup.enter()
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { [unowned self]  (response) in
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.favouritesProducts = []
                if status == 200 {
                    self.favouritesProducts = []
                    if let favourites = data.value(forKeyPath: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.favouriteProductList.caseValue, modelName: "Product", onSuccess: { (anyData) in
                            
                            if let favorite = anyData as? Product {
                                self.favouritesProducts.append(favorite)
                            }
//                            DispatchQueue.main.async {
//                                self.tableviewHome.reloadData()
//                            }
                            
                        }) { (errror, reason) in
                            print("error \(String(describing: errror)), reason \(reason)")
                        }
                    }
                } else {
                    let _ = data[key_message] as? String ?? serverError
                }
            }
            
            self.dispatchGroup.leave()
        } onFailure: { (reason, statusCode) in
        }
    }
    
    func getAnnouncementAPICall() {
        APIClient.fetchAnnouncement().execute { data in
            if data.status == 200 {
                if let data = data.data {
                    self.announcements = data
//                    self.announcements.append(contentsOf: data)
                }
            }
        } onFailure: { error in
            print(error.localizedDescription)
        }
    }
    
    
    func getPromotions() {
        
        self.dispatchGroup.enter()
        APIUtils.APICall(postName: APIEndPoint.promotions.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { [unowned self] (response) in
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.promotions = []
            
            if status == 200{
                
                if let newPromotions = data.value(forKeyPath: "data") as? NSArray {
                    
                    APIUtils.prepareModalFromData(newPromotions, apiName: APIEndPoint.promotions.caseValue, modelName: "Promotions", onSuccess: { (anyData) in
                        
                        if let promotions = anyData as? Promotion {
                            
                            self.promotions.append(promotions)
                            
                            self.tableviewHome.reloadData()
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            }else{
                _ = data[key_message] as? String ?? serverError
            }
            
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
        }
    }
    
    
    func loadNewArrivalFromServer(){
        let api = "\(APIEndPoint.newArrival.caseValue)?lat=\(lat)&lng=\(long)"
        APIUtils.APICall(postName: api, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
                        
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let newArrivals = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(newArrivals, apiName: APIEndPoint.newArrival.caseValue, modelName: "NewArrivals", onSuccess: { (anyData) in
                        if let newArrivalsData = anyData as? HomeData{
                            self.newArrivalProducts = []//newArrivalsData.products ?? []
                            self.newArrivalRestaurants = []//newArrivalsData.restaurant_branches ?? []
                            
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            }else{
                _ = data[key_message] as? String ?? serverError
            }
            
        }) { (reason, statusCode) in
        }
    }
   
    
    func loadStoreCategoriesFromServer(){
        
        self.dispatchGroup.enter()
        APIUtils.APICall(postName: APIEndPoint.shopCategories.caseValue, method: .get,  parameters: param, controller: self, onSuccess: {  [unowned self] (response) in
                        
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.categories = []
            if status == 200{
                
                let shopCategory = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(shopCategory, apiName: APIEndPoint.shopCategories.caseValue, modelName:"ShopCategory", onSuccess: { (products) in
                                        
                    self.categories = products as? [ShopCategory] ?? []
                    DispatchQueue.main.async {
                        self.collectioViewCtegory.reloadData()
                    }
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                
            }
            
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
        }
    }
    
    
    func loadAppVersion(){
        
        self.dispatchGroup.enter()
        APIUtils.APICall(postName: APIEndPoint.appVersion.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let versionData = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(versionData, apiName: APIEndPoint.appVersion.caseValue, modelName: "version", onSuccess: { (anyData) in
                        
                        //from appstore
                        let appVersionData = anyData as? AppVersionData
                        let appStoreVersion = appVersionData?.ios_version
                        let appVersion = "\(appStoreVersion?.major ?? 0)\(appStoreVersion?.minor ?? 0)\(appStoreVersion?.patch ?? 0)"
                        
                        //this is current version
                        var currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                        currentVersion = currentVersion?.replacingOccurrences(of: ".", with: "")
                        
                        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                                                
                        SentrySDK.configureScope { scope in
                            scope.setContext(value: [
                                "app_version": currentVersion ?? "",
                                "app_build" : buildVersion ?? "",
                            ], key: "app")
                        }
                        
                        if appVersion > currentVersion ?? "" {
                            self.forceUpdate()
                        }
                        
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }
            else{
//            let message = data[key_message] as? String ?? serverError
//            self.presentAlertWithTitle(title: APIEndPoint.appVersion.caseValue, message: message, options: okayText) { (value) in
//            }
        }
            
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
        }
    }
    
    func forceUpdate() {
        self.presentAlertWithTitle(title: errorText, message: updateAppText, options: updateText, goBackText) { (value) in
            switch(value) {
            case 0:
                
                if let url = URL(string: appstoreLink)
                {
                       if #available(iOS 10.0, *) {
                          UIApplication.shared.open(url, options: [:], completionHandler: nil)
                       }
                       else {
                             if UIApplication.shared.canOpenURL(url as URL) {
                                UIApplication.shared.openURL(url as URL)
                            }
                       }
                }
                break
            case 1: self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func alertUpdate() {
        self.presentAlertWithTitle(title: errorText, message: updateAppText, options: okayText) { (value) in
            switch(value) {
            case 0: self.dismiss(animated: true, completion: nil)
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func startimer(){
        if let cell:Cell_TV_Home_Offers = tableviewHome.cellForRow(at: IndexPath(row: 0, section: 0)) as? Cell_TV_Home_Offers{
            cell.startTimer()
        }
    }
    
    @objc func stopTimer(){
        if let cell:Cell_TV_Home_Offers = tableviewHome.cellForRow(at: IndexPath(row: 0, section: 0)) as? Cell_TV_Home_Offers{
            cell.stopTimer()
        }
    }
    
   
    
    //MARK: - Action Functions
    @IBAction func cart(_ sender: UIButton) {
        print("show cart == " , readLogin())
        if readLogin() != 0 {
            
//            let vc : VC_Cart = storyboardCart.instantiateViewController(withIdentifier: "VC_Cart") as! VC_Cart
            let vc : CartViewController = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            vc.cartType = Cart.store
            vc.isFromStore = true
            vc.fromHome = true
            vc.isTappedFromStore = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.showNeedToLoginApp()
        }
        
    }
    
    @IBAction func btnViewAll(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableviewHome)
        guard let customIndexPath = tableviewHome.indexPathForRow(at: point),
              let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_Favorite") as? VC_Favorite
        else { return }
        vc.showMenuBar = false
        vc.selectedTag = customIndexPath.row == 4 ? 1 : 0
        self.navigationController?.pushViewController(vc, animated: true)
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
                                        { [self](placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                if placemarks == nil {
                    self.presentAlert(title: attentionText, message: no_internet_connection_available)
                }
                else {
                let pm = (placemarks ?? nil) as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        print("get geo")
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
                            addressString = addressString + pm.country!
                        }
//                        if pm.postalCode != nil {
//                            print(pm.postalCode)
//                            addressString = addressString + pm.postalCode! + " "
//                        }

                        
                        self.labelAddress.text = addressString// addressString.trunc(length: 35)
                           
                        Singleton.shareInstance.currentAddress = addressString
                        Singleton.shareInstance.selectedAddress?.latitude = lat
                        Singleton.shareInstance.selectedAddress?.longitude = long
                        updateFoodAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: "", floor: 0, street_name: addressString, latitude: lat, longitude: long, township_slug: ""))
                        updateShopAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: "", floor: 0, street_name: addressString, latitude: lat, longitude: long, township_slug: ""))
                        
                  }
                }
            })

        }
    
    func updateShopAddressAPICall(request: UpdateAddressRequest) {
        APIClient.fetchShopUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
                Singleton.shareInstance.selectedAddress?.township_slug = data.data?.address?.township_slug
            }
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }

    
    func updateFoodAddressAPICall(request: UpdateAddressRequest) {
        APIClient.fetchFoodUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
//                Singleton.shareInstance.selectedAddress = data.data?.address
            }
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }
    
    func checkToRequest() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dMMyyyy"
        let currentDateString = dateFormatter.string(from: date)
       
        if readLogin() != 0 {
            if currentDateString != UserDefaults.standard.string(forKey: UD_Token) {
                UserDefaults.standard.set(currentDateString, forKey: UD_Token)
                refreshToken()
            }
            else {
                if Singleton.shareInstance.userProfile == nil {
                    UserDefaults.standard.set(readToken(), forKey: UD_APITOKEN)
                    loadUserProfile()
                }
            }
        }
        if currentDateString != UserDefaults.standard.string(forKey: UD_Token) {
            loadAppVersion()
        }
        
    }
    
    func loadUserProfile(){
        
        let param : [String:Any] = [:]
        
        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let profile = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                        
                        Singleton.shareInstance.userProfile = anyData as? Profile ?? nil
                        
                        self.loadFavouriteRestaurants(needToAlign: false)
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }else{
//                self.changeLoginState(newState: false)
//                self.hideHud()
            }
            
        }) { (reason, statusCode) in
//            self.hideHud()
        }
        
    }
    
    private func updateUIForServiceAnnouncement() {
        guard let serviceAnnouncement = serviceAnnouncement else {
            return
        }

        serviceAnnouncementLabel.isHidden = !(serviceAnnouncement.announcement_service ?? false)
        serviceAnnouncementLabel.text = serviceAnnouncement.announcement
        if serviceAnnouncement.announcement_service == true {
            let announcementText = serviceAnnouncement.announcement ?? ""
            let screenWidth = UIScreen.main.bounds.width
            serviceAnnouncementLabelHeight.constant = announcementText.height(withConstrainedWidth: screenWidth - 32, font: UIFont(name: "Lato-Regular", size: 15)!) + 16
        } else {
            serviceAnnouncementLabelHeight.constant = 0
        }
        
    }
    
    private func loadServiceAnnouncement() {
        APIUtils.APICall(postName: APIEndPoint.serviceAnnouncement.caseValue, method: .get, parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            
            if status == 200 {
                if let home_popups = data.value(forKeyPath: "data") as? NSDictionary {
                    
                    APIUtils.prepareModalFromData(home_popups, apiName: APIEndPoint.serviceAnnouncement.caseValue, modelName: "ServiceAnnouncement", onSuccess: { (anyData) in
                        if let serviceAnnouncement = anyData as? ServiceAnnouncement {
                            self.serviceAnnouncement = serviceAnnouncement
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            }
        }) { (reason, statusCode) in
            
        }
    }
    
    
    
    private func refreshToken(){
        let param : [String:Any] = [:]
                
        APIUtils.APICall(postName: APIEndPoint.refreshToken.caseValue, method: .post, parameters: param, controller: self, onSuccess: { (response) in
            
            let response = response as? [String:Any] ?? [:]
            let status = response["status"] as? Int
            let data = response["data"] as? [String:Any] ?? [:]
            
            if status == 200{
                if let token = data["token"] as? String {
                    self.writeToken(token: token)
                    UserDefaults.standard.set(token, forKey: UD_APITOKEN)
                    self.changeLoginState(newState: 1)
                    self.loadUserProfile()
                }
            }
            
        }) { (reason, statusCode)  in
        }
    }
    

    func floorDataSource(){
      var floors : [Floor] = [Floor]()
      floors.append(Floor(name: "Ground Floor", value: 0))
      floors.append(Floor(name: "1st Floor", value: 1))
      floors.append(Floor(name: "2nd Floor", value: 2))
      floors.append(Floor(name: "3rd Floor", value: 3))
      floors.append(Floor(name: "4th Floor", value: 4))
      floors.append(Floor(name: "5th Floor", value: 5))
      floors.append(Floor(name: "6th Floor", value: 6))
      floors.append(Floor(name: "7th Floor", value: 7))
      floors.append(Floor(name: "8th Floor", value: 8))
      floors.append(Floor(name: "9th Floor", value: 9))
      floors.append(Floor(name: "10th Floor", value: 10))
      floors.append(Floor(name: "More than 10th Floor", value: 11))
      Singleton.shareInstance.floors = floors
    }
}


extension VC_Home : UITableViewDelegate, UITableViewDataSource{
    
    func tableviewSetUp(){
        
        tableviewHome.delegate = self
        tableviewHome.dataSource = self
        tableviewHome.register(UINib(nibName: "Cell_TV_Announcement", bundle: nil), forCellReuseIdentifier: "Cell_TV_Announcement")
        tableviewHome.register(UINib(nibName: "Cell_TV_Promotion", bundle: nil), forCellReuseIdentifier: "Cell_TV_Promotion")
        
        self.collectionViewSetUP()
        
        tableviewHome.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0);
        for i in 0...6 {
            xOffsets[i] = 0.0
        }
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
        if readLogin() == 0 {
            return 8
        } else {
            if favouriteRestaurants.isEmpty && favouritesProducts.isEmpty {
                return 8
            } else if favouriteRestaurants.isEmpty || favouritesProducts.isEmpty {
                return 9
            } else {
                return 10
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Store, Food, Reward, Donation
        if indexPath.row == 1{
            
            let cell : Cell_TV_Home_Options = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Home_Options") as! Cell_TV_Home_Options
            cell.selectionStyle = .none
            cell.controller = self
            cell.selectionStyle = .none
            cell.collectionViewSetUP()
            return cell
            
        }
        //Slide Show image and category
        else if indexPath.row == 0{
            
            let cell : Cell_TV_Home_Offers = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Home_Offers") as! Cell_TV_Home_Offers
            cell.selectionStyle = .none
            cell.controller = self
            cell.collectionViewSetUP()
            
            cell.selectionStyle = .none
            cell.configurePageView()
            cell.collectionViewHomeOffers.reloadData()
            
            return cell
            
        }
        else if indexPath.row == 2 {
            
            let cell : Cell_TV_Announcement = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Announcement") as! Cell_TV_Announcement
            cell.controller = self
            cell.setupCollectionView()
            cell.selectionStyle = .none
            cell.setData(announcments: self.announcements)
            cell.collectionView.reloadData()
            
            return cell
            
        }
        else if indexPath.row == 3 {
            let cell : Cell_TV_Promotion = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Promotion") as! Cell_TV_Promotion
            cell.controller = self
            cell.setupCollectionView()
            cell.selectionStyle = .none
            cell.setData(promotions: self.promotions)
            cell.collectionView.reloadData()
            
            return cell
        } else if indexPath.row == 4 {
            let cell : Cell_TV_Home_Suggestions = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Home_Suggestions") as! Cell_TV_Home_Suggestions
            cell.selectionStyle = .none
            cell.controller = self
            cell.parentIndexPath = indexPath
            cell.collectionViewSetUP()
            cell.selectionStyle = .none
            cell.btnViewAll.tag = indexPath.row
            cell.labelCategory.text = "Favourite Products"
            cell.btnViewAll.isHidden = false
            cell.homeItemType = HomeItemType.FavouriteProductsType
            cell.setupData(favoriteProducts: self.favouritesProducts, type: .FavouriteProductsType)
            cell.collectionViewHomeSuggestions.reloadData()
            return cell
        } else if indexPath.row == 5 {
            let cell : Cell_TV_Home_Suggestions = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Home_Suggestions") as! Cell_TV_Home_Suggestions
            cell.selectionStyle = .none
            cell.controller = self
            cell.parentIndexPath = indexPath
            cell.collectionViewSetUP()
            cell.selectionStyle = .none
            cell.serviceAnnouncement = self.serviceAnnouncement
            cell.btnViewAll.tag = indexPath.row
            cell.btnViewAll.isHidden = false
            cell.homeItemType = HomeItemType.FavouriteRestaurantType
            cell.labelCategory.text = "Favourite Restaurants"
//                cell.spaceConstraintLabel.constant = 0
            cell.dividerView.isHidden = false
            cell.setupData(favoriteRestaurants: self.favouriteRestaurants, type: .FavouriteRestaurantType)
            cell.collectionViewHomeSuggestions.reloadData()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = UIScreen.main.bounds.size.width/homeCellWidthRatio
        
        if indexPath.row == 0{//Slide Show image and category
//            return 192
            return 220
        }else if indexPath.row == 1{//Store, Food, Reward, Donation
            let width = tableView.frame.size.width/1.8
            return 160//width
        }else if indexPath.row == 2 {
            return self.announcements.count > 0 ? 530: 0
        }
        else if indexPath.row == 3 {
            return self.promotions.count > 0 ? 280: 0
        } else if indexPath.row == 4 && favouritesProducts.count > 0 {
            return height * 1.6 + 80
        }else if indexPath.row == 5 && favouriteRestaurants.count > 0 {
            return 330
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 4 || indexPath.row == 5 {
            xOffsets[indexPath.row] = (cell as? Cell_TV_Home_Suggestions)?.collectionViewHomeSuggestions.contentOffset.x
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 4 || indexPath.row == 5 {
            (cell as? Cell_TV_Home_Suggestions)?.collectionViewHomeSuggestions.contentOffset.x = xOffsets[indexPath.row] ?? 0
        }
    }
}


//MARK: - CollectionView Functions
extension VC_Home : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectioViewCtegory.dataSource = self
        collectioViewCtegory.delegate = self
        
        collectioViewCtegory.register(UINib(nibName: "Cell_CV_ProductCategory", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_ProductCategory")
//        collectioViewCtegory.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 0);
       // collectioViewCtegory.backgroundColor = UIColor.white
        collectioViewCtegory.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0);
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.categories.count > 4{
            return 5
        }else{
            return self.categories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : Cell_CV_ProductCategory = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_ProductCategory", for: indexPath) as! Cell_CV_ProductCategory
     
        if self.categories.count > 4{
            if indexPath.row == 4{
//                cell.isLastCell = true
                cell.setData(category: self.categories[indexPath.row])
            }else{
//                cell.isLastCell = false
                cell.setData(category: self.categories[indexPath.row])
            }
        }else{
            cell.setData(category: self.categories[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/3.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.categories.count > 4{
            if indexPath.row == 4{
                let vc : VC_AllCategories = storyboardStore.instantiateViewController(withIdentifier: "VC_AllCategories") as! VC_AllCategories
                vc.categoryArray = self.categories
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                let vc : VC_Store_Search = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
                //vc.category = self.categories[indexPath.row]
                vc.categorySlug = self.categories[indexPath.row].slug ?? ""
                vc.type = StoreProduct.viewAll
                vc.categoryName = self.categories[indexPath.row].name ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            let vc : VC_Store_Search = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
            //vc.category = self.categories[indexPath.row]
            vc.type = StoreProduct.viewAll
            vc.categoryName = self.categories[indexPath.row].name ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}

extension VC_Home: UITextFieldDelegate {
    
    //MARK: - Search Bar
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = storyboardHome.instantiateViewController(withIdentifier: "VC_Search") as! VC_Search
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: doneText, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.searchBar.resignFirstResponder()
    }
    
}

extension VC_Home: ChooseOpationDelegate {

    func chooseFoodOption() {
        let vc : VC_Restaurant = storyboardRestaurant.instantiateViewController(withIdentifier: "VC_Restaurant") as! VC_Restaurant
        self.navigationController?.pushViewController(vc, animated: true)

    }

    func chooseShopOption() {
        let vc : VC_Store = storyboardStore.instantiateViewController(withIdentifier: "VC_Store") as! VC_Store
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}




extension VC_Home: ChangeAddressDelegate {
    var addressLabel: UILabel {
        return labelAddress
    }
    
    func useSelectedLocation() {
        
        if let address = Singleton.shareInstance.selectedAddress {
            print(address)
            let add = Util.getFormattedAddress(address: address)
            self.labelAddress.text = add
            
        }
        else {
            self.labelAddress.text = Singleton.shareInstance.currentAddress
            print(Singleton.shareInstance.currentAddress)
        }
        fetchAllData()
        hideChangeAddress()
    }
    
    
    
    func changeLocation() {
        print("change location selected == " , Singleton.shareInstance.selectedAddress)
        if Singleton.shareInstance.selectedAddress != nil {
            useSelectedLocation()
        }
        else {
            useCurrentLocation()
            hideChangeAddress()
            return
        }
        
    }
    
    
    
    
    func refetchData() {
        fetchAllData()
    }
    
    func getAddressFromCoordinate(latitude: String, longitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(latitude)")!
        let lon: Double = Double("\(longitude)")!
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
            if placemarks == nil {
                self.presentAlert(title: attentionText, message: no_internet_connection_available)
            }
            else {
                let pm = (placemarks ?? nil) as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print("get geo")
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
                        addressString = addressString + pm.country!
                    }
                    print("address string == " , addressString)
                    self.labelAddress.text = addressString// addressString.trunc(length: 35)
                    //Singleton.shareInstance.selectedAddress = nil
                    Singleton.shareInstance.currentAddress = addressString
                    DispatchQueue.main.async {
                        self.fetchAllData()
                    }
                }
            }
        })
        
    }
    
    func useCurrentLocation() {
        let instance = Singleton.shareInstance
        if instance.currentLat != 0 {
            getAddressFromCoordinate(latitude: "\(instance.currentLat)", longitude: "\(instance.currentLong)")
        }
        else {
            self.labelAddress.text = "Myanmar"
        }
    }
    
    
    private func getAddress() {
        let address = Singleton.shareInstance.selectedAddress
        if let address = address {
            lat = address.latitude ?? 0.0
            long = address.longitude ?? 0.0
        } else {
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
    }
    
    func hideChangeAddress() {
        showAddView.isHidden = true
        backgroundView.isHidden = true
    }
    
    
}
