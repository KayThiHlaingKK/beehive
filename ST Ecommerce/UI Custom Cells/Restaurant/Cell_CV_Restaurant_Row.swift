//
//  Cell_CV_Restaurant_Row.swift
//  ST Ecommerce
//
//  Created by necixy on 30/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_CV_Restaurant_Row: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var viewDiscountContainer: UIView!
    @IBOutlet weak var imageViewRestaurant: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelExpert: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var labelFreeDelivery: UILabel!
    
    @IBOutlet weak var labelSpeciality: UILabel!
    
    @IBOutlet weak var topContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewProductNotAvailable: UIView!
    @IBOutlet weak var leadingContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelNotAvailable: UILabel!
    
    @IBOutlet weak var bottomContainerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var RightContainerViewConstraint: NSLayoutConstraint!
    
    //MARK: - Variables

    override func awakeFromNib() {
        super.awakeFromNib()        
        labelSpeciality.roundCorners(corners: [.topLeft, .bottomRight], amount: 5)
        
    }
    
    func setData(restaurant : RestaurantBranch){
        
        var imagePath = ""
        if let images = restaurant.restaurant?.images,
           images.count > 0 {
            
            imageViewRestaurant.setIndicatorStyle(.gray)
            imageViewRestaurant.setShowActivityIndicator(true)
            imagePath = "\(restaurant.restaurant?.images?[0].url ?? "")?size=xsmall"
            imageViewRestaurant.downloadImage(url: imagePath, fileName: images.first?.file_name, size: .xsmall)
        }
        else {
            imageViewRestaurant.downloadImage()
        }
        let title = "\(restaurant.restaurant?.name ?? "") (\(restaurant.name ?? ""))"
        /////let excerpt = restaurant.excerpt ?? ""
        
        labelTitle.text = title
//        labelExpert.text = excerpt
        
        cellConfiguration()
        
        
//        labelRating.text = "\(restaurant.rating ?? 0).0"
        
        labelFreeDelivery.isHidden = true
        
//        let is_delivery_free = restaurant.isDeliveryFree ?? false
//        if is_delivery_free{
//            labelFreeDelivery.isHidden = false
//        }
//
        viewDiscountContainer.isHidden = true
////        if let discount = restaurant.discount{
////            if discount != 0{
//                labelDiscount.text = "\(discount)%"
//                viewDiscountContainer.isHidden = false
//            }
//        }
       
        
        labelSpeciality.isHidden = true
//        if (restaurant.cuisine?.count != 0){
//            labelSpeciality.isHidden = false
//            labelSpeciality.text = "   \(restaurant.cuisine?.first?.name ?? "")   "
//        }
        
//        let ratingVal = restaurant.rating ?? 0
        ratingView.isHidden = false
//        if ratingVal == 0{
//            labelRating.text = ""
//            ratingView.isHidden = true
//        }
        
        viewProductNotAvailable.isHidden = true
//               let available = restaurant.isOpen ?? true
//               
//               labelNotAvailable.text = ""
//               if !available{
//                   labelNotAvailable.text = closedText
//                   viewProductNotAvailable.isHidden = false
//               }
        
    }
    
    func cellConfiguration(){
        self.labelFreeDelivery.roundCorners(corners: [.topRight, .bottomRight], amount: 10)
    }
    
    
    
}
