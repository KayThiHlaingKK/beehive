//
//  Cell_CV_Product.swift
//  ST Ecommerce
//
//  Created by necixy on 24/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Alamofire


class Cell_CV_Product: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var imageViewproduct: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelActualAmount: UILabel!
    @IBOutlet weak var labelPercentOff: UILabel!
    @IBOutlet weak var leadingConstraintContainer: NSLayoutConstraint!
    @IBOutlet weak var topConstraintContainer: NSLayoutConstraint!
    @IBOutlet weak var viewProductNotAvailable: UIView!
    @IBOutlet weak var labelNotAvailable: UILabel!
    @IBOutlet weak var viewDiscountContainer: UIView!
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var vwFavourite: UIView!
    //MARK: - Variables
    var controller:UIViewController?
    var isFavourites: Bool = false
    var id : Int?
    var slug: String?
    var product: Product?
    var favouriteListener: FavoriteListener?
    var index: Int = 0
    var productType: ProductType?
    
    
    
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outsideView.layer.cornerRadius = 5
        imageViewproduct.layer.cornerRadius = 5
        self.imageViewproduct.clipsToBounds = true
        //imageViewproduct.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    //MARK: - Helper Functions
    func cellConfiguration(){
        viewContainer.layer.borderWidth = 1
        viewContainer.layer.borderColor = UIColor().HexToColor(hexString: "#FAFAFA").cgColor
        DispatchQueue.main.async {
            self.labelPercentOff.roundCorners(corners: [.topRight, .bottomRight], amount: 10)
        }
    }
    func setData(product:Product) {
        
        btnFavourite.isHidden = false
        vwFavourite.isHidden = false
        var imagePath = ""
        var title = ""
        slug = product.slug
        
        print("product.images = " , product.images)
        if let images = product.images,
            images.count > 0 {
            imageViewproduct.setIndicatorStyle(.gray)
            imageViewproduct.setShowActivityIndicator(true)
            
            imagePath = "\(product.images?[0].url ?? "")?size=xsmall"
            imageViewproduct.downloadImage(url: imagePath, fileName: images.first?.file_name, size: .xsmall)
        }
        else {
            imageViewproduct.image = UIImage(named: "placeholder2")
        }
        
        
        title = product.name ?? ""
        ////category = product.subtitle ?? ""
        
        
        labelTitle.text = title
        //labelCategory.text = category
        
        cellConfiguration()
        
        
        labelAmount.text = "\(self.controller?.priceFormat(pricedouble: product.price ?? 0.0) ?? "0")\(currencySymbol)"
        
        
        labelActualAmount.isHidden = true
        
        if (product.discount != 0) {
            let discount = product.discount ?? 0
            let orgPrice = product.price ?? 0
            let actualPrice = orgPrice - discount
            
            labelActualAmount.isHidden = false
            let attributedString = NSAttributedString(string: "\(self.controller?.priceFormat(price: Int(orgPrice)) ?? "")\(currencySymbol)").withStrikeThrough()
            labelActualAmount.attributedText = attributedString
            
            labelAmount.text = "\(self.controller?.priceFormat(pricedouble: actualPrice) ?? "")\(currencySymbol)"
            
        }
        viewDiscountContainer.isHidden = true
        
        labelPercentOff.isHidden = true
        //        let discount = product.discount ?? 0
        //        if discount != 0{
        //            labelPercentOff.isHidden = false
        //            labelPercentOff.text = "\(discount)% \(offText)"
        //        }
        //
        viewProductNotAvailable.isHidden = true
        //        let available = product.available ?? true
        //
        //        labelNotAvailable.text = ""
        //        if !available{
        //            viewProductNotAvailable.isUserInteractionEnabled = true
        //            labelNotAvailable.text = notAvailableText
        //            viewProductNotAvailable.isHidden = false
        //            vwFavourite.isHidden = false
        //            btnFavourite.isHidden = false
        //        } else {
        //            if product.quantity == 0  {
        //                labelNotAvailable.text = "Out of stock"
        //                viewProductNotAvailable.isUserInteractionEnabled = true
        //                viewProductNotAvailable.isHidden = false
        //                vwFavourite.isHidden = false
        //                btnFavourite.isHidden = false
        //            }
        //        }
        let isFavourite = product.is_favorite ?? false
        isFavourites = isFavourite
        if isFavourite == true {
            self.btnFavourite.setImage(#imageLiteral(resourceName: "heart Favourite"), for: .normal)
        } else {
            self.btnFavourite.setImage(#imageLiteral(resourceName: "heart Unfavourite"), for: .normal)
        }
    }
    
    
    
    func setData(restro:RestaurantBranch){
        print("set restaurantttttttt")
        vwFavourite.isHidden = true
        btnFavourite.isHidden = true
        labelPercentOff.isHidden = true
        
        var imagePath = ""
        
        if let images = restro.restaurant?.images,
           images.count > 0 {
            imageViewproduct.setIndicatorStyle(.gray)
            imageViewproduct.setShowActivityIndicator(true)
            
            imagePath = "\(images.first?.url ?? "")?size=xsmall"
            imageViewproduct.downloadImage(url: imagePath, fileName: images.first?.file_name, size: .xsmall)
        }
                
        ///////imagePath = restro.bannerLogo ?? ""
        //////category = restro.excerpt ?? ""
        
        
        slug = restro.slug
        if let resName = restro.restaurant?.name, let branchName = restro.name {
            labelTitle.text = "\(resName) (\(branchName))"
        }
        
        //labelCategory.text = category
        
        cellConfiguration()
        labelAmount.text = ""
        
        labelActualAmount.text = ""
        labelActualAmount.isHidden = false
        viewProductNotAvailable.isHidden = true
        //        let available = restro.isOpen ?? true
        //        labelNotAvailable.text = ""
        //        if !available{
        //            labelNotAvailable.text = closedText
        //            viewProductNotAvailable.isHidden = false
        //        }
        viewDiscountContainer.isHidden = true
        //        if let discount = restro.discount{
        //            if discount != 0{
        //                labelDiscount.text = "\(discount)%"
        //                viewDiscountContainer.isHidden = false
        //            }
        //        }
    }
    
    func setData(restro:Restaurant_){
       
    }
    
    @IBAction func favourite(_ sender: UIButton) {
        if ((self.controller?.readLogin()) != nil){
            btnFavourite.isUserInteractionEnabled = true
            if !isFavourites {
                favouriteProductApi(method: .post)
            } else {
                favouriteProductApi(method: .delete)
            }
        } else {
            self.controller?.showNeedToLoginApp()
        }
    }
    
    func favouriteProductApi(method: HTTPMethod) {
        
        guard let ids  = slug else { return }
        let param : [String:Any] = [:]
        print("param======: \(param)")
        
        let apiStr = "\(APIEndPoint.product.caseValue)/\(ids)/\(favorites)"
        
        APIUtils.APICall(postName: apiStr, method: method, parameters: param, controller: nil) { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            _ = data.value(forKey: key_message) as? String ?? ""
            
            if status == 200 {
                if method == .post {
                    self.btnFavourite.setImage(#imageLiteral(resourceName: "heart Favourite"), for: .normal)
                    
                } else {
                    //self.btnFavourite.isSelected = false
                    self.btnFavourite.setImage(#imageLiteral(resourceName: "heart Unfavourite"), for: .normal)
                }
                self.isFavourites = !self.isFavourites
                
                if self.favouriteListener != nil {
                    self.favouriteListener?.isFavorited(index: self.index, productType: self.productType ?? .other, isFavourite: self.isFavourites)
                }
            }
            
            self.btnFavourite.isUserInteractionEnabled = true
            
        } onFailure: { (reason, statusCode) in
            self.btnFavourite.isUserInteractionEnabled = true
        }
    }
    
}

