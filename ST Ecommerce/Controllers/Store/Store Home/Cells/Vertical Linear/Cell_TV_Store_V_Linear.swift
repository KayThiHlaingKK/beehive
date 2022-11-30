//
//  Cell_TV_Store_V_Linear.swift
//  ST Ecommerce
//
//  Created by necixy on 14/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Store_V_Linear: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var collectionViewHomeStore_V_Linear: UICollectionView!
    @IBOutlet weak var labelHeadingTitle: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    
    //MARK: - Variables
    var controller:VC_Store!
    var index = 0
    var favouriteListener: FavoriteListener?
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAllBtn.layer.cornerRadius = 2
        viewAllBtn.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Action
    @IBAction func viewAll(_ sender: Any) {
       //navigating to search controller
        let vc : VC_Store_Search = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
        
        let slug = self.controller.products[index].slug

//               let category = self.controller.categories.filter { (Category) -> Bool in
//                   return Category.id == slug
//               }
        /////vc.category = category[0]
      
        vc.type = StoreProduct.viewAll
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - CollectionView Functions
extension Cell_TV_Store_V_Linear : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectionViewHomeStore_V_Linear.dataSource = self
        collectionViewHomeStore_V_Linear.delegate = self
        
        collectionViewHomeStore_V_Linear.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0);
        collectionViewHomeStore_V_Linear.register(UINib.init(nibName: "Cell_CV_Product", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Product")
        
        
        let layout = collectionViewHomeStore_V_Linear.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("product count ==== " , self.controller.products.count)
        let products = self.controller.products
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("cell " , indexPath.row)
        let cell : Cell_CV_Product = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Product", for: indexPath) as! Cell_CV_Product
        cell.controller = controller
//        cell.leadingConstraintContainer.constant = 12
//        cell.topConstraintContainer.constant = 12

        cell.index = indexPath.row
        cell.favouriteListener = self.favouriteListener
        cell.productType = .storeProductVLinear
    
        print("!!!!! " , self.controller.products[indexPath.row].name)
        
        cell.setData(product: self.controller.products[indexPath.row])
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.frame.size.width / 2
//        return CGSize(width: width, height: width/storeVCellHeightRatio)
        let height = collectionView.frame.size.height/homeCellWidthRatio
//        let width = collectionView.frame.size.width/homeCellWidthRatio
        return CGSize(width: width*0.95, height: width*1.8)
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //if let product = self.controller.products[indexPath.row]{

            let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.fromCart = self.controller.fromCart
            
        print("call product detail = " , self.controller.products[indexPath.row])
            if let productId = self.controller.products[indexPath.row].slug{
                vc.slug = productId
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
       // }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
   
    
    
}
