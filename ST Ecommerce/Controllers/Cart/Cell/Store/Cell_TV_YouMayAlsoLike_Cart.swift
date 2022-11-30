//
//  Cell_TV_YouMayAlsoLike_Cart.swift
//  ST Ecommerce
//
//  Created by necixy on 27/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_YouMayAlsoLike_Cart: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionViewYouMayAlsoLikeCart: UICollectionView!
    
    //MARK: - Variables
    var controller:VC_Cart!
    var parentIndexPath:IndexPath!
    var favouriteListener: FavoriteListener?
    
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
//
////MARK: - CollectionView Functions
//extension Cell_TV_YouMayAlsoLike_Cart : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    
//    func collectionViewSetUP(){
//        
//        collectionViewYouMayAlsoLikeCart.dataSource = self
//        collectionViewYouMayAlsoLikeCart.delegate = self
//        
//        collectionViewYouMayAlsoLikeCart.register(UINib.init(nibName: "Cell_CV_Product", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Product")
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//      return self.controller.alsoLikesProducts.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell : Cell_CV_Product = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Product", for: indexPath) as! Cell_CV_Product
//        cell.controller = controller
//        let product = self.controller.alsoLikesProducts[indexPath.row]
//        
//        cell.cellConfiguration()
//        cell.productType = .youMayAlsoLikeCart
//        cell.index = indexPath.row
//        cell.favouriteListener = self.favouriteListener
//        ///////////////cell.setData(product: product)
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let width = collectionView.frame.size.width/homeCellWidthRatio
//        return CGSize(width: width, height: width/homeCellHeightRatio)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let product = self.controller.alsoLikesProducts[indexPath.row]
//        let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
//        vc.fromCart = true
//        
//        if let productId = product.id{
//            vc.slug = productId
//            self.controller.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//        
//    }
//    
//}

