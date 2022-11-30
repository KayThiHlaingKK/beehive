//
//  VC_BrandDetail.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 22/03/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_BrandDetail: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private enum CellTypes: String, CaseIterable {
        case Cell_CV_BrandHeader, Cell_CV_AvailableShop, Cell_CV_ProductHome,
             Cell_CV_EmptyView
    }
    
    private enum HeaderTypes: String, CaseIterable {
        case ReusableView_BrandCategoryMenu, SectionHeader
    }
    private var brand: Brand?
    var brandId: String?
    private var products = [Product]()
    private var categories = [ShopCategory]()
    private var shops = [Shop]()
    private var productOrderCount = 0
    private var selectedCategoryIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func goToCartView() {
        if readLogin() != 0 {
            guard let vc = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
            vc.isTappedFromStore = true
            vc.cartType = Cart.store
            vc.cartOption = .navigation
            vc.isFromStore = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showNeedToLoginApp()
        }
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        CellTypes.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: $0.rawValue)
        }
        
        HeaderTypes.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: $0.rawValue)
        }
        
    }
    
    private func fetchData() {
        productOrderCount = 0
        shops = []
        categories = []
        products = []
        
        loadCartData()
        loadBrand()
        
        //        dispatchGroup.notify(queue: DispatchQueue.main) {
        //            print("SHOPS+======\(self.shops.count)")
        //            print("CATEGORIES+======\(self.categories.count)")
        //            self.collectionView.reloadData()
        //        }
    }
    
}


extension VC_BrandDetail: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return shops.count
        case 2:
            if categories.isEmpty && products.isEmpty {
                return 0
            }
            if products.isEmpty {
                return 1
            }
            return products.count
        default: return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: return createBrandHeaderCell(indexPath)
        case 1: return createAvailableShopCell(indexPath)
        case 2:
            if products.isEmpty {
                return createEmptyCell(indexPath)
            }
            
            return createProductHomeCell(indexPath)
        default: return UICollectionViewCell()
        }
    }
    
    private func createAvailableShopCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellTypes.Cell_CV_AvailableShop.rawValue, for: indexPath) as? Cell_CV_AvailableShop else { return UICollectionViewCell() }
        cell.setData(shop: shops[indexPath.item])
        return cell
    }
    
    private func createProductHomeCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellTypes.Cell_CV_ProductHome.rawValue, for: indexPath) as? Cell_CV_ProductHome else { return UICollectionViewCell() }
        
        //        if (indexPath.item + 1) == products.count && currentPage < lastPage {
        //            currentPage += 1
        //            fetchSubCategory()
        //        }
        //        if currentPage >= lastPage {
        //            loadingView?.activityIndicator.stopAnimating()
        //        }
        
        cell.indexPath = indexPath
        cell.controller = self
        cell.setData(product: products[indexPath.item])
        return cell
    }
    
    private func createEmptyCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellTypes.Cell_CV_EmptyView.rawValue, for: indexPath) as? Cell_CV_EmptyView
        else { return UICollectionViewCell() }
        return cell
    }
    
    private func createBrandHeaderCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellTypes.Cell_CV_BrandHeader.rawValue, for: indexPath) as? Cell_CV_BrandHeader else { return UICollectionViewCell() }
        cell.controller = self
        if let brand = brand {
            cell.setData(brand: brand, cartCount: productOrderCount)
        }
        return cell
    }
}


extension VC_BrandDetail {
    
    private func loadBrand(){
        guard let slug = brandId else { return }
        let api = "\(APIEndPoint.brands.caseValue)/\(slug)"
        showHud(message: "")
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
            let status = resp.value(forKey: key_status) as? Int ?? 0
            self.shops = []
            
            if status == 200 {
                if let data = resp.value(forKeyPath: "data") as? NSDictionary {
                    
                    APIUtils.prepareModalFromData(data, apiName: APIEndPoint.brands.caseValue, modelName: "Brand", onSuccess: { (anyData) in
                        
                        if let brandData = anyData as? Brand {
                            self.brand = brandData
                        }
                        DispatchQueue.main.async {
                            self.loadShopsByBrand()
                            self.loadCategoriesByBrand()
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            } else {
                let message =
                resp[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
        }
    }
    
    private func loadShopsByBrand(){
        guard let slug = brand?.slug else { return }
        let api = "\(APIEndPoint.brands.caseValue)/\(slug)/shops"
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
            let status = resp.value(forKey: key_status) as? Int ?? 0
            self.shops = []
            
            if status == 200 {
                if let data = resp.value(forKeyPath: "data") as? NSArray {
                    APIUtils.prepareModalFromData(data, apiName: api, modelName: "Shop", onSuccess: { (anyData) in
                        if let shopsData = anyData as? [Shop] {
                            self.shops.append(contentsOf: shopsData)
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadSections(IndexSet(integer: 1))
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            } else {
                let message =
                resp[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
        }
    }
    
    private func loadCategoriesByBrand(){
        guard let slug = brand?.slug else { return }
        let api = "\(APIEndPoint.brands.caseValue)/\(slug)/categories"
        
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
            let status = resp.value(forKey: key_status) as? Int ?? 0
            self.categories = []
            
            if status == 200 {
                if let data = resp.value(forKeyPath: "data") as? NSArray {
                    
                    APIUtils.prepareModalFromData(data, apiName: api, modelName: "ShopCategory", onSuccess: { (anyData) in
                        if let categoriesData = anyData as? ShopCategory {
                            self.categories.append(categoriesData)
                        }
                        DispatchQueue.main.async {
                            self.loadProductsByCategory(index: nil)
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            } else {
                let message =
                resp[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
        }
    }
    
    func loadProductsByCategory(index: Int?) {
        guard let slug = brand?.slug,
              let categorySlug = categories[index ?? 0].slug
        else { return }
        let api = "\(APIEndPoint.brands.caseValue)/\(slug)/categories/\(categorySlug)/products?size=40"
        self.selectedCategoryIndex = index ?? 0
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
            let status = resp.value(forKey: key_status) as? Int ?? 0
            self.products = []
            DispatchQueue.main.async {
                self.hideHud()
            }
            if status == 200 {
                if let data = resp.value(forKeyPath: "data") as? NSArray {
                    APIUtils.prepareModalFromData(data, apiName: api, modelName: "Product", onSuccess: { (anyData) in
                        if let products = anyData as? Product {
                            self.products.append( products)
                        }
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadSections(IndexSet([2]))
//                        }
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadSections(IndexSet([2]))
                    }
                }
            } else {
                let message =
                resp[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
        }
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
                        
                        if let shopcount = cartData?.shop?.shops?.count, shopcount > 0 {
                            for i in 0..<shopcount {
                                let product = cartData?.shop?.shops?[i].productCarts
                                for j in 0..<Int(product?.count ?? 0) {
                                    self.productOrderCount += product?[j].quantity ?? 0
                                }
                                
                            }
                            DispatchQueue.main.async {
                                self.collectionView.reloadSections(IndexSet(integer: 0))
                            }
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


extension VC_BrandDetail: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        switch indexPath.section {
        case 0:
            let cellHeight = (screenWidth * (213/408)) + 32
            return CGSize(width: screenWidth, height: cellHeight)
        case 1: return CGSize(width: 90, height: 138)
        case 2:
            let size = products.isEmpty ? calculateSizeEmptyCell(): calculateSizeForProductCell()
            return size
        default: return CGSize(width: 0, height: 0)
        }
    }
    
    func calculateSizeForProductCell() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = (screenWidth - (32 + 12 + 4)) / 2
        let cellHeight = (cellWidth*1.6) + 20
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func calculateSizeEmptyCell() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = screenWidth - 32
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 {
            return UIEdgeInsets(top: 32, left: 16, bottom: 0, right: 16)
        } else if section != 0 {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let emptySize = CGSize(width: collectionView.frame.width, height: 0)
        let headerSize = CGSize(width: collectionView.frame.width, height: 54)
        
        switch section {
        case 1: return shops.isEmpty ? emptySize: headerSize
        case 2: return categories.isEmpty ? emptySize: headerSize
        default: return emptySize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader
        else { return UICollectionReusableView() }
        
        if indexPath.section == 2,
           let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReusableView_BrandCategoryMenu", for: indexPath) as? ReusableView_BrandCategoryMenu {
            cell.controller = self
            cell.selectedCategoryIndex = selectedCategoryIndex
            cell.setData(categories: categories)
            return cell
        } else if let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {
            cell.sectionTitle.text = "Available Shop"
            return cell
        } else { return UICollectionReusableView() }
        
    }
    
    func isFavorited(indexPath: IndexPath, isFavourite: Bool) {
        switch indexPath.section {
        case 2: products[indexPath.item].is_favorite = isFavourite
        default: break
        }
    }
}


extension VC_BrandDetail: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1: goToShopDetail(indexPath)
        case 2: goToProductDetail(indexPath)
        default: break
        }
    }
    
    private func goToShopDetail(_ indexPath: IndexPath) {
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        vc.shop = shops[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToProductDetail(_ indexPath: IndexPath) {
        guard let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        else { return }
    
        vc.fromCart = false
        if let productId = products[indexPath.item].slug {
            vc.slug = productId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
