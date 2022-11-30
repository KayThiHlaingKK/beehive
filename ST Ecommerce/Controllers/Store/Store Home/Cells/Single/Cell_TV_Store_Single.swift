//
//  Cell_TV_Store_Single.swift
//  ST Ecommerce
//
//  Created by necixy on 14/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Store_Single: UITableViewCell {
    
    
    //MARK: - IBOutlet
    @IBOutlet weak var collectionViewHomeStore_Single: UICollectionView!
    
    //MARK: - Variables
    var controller:VC_Store!
    //    var indexPath:IndexPath!
    var index = 0
    var favouriteListener: FavoriteListener?
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//MARK: - CollectionView Functions
extension Cell_TV_Store_Single : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectionViewHomeStore_Single.dataSource = self
        collectionViewHomeStore_Single.delegate = self
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : Cell_CV_Store_Single = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Store_Single", for: indexPath) as! Cell_CV_Store_Single
        
        let product = self.controller.products[index]
        
        //        let productCount = product.productsCount ?? 0
        let name = product.name ?? ""
        
        var imagePath = ""
        //        if product. {
        //            <#code#>
        //        }
        cell.imageViewproduct.setIndicatorStyle(.gray)
        cell.imageViewproduct.setShowActivityIndicator(true)
        cell.imageViewproduct.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
            cell.imageViewproduct.setShowActivityIndicator(false)
        }
        
        cell.labelTitle.text = name
        //        cell.labelproductCount.text = "\(productCount) \(productsText)"
        
        //////////cell.buttonViewAll.tag = product.slug ?? 0
        cell.buttonViewAll.addTarget(self, action: #selector(buttonActionViewAll(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func buttonActionViewAll(sender:UIButton){
        
        //        let product = self.controller.categories.filter { (Category) -> Bool in
        //            return Category.id == sender.tag
        //        }
        
        //navigating to search controller
        let vc : VC_Store_Search = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
        ///////////vc.categorizedProduct = self.controller.categorizedProduct[sender.tag]
        vc.type = StoreProduct.viewAll
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width : CGFloat = UIScreen.main.bounds.size.width
        //return CGSize(width: width, height: width/1.67)
        return CGSize(width: width, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
