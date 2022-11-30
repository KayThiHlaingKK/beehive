//
//  Cell_FoodsMyOrder_Detail_Header.swift
//  ST Ecommerce
//
//  Created by necixy on 02/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_FoodsMyOrder_Detail_Header: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var imageViewRestroLogo: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labeltimings: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelEstimatedDelivery: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var takeAwayImageView: UIImageView!
    
    //MARK: - Variables
    var controller:VC_FoodsMyOrder_Detail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setData(restaurantOrderDeatil:RestaurantOrder){
        
        let restaurant = restaurantOrderDeatil.restaurant_branch_info!
        
        var imagePathBanner = ""
        if let images = restaurant.restaurant?.images,
            images.count > 0 {
            imagePathBanner = "\(images.first?.url ?? "")?size=xsmall"
            imageViewRestroLogo.setIndicatorStyle(.gray)
            imageViewRestroLogo.setShowActivityIndicator(true)
            imageViewRestroLogo.downloadImage(url: imagePathBanner, fileName: images.first?.file_name, size: .xsmall)
        }
       

//        let imgUrl = takeAwayImageUrl
        
//        if (restaurantOrderDeatil.selfPickup ?? false)  {
//
//            let imagePath = imgUrl
//
////            takeAwayImageView.setIndicatorStyle(.gray)
////            takeAwayImageView.setShowActivityIndicator(true)
////            takeAwayImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder")) { (image, error, type, url) in
////                self.takeAwayImageView.setShowActivityIndicator(false)
////            }
//        }
       
        labelAddress.text = ""
        if let add = restaurant.address{
//            let formattedAddress = Util.getFormattedAddress(address: address)
            labelAddress.text = add
        }
        labelName.text = "\(restaurant.restaurant?.name ?? "") (\(restaurant.name ?? ""))"
//        labelDetails.text = restaurant. ?? ""
        
        labeltimings.text = "\(restaurant.opening_time ?? "") - \(restaurant.closing_time ?? "")"
        
//        ratingView.rating = Double(restaurant.rating ?? 0)
        
//        if (restaurantOrderDeatil.order_status == "Delivered")  {
//            let date = Date(timeIntervalSince1970: Double(self.controller.restroOrderDetails?.deliveredAt ?? 0))
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
//
//            let localDate = dateFormatter.string(from: date)
//            labelEstimatedDelivery.text = "\(deliveredAt) : \n\(localDate)"
//
//            var myString:NSString =  labelEstimatedDelivery.text as! NSString
//            var myMutableString = NSMutableAttributedString(string: myString as String)
//            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSRange(location:15,length:26))
//            labelEstimatedDelivery.attributedText = myMutableString
//
//        }else if (self.controller.restroOrderDetails?.status == "Cancelled") {
//            labelEstimatedDelivery.isHidden = true
//        }else{
//
//            labelEstimatedDelivery.text = "\(estimatedDeliveryText) : \(self.controller.restroOrderDetails?.deliveredBy ?? "")"
//        }
//        labelStatus.text = self.controller.restaurantOrder?.order_status ?? ""
        
        if restaurantOrderDeatil.order_status == deliveredText{
//            labelStatus.textColor = UIColor.appGreenColor()
        }
    }
}
