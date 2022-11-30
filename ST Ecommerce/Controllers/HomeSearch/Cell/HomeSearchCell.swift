//
//  HomeSearchCell.swift
//  ST Ecommerce
//
//  Created by Rishabh on 24/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class HomeSearchCell: UITableViewCell {

   //MARK: - IBOutlet
        @IBOutlet weak var collectionViewHomeSuggestions: UICollectionView!
        @IBOutlet weak var labelCategory: UILabel!
    
        //MARK: - Variables
        var controller:HomeSearch_VC!
        var parentIndexPath:IndexPath!
        var homeItemType : HomeItemType!
    var favoriteListener: FavoriteListener?
        
        
        //MARK: - Internal Functions
        override func awakeFromNib() {
            super.awakeFromNib()
            
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
    }

    //MARK: - CollectionView Functions
    extension HomeSearchCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
        func collectionViewSetUP(){
            
            collectionViewHomeSuggestions.dataSource = self
            collectionViewHomeSuggestions.delegate = self
            
            collectionViewHomeSuggestions.register(UINib.init(nibName: "Cell_CV_Product", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Product")
            collectionViewHomeSuggestions.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0);
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if homeItemType == HomeItemType.SuggestionsProductType{
                return self.controller.suggestionsProducts.count
            }
            else if homeItemType == HomeItemType.SuggestionsRestaurantType{
                return self.controller.suggestionsRestaurants.count
            }

            return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell : Cell_CV_Product = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Product", for: indexPath) as! Cell_CV_Product
            
            cell.controller = controller
            var product :Product?
            var restro :RestaurantBranch?
            
            if homeItemType == HomeItemType.SuggestionsProductType{
                product = self.controller.suggestionsProducts[indexPath.row]
            }
            else if homeItemType == HomeItemType.SuggestionsRestaurantType{
                restro = self.controller.suggestionsRestaurants[indexPath.row]
            }

//            cell.leadingConstraintContainer.constant = 0
            

            if let p = product{
                cell.productType = .other
                cell.index = indexPath.row
                cell.favouriteListener = self.favoriteListener
                cell.setData(product: p)
            }else if let r = restro{
                cell.setData(restro: r)
            }
            
            cell.layer.cornerRadius = 2
            cell.layer.masksToBounds = true
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
//            let width = collectionView.frame.size.width/homeCellWidthRatio
//            return CGSize(width: width, height: width/homeCellHeightRatio)
            
            let width = collectionView.frame.size.width/homeCellWidthRatio
            return CGSize(width: width, height: width*1.8)
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            var product : Product?
            var restaurant : RestaurantBranch?
            
            if homeItemType == HomeItemType.SuggestionsProductType{
                product = self.controller.suggestionsProducts[indexPath.row]
            }
            else if homeItemType == HomeItemType.SuggestionsRestaurantType{
                restaurant = self.controller.suggestionsRestaurants[indexPath.row]
            }

            if let p = product{

                let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController

//                if let cell : Cell_CV_Product = collectionView.cellForItem(at: indexPath) as? Cell_CV_Product{
//                    let placeHolder = #imageLiteral(resourceName: "placeholder")
//                    vc.headerImage = cell.imageViewproduct.image ?? placeHolder
//                }
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
}
