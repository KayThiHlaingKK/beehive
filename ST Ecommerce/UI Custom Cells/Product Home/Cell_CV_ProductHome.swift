//
//  Cell_CV_Product.swift
//  ST Ecommerce
//
//  Created by necixy on 24/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Alamofire


class Cell_CV_ProductHome: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var imageViewproduct: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelActualAmount: UILabel!
    @IBOutlet weak var labelPercentOff: UILabel!
    
    @IBOutlet weak var triangleView: UIView!
    @IBOutlet weak var triangleLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var startImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var vwFavourite: UIView!
    
    
    //MARK: - Variables
    var controller: UIViewController?
    private var isFavorite = false
    var id : Int?
    var slug: String?
    var product: Product?
    var favouriteListener: FavoriteListener?
    var index: Int = 0
    var indexPath: IndexPath?
    var productType: ProductType?
    
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        setDownTriangle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func setDownTriangle(){
        let heightWidth = triangleView.frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x:heightWidth, y: heightWidth))
        path.addLine(to: CGPoint(x:heightWidth, y:0))
        path.addLine(to: CGPoint(x:0, y:0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = #colorLiteral(red: 1, green: 0.662745098, blue: 0.1921568627, alpha: 1)
        
        triangleView.layer.insertSublayer(shape, at: 0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewproduct.layer.cornerRadius = 5
        self.imageViewproduct.clipsToBounds = true
        clipsToBounds = false

    }
    
    //MARK: - Helper Functions
    func cellConfiguration(){
        DispatchQueue.main.async {
            self.labelPercentOff.roundCorners(corners: [.topRight, .bottomRight], amount: 10)
        }
    }
    
    func setData(product: Product) {
        let product = product
        self.favouriteListener = self.controller as? FavoriteListener
        
        var imagePath = ""
        var title = ""
        slug = product.slug
        if let images = product.images,
           images.count > 0 {
            imageViewproduct.setIndicatorStyle(.gray)
            imageViewproduct.setShowActivityIndicator(true)
            
            imagePath = "\(images.first?.url ?? "")?size=thumbnail"
            imageViewproduct.downloadImage(url: imagePath, fileName: images.first?.file_name, size: .xsmall)//.thumbnail)
        } else {
            imageViewproduct.image = UIImage(named: "placeholder2")
        }
        
        title = product.name ?? ""
        
        labelTitle.text = title
        
        cellConfiguration()
        if let price = product.price {
            labelAmount.text = "\(self.controller?.priceFormat(pricedouble: price) ?? "")\(currencySymbol)"
        }
        
        labelActualAmount.isHidden = true
//        setupRatingLabel(rating: product.rating)
        setupDiscountLabel(product)
        setupContentLabel(product)
//        labelPercentOff.isHidden = true
        self.isFavorite = product.is_favorite ?? false
        
        checkIsFavorite()
    }
    
    
    func setData(restro:RestaurantBranch){
        
        vwFavourite.isHidden = true
        btnFavourite.isHidden = true
        labelPercentOff.isHidden = true
        isFavorite = restro.restaurant?.is_favorite ?? false
        
        setupRatingLabel(rating: "\(restro.restaurant?.rating)")
        self.vwFavourite.backgroundColor = self.isFavorite ? #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        var imagePath = ""
        if let images = restro.restaurant?.images,
            images.count > 0 {
            imageViewproduct.setIndicatorStyle(.gray)
            imageViewproduct.setShowActivityIndicator(true)
            
            imagePath = "\(images[0].url ?? "")?size=xsmall"
            imageViewproduct.downloadImage(url: imagePath, fileName: images.first?.file_name, size: .xsmall)
            
        }
        
        slug = restro.slug
        if let resName = restro.restaurant?.name, let branchName = restro.name {
            labelTitle.text = "\(resName) (\(branchName))"
        }
                
        cellConfiguration()
        labelAmount.text = ""
        
        labelActualAmount.text = ""
        labelActualAmount.isHidden = false

    }
    
    
    @IBAction func favourite(_ sender: UIButton) {
        if ((self.controller?.readLogin()) != nil){
            btnFavourite.isUserInteractionEnabled = false
            favouriteProductApi(method: !self.isFavorite ? .post: .delete)
        } else {
            self.controller?.showNeedToLoginApp()
        }
    }
    
    func favouriteProductApi(method: HTTPMethod) {
        
        guard let ids  = slug else { return }
        let param : [String:Any] = [:]
        
        let apiStr = "\(APIEndPoint.product.caseValue)/\(ids)/\(favorites)"
        APIUtils.APICall(postName: apiStr, method: method, parameters: param, controller: nil) { (response) in
            DispatchQueue.main.async {
                
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                _ = data.value(forKey: key_message) as? String ?? ""
                
                if status == 200 {
                    self.isFavorite = !self.isFavorite
                    self.product?.is_favorite = self.isFavorite
                    self.checkIsFavorite()
                    
                    
                    if let controller = self.controller as? VC_Store {
                        controller.isFavorited(indexPath: self.indexPath ?? IndexPath(), isFavourite: self.isFavorite)
                    } else if let controller = self.controller as? VC_BrandDetail {
                        controller.isFavorited(indexPath: self.indexPath ?? IndexPath(), isFavourite: self.isFavorite)
                    } else if let controller = self.controller as? FavoriteListener {
                        controller.isFavorited(index: self.index, productType: self.productType ?? .other, isFavourite: self.isFavorite)
                    } else if let favouriteListener = self.favouriteListener {
                        favouriteListener.isFavorited(index: self.index, productType: self.productType ?? .other, isFavourite: self.isFavorite)
                    }
                }
                
                self.btnFavourite.isUserInteractionEnabled = true
                
            }
        } onFailure: { (reason, statusCode) in
            self.btnFavourite.isUserInteractionEnabled = true
//            if statusCode == 401 {
//                self.controller?.showNeedToLoginApp()
//            }
        }
    }
    
    private func checkIsFavorite() {
        vwFavourite.backgroundColor = isFavorite ? #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func setupRatingLabel(rating: String?) {
        if rating != nil {
            ratingView.isHidden = false
            ratingLabel.text = rating
        }
    }
    
    private func setupDiscountLabel(_ product: Product) {
            let discount = product.discount ?? 0
            let orgPrice = product.price ?? 0
            let actualPrice = orgPrice - discount
            if discount != 0{
                let percentagePrice = Double((discount/orgPrice) * 100)
                labelPercentOff.isHidden = false
                labelPercentOff.text = String(format: "%.f",Double(percentagePrice)) + "% Off"
                labelActualAmount.isHidden = false
                let attributedString = NSAttributedString(string: "\(self.controller?.priceFormat(pricedouble: orgPrice) ?? "0")\(currencySymbol)").withStrikeThrough()
                labelActualAmount.attributedText = attributedString
                
                labelAmount.text = "\(self.controller?.priceFormat(pricedouble: actualPrice) ?? "0")\(currencySymbol)"
            }else{
                labelActualAmount.isHidden = true
                labelPercentOff.isHidden = true
            }
    }
    
    private func setupContentLabel(_ product: Product){
        if product.content_name != nil{
            triangleView.isHidden = false
            triangleLbl.text = product.content_name
            
        }else{
            triangleView.isHidden = true
        }
        
    }
    
}

