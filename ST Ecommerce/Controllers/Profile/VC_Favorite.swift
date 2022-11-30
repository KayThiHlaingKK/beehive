//
//  VC_Favorite.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 10/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_Favorite: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var foodsTab: UIView!
    @IBOutlet weak var shopsTab: UIView!
    @IBOutlet weak var foodsTabUnderline: RoundedView!
    @IBOutlet weak var shopsTabUnderline: RoundedView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuBar: UIStackView!
    
    
    // MARK: - Properties
    
    private var products = [Product]()
    private var restaurants = [RestaurantBranch]()
    private enum CellType: String, CaseIterable {
        case Cell_CV_RestaurantRow, Cell_CV_ProductHome
    }
    private var isFoodsTabSelected = true
    var selectedTag: Int?
    private var lat = "0.0"
    private var long = "0.0"
    private let dispatchGroup = DispatchGroup()
    private var serviceAnnouncement: ServiceAnnouncement?
    var showMenuBar = true
 
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        fetchData()
        
        changeMenu(tag: selectedTag ?? 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuHeightConstraint.constant = showMenuBar ? 50: 0
        menuBar.isHidden = !showMenuBar
    }
    
    
    // MARK: - Setup Functions
    
    private func setupCollectionView() {
        CellType.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: $0.rawValue)
        }
    }
    
    private func setupUI() {
        setupSegmentedMenu()
    }
    
    private func fetchData() {
        if let selectedAddress = Singleton.shareInstance.selectedAddress,
           let latitude = selectedAddress.latitude,
           let longitude = selectedAddress.longitude {
            lat = "\(latitude)"
            long = "\(longitude)"
        } else {
            lat = "\(Singleton.shareInstance.currentLat)"
            long = "\(Singleton.shareInstance.currentLong)"
        }
//        if let selectedLocation = Singleton.shareInstance.selectedAddress {
//            lat = "\(selectedLocation.latitude)"
//            long = "\(selectedLocation.longitude)"
//        }
        showHud(message: "Loading...")
        
        loadServiceAnnouncement()
        loadFavouriteRestaurants()
        loadFavoriteProducts()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if let controller = self {
                controller.hideHud()
                controller.collectionView.isHidden = controller.isFoodsTabSelected ? controller.restaurants.isEmpty : controller.products.isEmpty
                controller.collectionView.reloadData()
            }
           
        }
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}


extension VC_Favorite: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFoodsTabSelected ? restaurants.count : products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        isFoodsTabSelected ? createRestaurantCell(indexPath): createProductCell(indexPath)
    }
    
    private func createProductCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.Cell_CV_ProductHome.rawValue, for: indexPath) as? Cell_CV_ProductHome else { return UICollectionViewCell() }
        cell.controller = self
        cell.favouriteListener = self
        cell.index = indexPath.item
        cell.setData(product: products[indexPath.item])
        return cell
    }
    
    private func createRestaurantCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.Cell_CV_RestaurantRow.rawValue, for: indexPath) as? Cell_CV_RestaurantRow else { return UICollectionViewCell() }
        cell.serviceAnnouncement = self.serviceAnnouncement
        cell.favoriteDelegate = self
        cell.controller = self
        cell.indexPath = indexPath
        cell.setData(restaurantBranch: restaurants[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isFoodsTabSelected ? goToRestaurantDetail(indexPath) : goToProductDetail(indexPath)
    }
    
    private func goToProductDetail(_ indexPath: IndexPath) {
        let item = products[indexPath.item]
        let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.slug = item.slug ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToRestaurantDetail(_ indexPath: IndexPath) {
        let item = restaurants[indexPath.item]
        let vc = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.slug = item.slug ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension VC_Favorite: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        isFoodsTabSelected ? sizeForRestaurantCell() : sizeForProductCell()
    }
    
    private func sizeForProductCell() -> CGSize {
        let screenWidth = collectionView.frame.width
        let cellWidth = (screenWidth - (32 + 12 + 4)) / 2
        let cellHeight = (cellWidth*1.6) + 20
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    private func sizeForRestaurantCell() -> CGSize {
        let screenWidth = collectionView.frame.width
        let cellWidth = (screenWidth - 16)
        let cellHeight = (cellWidth * (176/344))
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


// MARK: - MenuTap Related Functions

extension VC_Favorite {
    
    private func setupSegmentedMenu() {
        [foodsTab, shopsTab].forEach { [unowned self] in
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapMenu(sender:)))
            $0!.addGestureRecognizer(gesture)
        }
    }
    
    @objc func onTapMenu(sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        changeMenu(tag: tag)
    }
    
    func changeMenu(tag: Int) {
        isFoodsTabSelected = tag == 0
        foodsTabUnderline.isHidden = !isFoodsTabSelected
        shopsTabUnderline.isHidden = isFoodsTabSelected
        collectionView.isHidden = isFoodsTabSelected ? restaurants.isEmpty : products.isEmpty
        collectionView.reloadData()
    }
}


// MARK: - Networking Functions

extension VC_Favorite {
    
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
    
    
    
    private func loadFavouriteRestaurants() {
        let apiStr = "\(APIEndPoint.favouriteRestaurantList.caseValue)?lat=\(lat)&lng=\(long)&size=100&page=1"
        
        self.dispatchGroup.enter()
        
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any]() , controller: self) { (response) in
            
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                if status == 200 {
                    if let favourites = data.value(forKey: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.favouriteRestaurantList.caseValue, modelName: "Favourites", onSuccess: { (anyData) in
                            
                            if let favorite = anyData as? RestaurantBranch {
                                self.restaurants.append(favorite)
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
    
    
    private func loadFavoriteProducts() {
        let apiStr = "\(APIEndPoint.favouriteProductList.caseValue)?size=100&page=1"
        dispatchGroup.enter()
        
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                if status == 200 {
                    if let favourites = data.value(forKeyPath: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: APIEndPoint.favouriteProductList.caseValue, modelName: "Product", onSuccess: { (anyData) in
                            
                            if let favorite = anyData as? Product {
                                self.products.append(favorite)
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


extension VC_Favorite: FavoriteListener {
    
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        guard let index = index else { return }
        self.products[index].is_favorite = isFavourite
    }
}

extension VC_Favorite: Cell_CV_RestaurantRowDelegate {
    func isFavorite(indexPath: IndexPath, isFavorite: Bool) {
        self.restaurants[indexPath.item].restaurant?.is_favorite = isFavorite
    }
}
