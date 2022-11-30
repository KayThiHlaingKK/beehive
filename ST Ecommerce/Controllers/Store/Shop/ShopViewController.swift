//
//  ShopViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 08/12/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import FBSDKCoreKit

class ShopViewController: UIViewController, Cell_TV_HeaderDelegate {
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonCart: UIButton!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var labelShopName: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!

    
    //MARK: - Variables
    var homeViewController:  VC_Home?
    let hud = JGProgressHUD(style: .dark)
    var categories : [ShopCategory] = [ShopCategory]()
    var products = [Product]()
    private var newArrivals = [Product]()
    private var discountProducts = [Product]()
    private var allProducts = [Product]()
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
    var newFetchBool = 0
    private var lat = 0.0
    private var long = 0.0
    private let dispatchGroup = DispatchGroup()
    let productCellWidthRatio : CGFloat = 2.3
    let screenWidth = UIScreen.main.bounds.size.width
    var shop = Shop()
    var shopSlug: String?
    var apiStr = ""
   
    private enum CellType: String, CaseIterable {
        case Cell_TV_Header, Cell_TV_ProductRow, Cell_Store_Product_Header, Cell_TV_EndResult
    }
    
    
    //MARK: - INternal functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppEvents.logEvent(AppEvents.Name("openShop"))
        buttonBack.setTitleColor(UIColor.clear, for: .normal)
        buttonCart.setTitleColor(UIColor.clear, for: .normal)
        self.setupTableView()
        tableView.contentInsetAdjustmentBehavior = .never
        
        self.showHud(message: "Loading...")
        
        if let slug = shopSlug {
            fetchShopBy(slug: slug)
        }
        
        lat = Singleton.shareInstance.currentLat
        long = Singleton.shareInstance.currentLong
        
        loadStoreCategoriesFromServer()
        loadNewArrivalsProducts()
        loadDiscountProducts()
        loadAllProducts()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.setDataForUI()
        }
        self.view.backgroundColor = UIColor.appBackGroundColor()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if readLogin() != 0{
            self.loadCartCount()
        }
        else {
            labelCartCount.isHidden = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tableView.reloadData()
    }
    
    private func setDataForUI() {
        labelShopName.text = shop.name
        if let images = shop.images,
           images.count > 0 {
            coverImage.downloadImage(url: images[0].url, fileName: images[0].file_name, size: .medium)
            shopImage.downloadImage(url: images[0].url, fileName: images[0].file_name, size: .xsmall)
        } else {
            coverImage.downloadImage()
            shopImage.downloadImage()
        }
    }
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
//        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear
        
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 340)
        tableView.tableHeaderView = headerView
        
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
        tableView.backgroundColor = .white
        CellType.allCases.forEach {
            tableView.register(UINib(nibName: $0.rawValue, bundle: nil), forCellReuseIdentifier: $0.rawValue)
        }
        
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension ShopViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return categories.isEmpty ? 0: 1
        case 1: return newArrivals.isEmpty ? 0: 1
        case 2: return discountProducts.isEmpty ? 0: 1
        case 3: return (allProducts.count / 2) + (allProducts.count % 2)
        default: return 0
        }
    }
    
    private func createCategoryCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.type = "shop"
        cell.currentIndexPath = indexPath
        cell.setData(shopSlug: (shopSlug ?? shop.slug) ?? nil, categories: categories)
        return cell
    }
    
    
    
    private func createNewArrivalProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.type = "shop"
        cell.currentIndexPath = indexPath
        cell.setData(products: newArrivals)
        return cell
    }
    
    private func createSuggestionProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.type = "shop"
        cell.setData(products: discountProducts)
        return cell
    }
    
   
    private func createAllProductCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellType.Cell_TV_ProductRow.rawValue, for: indexPath) as! Cell_TV_ProductRow
        let firstIndex = indexPath.row * 2
        
        var twoProducts = [allProducts[firstIndex]]
        if allProducts.indices.contains(firstIndex+1) {
            twoProducts.append(allProducts[firstIndex+1])
        }
        print("two product = " , twoProducts.count)
        cell.type = "shop"
        cell.controller = self
        cell.currentIndexPath = indexPath
        cell.setData(allProducts: twoProducts)
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch indexPath.section {
        case 0: return createCategoryCell(indexPath)
        case 1: return createNewArrivalProductCell(indexPath)
        case 2: return createSuggestionProductCell(indexPath)
        case 3: return createAllProductCell(indexPath)
        default: return UITableViewCell()
        }
 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let productCellHeight = screenWidth / homeCellWidthRatio
        let cellHeight = productCellHeight * 1.6 + 80
        
        switch indexPath.section {
        case 0: return categories.isEmpty ? 0: 160
        case 1: return newArrivals.isEmpty ? 0: cellHeight
        case 2: return discountProducts.isEmpty ? 0: cellHeight
        case 3:
            let cellWidth = (screenWidth - 48) / 2
            let cellHeight = (cellWidth*1.6) + 20
            return allProducts.isEmpty ? 0 : cellHeight
        default: return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0: return categories.isEmpty ? nil: createSectionHeader(title: "Category", section: section)
        
        case 1: return newArrivals.isEmpty ? nil: createSectionHeader(title: "New Arrivals", section: section, showViewAllButton: false)
        case 2: return discountProducts.isEmpty ? nil: createSectionHeader(title: "Special Discount", section: section, showViewAllButton: false)
        
        case 3: return allProducts.isEmpty ? nil: createSectionHeader(title: "All Products", section: section, showViewAllButton: false)
        default: return UIView()
        }

    }
    
    func goToAllCategories() {
        let vc : VC_AllCategories = storyboardStore.instantiateViewController(withIdentifier: "VC_AllCategories") as! VC_AllCategories
        vc.loadStoreCategoriesFromServer()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAllProducts(section: Int) {
        let vc: VC_AllProducts = storyboardStore.instantiateViewController(withIdentifier: "VC_AllProducts")
        as! VC_AllProducts
        
        vc.controller = self
        switch section {
        case 1: vc.products = newArrivals
        case 2: vc.products = discountProducts
        default: vc.products = []
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onTapViewAll(section: Int) {
        switch section {
        case 0: goToAllCategories()
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
        case 1: return newArrivals.isEmpty ? 0: 50
        case 2: return discountProducts.isEmpty ? 0: 50
        case 3: return allProducts.isEmpty ? 0: 50
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let endResultCell = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_EndResult") as! Cell_TV_EndResult
        endResultCell.isHidden = self.lastPage == 0
        if section == 6 && self.lastPage > self.currentPage {
            spinner.startAnimating()
            tableView.tableFooterView?.isHidden = false
            return spinner
        } else if section == 6 && self.lastPage <= self.currentPage {
            
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
        if section == 6 {
            return 44
        }
        return 0
    }
    

    func isFavorited(indexPath: IndexPath, isFavourite: Bool) {
        switch indexPath.section {
        case 1: newArrivals[indexPath.item].is_favorite = isFavourite
        case 2: discountProducts[indexPath.item].is_favorite = isFavourite
        case 3: allProducts[indexPath.item].is_favorite = isFavourite
        default: break
        }
    }
}






extension ShopViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      currentPage += 1
      if currentPage <= lastPage {
          loadAllProducts()
          
//          dispatchGroup.notify(queue: .main) { [unowned self] in
//              print("reloadddddd ", indexPaths)
//              self.tableView.reloadData()
//          }
      }
      
      
  }
}


extension ShopViewController {
    
    func loadStoreCategoriesFromServer(){
        let param : [String:Any] = [:]
        dispatchGroup.enter()
        
        if let slug = shopSlug {
            apiStr = "\(APIEndPoint.shops.caseValue)/\(slug)/\(APIEndPoint.categories.caseValue)"
        }
        
        APIUtils.APICall(postName: apiStr, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                let productsCategoryWise = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(productsCategoryWise, apiName: APIEndPoint.shopCategories.caseValue, modelName:"ShopCategory", onSuccess: { (products) in
                    self.categories = products as? [ShopCategory] ?? []
                    self.tableView.reloadData()
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func fetchShopBy(slug: String) {
        let param : [String:Any] = [:]
        let apiStr = "\(APIEndPoint.shops.caseValue)/\(slug)"
        
        self.dispatchGroup.enter()
        APIUtils.APICall(postName: apiStr, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                let shopData = data.value(forKeyPath: "data") as? NSDictionary
                
                APIUtils.prepareModalFromData(shopData, apiName: APIEndPoint.shops.caseValue, modelName:"Shop", onSuccess: { (shop) in
                    
                    if let shop = shop as? Shop {
                        self.shop = shop
                    }
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    private func loadNewArrivalsProducts() {
        
        if let slug = shopSlug {
            apiStr = "\(APIEndPoint.shops.caseValue)/\(slug)\(APIEndPoint.productNewArrival.caseValue)"
        }
        dispatchGroup.enter()
        
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            print("product new arrival = " , response)
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                if status == 200 {
                    
                    let productNewArrival = data.value(forKeyPath: "data") as? NSArray ?? []
                    
                    APIUtils.prepareModalFromData(productNewArrival, apiName: APIEndPoint.product.caseValue, modelName:"ShopProduct", onSuccess: { (products) in
                        
                        self.newArrivals.append(products as! Product)
                        self.tableView.reloadData()
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
                
            }
            
            self.dispatchGroup.leave()
        } onFailure: { (reason, statusCode) in
            print("new arrival fail")
        }
    }
    
    private func loadDiscountProducts(){
        if let slug = shopSlug {
            apiStr = "\(APIEndPoint.shops.caseValue)/\(slug)\(APIEndPoint.productDiscount.caseValue)"
        }
        
        dispatchGroup.enter()
        APIUtils.APICall(postName: apiStr, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                let productNewArrival = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(productNewArrival, apiName: APIEndPoint.product.caseValue, modelName:"ShopProduct", onSuccess: { (products) in
                    
                    self.discountProducts.append(products as! Product)
                    self.tableView.reloadData()
                    
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: self.apiStr, message: message)
            }
            self.dispatchGroup.leave()
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
    
    private func loadAllProducts() {
        
        if let slug = shopSlug {
            apiStr = "\(APIEndPoint.stores.caseValue)\(slug)?size=\(14)&page=\(currentPage)"
        }
        dispatchGroup.enter()
        
//        self.spinner.startAnimating()
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            print("all response = " , response)
            if let data = response as? NSDictionary {
                
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
                
                if status == 200 {
                    if let allProducts = data.value(forKeyPath: "data") as? NSDictionary {
                        APIUtils.prepareModalFromData(allProducts, apiName: APIEndPoint.stores.caseValue, modelName: "AllProduct", onSuccess: { (anyData) in
                            if let shopproduct = anyData as? ShopProduct {
                                self.allProducts += shopproduct.products ?? []
                                self.tableView.reloadData()
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
}


extension ShopViewController: UITextFieldDelegate {
   
    
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
        
    }
    
    
    
    func loadCartCount(){
        
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        
        APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200 {
                if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                    APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cart.caseValue, modelName: "Cart", onSuccess: { (anyData) in
                        
                        let cartData = anyData as? CartData
                        
                        var productCartCount = 0
                        
                        if let shopcount = cartData?.shop?.shops?.count, shopcount > 0 {
                            for i in 0..<shopcount {
                                let product = cartData?.shop?.shops?[i].productCarts
                                for j in 0..<Int(product?.count ?? 0) {
                                    productCartCount += product?[j].quantity ?? 0
                                }
                                
                            }
                        }
                        
                        print("cart count = " , productCartCount)
                        self.labelCartCount.text = "\(productCartCount)"
                        if productCartCount > 10{
                            self.labelCartCount.text = "10+"
                        }
                        
                        if productCartCount == 0{
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
            self.hideHud()
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
  
   
   @IBAction func cart(_ sender: UIButton) {
       if readLogin() != 0 {
           guard let vc = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
           vc.isTappedFromStore = true
           vc.cartType = Cart.store
           vc.cartOption = .navigation
           vc.isFromStore = true
           
           self.navigationController?.pushViewController(vc, animated: true)
       }else{
           self.showNeedToLoginApp()
       }
       
   }
    

}
