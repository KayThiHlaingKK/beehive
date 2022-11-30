//
//  FavouritesViewController.swift
//  ST Ecommerce
//
//  Created by necixy on 21/10/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController, FavoriteListener {

    @IBOutlet weak var vWSwitch: UISegmentedControl!
    @IBOutlet weak var favouritesCollectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var segIndex: Int?
    
    @IBOutlet weak var vwEmpty: UIView!
    
    var favouritesProducts : [Product] = [Product]()
    var favouriteRestaurants : [Restaurant] = [Restaurant]()
    var favouritesProductsFetched = false
    var favouriteRestaurantsFetched = false
    let param : [String:Any] = [:]
    var favoriteListener: FavoriteListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vWSwitch.selectedSegmentIndex = segIndex ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouriteRestaurantsFetched = false
        favouritesProductsFetched = false
        setupUI()
        loadFavouriteProducts()
        loadFavouriteRestaurants()
        
    }
    
    func showEmptyView() {
        if favouriteRestaurantsFetched == true && favouritesProductsFetched == true {
            if favouriteRestaurants.isEmpty && favouritesProducts.isEmpty {
                self.vwEmpty.isHidden = false
            } else {
                self.vwEmpty.isHidden = true
            }
        }
    }
    
    fileprivate func setupUI() {
        Util.configureTopViewPosition(heightConstraint: heightConstraint)
        self.view.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        vWSwitch.backgroundColor = .clear
        if #available(iOS 12.0, *) {
            vWSwitch.tintColor = #colorLiteral(red: 1, green: 0.7851476073, blue: 0.4851175547, alpha: 1)
            vWSwitch.selectedSegmentTintColor(Textcolor: .white, backgroundColor: .green)
            vWSwitch.unselectedSegmentTintColor(Textcolor: .black, backgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
        }


        collectionViewSetUP()
        let font = UIFont.systemFont(ofSize: 20, weight: .medium)
        vWSwitch.setTitleTextAttributes([NSAttributedString.Key.font: font,
                                         NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        print("is favourite")
        self.favouritesProducts[index!].is_favorite = isFavourite
    }
    
    
    @IBAction func btnReload(_ sender: Any) {
        favouriteRestaurantsFetched = false
        favouritesProductsFetched = false
        setupUI()
        loadFavouriteProducts()
        loadFavouriteRestaurants()
    }
    
    func collectionViewSetUP(){
        
        favouritesCollectionView.register(UINib.init(nibName: "Cell_CV_Product", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Product")
        
        //Register Loading Reuseable View
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        favouritesCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")
        
        favouritesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0);
    }
    
    //MARK: - Api calling products and restaurants [need to refactor]
    func loadFavouriteProducts()  {
        
//        print("param \(param)")
//        let apiStr: String? = "\(APIEndPoint.favouriteProductList.caseValue)"
//        self.showHud(message: loadingText)
//
//        APIUtils.APICall(postName: "\(apiStr ?? "")", method: .get, parameters: param, controller: self) { (response) in
//            self.favouritesProductsFetched = true
//            self.hideHud()
//            if let data = response as? NSDictionary {
//                let status = data.value(forKey: key_status) as? Bool ?? false
//                if status{
//                    if let favourites = data.value(forKeyPath: "data") as? NSDictionary{
//
//                        APIUtils.prepareModalFromData(favourites, apiName: apiStr ?? "Empty", modelName: "Favourites", onSuccess: { (anyData) in
//                            if let favourites = anyData as? Favourites{
//                                self.favouritesProducts = favourites.products ?? []
////                                self.favouriteRestaurants = favourites.restaurants ?? []
//
//                                DispatchQueue.main.async {
//                                    self.favouritesCollectionView.reloadData()
//                                }
//                            }
//
//                        }) { (errror, reason) in
//                            print("error \(String(describing: errror)), reason \(reason)")
//                        }
//                    }
//                } else {
//                    let _ = data[key_message] as? String ?? serverError
//                }
//            }
//
//
//            self.showEmptyView()
//        } onFailure: { (reason, statusCode) in
//            self.showEmptyView()
//            self.hideHud()
//        }

        
    }
    func loadFavouriteRestaurants() {
        
//        print("param \(param)")
//        let apiStr: String? = "\(APIEndPoint.favouriteRestaurantList.caseValue)"
//        
//        self.showHud(message: loadingText)
//        APIUtils.APICall(postName: "\(apiStr ?? "")", method: .get, parameters: param, controller: self) { (response) in
//            self.favouriteRestaurantsFetched = true
//            self.hideHud()
//            if let data = response as? NSDictionary {
//                let status = data.value(forKey: key_status) as? Bool ?? false
//                if status{
//                    if let favourites = data.value(forKeyPath: "data") as? NSDictionary{
//                        
//                        APIUtils.prepareModalFromData(favourites, apiName: apiStr ?? "", modelName: "Favourites", onSuccess: { (anyData) in
//                            if let favourites = anyData as? Favourites{
//                                self.favouriteRestaurants = favourites.restaurants ?? []
//                                DispatchQueue.main.async {
//                                    self.favouritesCollectionView.reloadData()
//                                }
//                            }
//                            
//                        }) { (errror, reason) in
//                            print("error \(String(describing: errror)), reason \(reason)")
//                        }
//                    }
//                } else {
//                    let _ = data[key_message] as? String ?? serverError
//                }
//            }
//            
//            self.showEmptyView()
//            
//        } onFailure: { (reason, statusCode) in
//            self.showEmptyView()
//            self.hideHud()
//        }

    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch vWSwitch.selectedSegmentIndex {
        case 0:
            self.showHud(message: loadingText)
            DispatchQueue.background(delay: 0) {
                self.loadFavouriteProducts()
            } completion: {
                self.hideHud()
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
                
            }

            
        case 1:
            self.showHud(message: loadingText)
            DispatchQueue.background(delay: 0) {
                self.loadFavouriteRestaurants()
            } completion: {
                self.hideHud()
                DispatchQueue.main.async {
                    self.favouritesCollectionView.reloadData()
                }
            }
        default:
            break
        }
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if vWSwitch.selectedSegmentIndex == 0 {
            return self.favouritesProducts.count
        } else {
            return self.favouriteRestaurants.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let cell : Cell_CV_Product = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Product", for: indexPath) as? Cell_CV_Product else { return  UICollectionViewCell()}
        cell.controller = self
        var favouriteRestaurant: Restaurant?
        var favouriteProduct: Product?
        
//        favouriteProduct = self.favouritesProducts[indexPath.row]
//        cell.leadingConstraintContainer.constant = 0
//        cell.topConstraintContainer.constant = 12
        if vWSwitch.selectedSegmentIndex == 0 {
            favouriteProduct = self.favouritesProducts[indexPath.row]
            if let favouriteProduct = favouriteProduct {
                cell.index = indexPath.row
                cell.productType = .favouriteProducts
                cell.favouriteListener = self.favoriteListener
                cell.setData(product: favouriteProduct)
            }
        } else {
            favouriteRestaurant = self.favouriteRestaurants[indexPath.row]
            if let favouriteRestaurant = favouriteRestaurant {
                /////////cell.setData(restro: favouriteRestaurant)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/2.0
        return CGSize(width: width, height: width/storeVCellHeightRatio)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if vWSwitch.selectedSegmentIndex == 0 {
            let product = self.favouritesProducts[indexPath.row]
            
            guard let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController else { return  }
            
            if let productId = product.slug{
                vc.slug = productId
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let restaurant = self.favouriteRestaurants[indexPath.row]
//            let isOpen = self.favouriteRestaurants[indexPath.row].isOpen ?? true
//            if !isOpen{
//                return
//            }
            let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
            
            if let restroid = restaurant.slug{
                vc.slug = restroid
                //vc.restaurantSlug = restaurant.res
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
                
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: favouritesCollectionView.bounds.size.width, height: 55)
        }
        
        
    }
}
