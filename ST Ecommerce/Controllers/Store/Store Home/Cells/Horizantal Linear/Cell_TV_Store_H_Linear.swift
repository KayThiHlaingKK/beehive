//
//  Cell_TV_Store_H_Linear.swift
//  ST Ecommerce
//
//  Created by necixy on 14/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Store_H_Linear: UITableViewCell, FavoriteListener {
    
    //MARK: - IBOutlet
    @IBOutlet weak var collectionViewHomeStore_H_Linear: UICollectionView!
    @IBOutlet weak var labelHeadingTitle: UILabel!
    @IBOutlet weak var viewAllBtn: UIButton!
    
    
    //MARK: - Variables
    var controller:VC_Store!
    var index = 0
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewAllBtn.layer.cornerRadius = 2
        viewAllBtn.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        //self.controller.categorizedProduct[self.index].products?[index!].is_favorite = isFavourite
    }
    
    //MARK: - Action
    @IBAction func viewAll(_ sender: Any) {
        
        //navigating to search controller
        let vc : VC_Store_Search = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
        
        //       let productCatId = self.controller.categorizedProduct[index].id
        //
        //        let category = self.controller.categories.filter { (Category) -> Bool in
        //            return Category.id == productCatId
        //        }
        
        //vc.categorizedProduct = self.controller.products
        vc.type = StoreProduct.other
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - CollectionView Functions
extension Cell_TV_Store_H_Linear : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionViewSetUP(){
        
        collectionViewHomeStore_H_Linear.dataSource = self
        collectionViewHomeStore_H_Linear.delegate = self
        
        collectionViewHomeStore_H_Linear.register(UINib.init(nibName: "Cell_CV_Product", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Product")
        
        collectionViewHomeStore_H_Linear.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 12, right: 0);
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let products = self.controller.products
        return products.count ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : Cell_CV_Product = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Product", for: indexPath) as! Cell_CV_Product
        
        cell.controller = controller
        
        let product = self.controller.products[indexPath.row]
        
        
        let title = product.name ?? ""
        //let subtitle = product?.subtitle ?? ""
        
        
        var imagePath = ""
        if let images = product.images,
           images.count > 0 {
            cell.imageViewproduct.setIndicatorStyle(.gray)
            cell.imageViewproduct.setShowActivityIndicator(true)
            
            imagePath = "\(images.first?.url ?? "")?size=xsmall"
            cell.imageViewproduct.downloadImage(url: imagePath, fileName: images.first?.file_name, size: .xsmall)
        }
        
        
        cell.contentView.layer.cornerRadius = 2
        
        cell.labelTitle.text = title
        //cell.labelCategory.text = subtitle
        
//        cell.viewDiscountContainer.isHidden = true
//        cell.viewProductNotAvailable.isHidden = true
        //                   let available = product?.available ?? true
        //
        //                   cell.labelNotAvailable.text = ""
        //                   if !available{
        //                       cell.labelNotAvailable.text = notAvailableText
        //                       cell.viewProductNotAvailable.isHidden = false
        //                   }
        
        //if let p = product{
            cell.index = indexPath.row
            cell.favouriteListener = self
            cell.productType = .storeProductHLinear
            print("the product type is \(cell.productType)")
            cell.setData(product: product)
        //}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width/homeCellWidthRatio
        return CGSize(width: width, height: width/0.65)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //if let product = self.controller.products[indexPath.row]{
            
            let vc : ProductDetailViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.fromCart = self.controller.fromCart
            
            if let productId = self.controller.products[indexPath.row].slug{
                vc.slug = productId
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
       // }
        
    }
    
}
