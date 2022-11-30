//
//  VC_Store.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import ViewAnimator
import JGProgressHUD
import PhoneNumberKit
import CoreLocation

class VC_Store: UIViewController, Cell_TV_HeaderDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var searchBarStore: UITextField!
    @IBOutlet weak var buttonCart: UIButton!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    //MARK: - Variables
    var homeViewController:  VC_Home?
    let hud = JGProgressHUD(style: .dark)
    var categories : [ShopCategory] = [ShopCategory]()
    var products = [Product]()
    private var favoriteProducts = [Product]()
    private var newArrivals = [Product]()
    private var suggestionProducts = [Product]()
    private var shops = [Shop]()
    private var brands = [Brand]()
    private var banners = [Banner]()
    private var allProducts = [Product]()
    var apiPage = 1
    private var currentPage = 1
    var lastPage = 0
    var apiRequested = false
    var fromCart = false
    let refreshControl = UIRefreshControl()
    private var spinner = UIActivityIndicatorView(style: .gray)
    var isLoading = true
    private var alreadyShown = false
    var loadingView: LoadingReusableView?
    var otherProductsModel : SearchProduct?
    //let spinner = UIActivityIndicatorView(style: .gray)
    var newFetchBool = 0
    private var lat = 0.0
    private var long = 0.0
    private let dispatchGroup = DispatchGroup()
    let productCellWidthRatio : CGFloat = 2.3
    let screenWidth = UIScreen.main.bounds.size.width
    private var isFetching = false
    
    private var xOffsets: [Int: CGFloat] = [:]
    private let pullToRefreshControl = UIRefreshControl()
    
    private enum CellType: String, CaseIterable {
        case Cell_TV_Header, Cell_TV_ProductRow, Cell_TV_Banner, Cell_Store_Product_Header, Cell_TV_EndResult
    }
    
    private func resetData() {
        categories = []
        products = []
        favoriteProducts = []
        newArrivals = []
        suggestionProducts = []
        shops = []
        brands = []
        banners = []
        allProducts = []
        
        apiPage = 1
        currentPage = 1
        lastPage = 0
    }
    
    //MARK: - INternal functions
    @objc private func fetchData() {
        print("fetchData !!")
        if readLogin() != 0 {
            self.loadCartData()
            loadFavoriteProducts()
        } else {
            labelCartCount.isHidden = true
        }
        
        showHud(message: "Loading...")
        resetData()
        loadStoreCategoriesFromServer()
        loadNewArrivalsProducts()
        loadSuggestionProducts()
        loadBannerAds()
        loadShops()
        loadBrands()
        allProducts = []
        loadAllProducts(needToAlign: true)
        //        changeDefault()
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
//            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            self.tableView.reloadData()
            self.pullToRefreshControl.endRefreshing()
            self.hideHud()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Store == ", Singleton.shareInstance.selectedAddress)
        hideHud()
        changeLocation()
        
        addView.isHidden = true
        backgroundView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAddress(sender:)))
        addressView.addGestureRecognizer(tapGesture)
        
        setupTableView()
//        tableView.contentInsetAdjustmentBehavior = .never
        
        
        
//        fetchData()
//        dispatchGroup.notify(queue: .main) { [unowned self] in
////            tableView.isHidden = false
//            self.tableView.reloadData()
//            self.hideHud()
//        }
        
        self.setupSearchBar()
        
        self.view.backgroundColor = UIColor.appBackGroundColor()
        
        setupRefreshControl()
     
    }
    
    private func setupRefreshControl() {
        pullToRefreshControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        pullToRefreshControl.backgroundColor = .clear
        tableView.tableHeaderView = nil
        pullToRefreshControl.addTarget(self, action: #selector(self.fetchData), for: .valueChanged)
        tableView.refreshControl = pullToRefreshControl
//        tableView.addSubview(pullToRefreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
   
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.prefetchDataSource = self
        
//        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderHeight = 0.0
        
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = .white
        CellType.allCases.forEach {
            tableView.register(UINib(nibName: $0.rawValue, bundle: nil), forCellReuseIdentifier: $0.rawValue)
        }
        
        for i in 0...6 {
            xOffsets[i] = 0.0
        }
        
        
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.loadStoreCategorisedDataFromServer()
    }
     
}

extension VC_Store : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        
        print("search \(searchController.searchBar.text ?? "")")
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_Store : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return categories.isEmpty ? 0: 1
        case 1: return favoriteProducts.isEmpty ? 0: 1
        case 2: return newArrivals.isEmpty ? 0: 1
        case 3: return banners.isEmpty ? 0: 1
        case 4: return suggestionProducts.isEmpty ? 0: 1
        case 5: return shops.isEmpty ? 0: 1
        case 6: return brands.isEmpty ? 0: 1
        case 7: return (allProducts.count / 2) + (allProducts.count % 2)
        default: return 0
        }
    }
    
    private func requestMoreProducts() {
        if currentPage <= lastPage {
            currentPage += 1
            isFetching = true
            loadAllProducts(needToAlign: false)
        }
    }
    private func createCategoryCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(categories: categories)
        return cell
    }
    
    private func createFavoriteProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(products: favoriteProducts)
        return cell
    }
    
    private func createNewArrivalProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(products: newArrivals)
        return cell
    }
    
    private func createSuggestionProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(products: suggestionProducts)
        return cell
    }
    
    private func createBannerAdsCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_Banner.rawValue) as? Cell_TV_Banner else { return UITableViewCell() }
        cell.controller = self
        cell.setData(banners: banners)
        cell.startTimer()
        return cell
    }
    
    private func createShopCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(shops: shops)
        return cell
    }
    
    private func createBrandCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(brands: brands)
        return cell
    }
    
    private func createAllProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let numberOfRows = (allProducts.count / 2) + (allProducts.count % 2)
        if isFetching != true && (indexPath.row == numberOfRows || indexPath.row == (numberOfRows - 1)) {
            requestMoreProducts()
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        let firstIndex = indexPath.row * 2
        
        var twoProducts = [allProducts[firstIndex]]
        if allProducts.indices.contains(firstIndex+1) {
            twoProducts.append(allProducts[firstIndex+1])
        }
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(allProducts: twoProducts)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch indexPath.section {
        case 0: return createCategoryCell(indexPath)
        case 1: return createFavoriteProductCell(indexPath)
        case 2: return createNewArrivalProductCell(indexPath)
        case 3: return createBannerAdsCell(indexPath: indexPath)
        case 4: return createSuggestionProductCell(indexPath)
        case 5: return createShopCell(indexPath)
        case 6: return createBrandCell(indexPath)
        case 7: return createAllProductCell(indexPath)
        default: return UITableViewCell()
        }
 
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 7 {
            xOffsets[indexPath.section] = (cell as? Cell_TV_ProductRow)?.itemCollectionView.contentOffset.x
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section != 7 {
            (cell as? Cell_TV_ProductRow)?.itemCollectionView.contentOffset.x = xOffsets[indexPath.section] ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productCellHeight = screenWidth / homeCellWidthRatio
        let cellHeight = productCellHeight * 1.6 + 20
        
        switch indexPath.section {
        case 0: return categories.isEmpty ? 0: 140
        case 1: return favoriteProducts.isEmpty ? 0: cellHeight
        case 2: return newArrivals.isEmpty ? 0: cellHeight
        case 3: return banners.isEmpty ? 0: ((screenWidth * (186 / 380)) + 55)
        case 4: return suggestionProducts.isEmpty ? 0: cellHeight
        case 5: return shops.isEmpty ? 0: (screenWidth * (196 / 350)) + 30
        case 6: return brands.isEmpty ? 0: 170
        case 7:
            let cellWidth = (screenWidth - 35) / 2
            let cellHeight = (cellWidth*1.6) + 20
            return allProducts.isEmpty ? 0 : cellHeight
        default: return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0: return categories.isEmpty ? nil: createSectionHeader(title: "Category", section: section)
        case 1: return favoriteProducts.isEmpty ? nil: createSectionHeader(title: "Favorites", section: section)
        case 2: return newArrivals.isEmpty ? nil: createSectionHeader(title: "New Arrivals", section: section)
        case 3: return nil
        case 4: return suggestionProducts.isEmpty ? nil: createSectionHeader(title: "Recommended For You", section: section)
        case 5: return shops.isEmpty ? nil: createSectionHeader(title: "Shops", section: section, showViewAllButton: true)
        case 6: return brands.isEmpty ? nil: createSectionHeader(title: "Popular Brands", section: section, showViewAllButton: true)
        case 7: return allProducts.isEmpty ? nil: createSectionHeader(title: "All Products", section: section, showViewAllButton: false)
        default: return UIView()
        }

    }
    
    private func goToFavoriteProducts() {
        guard let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_Favorite") as? VC_Favorite
        else { return }
        vc.showMenuBar = false
        vc.selectedTag = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToAllShops() {
        let vc = storyboardStore.instantiateViewController(withIdentifier: "VC_AllShops") as! VC_AllShops
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToAllCategories() {
        let vc : VC_AllCategories = storyboardStore.instantiateViewController(withIdentifier: "VC_AllCategories") as! VC_AllCategories
        vc.loadStoreCategoriesFromServer()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToAllProducts(section: Int) {
        let vc: VC_AllProducts = storyboardStore.instantiateViewController(withIdentifier: "VC_AllProducts")
        as! VC_AllProducts
        
        vc.controller = self
        switch section {
        case 1: vc.products = favoriteProducts
        case 2:
//            vc.products = newArrivals
            vc.productType = .newArrivalsProduct
        case 4:
            vc.products = [] // suggestionProducts
            vc.productType = .suggestionsProduct
        default: vc.products = []
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAllBrands() {
        let vc = storyboardStore.instantiateViewController(withIdentifier: "VC_AllBrands") as! VC_AllBrands
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onTapViewAll(section: Int) {
        switch section {
        case 0: goToAllCategories()
        case 1: goToFavoriteProducts()
        case 5: goToAllShops()
        case 6: goToAllBrands()
        default: goToAllProducts(section: section)
        }
    }
    
    private func createSectionHeader(title: String, section: Int, showViewAllButton: Bool = true) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_Header.rawValue) as! Cell_TV_Header
        cell.viewAllLabel.isHidden = !showViewAllButton
        cell.delegate = self
        cell.section = section
        cell.headerLabel.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return categories.isEmpty ? 0: 50
        case 1: return favoriteProducts.isEmpty ? 0: 50
        case 2: return newArrivals.isEmpty ? 0: 50
        case 3: return 0
        case 4: return suggestionProducts.isEmpty ? 0: 50
        case 5: return shops.isEmpty ? 0: 50
        case 6: return brands.isEmpty ? 0: 50
        case 7: return allProducts.isEmpty ? 0: 50
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let endResultCell = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_EndResult") as! Cell_TV_EndResult
        endResultCell.isHidden = self.lastPage == 0
        if section == 7 && self.lastPage > self.currentPage {
            spinner.startAnimating()
            tableView.tableFooterView?.isHidden = false
            return spinner
        } else if section == 7 && self.lastPage <= self.currentPage {
            
            spinner.stopAnimating()
            tableView.tableFooterView?.isHidden = false
            tableView.tableFooterView = endResultCell
            return endResultCell
        }
        else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 7 {
            return 44
        }
        return 0
    }
    

    func isFavorited(indexPath: IndexPath, isFavourite: Bool) {
        switch indexPath.section {
        case 1: favoriteProducts[indexPath.item].is_favorite = isFavourite
        case 2: newArrivals[indexPath.item].is_favorite = isFavourite
        case 4: suggestionProducts[indexPath.item].is_favorite = isFavourite
        case 7: allProducts[indexPath.item].is_favorite = isFavourite
        default: break
        }
    }
}

extension VC_Store:UISearchBarDelegate{
    
    //MARK: - Search Bar
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarStore.text = ""
        self.searchBarStore.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    @objc func doneButtonAction()
    {
        self.searchBarStore.resignFirstResponder()
    }
    
}



//extension VC_Store: UIScrollViewDelegate {
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if self.lastPage > self.apiPage {
//            self.apiPage += 1
//            print(self.apiPage)
//            DispatchQueue.background(delay: 7, background: {
//                self.loadStoreCategorisedDataFromServer()
//            }, completion: {
//                self.hideHud()
//            })
//
//        }
//    }
//
//}



extension VC_Store {
    
    func loadStoreCategoriesFromServer(){
        let param : [String:Any] = [:]
        dispatchGroup.enter()
        APIUtils.APICall(postName: APIEndPoint.shopCategories.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.categories = []
            if status == 200{
                let productsCategoryWise = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(productsCategoryWise, apiName: APIEndPoint.shopCategories.caseValue, modelName:"ShopCategory", onSuccess: { (products) in
                    self.categories = products as? [ShopCategory] ?? []
//                    self.tableView.reloadData()
//                    self.hideHud()
//                    self.tableView.isHidden = false
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
            
        }
        
    }
    
    private func loadFavoriteProducts() {
        
        let apiStr = "\(APIEndPoint.favouriteProductList.caseValue)?size=10&page=1"
        dispatchGroup.enter()
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.favoriteProducts = []
                if status == 200 {
                    if let favourites = data.value(forKeyPath: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.favouriteProductList.caseValue, modelName: "Product", onSuccess: { (anyData) in
                            
                            if let favorite = anyData as? Product {
                                self.favoriteProducts.append(favorite)
//                                self.tableView.reloadData()
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
    
    private func loadNewArrivalsProducts() {
        
        let apiStr = "\(APIEndPoint.newArrival.caseValue)?lat=\(lat)&lng=\(long)"
        dispatchGroup.enter()
        
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.newArrivals = []
                if status == 200 {
                    if let favourites = data.value(forKeyPath: "data") as? NSDictionary  {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.newArrival.caseValue, modelName: "HomeData", onSuccess: { (anyData) in
                            
                            if let products = (anyData as? HomeData)?.products {
                                self.newArrivals.append(contentsOf: products)
//                                self.tableView.reloadData()
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
            print("new arrival fail")
        }
    }
    
    private func loadSuggestionProducts(){
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let api = "\(APIEndPoint.recommendProduct.caseValue)?device_id=\(deviceId)"
        
        dispatchGroup.enter()
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            print("rec pro = " ,response)
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.suggestionProducts = []
            
            if status == 200{
                if let suggestions = data.value(forKeyPath: "data") as? NSArray{
                    
                    APIUtils.prepareModalFromData(suggestions, apiName: APIEndPoint.recommendProduct.caseValue, modelName: "Product", onSuccess: { (anyData) in
//                        let recommendedProducts = anyData as? SearchProduct
//                        self.suggestionProducts += (recommendedProducts?.data ?? [])
                        
                        if let recommend = anyData as? Product {
                            self.suggestionProducts.append(recommend)
                        }
                        print("recommend count = " , self.suggestionProducts.count)
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
//                        self.hideHud()
                    }
                }
                
            }else{
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlert(title: APIEndPoint.recommendProduct.caseValue, message: message)
////                self.hideHud()
            }
            self.dispatchGroup.leave()
            
        }) { (reason, statusCode) in
            
            
        }
    }
    
    private func loadBannerAds() {
        dispatchGroup.enter()
        
        APIUtils.APICall(postName: "\(APIEndPoint.home_banner_sliders.caseValue)&source=shop", method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            self.banners = []
            if status == 200 {
                
                if let home_sliders = data.value(forKeyPath: "data") as? NSArray{
                    APIUtils.prepareModalFromData(home_sliders, apiName: APIEndPoint.home_banner_sliders.caseValue, modelName: "Banner", onSuccess: { (anyData) in
                        
                        if let banner = anyData as? Banner {
                            self.banners.append(banner)
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
    
    private func loadShops(){
        let api = APIEndPoint.shops.caseValue
        
        dispatchGroup.enter()
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            self.shops = []
            if status == 200 {
                
                if let shops = data.value(forKeyPath: "data") as? NSArray {
                    
                    APIUtils.prepareModalFromData(shops, apiName: api, modelName: "Shop", onSuccess: { (anyData) in
                        if let shop = anyData as? Shop {
                            self.shops.append(shop)
//                            self.tableView.reloadData()
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
    
    private func loadBrands(){
        let api = APIEndPoint.brands.caseValue
        
        dispatchGroup.enter()
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            self.brands = []
            if status == 200 {
                if let brands = data.value(forKeyPath: "data") as? NSArray {
                    APIUtils.prepareModalFromData(brands, apiName: api, modelName: "Brands", onSuccess: { (anyData) in
                        if let brand = anyData as? Brand {
                            self.brands.append(brand)
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
    
    
    func loadStoreCategorisedDataFromServer(){

        let param : [String:Any] = [:]
        
        APIUtils.APICall(postName: "\(APIEndPoint.product.caseValue)?page=\(apiPage)&size=30", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
//            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
                        
            if status == 200{
                //Success from our server
                let productsCategoryWise = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(productsCategoryWise, apiName: APIEndPoint.product.caseValue, modelName:"Product", onSuccess: { (products) in
                    
                    self.products += products as? [Product] ?? []
//                    self.tableView.reloadData()
                    
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            
        }
        
    }
    
    
    private func loadAllProducts(needToAlign: Bool = false) {
        let apiStr = "\(APIEndPoint.product.caseValue)?size=\(14)&page=\(currentPage)"
      
      
        if needToAlign {
            dispatchGroup.enter()
        }
//        self.spinner.startAnimating()
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
                
                if self.currentPage == 1 {
                    self.allProducts = []
                }
                if status == 200 {
                    if let allProducts = data.value(forKeyPath: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(allProducts, apiName: APIEndPoint.favouriteProductList.caseValue, modelName: "Product", onSuccess: { (anyData) in
                            
                            if let product = anyData as? Product {
                                self.allProducts.append(product)
                            }
                            
                            if needToAlign == false {
                                DispatchQueue.main.async {
                                    self.isFetching = false
                                    self.spinner.stopAnimating()
                                    self.tableView.reloadData()
                                }
                            }
                            else {
//                                self.tableView.reloadData()
//                                self.hideHud()
                            }
                            
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
}


extension VC_Store: UITextFieldDelegate {
    
    func setupSearchBar(){
        if #available(iOS 12.0, *) {
            searchBarStore.contentVerticalAlignment = .center
        }
        searchBarStore.delegate = self
        addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let searchStr = searchBarStore.text ?? ""
        let strCheck = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if strCheck != ""{
            let vc : VC_Store_Search = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
            vc.type = StoreProduct.search
            vc.searchStr = searchBarStore.text ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
            
            searchBarStore.text = ""
            self.searchBarStore.resignFirstResponder()
        }else{
            searchBarStore.text = ""
            self.searchBarStore.resignFirstResponder()
        }
        return true
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: doneText, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBarStore.inputAccessoryView = doneToolbar
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc = storyboardHome.instantiateViewController(withIdentifier: "VC_Search") as! VC_Search
        vc.tappedMenuTag = 0
        vc.hideMenuBar = true
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
    
    //MARK: - Private Functions
    private func navigationBarSetUp(){
        
        self.title = storeText
        
        let redColor = #colorLiteral(red: 0.8117647059, green: 0.1647058824, blue: 0.1529411765, alpha: 1)
        
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor:redColor,
             NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 30)]
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor:redColor,
             NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)]
        
        
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = searchText
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }
    
    @objc private func toggleChangeAddressView() {
        let storyboard = UIStoryboard(name: "ChangeAddressView", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangeAddressViewController") as! ChangeAddressViewController
        
        if alreadyShown {
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            vc.controller = self
            
            self.present(vc, animated: false)
        } else {
            vc.dismissController()
        }
        alreadyShown = !alreadyShown
    }
    
   
    
    func loadCartData(){
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        
        APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200 {
                if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                    APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cart.caseValue, modelName: "Cart", onSuccess: { (anyData) in
                        let cartData = anyData as? CartData

                        var productOrderCount = 0
                        if let shopcount = cartData?.shop?.shops?.count, shopcount > 0 {
                            for i in 0..<shopcount {
                                let product = cartData?.shop?.shops?[i].productCarts
                                for j in 0..<Int(product?.count ?? 0) {
                                    productOrderCount += product?[j].quantity ?? 0
                                }
                                
                            }
                        }
                        self.labelCartCount.text = "\(productOrderCount)"
                        
                        if productOrderCount > 10{
                            self.labelCartCount.text = "10+"
                        }
                        
                        if productOrderCount == 0{
                            self.labelCartCount.isHidden = true
                        }
                        else {
                            self.labelCartCount.isHidden = false
                        }
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
                
            }
        }) { (reason, statusCode) in
//            self.hideHud()
        }
    }
    
    
   func isFavorited(index: Int?, productType: ProductType, isFavourite: Bool) {

       switch productType {
      // case .other:
      //     self.otherProductsModel?.data?.products?[index!]. = isFavourite
       case .storeProductHLinear:
           self.products[index!].is_favorite = isFavourite
           //self.productsCategoryWise[index!].products?[index!].is = isFavourite
//        case .storeProductVLinear:
//            self.productsCategoryWise[index!].products?[index!].isFavorite = isFavourite
       default:
           break

       }
   }
  
   
   //MARK: - Action Functions
   @IBAction func search(_ sender: UIButton) {
       
   }
   
   @IBAction func home(_ sender: UIButton) {
       self.navigationController?.popToRootViewController(animated: true)
   }
   
   @IBAction func cart(_ sender: UIButton) {
       if readLogin() != 0 {
           
           guard let vc = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
           vc.isTappedFromStore = true
           //            vc.viewCartOptions.isHidden = true
           //            vc.heightCartOptionsConstraint.constant = 0
           vc.cartType = Cart.store
           vc.cartOption = .navigation
           vc.isFromStore = true
           
           self.navigationController?.pushViewController(vc, animated: true)
       }else{
           self.showNeedToLoginApp()
       }
       
   }
    

}


extension VC_Store: ChangeAddressDelegate {
    
    func changeLocation() {
        guard Singleton.shareInstance.selectedAddress != nil
        else {
            useCurrentLocation()
            hideChangeAddress()
            return
        }
        useSelectedLocation()
    }
    
    var addressLabel: UILabel {
        return labelAddress
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
    
    func refetchData() { 
        getAddress()
        fetchData()
    }
    
    func useCurrentLocation() {
        getAddressFromCoordinate(latitude: "\(Singleton.shareInstance.currentLat)", longitude: "\(Singleton.shareInstance.currentLong)")
    }
    
    
    func useSelectedLocation() {
        
        if let address = Singleton.shareInstance.selectedAddress {
            let add = Util.getFormattedAddress(address: address)
            self.labelAddress.text = add.trunc(length: 25)
        }
        else {
            self.labelAddress.text = Singleton.shareInstance.currentAddress.trunc(length: 25)
        }
        fetchData()
        hideChangeAddress()
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
                    //                        if pm.postalCode != nil {
                    //                            print(pm.postalCode)
                    //                            addressString = addressString + pm.postalCode! + " "
                    //                        }
                    
                    
                    self.labelAddress.text = addressString.trunc(length: 35)
                    Singleton.shareInstance.selectedAddress = nil
                    Singleton.shareInstance.currentAddress = addressString
                    DispatchQueue.main.async {
                        self.fetchData()
                    }
                }
            }
        })
        
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
    
    func hideChangeAddress() {
        addView.isHidden = true
        backgroundView.isHidden = true
    }
}
