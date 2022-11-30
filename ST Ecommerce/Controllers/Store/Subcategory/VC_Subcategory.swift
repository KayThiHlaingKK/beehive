//
//  VC_Subcategory.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 05/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_Subcategory: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var largeTitleLabel: UILabel!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    private var loadingView: LoadingReusableView?
    
    
    // MARK: - Properties
    
    private var currentPage = 1
    private var lastPage = 1
    private var shopSubcategory: ShopSubCategory!
    private var shopCategory: ShopCategory!
    private var isLoading = false
    private var products = [Product]()
    private enum CellTypes: String, CaseIterable {
        case Cell_CV_ProductHome
    }
    
    private enum FooterCellTypes: String, CaseIterable {
        case Cell_CV_EndResult, LoadingReusableView
    }
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentPage = 1
        lastPage = 1
        products = []
        hideFilterView()
        
        if readLogin() != 0{
            self.loadCartCount()
        } else {
            labelCartCount.isHidden = true
        }
        largeTitleLabel.text = shopSubcategory.name
        fetchSubCategory()
    }
    
    private func hideFilterView() {
        filterView.isHidden = true
        filterViewHeightConstraint.constant = 0
    }
    
    private func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16)
        
        CellTypes.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: $0.rawValue)
        }
        
        FooterCellTypes.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0.rawValue)
        }
        
    }
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goToCart(_ sender: UIButton) {
        navigateToCartViewController()
    }
    
    @IBAction func searchBarTap(_ sender: UIButton) {
        let vc = storyboardHome.instantiateViewController(withIdentifier: "VC_Search") as! VC_Search
        vc.tappedMenuTag = 0
        vc.hideMenuBar = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setData(shopSubcategory: ShopSubCategory) {
        self.shopSubcategory = shopSubcategory
    }
    
    func setData(shopCategory: ShopCategory) {
        self.shopCategory = shopCategory
    }
    
    @IBAction func dropDownPressed(_ sender: UIButton) {
        
    }
    
}


// MARK: - UICollectionViewDelegate

extension VC_Subcategory: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < products.count else { return }
        let product = products[indexPath.item]
        navigateToProducDetail(product: product)
    }
    
    func navigateToProducDetail(product: Product) {
        guard let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        else { return }
        
        if let productId = product.slug {
            vc.slug = productId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



// MARK: - UICollectionViewDataSource

extension VC_Subcategory: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if products.isEmpty {
            return 0
        }
        return products.count// MARK: + 1 is for EndResult Cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return createProductHomeCell(indexPath: indexPath)
    }
    
    private func createProductHomeCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellTypes.Cell_CV_ProductHome.rawValue, for: indexPath) as? Cell_CV_ProductHome else { return UICollectionViewCell() }
        
        if (indexPath.item + 1) == products.count && currentPage < lastPage {
            currentPage += 1
            fetchSubCategory()
        }
        if currentPage >= lastPage {
            loadingView?.activityIndicator.stopAnimating()
        }
        
        cell.index = indexPath.item
        cell.controller = self
        let product = products[indexPath.item]
        cell.setData(product: product)
        
        return cell
    }
}



// MARK: - UICollectionViewDelegateFlowLayout

extension VC_Subcategory: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        calculateSizeForProductCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter
        else { return UICollectionReusableView() }
        
//        if currentPage >= self.lastPage && products.count > 0 && isLoading == false {
//            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCellTypes.Cell_CV_EndResult.rawValue, for: indexPath) as! Cell_CV_EndResult
//            return aFooterView
//        }
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FooterCellTypes.LoadingReusableView.rawValue, for: indexPath) as! LoadingReusableView
        loadingView = footerView
        loadingView?.backgroundColor = UIColor.clear
        loadingView?.activityIndicator.startAnimating()
        loadingView?.activityIndicator.hidesWhenStopped = true
        return footerView
    }
    
    func calculateSizeForProductCell() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = (screenWidth - (32 + 12 + 4)) / 2
        let cellHeight = (cellWidth*1.6) + 20
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func calculateSizeForEndResultCell() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width - 32
        return CGSize(width: screenWidth, height: 50)
    }
}





// MARK: - Networking

extension VC_Subcategory {
    
    private func fetchSubCategory() {
        guard let slug = shopSubcategory.slug else { return }
        let api = "\(APIEndPoint.shopSubcategory.caseValue)/\(slug)/products?page=\(currentPage)&size=10"
        isLoading = true
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
            
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.loadingView?.activityIndicator.stopAnimating()
            }
                
            if status == 200 {
                let shopSubCategoriesData = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(shopSubCategoriesData, apiName: APIEndPoint.shopSubcategory.caseValue, modelName:"ShopSubCategory", onSuccess: { [unowned self] (product) in
                    if let product = product as? Product {
                        self.products.append(product)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.isHidden = self.products.isEmpty
                        self.collectionView.reloadData()
                    }
                    
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { [unowned self] (reason, statusCode) in
            self.hideHud()
        }
    }
    
    private func fetchProductbyCategory() {
        guard let slug = shopSubcategory.slug else { return }
        let api = "\(APIEndPoint.shopSubcategory.caseValue)/\(slug)/products"
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                let shopSubCategoriesData = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(shopSubCategoriesData, apiName: APIEndPoint.shopSubcategory.caseValue, modelName:"ShopSubCategory", onSuccess: { [unowned self] (product) in
                    if let product = product as? Product {
                        self.products.append(product)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.isHidden = self.products.isEmpty
                        self.collectionView.reloadData()
                    }
                    
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { [unowned self] (reason, statusCode) in
            self.hideHud()
        }
    }
    
    private func errorAlert(message: String) {
        let alertController = UIAlertController(title: errorText, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true)
    }
}



// MARK: - Cart Related Functions

extension VC_Subcategory {
    
    private func loadCartCount() {
        
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
    
    private func navigateToCartViewController() {
        guard readLogin() == 1 else {
            self.showNeedToLoginApp()
            return
        }
        guard let vc = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
        vc.cartType = Cart.store
        vc.cartOption = .navigation
        vc.isFromStore = true
        vc.fromHome = false
        vc.isTappedFromStore = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VC_Subcategory: FavoriteListener {
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        guard let index = index else {
            return
        }
        products[index].is_favorite = isFavourite
    }
    
    
}
