//
//  VC_AllProducts.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 25/11/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class VC_AllProducts: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    private let cellId = "Cell_CV_ProductHome"
    private var loadingView: LoadingReusableView?
    
    private let refreshControl = UIRefreshControl()
    
    
    weak var controller: UIViewController!
    var products = [Product]()
    var productType: ProductType = .other
    private var lat = 0.0
    private var long = 0.0
    private var currentPage = 1
    private var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupRefreshControl()
    }
    
    
    private func setupRefreshControl() {
        refreshControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        productsCollectionView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    private func setupCollectionView() {
        productsCollectionView.dataSource = self
        productsCollectionView.delegate = self
        productsCollectionView.register(UINib(nibName: "Cell_CV_ProductHome", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_ProductHome")
        productsCollectionView.register(UINib(nibName: "LoadingReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")
        
        productsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productsCollectionView.reloadData()
    }
    
    func setData(products: [Product]) {
        self.products = products
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        controller.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
       fetchData()
    }
    
    private func fetchData() {
        products = []
        productsCollectionView.reloadData()
        getLocation()
        refreshControl.beginRefreshing()
        switch productType {
        case .newArrivalsProduct:
            loadNewArrivalsProducts()
            titleLbl.text = "New Arrivals"
        case .suggestionsProduct:
            currentPage = 1
            lastPage = 1
            loadSuggestionProducts()
            titleLbl.text = "Recommend For You"
        default:
            break
        }
    }
    
    private func getLocation() {
        let address = Singleton.shareInstance.selectedAddress
        if let address = address {
            lat = address.latitude ?? 0.0
            long = address.longitude ?? 0.0
        } else {
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
    }
    
}




extension VC_AllProducts: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = (screenWidth - 48) / 2
        let cellHeight = (cellWidth*1.6) + 20
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? Cell_CV_ProductHome else {
            return UICollectionViewCell()
        }
       
        if (indexPath.item + 1) == products.count && currentPage < lastPage && productType == .suggestionsProduct {
            currentPage += 1
            loadSuggestionProducts()
        }
        if currentPage >= lastPage {
            loadingView?.activityIndicator.stopAnimating()
        }
        
        cell.productType = .other
        cell.indexPath = indexPath
        cell.index = indexPath.item
        cell.controller = self
        cell.setData(product: products[indexPath.item])
        cell.favouriteListener = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        
        if let productId = product.slug {
            vc.slug = productId
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter
        else { return UICollectionReusableView() }
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath) as! LoadingReusableView
        loadingView = footerView
        loadingView?.backgroundColor = UIColor.clear
        loadingView?.activityIndicator.startAnimating()
        footerView.isHidden = self.currentPage == 1
        
        loadingView?.activityIndicator.hidesWhenStopped = true
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }

}


// MARK: - Networking

extension VC_AllProducts {
    
    private func loadSuggestionProducts() {
        guard lat != 0.0 else { return }
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        
        let api = "\(APIEndPoint.recommendProduct.caseValue)?device_id=\(deviceId)&size=10&page=\(currentPage)"
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            print("recommend res = ", response)
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
            
            DispatchQueue.main.async {
                self.loadingView?.activityIndicator.stopAnimating()
            }
            
            if status == 200{
                let suggestions = data.value(forKeyPath: "data") as? NSArray ?? []
                   
                    APIUtils.prepareModalFromData(suggestions, apiName: APIEndPoint.recommendProduct.caseValue, modelName:"Product", onSuccess: { (anyData) in
                        
                        if let recommend = anyData as? Product {
                            self.products.append(recommend)
                        }
                        
                        DispatchQueue.main.async {
                            self.productsCollectionView.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                        self.hideHud()
                    }
                
                
            }else{
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlert(title: APIEndPoint.recommendProduct.caseValue, message: message)
//                self.hideHud()
            }
            
        }) { (reason, statusCode) in
            
        }
    }
    
    private func loadNewArrivalsProducts() {
        let apiStr = "\(APIEndPoint.newArrival.caseValue)?lat=\(lat)&lng=\(long)"
//        showHud(message: "")
        
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.products = []
                DispatchQueue.main.async {
                    self.loadingView?.activityIndicator.stopAnimating()
                }
                
                if status == 200 {
                    if let favourites = data.value(forKeyPath: "data") as? NSDictionary  {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.newArrival.caseValue, modelName: "HomeData", onSuccess: { (anyData) in
                            
                            if let products = (anyData as? HomeData)?.products {
                                self.products.append(contentsOf: products)
                                
                            }
                            DispatchQueue.main.async {
//                                self.hideHud()
                                self.productsCollectionView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                            
                        }) { (errror, reason) in
                            print("error \(String(describing: errror)), reason \(reason)")
                        }
                    }
                } else {
                    let _ = data[key_message] as? String ?? serverError
                }
            }
            
        } onFailure: { (reason, statusCode) in
            print("new arrival fail")
        }
    }
    
}


extension VC_AllProducts: FavoriteListener {
    
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        guard let index = index else { return }
        products[index].is_favorite = isFavourite
    }
}
