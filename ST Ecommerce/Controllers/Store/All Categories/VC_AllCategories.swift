//
//  VC_AllCategories.swift
//  ST Ecommerce
//
//  Created by Rishabh on 07/09/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit


class VC_AllCategories: UIViewController {
    
    //MARK:- outlets
   
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var subCategoryTableView: UITableView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var TopViewHeightConstrains: NSLayoutConstraint!
    @IBOutlet weak var labelCartCount: UILabel!
    
    //MARK:- variable
    private let screenWidth = UIScreen.main.bounds.width
    var categoryArray = [ShopCategory]()
    private var categories = [ShopCategoryMenu]()
    private var subCategories = [CategorizedProduct]()
    private var dropDownIndexPaths = [IndexPath]()
    private var selectedIndex = 0
    private var selectedName = [String]()
    
    var myCategoryData : MyCategoryData?
    var loadingView: LoadingReusableView?
    var apiRequested = false
    var apiPage = 1
    var isLoading = true
    var lastPage = 1
    var selectedValue = String()
    //MARK:- class functions

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
        fetchCategories()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if readLogin() != 0 {
            self.loadCartCount()
        }
        else {
            labelCartCount.isHidden = true
        }
    }
    
    fileprivate func setupView() {
        setupCollectionView()
//        self.categoryCollectionView.reloadData()
        Util.configureTopViewPosition(heightConstraint: TopViewHeightConstrains)
    }
    
    //MARK:- actions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToCartView(_ sender: UIButton) {
        if readLogin() != 0 {
            let vc : CartViewController = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            
            vc.cartType = Cart.store
            vc.cartOption = .navigation
            vc.isFromStore = true
            vc.fromHome = true
            vc.isTappedFromStore = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.showNeedToLoginApp()
        }
    }
    
    private func loadCartCount(){
        
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        
        APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
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
        }
        
    }
   
}

extension VC_AllCategories: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        categoryCollectionView.register(UINib.init(nibName: "Cell_CV_Category", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Category")

        categoryCollectionView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Category", for: indexPath) as! Cell_CV_Category
        if self.categories[indexPath.row].slug == self.selectedValue {
            cell.labelCategoryName.textColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
        } else {
            cell.labelCategoryName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        cell.setData(menu: categories[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (screenWidth / 4) - 16
        return CGSize(width: width, height: width + 32)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsSelection = true
        itemSelect(indexPath: indexPath)
    }
    
    
    private func itemSelect(indexPath: IndexPath) {
        selectedIndex = indexPath.item
        dropDownIndexPaths.removeAll()
        subCategoryTableView.reloadData()
        navigationTitleLabel.text = categories[selectedIndex].name
        self.selectedValue = categories[indexPath.row].slug ?? ""
        categoryCollectionView.reloadData()
    }
}

extension VC_AllCategories: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if self.lastPage > self.apiPage {
//            self.apiPage += 1
//            loadStoreCategoriesFromServer()
//
//        }

    }
}

extension VC_AllCategories: UITableViewDelegate, UITableViewDataSource, DropDownCellDelegate {
    
    func goToProductList(indexPath: IndexPath) {
        guard let shopCategory = categories[selectedIndex].shop_categories?[indexPath.row] else { return }
        let vc : VC_Store_Search = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
        vc.type = StoreProduct.viewAll
        vc.categoryName = shopCategory.name ?? ""
        
        if let productId = shopCategory.slug {
            vc.categorySlug = productId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func select(shopSubcategory: ShopSubCategory, indexPath: IndexPath) {
        guard let subcategoryVC = storyboardSubcategory.instantiateViewController(withIdentifier: "VC_Subcategory") as? VC_Subcategory else { return }
            
        subcategoryVC.setData(shopSubcategory: shopSubcategory)
        self.navigationController?.pushViewController(subcategoryVC, animated: true)
    }
    
    func toggleDropDown(indexPath: IndexPath, isShowing: Bool) {
        if isShowing {
            dropDownIndexPaths = dropDownIndexPaths.filter{ $0 != indexPath }
            subCategoryTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            dropDownIndexPaths.append(indexPath)
            subCategoryTableView.reloadRows(at: dropDownIndexPaths, with: .automatic)
        }
    }
    
    private func setupTableView() {
        subCategoryTableView.delegate = self
        subCategoryTableView.dataSource = self
        subCategoryTableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        subCategoryTableView.rowHeight = (UIScreen.main.bounds.width / 4.0) + 40
        subCategoryTableView.estimatedRowHeight = UITableView.automaticDimension
        subCategoryTableView.allowsSelection = false
        subCategoryTableView.register(UINib(nibName: "Cell_TV_DropDownHeader", bundle: nil), forCellReuseIdentifier: "Cell_TV_DropDownHeader")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories.count > 0 {
            let subCategories = categories[selectedIndex].shop_categories
            return subCategories?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_DropDownHeader", for: indexPath) as! Cell_TV_DropDownHeader
        cell.indexPath = indexPath
        cell.delegate = self
        if let subcategory = categories[selectedIndex].shop_categories?[indexPath.row] {
            cell.setData(subcategory: subcategory)
        }
        cell.isShowing = dropDownIndexPaths.contains(indexPath)
        cell.showDropDown(shouldDrop: dropDownIndexPaths.contains(indexPath))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dropDownIndexPaths.contains(indexPath) {
            if let subcategories = categories[selectedIndex].shop_categories,
               let shopSubcategories = subcategories[indexPath.row].shop_sub_categories,
               shopSubcategories.count > 0 {
                return calculateHeight(shopSubcategories: shopSubcategories)
            }
        }
        return 50
    }
    
    private func calculateHeight(shopSubcategories: [ShopSubCategory]) -> CGFloat {
        let noColumns = 3
        let totalPadding = CGFloat((noColumns * 10) + 10)
        let itemWidth: CGFloat = (subCategoryTableView.frame.size.width - totalPadding) / CGFloat(noColumns)
        let itemHeight: CGFloat = itemWidth + 30 + 16
        let count = shopSubcategories.count
        let noRows: Int = count / noColumns + (count % noColumns == 0 ? 0: 1)
        return 50 + 16 + (itemHeight * CGFloat(noRows))
    }
    
}



extension VC_AllCategories {
    
    
    func loadStoreCategoriesFromServer(){
        var param : [String:Any] = [:]
        APIUtils.APICall(postName: "\(APIEndPoint.shopCategories.caseValue)?page=\(apiPage)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
                        
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
            if status == 200{
                let shopCategory = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(shopCategory, apiName: APIEndPoint.shopCategories.caseValue, modelName:"ShopCategory", onSuccess: { (products) in
                    
                    self.categoryArray += products as? [ShopCategory] ?? []
                    DispatchQueue.main.async {
//                        self.categoriesCollectionView.reloadData()
                    }
                    
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
            }
            
        }) { (reason, statusCode) in
        }
    }
    
    
    private func fetchCategories() {
        let api = APIEndPoint.categoryList.caseValue
        showHud(message: "")
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            self.apiRequested = false
            
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                let shopCategoriesData = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(shopCategoriesData, apiName: APIEndPoint.categoryList.caseValue, modelName:"ShopMainCategory", onSuccess: { (categories) in
                    
                    self.categories += categories as? [ShopCategoryMenu] ?? []
                    DispatchQueue.main.async {
                        self.selectedValue = self.categories[0].slug ?? ""
                        self.categoryCollectionView.reloadData()
                        self.subCategoryTableView.reloadData()
                        self.selectedIndex = 0
                        self.itemSelect(indexPath: IndexPath(row: 0, section: 0))
                        self.hideHud()
                    }
                    
                    
                }) { (error, endPoint) in
                    self.hideHud()
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                self.hideHud()
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
//            self.hideHud()
        }
    }
}
