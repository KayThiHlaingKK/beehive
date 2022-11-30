//
//  VC_Store_Search.swift
//  ST Ecommerce
//
//  Created by necixy on 07/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD

class VC_Store_Search: UIViewController, FavoriteListener {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var lblHeaderView: UILabel!
    @IBOutlet weak var heightContraintsHeaderView: NSLayoutConstraint!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarStore: UISearchBar!
    @IBOutlet weak var imgCart: UIImageView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var imgAssuredStore: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var searchProducts : SearchProduct?
    var products = [Product]()
    var apiPage = 1
    var searchStr = ""
    var storeSearch: VC_Store_Search?
    var shopSlug: String?
    var categorySlug = ""
    var categoryId = 0
    var categoryName = ""
    var categorizedProduct: CategorizedProduct?
    var lastPage = 1
    
    private let cellId = "Cell_CV_ProductHome"
    //    let search = UISearchController(searchResultsController: nil)
    var apiRequested = false
    
    //for coming from selected category
    var category : ShopCategory?
    //    var isFromSearch = true
    var type : StoreProduct?
    var store : Shop?
    
    var isLoading = true
    var loadingView: LoadingReusableView?
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarStore.setImage(#imageLiteral(resourceName: "magnifying-glass"), for: .search, state: .normal)
        if #available(iOS 12.0, *) {
            searchBarStore.textField?.contentVerticalAlignment = .center
            searchBarStore.searchTextPositionAdjustment = UIOffset(horizontal: 8.0, vertical: 0.0)
        }
        
        //        if category != nil {
        //            categoryId = category?.id ?? 0
        //            categoryName = category?.name ?? ""
        //        } else {
        //        }
        setupView()
        
        if self.type == StoreProduct.search{
            self.loadProductsFromServer(str: self.searchStr)
        }
        else if self.type == StoreProduct.viewAll {
            self.loadProductsFromServer(str: "")
        }
        else if self.type == StoreProduct.other {
            self.products = categorizedProduct?.products ?? []
            self.collectionView.reloadData()
        }
        else {
            self.loadProductsFromServer(str: "")
        }
        
        self.activityIndicator.isHidden = true
        activityViewHeight.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        
        if type == StoreProduct.search{
            lblHeaderView.isHidden = true
//            imgAssuredStore.isHidden = true
            imgCart.isHidden = true
            labelCartCount.isHidden = true
            btnCart.isHidden = true
            self.labelCartCount.isHidden = true
            
        }else{
            imgCart.isHidden = false
            btnCart.isHidden = false
            labelCartCount.isHidden = false
            searchBarStore.isHidden = true
            self.labelCartCount.isHidden = false
        }
        
        if readLogin() != 0 {
            self.loadCartCount()
        }
        else {
            self.labelCartCount.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
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
    
    //MARK: - Helper Functions
    
    func setupView(){
        self.collectionViewSetUP()
        
        heightContraintsHeaderView.constant = 85
        if DeviceUtils.isDeviceIphoneXOrlatter() {
            heightContraintsHeaderView.constant = 105
        }
        
        if type == StoreProduct.search{
            self.navigationBarSetUp()
            //            loadProductsFromServer(str: searchStr)
        }
        else if type == StoreProduct.other {
            lblHeaderView.text = categoryName
//            imgAssuredStore.isHidden = true
            viewEmpty.isHidden = true
        }
        else{
            
            if type == StoreProduct.viewAll{
                lblHeaderView.text = categoryName
//                imgAssuredStore.isHidden = true
            }
            
            else if type == StoreProduct.store{
                lblHeaderView.text = store?.name
//                                if store?.is_official == true {
////                                    imgAssuredStore.isHidden = false
//                                    imgAssuredStore.setImageColor(color: .white)
//                                } else {
//                                    imgAssuredStore.isHidden = true
//                                }
            }
            
            //loadProductsFromServer(str: "")
        }
        
    }
    
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        products[index!].is_favorite = isFavourite
    }
    
    
    
    
    private func navigationBarSetUp(){
        
        searchBarStore.delegate = self
        searchBarStore.layer.cornerRadius = 8
        //searchBarStore.layer.borderColor = UIColor.clear.cgColor
        //searchBarStore.textField?.borderStyle = .none
        searchBarStore.clipsToBounds = true
        searchBarStore.searchBarStyle = .minimal
        searchBarStore.setTextField(color: .white)
        
        //        searchBarStore.delegate = self
        //        searchBarStore.layer.cornerRadius = 10
        //        searchBarStore.clipsToBounds = true
        //
        if type == StoreProduct.search{
            self.title = searchProductText
        }
        
        if type == StoreProduct.search{
            
            if #available(iOS 13.0, *) {
                searchBarStore.searchTextField.backgroundColor = UIColor.white
            } else {
                searchBarStore.backgroundColor = UIColor.white
            }
            searchBarStore.text = searchStr
            addDoneButtonOnKeyboard()
        }
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
        
        searchBarStore.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.searchBarStore.resignFirstResponder()
    }
    
    
    func loadProductsFromServer(str:String){

        let param : [String:Any] = [:]
        print("param \(param)")
        
        if apiPage == 1{
            self.showHud(message: loadingText)
        }
        let strCheck = str.trimmingCharacters(in: .whitespacesAndNewlines)
        var apiStr = ""
        
        if type == StoreProduct.search{
            apiStr = "\(APIEndPoint.product.caseValue)?filter=\(strCheck)&page=\(apiPage)&size=20"
        }
        else if type == StoreProduct.viewAll {
            
            if let shopSlug = shopSlug {
                apiStr = "\(APIEndPoint.shops.caseValue)/\(shopSlug)/categories/\(categorySlug)/products?page=\(apiPage)&size=20"
            } else {
                apiStr = "\(APIEndPoint.productByCategory.caseValue)\(categorySlug)?page=\(apiPage)&size=20"
            }
        }
        else if type == StoreProduct.store{
            apiStr = "\(APIEndPoint.stores.caseValue)\(store?.slug ?? "")"
        }
        print("search == " , apiStr)
        
        APIUtils.APICall(postName: "\(apiStr)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.apiRequested = false
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                //Success from our server
                APIUtils.prepareModalFromData(data, apiName: APIEndPoint.productSearchStore.caseValue, modelName:"SearchProducts", onSuccess: { (anyData) in
                    
                    if let searchProducts = anyData as? SearchProduct {
                        self.isLoading = false
                        if self.searchProducts == nil {
                            self.searchProducts = searchProducts
                        } else {
                            self.searchProducts?.data?.append(contentsOf: searchProducts.data!)
                        }
                    }
                    
                    self.lastPage = self.searchProducts?.lastPage ?? 1
                    
                    //showing empty store view when no data
                    if self.searchProducts?.data?.count == 0 {
                        self.viewEmpty.isHidden = false
                    }else{
                        self.viewEmpty.isHidden = true
                        //adding to product array
//
                        self.products = (self.searchProducts?.data)!
                        
                        print("pro count == " , self.products.count)
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.activityViewHeight.constant = 0
                            self.collectionView.reloadData()
                        }
                    }
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
                self.hideHud()
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    
    //MARK: - Action Functions
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cart(_ sender: Any) {
        if readLogin() != 0
        {
            guard let vc = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
            
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
    
}


extension VC_Store_Search : UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate{
    //MARK: - Search Bar
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchStr = ""
        searchBarStore.text = ""
        products = []
        self.searchBarStore.resignFirstResponder()
        //showing empty store view when no data
        viewEmpty.isHidden = false
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStr = searchBar.text ?? ""
        let strCheck = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if strCheck != ""{
            apiPage = 1
            products = []
            viewEmpty.isHidden = true
            loadProductsFromServer(str: strCheck)
        }else{
            searchStr = ""
            products = []
            //showing empty store view when no data
            viewEmpty.isHidden = false
            self.collectionView.reloadData()
        }
    }
    
    //for making active search bar
    func didPresentSearchController(searchController: UISearchController) {
        self.searchBarStore.becomeFirstResponder()
    }
}




extension VC_Store_Search : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //MARK: - CollectionView Functions
    
    func collectionViewSetUP(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: "Cell_CV_Product", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Product")
        
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
        ["LoadingReusableView", "Cell_CV_EndResult"].forEach {
            let nib = UINib(nibName: $0, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0)
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       return createProductHomeCell(indexPath)
    }
    
    private func createProductHomeCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? Cell_CV_ProductHome else { return UICollectionViewCell() }
        cell.controller = self
        cell.indexPath = indexPath
        cell.index = indexPath.item
        cell.setData(product: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        let cellWidth = (screenWidth - 48) / 2
        let cellHeight = cellWidth*1.6
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let  product = self.products[indexPath.row]
        
        let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController

        if let productId = product.slug{
            vc.slug = productId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else if !self.isLoading && apiPage == lastPage {
            return CGSize(width: collectionView.bounds.size.width, height: 44)
        }
        else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if !self.isLoading && apiPage == lastPage {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell_CV_EndResult", for: indexPath) as! Cell_CV_EndResult
            return aFooterView
        }
        else if kind == UICollectionView.elementKindSectionFooter && type == StoreProduct.viewAll {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            loadingView?.activityIndicator.startAnimating()
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
//            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    //methods for adding footer indicator : end
    
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            if self.lastPage > self.apiPage && type == StoreProduct.viewAll {
//                self.isLoading = false
//                self.apiPage += 1
//                loadProductsFromServer(str: searchStr)
//
//            }
//            else {
//                self.isLoading = true
//            }
        }
}

extension VC_Store_Search: UITextFieldDelegate {
    
    //MARK: - TextField Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}


extension VC_Store_Search: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("called")
        print(lastPage , apiPage)
        if self.lastPage > self.apiPage {
            self.apiPage += 1
            self.activityViewHeight.constant = 50

            DispatchQueue.background(delay: 7, background: {
                if self.type == StoreProduct.viewAll  {
                    self.isLoading = true
                    self.loadProductsFromServer(str: "")
                }
                else if self.type == StoreProduct.search {
                    
                    self.isLoading = true
                    self.loadProductsFromServer(str: self.searchStr)
                }

            }, completion: {
                self.hideHud()
            })
            
        }

    }
}


