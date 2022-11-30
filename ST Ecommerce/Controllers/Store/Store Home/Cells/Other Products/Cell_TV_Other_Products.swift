//
//  Cell_TV_Other_Products.swift
//  ST Ecommerce
//
//  Created by Necixy on 09/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Other_Products: UITableViewCell, FavoriteListener {

//   MARK: - Outlets
    
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var collectionViewOtherProducts: UICollectionView!
    
    //MARK: - Variables
    var controller: VC_Store!
    var products = [Product]()
    var index = 0

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        self.controller.products[index!].is_favorite = isFavourite
    }

}
//MARK: - CollectionView Functions
extension Cell_TV_Other_Products : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionViewSetUP(){
        
        collectionViewOtherProducts.dataSource = self
        collectionViewOtherProducts.delegate = self
        
        collectionViewOtherProducts.register(UINib.init(nibName: "Cell_CV_Product", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Product")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       
        return self.controller.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : Cell_CV_Product = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Product", for: indexPath) as! Cell_CV_Product
        cell.controller = controller
//        cell.leadingConstraintContainer.constant = 0
//        cell.topConstraintContainer.constant = 12
        if indexPath.row == 0 || indexPath.row == 2{
//             cell.leadingConstraintContainer.constant = 12
        }
        cell.index = indexPath.row
        cell.productType = .other
        cell.favouriteListener = self
        cell.setData(product: self.controller.products[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionViewOtherProducts.frame.size.width/2
        return CGSize(width: width, height: width/storeVCellHeightRatio)
        print("other width = ", width)
//        return CGSize(width:  100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            
        if let slug = self.controller.products[indexPath.row].slug{
                vc.slug = slug
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    
    
    
}
