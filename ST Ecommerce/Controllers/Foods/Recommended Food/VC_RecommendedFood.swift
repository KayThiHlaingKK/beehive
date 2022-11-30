//
//  VC_RecommendedFood.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 27/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_RecommendedFood: UIViewController {
   
    
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var loadingView: LoadingReusableView?
    
    private let cellID = "Cell_CV_Restaurant"
    private var restaurants = [RestaurantBranch]()
    private var currentPage = 1
    private var lastPage = 1
    private var isLoading = false
    private var lat = 0.0
    private var long = 0.0
    var serviceAnnouncement: ServiceAnnouncement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLocation()
        labelCartCount.isHidden = true
        isUserLoginOrNot()
        currentPage = 1
        lastPage = 1
        restaurants = []
        
        loadRestaurantsRecommendataions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        ["LoadingReusableView", "Cell_CV_EndResult"].forEach {
            let nib = UINib(nibName: $0, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartButtonPressed(_ sender: UIButton) {
        
    }
    
}



// MARK: - Cart Count Related Functions

extension VC_RecommendedFood {
    @objc func isUserLoginOrNot(){
        if readLogin() != 0 {
            self.loadRestaurantCart()
        } else {
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
            }
        }) { (reason, statusCode) in
        }
    }
    
    private func loadRestaurantsRecommendataions() {
        let apiStr: String? = "\(APIEndPoint.restaurantsRecommendations.caseValue)?lat=\(lat)&lng=\(long)&page=\(currentPage)&size=15"
        
        self.isLoading = true
        APIUtils.APICall(postName: "\(apiStr ?? "")", method: .get, parameters: [:], controller: self) { (response) in
            
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                self.lastPage = data.value(forKey: "last_page") as? Int ?? 0
                self.isLoading = false
                if status == 200 {
                    
                    if let restaurants = data.value(forKeyPath: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(restaurants, apiName: APIEndPoint.restaurantsRecommendations.caseValue, modelName: "RestaurantBranch", onSuccess: { (anyData) in
                            
                            if let recommendation = anyData as? RestaurantBranch {
                                self.restaurants.append(recommendation)
                            }
                            DispatchQueue.main.async {
                                self.loadingView?.activityIndicator.stopAnimating()
                                
                                self.collectionView.reloadData()
                            }
                            
                        }) { (errror, reason) in
                            print("error \(String(describing: errror)), reason \(reason)")
                        }
                    }
                } else {
                    print("else")
                    let _ = data[key_message] as? String ?? serverError
                }
            }
            
        } onFailure: { (reason, statusCode) in
            
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

extension VC_RecommendedFood: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let restroID = self.restaurants[indexPath.row].slug {
            let vc = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
            vc.slug = restroID
            vc.restaurantSlug = self.restaurants[indexPath.item].restaurant?.slug ?? ""
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter
        else { return UICollectionReusableView() }
        if currentPage >= lastPage && lastPage != 0 && isLoading == false {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Cell_CV_EndResult", for: indexPath) as! Cell_CV_EndResult
            return aFooterView
        }
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath) as! LoadingReusableView
        loadingView = footerView
        loadingView?.backgroundColor = UIColor.clear
        loadingView?.activityIndicator.startAnimating()
        loadingView?.activityIndicator.hidesWhenStopped = true
        return footerView
    }
}

extension VC_RecommendedFood: FavoriteListener {
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        guard let index = index else { return }
        restaurants[index].restaurant?.is_favorite = isFavourite
    }
    
    
}

extension VC_RecommendedFood: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! Cell_CV_Restaurant
        let item = indexPath.item
        cell.serviceAnnouncement = self.serviceAnnouncement
        if (item + 1) == restaurants.count && currentPage <= lastPage {
            currentPage += 1
            loadRestaurantsRecommendataions()
        }
        if currentPage >= lastPage {
            loadingView?.activityIndicator.stopAnimating()
        }
        
        let restaurant = restaurants[item]
        cell.setupData(restaurantBranch: restaurant)
        cell.favoriteDelegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        restaurants.count
    }
}

extension VC_RecommendedFood: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 64
        let height = width * (251 / 288)
        return CGSize(width: width, height: height)
    }
}
