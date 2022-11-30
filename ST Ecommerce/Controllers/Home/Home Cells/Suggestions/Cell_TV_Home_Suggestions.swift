//
//  Cell_TV_Home_Suggestions.swift
//  ST Ecommerce
//
//  Created by necixy on 13/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import SDWebImage


class Cell_TV_Home_Suggestions: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var spaceConstraintLabel: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHomeSuggestions: UICollectionView!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var dividerView: UIView!
    var serviceAnnouncement: ServiceAnnouncement?
    
    //MARK: - Variables
    var controller:VC_Home!
    var parentIndexPath:IndexPath!
    var homeItemType : HomeItemType!
    var isLastCell = false
    var favouriteListener: FavoriteListener?
    private var favoriteProducts = [Product]()
    private var favoriteRestaurants = [RestaurantBranch]()
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupUI() {
        btnViewAll.layer.cornerRadius = 4
    }
    
}

//MARK: - CollectionView Functions
extension Cell_TV_Home_Suggestions : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectionViewHomeSuggestions.dataSource = self
        collectionViewHomeSuggestions.delegate = self
        if let layout = collectionViewHomeSuggestions.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
        }
        collectionViewHomeSuggestions.register(UINib.init(nibName: "Cell_CV_ProductHome", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_ProductHome")
        collectionViewHomeSuggestions.register(UINib.init(nibName: "Cell_CV_Restaurant", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Restaurant")
        
         collectionViewHomeSuggestions.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if homeItemType == HomeItemType.FavouriteProductsType {
            return self.controller.favouritesProducts.count > 10 ? 10 : self.controller.favouritesProducts.count
            
        }
        else if homeItemType == HomeItemType.FavouriteRestaurantType{
            return self.controller.favouriteRestaurants.count > 10 ? 10 : self.controller.favouriteRestaurants.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if homeItemType == HomeItemType.FavouriteProductsType
        {
            let cell: Cell_CV_ProductHome = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_ProductHome", for: indexPath) as! Cell_CV_ProductHome
            let product = favoriteProducts[indexPath.row]
            cell.productType = .favouriteProducts
            cell.controller = self.controller
            cell.index = indexPath.row
            cell.setData(product: product)
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.layer.masksToBounds = true
            return cell
        }
        else if homeItemType == HomeItemType.FavouriteRestaurantType{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Restaurant", for: indexPath) as! Cell_CV_Restaurant
            let restaurantBranch = favoriteRestaurants[indexPath.row]
            cell.serviceAnnouncement = self.serviceAnnouncement
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.layer.masksToBounds = true
            cell.setupData(restaurantBranch: restaurantBranch)
            return cell
        }
     
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if homeItemType == .FavouriteRestaurantType {
            return CGSize(width: 288, height: 251)
        }
        let height = collectionView.frame.size.height/homeCellWidthRatio
        let width = collectionView.frame.size.width/homeCellWidthRatio
        return CGSize(width: width, height: width*1.6)//CGSize(width: width, height: width/0.67)
//        return CGSize(width: 184, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var product : Product?
        var restaurant : RestaurantBranch?
        if homeItemType == HomeItemType.FavouriteProductsType{
            product = self.controller.favouritesProducts[indexPath.row]
        }
        else if homeItemType == HomeItemType.FavouriteRestaurantType{

            restaurant = self.controller.favouriteRestaurants[indexPath.row]
        }
        
        if let p = product{

            let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            
            if let productId = p.slug{
                vc.slug = productId
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if let r = restaurant{
            if let restroID = r.slug{

                let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
                vc.slug = restroID
                vc.restaurantSlug = r.restaurant?.slug ?? ""
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
       
        
    }
    
    func setupData(favoriteProducts: [Product], type: HomeItemType) {
        self.favoriteProducts = favoriteProducts
        self.homeItemType = type
        collectionViewHomeSuggestions.reloadData()
    }
    
    func setupData(favoriteRestaurants: [RestaurantBranch], type: HomeItemType) {
        self.favoriteRestaurants = favoriteRestaurants
        self.homeItemType = type
        collectionViewHomeSuggestions.reloadData()
    }
    
    
}
