//
//  VC_Foods.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import CoreLocation
import SwiftLocation
import FBSDKCoreKit

class VC_Restaurant: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var buttonCart: UIButton!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var changeAddView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    private let spinner = UIActivityIndicatorView()
    private var serviceAnnouncement: ServiceAnnouncement?
    
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    private var favoriteRestaurants = [RestaurantBranch]()
    private var recommendedRestaurants = [RestaurantBranch]()
    private let dispatchGroup = DispatchGroup()
    private enum CellType: String, CaseIterable {
        case Cell_TV_Restaurant, Cell_TV_Banner, Cell_TV_Header, Cell_TV_RestaurantRow, Cell_Foods_Search
    }
    
    
    var alreadyShown = false
    
    var banners = [Banner]()
    var restaurantBranches: [RestaurantBranch] = [RestaurantBranch]()
    var categoryIndexs = [Int]()
    let storyboardRestroSearch = UIStoryboard(name: "RestroSearch", bundle: nil)
    weak var homeViewController:  VC_Home?
    var locationManager = CLLocationManager()
    private var lat = "0.0"
    private var long = "0.0"
    private var currentPage = 1
    private var lastPage = 1
    var sliderImage: [String] = []
    private let pullToRefreshControl = UIRefreshControl()
    let param : [String:Any] = [:]
    
    var apiPage = 1
    
    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppEvents.logEvent(AppEvents.Name("openRestaurant"))
        
        setupTableView()
        setupSearchBar()
//        fetchData()
        setupRefreshControl()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showAddress))
        self.changeAddView.isUserInteractionEnabled = true
        self.changeAddView.addGestureRecognizer(gesture)
        
        addView.isHidden = true
        backgroundView.isHidden = true

        Singleton.shareInstance.deliDate = DeliveryDate.today
        Singleton.shareInstance.deliTime = ""
        Singleton.shareInstance.willdeli = DeliveryMode.delivery
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //managelocationAlert()
        labelCartCount.isHidden = true
        isUserLoginOrNot()
        
        changeLocation()
        
//        changeDefault()
    }
    
    
    private func presentChangeAddressView() {
        let changeAddressVC = storyboardHome.instantiateViewController(withIdentifier: "ChangeAddressViewController") as! ChangeAddressViewController
        changeAddressVC.modalPresentationStyle = .popover
        self.present(changeAddressVC, animated: false)
    }
    
    @objc private func fetchData() {
        getAddress()
        showHud(message: loadingText)
        restaurantBranches = []
        banners = []
        favoriteRestaurants = []
        currentPage = 1
        lastPage = 1
        loadRestaurantsRecommendataions()
        if readLogin() != 0 {
            loadFavouriteRestaurants()
        }
        loadSliderFromServer()
        loadServiceAnnouncement()
        
        loadAllRestaurantsBranches(needToAlign: true)
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            self.hideHud()
            let isEmpty = self.favoriteRestaurants.isEmpty && self.recommendedRestaurants.isEmpty && self.banners.isEmpty && self.restaurantBranches.isEmpty
            self.emptyView.isHidden = !isEmpty
            self.tableView.isHidden = isEmpty
            self.pullToRefreshControl.endRefreshing()
            self.tableView.reloadData()
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
                            DispatchQueue.main.async {
                                self.labelCartCount.isHidden = false
                                if rescount > 10{
                                    self.labelCartCount.text = "10+"
                                }
                                else {
                                    self.labelCartCount.text = "\(rescount)"
                                }
                            }
                            
                        }
                    
                        
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
        }
    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//    }
    
   @objc func isUserLoginOrNot(){
        if readLogin() != 0 {
            self.loadRestaurantCart()
        }
        else
        {
            labelCartCount.isHidden = true
        }
    
   }
    
    func managelocationAlert() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showLocationSettingsAlert()
            case .authorizedWhenInUse, .authorizedAlways:
                if self.apiPage == 1 && self.restaurantBranches.count == 0 {
                    self.loadReastaurantsCategorisedDataFromServer()
                }
            @unknown default:
                showLocationSettingsAlert()
            }
        } else {
            showLocationSettingsAlert()
        }
    }
    
    //MARK: - Private Functions
    
    private func setupTableView(){
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        
        CellType.allCases.forEach {
            tableView.register(UINib(nibName: $0.rawValue, bundle: nil), forCellReuseIdentifier: $0.rawValue)
        }
        
        tableView.register(UINib(nibName: "Cell_TV_EndResult", bundle: nil), forCellReuseIdentifier: "Cell_TV_EndResult")
        tableView.tableFooterView?.isHidden = true
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
    }
    
    
    private func setupRefreshControl() {
        pullToRefreshControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        pullToRefreshControl.backgroundColor = .clear
        tableView.tableHeaderView = nil
        pullToRefreshControl.addTarget(self, action: #selector(useSelectedLocation), for: .valueChanged)
        tableView.refreshControl = pullToRefreshControl
    }
    
    @IBAction func home(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func cart(_ sender: UIButton) {
        if readLogin() != 0 {
        
            guard let vc : CartViewController = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else {
                return
            }
            vc.cartType = Cart.restaurant
            vc.cartOption = .navigation
            vc.fromHome = false
            vc.isFromStore = false
            vc.isTappedFromStore = true
            vc.fromDetail = false
            if let deliDateTime = CustomUserDefaults.shared.get(key: .deliDateTime) as? String {
                vc.deliDateTime = deliDateTime
            }
            if let deliTime = CustomUserDefaults.shared.get(key: .deliTime) as? String {
                Singleton.shareInstance.deliTime = deliTime
            }
            //        vc.viewCartOptions.isHidden = true
            //        vc.heightCartOptionsConstraint.constant = 0
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.showNeedToLoginApp()
        }
    }
   
    @IBAction func searchBtn(_ sender: Any) {
        let vc : VC_Food_Search = storyboardRestroSearch.instantiateViewController(withIdentifier: "VC_Food_Search") as! VC_Food_Search
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - API Call Functions
    
    
//    func customizeData() {
//        var temp: [CategorizedRestaurant] = []
//        for i in 0..<restaurantBranches.count {
//            print(categorizedRestaurant[i].restaurant_branches?.count)
//            if (categorizedRestaurant[i].restaurant_branches?.count ?? 0 > 0) {
//                temp.append(categorizedRestaurant[i])
//            }
//        }
//        categorizedRestaurant = temp
//        print("cat caount == " , restaurantBranches.count)
//    }
    
    func showLocationSettingsAlert()  {
        presentAlertWithTitle(title: locationPermissionRequiredText, message: locationEnableText, options: settingsText, cancelText) { (option) in
            
            switch(option) {
            case 0:
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            case 1:
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
 
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_Restaurant : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 3 : restaurantBranches.count// will change later
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: return createFavoriteCell(tableView, indexPath: indexPath)
            case 1: return createBannerAdsCell(tableView, indexPath: indexPath)
            case 2: return createRecommendationCell(tableView, indexPath: indexPath)
            default: return UITableViewCell()
            }
        }
        if currentPage >= lastPage && indexPath.section > 0 {
            spinner.stopAnimating()
            tableView.tableFooterView = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_EndResult") as! Cell_TV_EndResult
            tableView.tableFooterView?.isHidden = false
        }
//        if indexPath.row == self.restaurantBranches.count - 1 {
//            currentPage += 1
//            loadAllRestaurantsBranches(needToAlign: false)
//        }
        return createRestaurantRowCell(tableView, indexPath: indexPath)
    }
    
    private func createFavoriteCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_Restaurant.rawValue) as? Cell_TV_Restaurant else { return UITableViewCell() }
        cell.serviceAnnouncement = serviceAnnouncement
        cell.controller = self
        cell.indexPath = indexPath
        cell.showViewAllButton = true
        cell.sectionLabel.text = "Favorite Foods"
        cell.setData(restaurantBranches: favoriteRestaurants)
        return cell
    }
    
    private func createBannerAdsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_Banner.rawValue) as? Cell_TV_Banner else { return UITableViewCell() }
        cell.controller = self
        cell.setData(banners: banners)
        cell.startTimer()
        return cell
    }
    
    private func createRecommendationCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_Restaurant.rawValue) as? Cell_TV_Restaurant else { return UITableViewCell() }
        cell.serviceAnnouncement = self.serviceAnnouncement
        cell.controller = self
        cell.indexPath = indexPath
        cell.showViewAllButton = true
        cell.sectionLabel.text = "Recommend For You"
        cell.setData(restaurantBranches: recommendedRestaurants)
        return cell
    }
    
    private func createRestaurantRowCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_RestaurantRow.rawValue) as! Cell_TV_RestaurantRow
        cell.serviceAnnouncement = self.serviceAnnouncement
        cell.controller = self
        let restaurantBranch = restaurantBranches[indexPath.row]
        cell.setData(restaurantBranch: restaurantBranch)
        
        return cell
    }
    
    private func createFoodSearchCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_Foods_Search.rawValue) as! Cell_Foods_Search
        cell.restaurant = restaurantBranches[indexPath.row]
        cell.setData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: return favoriteRestaurants.isEmpty ? 0: 340
            case 1: return banners.isEmpty ? 0: (view.frame.size.width * (186 / 376)) + 40
            case 2: return recommendedRestaurants.isEmpty ? 0: 340
            default: return 0
            }
        }
        
        return 162 + 32
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        (section == 1 && !restaurantBranches.isEmpty) ? 54 : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 && !restaurantBranches.isEmpty {
//            guard let header = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_Header.rawValue) as? Cell_TV_Header else { return nil }
//            header.headerLabel.text = "All Restaurants"
//            return header
            
            guard let header = Bundle.main.loadNibNamed("SectionHeader", owner: self, options: nil)![0] as? SectionHeader else { return UIView() }
            header.sectionTitle.text = "All Restaurants"
            return header
        }
        return nil
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1,
            let restroID = self.restaurantBranches[indexPath.row].slug {
            
            let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
            vc.slug = restroID
            vc.restaurantSlug = self.restaurantBranches[indexPath.row].restaurant?.slug ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        if( indexPath.section ==  1) && (indexPath.row == lastRowIndex) {
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
        
        if currentPage >= lastPage && indexPath.section > 0 {
            spinner.stopAnimating()
            tableView.tableFooterView = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_EndResult") as! Cell_TV_EndResult
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    private func loadNewRows(_ newRestaurantBranches: [RestaurantBranch]) {
        spinner.stopAnimating()
        guard !newRestaurantBranches.isEmpty else { return }
        self.restaurantBranches.append(contentsOf: newRestaurantBranches)
        let indexPaths = calculateIndexPathsToReload(from: newRestaurantBranches)
//        let ips = visibleIndexPathsToReload(intersecting: indexPaths)
//        tableView.reloadRows(at: indexPaths, with: .automatic)
//        tableView.reloadData()
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    private func calculateIndexPathsToReload(from newRestaurantBranches: [RestaurantBranch]) -> [IndexPath] {
        let startIndex = self.restaurantBranches.count - newRestaurantBranches.count
        let endIndex = startIndex + newRestaurantBranches.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 1) }
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    private func loadServiceAnnouncement() {
        dispatchGroup.enter()
        
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
            
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
            
        }
    }
    
    
}



extension VC_Restaurant: UITextFieldDelegate {
    
    //MARK: - Search Bar
    
    func setupSearchBar(){
        if #available(iOS 12.0, *) {
            searchBar.contentVerticalAlignment = .center
        }
        searchBar.delegate = self
        addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchStr = searchBar.text ?? ""
        let strCheck = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if strCheck != ""{
            let vc : VC_Food_Search = storyboardRestroSearch.instantiateViewController(withIdentifier: "VC_Food_Search") as! VC_Food_Search
            vc.searchStr = searchBar.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
            searchBar.text = ""
            self.searchBar.resignFirstResponder()
        }else{
            searchBar.text = ""
            self.searchBar.resignFirstResponder()
        }
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = storyboardHome.instantiateViewController(withIdentifier: "VC_Search") as! VC_Search
        vc.tappedMenuTag = 1
        vc.hideMenuBar = true
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
}


extension VC_Restaurant: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      currentPage += 1
      loadAllRestaurantsBranches(needToAlign: false)
  }
}



//MARK: - API Call Functions

extension VC_Restaurant {
    
    
    private func loadFavouriteRestaurants() {
        let apiStr = "\(APIEndPoint.favouriteRestaurantList.caseValue)?lat=\(lat)&lng=\(long)&size=10&page=1"
        dispatchGroup.enter()
        self.favoriteRestaurants = []
        APIUtils.APICall(postName: apiStr, method: .get, parameters: param, controller: self) { (response) in
            
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                if status == 200 {
                    if let favourites = data.value(forKey: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.favouriteRestaurantList.caseValue, modelName: "Favourites", onSuccess: { (anyData) in
                            
                            if let favorite = anyData as? RestaurantBranch {
                                self.favoriteRestaurants.append(favorite)
                            }
                            
                            
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
    
    private func loadRestaurantsRecommendataions() {
        
        dispatchGroup.enter()
        let apiStr: String? = "\(APIEndPoint.restaurantsRecommendations.caseValue)?lat=\(lat)&lng=\(long)"
        recommendedRestaurants = []
        APIUtils.APICall(postName: "\(apiStr ?? "")", method: .get, parameters: param, controller: self) { (response) in
            
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                if status == 200 {
                    
                    if let restaurants = data.value(forKeyPath: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(restaurants, apiName: APIEndPoint.restaurantsRecommendations.caseValue, modelName: "RestaurantBranch", onSuccess: { (anyData) in
                            
                            if let recommendation = anyData as? RestaurantBranch {
                                self.recommendedRestaurants.append(recommendation)
                            }
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
                            
                        }) { (errror, reason) in
                            print("error \(String(describing: errror)), reason \(reason)")
                        }
                    }
                } else {
                    print("else")
                    let _ = data[key_message] as? String ?? serverError
                }
            }
            
            self.dispatchGroup.leave()
            
        } onFailure: { (reason, statusCode) in
        }
    }
    
    
    private func loadSliderFromServer() {
        dispatchGroup.enter()
        APIUtils.APICall(postName: "\(APIEndPoint.home_banner_sliders.caseValue)&source=restaurant", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            
            self.banners = []
            if status == 200 {
                
                if let home_sliders = data.value(forKeyPath: "data") as? NSArray{
                    APIUtils.prepareModalFromData(home_sliders, apiName: APIEndPoint.home_banner_sliders.caseValue, modelName: "Banner", onSuccess: { (anyData) in
                        
                        if let banner = anyData as? Banner {
                            self.banners.append(banner)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            } else {
                let message =
                data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
        }
    }
    
    private func loadAllRestaurantsBranches(needToAlign: Bool) {
        let apiStr: String = "\(APIEndPoint.restaurants.caseValue)?lat=\(lat)&lng=\(long)&size=10&page=\(currentPage)"
        if needToAlign {
            dispatchGroup.enter()
        }
        
        spinner.startAnimating()
        APIUtils.APICall(postName: apiStr, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            if self.currentPage == 1 {
                self.restaurantBranches = []
            }
            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
            self.hideHud()
            if status == 200 {
                if let jsonArr = data.value(forKey: "data") as? NSArray {
                    
                    var newRB = [RestaurantBranch]()
                    for item in jsonArr {
                        let dict = item as! NSDictionary
                        
                        if let JSONData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        {
                            newRB.append(try! RestaurantBranch(data: JSONData))
                        }
                    }
                    self.spinner.stopAnimating()
                    if self.currentPage == 1 {
                        self.restaurantBranches = newRB
                    } else if needToAlign == false {
                        DispatchQueue.main.async {
                            self.loadNewRows(newRB)
                        }
                    }
                }
                
            } else {
                
                
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            if needToAlign {
                self.dispatchGroup.leave()
            }
        }) { (reason, statusCode) in
        }
    }
    
    
    private func loadReastaurantsCategorisedDataFromServer(){
        
       let param : [String:Any] = [:]
//       var lat = 0.0
//       var long = 0.0
//
//       if Singleton.shareInstance.defaultAddress?.latitude != nil {
//           print("default address")
//           lat = Singleton.shareInstance.defaultAddress?.latitude ?? 0.0
//           long = Singleton.shareInstance.defaultAddress?.longitude ?? 0.0
//       }
//       else {
//           print("current address")
//           lat = Singleton.shareInstance.currentLat
//           long = Singleton.shareInstance.currentLong
//       }
       
       let api = "\(APIEndPoint.restaurants.caseValue)?lat=\(lat)&lng=\(long)&page=\(apiPage)"
        
           APIUtils.APICall(postName: api, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
               
               
               let data = response as! NSDictionary
               let status = data.value(forKey: key_status) as? Int
               print(response)
               
               if status == 200{
                   //Success from our server
                   let restaurantBranch = data.value(forKeyPath: "data") as? NSArray ?? []
                   
                   APIUtils.prepareModalFromData(restaurantBranch, apiName: APIEndPoint.restaurants.caseValue, modelName:"RestaurantList", onSuccess: { (restaurantcategory) in
                       
                       self.restaurantBranches += restaurantcategory as? [RestaurantBranch] ?? []
                       
//                        self.customizeData()
                       self.hideHud()
                       
                       DispatchQueue.main.async {
                           self.tableView.reloadData()
                       }
                   }) { (error, endPoint) in
                       print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                   }
                   
                   
               }
               else{
                   let message = data[key_message] as? String ?? serverError
                   self.presentAlert(title: errorText, message: message)
               }
               
               self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
               
           }) { (reason, statusCode) in
           }
           
//        }else{
//            managelocationAlert()
//        }
//
   }
}


extension VC_Restaurant: Cell_TV_RestaurantDelegate {
    func viewAllButtonPressed(indexPath: IndexPath) {
        switch indexPath.row {
        case 0: goToFavoriteRestaurant()
        case 2: goToRecommendedRestaurant()
        default: break
        }
    }
    
    private func goToFavoriteRestaurant() {
        guard let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_Favorite") as? VC_Favorite
        else { return }
        vc.showMenuBar = false
        vc.selectedTag = 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToRecommendedRestaurant() {
        guard let vc = storyboardRestaurant.instantiateViewController(withIdentifier: "VC_RecommendedFood") as? VC_RecommendedFood
        else { return }
        vc.serviceAnnouncement = self.serviceAnnouncement
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension VC_Restaurant: ChangeAddressDelegate {
    var addressLabel: UILabel {
        return labelAddress
    }
    
    private func getAddress() {
        let address = Singleton.shareInstance.selectedAddress
        if let address = address {
            lat = "\(address.latitude ?? 0.0)"
            long = "\(address.longitude ?? 0.0)"
        } else {
            lat = "\(Singleton.shareInstance.currentLat)"
            long = "\(Singleton.shareInstance.currentLong)"
        }
    }
    
    func refetchData() {
        fetchData()
    }
    
    
    @objc func showAddress(sender : UITapGestureRecognizer) {
        if !alreadyShown {
            UIView.transition(with: addView, duration: 1.0,
                              options: .curveEaseOut,
                              animations: {
                self.addView.isHidden = false
            })
            backgroundView.isHidden = false
        }
        else {
            self.addView.isHidden = true
            backgroundView.isHidden = true
        }
        alreadyShown = !alreadyShown
    }
    
    func useCurrentLocation() {
        let instance = Singleton.shareInstance
        print(instance.currentLat,instance.currentLong)
        getAddressFromCoordinate(latitude: "\(instance.currentLat)", longitude: "\(instance.currentLong)")
    }
    
  
    
//    @objc func useSelectedLocation() {
//        print("Restaurant == ", Singleton.shareInstance.selectedAddress)
//        if let address = Singleton.shareInstance.selectedAddress {
//            let add = Util.getFormattedAddress(address: address)
//            self.labelAddress.text = add// add.trunc(length: 32)
//        }
//        else {
//            self.labelAddress.text = Singleton.shareInstance.currentAddress
//        }
//        fetchData()
//        hideChangeAddress()
//    }
    
    @objc func useSelectedLocation() {
        
        if let address = Singleton.shareInstance.selectedAddress {
            let add = Util.getFormattedAddress(address: address)
            self.labelAddress.text = add
            
        }
        else {
            self.labelAddress.text = Singleton.shareInstance.currentAddress
            print(Singleton.shareInstance.currentAddress)
        }
        fetchData()
        hideChangeAddress()
    }
    
    
    func hideChangeAddress() {
        addView.isHidden = true
        backgroundView.isHidden = true
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
                    
                    self.labelAddress.text = addressString//.trunc(length: 35)
                    Singleton.shareInstance.selectedAddress = nil
                    Singleton.shareInstance.currentAddress = addressString
                    self.fetchData()
                }
            }
        })
        
    }
    
}
