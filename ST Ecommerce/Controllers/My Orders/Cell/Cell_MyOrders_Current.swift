//
//  Cell_Store_MyOrders_Current.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import SDWebImage

class Cell_MyOrders_Current: UITableViewCell {
    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var labelOrderPrice: UILabel!
    
    @IBOutlet weak var imgCancel: UIImageView!
    @IBOutlet weak var labelEstimatedDelivery: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var takeAwayImageView: UIImageView!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var vwwBtncancelOrder: UIView!
    @IBOutlet weak var lblOrderRestaurantTitle: UILabel!
    @IBOutlet weak var lblOrderDetailsText: UILabel!
    @IBOutlet weak var orderDetailStackView: UIStackView!
    
    
    var controller:VC_MyOrders!
    var delegate: DataPass?
    var cancelOrder: Bool? = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func BtnCancel(_ sender: UIButton) {
        self.delegate?.cancelOrder(title: "Cancel Order", message: "Are you sure you want to cancel this order? \n\n\n\n\n",  completion: { (result) in
        })
    }
    func setData(order:MyOrder){
        takeAwayImageView.isHidden = false
        orderDetailStackView.isHidden = false
        if !(self.controller.isFromStore){
            
            // MARK: - logic for Food
            lblOrderRestaurantTitle.text  = "\(order.restaurantDetails?.name ?? "")"
            lblOrderDetailsText.text = "\(order.items ?? "")"
            let imgUrl = takeAwayImageUrl
            
            if (order.selfPickup == true)  {
                
                let imagePath = imgUrl
                takeAwayImageView.isHidden = false
                takeAwayImageView.setIndicatorStyle(.gray)
                takeAwayImageView.setShowActivityIndicator(true)
                takeAwayImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "takeAway")) { (image, error, type, url) in
                    self.takeAwayImageView.setShowActivityIndicator(false)
                }
            } else {
                takeAwayImageView.isHidden = true
            }
            vwwBtncancelOrder.isHidden = true
            btnCancelOrder.isHidden = true
            let isCancel = order.cancelOrder ?? false
            
            cancelOrder = isCancel
            
            if isCancel == true {
                vwwBtncancelOrder.isHidden = false
                btnCancelOrder.isHidden = false
            } else  {
                vwwBtncancelOrder.isHidden = true
                btnCancelOrder.isHidden = true
            }
            if order.status == "Pending" {
                btnCancelOrder.backgroundColor = .clear
                btnCancelOrder.setTitle("CANCEL ORDER", for: .normal)
                btnCancelOrder.layer.borderWidth = 1
                btnCancelOrder.layer.borderColor = UIColor.red.cgColor
            }
            
        } else {
            orderDetailStackView.isHidden = true
            takeAwayImageView.isHidden = true
            vwwBtncancelOrder.isHidden = true
            btnCancelOrder.isHidden = true 
        }
        
        labelOrderNumber.text = "\(orderNoText) \(order.orderSerial ?? "")"
        labelOrderPrice.text = "\(self.controller.priceFormat(price: (order.amount as! NSString).integerValue))\(currencySymbol)"
        
        
        labelStatus.text = (order.status ?? "").capitalized
        
        labelEstimatedDelivery.text = ""
            //labelEstimatedDelivery.text = "\(estimatedDeliveryText)\n\(order.deliveredBy ?? "")"
    }
    
    func setData(order:RestaurantOrder){
        
        
        takeAwayImageView.isHidden = false
        orderDetailStackView.isHidden = false
//        if !(self.controller.isFromStore){
            
            // MARK: - logic for Food
            lblOrderRestaurantTitle.text  = "\(order.restaurant_branch_info?.name ?? "")"
            //lblOrderDetailsText.text = "\(order.items ?? "")"
        _ = takeAwayImageUrl
            
//            if (order.selfPickup == true)  {
//
//                let imagePath = imgUrl
//                takeAwayImageView.isHidden = false
//                takeAwayImageView.setIndicatorStyle(.gray)
//                takeAwayImageView.setShowActivityIndicator(true)
//                takeAwayImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "takeAway")) { (image, error, type, url) in
//                    self.takeAwayImageView.setShowActivityIndicator(false)
//                }
//            } else {
//                takeAwayImageView.isHidden = true
//            }
            
            vwwBtncancelOrder.isHidden = true
            btnCancelOrder.isHidden = true
//            let isCancel = order.cancelOrder ?? false
//
//            cancelOrder = isCancel
//
//            if isCancel == true {
//                vwwBtncancelOrder.isHidden = false
//                btnCancelOrder.isHidden = false
//            } else  {
//                vwwBtncancelOrder.isHidden = true
//                btnCancelOrder.isHidden = true
//            }
            if order.order_status == "Pending" {
                btnCancelOrder.backgroundColor = .clear
                btnCancelOrder.setTitle("CANCEL ORDER", for: .normal)
                btnCancelOrder.layer.borderWidth = 1
                btnCancelOrder.layer.borderColor = UIColor.red.cgColor
            }
            
//        } else {
//            orderDetailStackView.isHidden = true
//            takeAwayImageView.isHidden = true
//            vwwBtncancelOrder.isHidden = true
//            btnCancelOrder.isHidden = true
//        }
        
        labelOrderNumber.text = "\(orderNoText) \(order.invoice_id ?? "")"
        labelOrderPrice.text = "\(self.controller.priceFormat(pricedouble: order.total_amount ?? 0.0))\(currencySymbol)"
        
        
        labelStatus.text = (order.order_status ?? "").capitalized
        
        //labelEstimatedDelivery.text = //////////""
        labelEstimatedDelivery.text = order.order_date //"\(estimatedDeliveryText)\n\(order.delivery_mode ?? "")"
    }
    
    func setData(order:ProductOrder){
                
        takeAwayImageView.isHidden = false
        orderDetailStackView.isHidden = false
//        if !(self.controller.isFromStore){
            
            // MARK: - logic for Food
           // lblOrderRestaurantTitle.text  = "\(order.vendors?[0].name ?? "")"
           // lblOrderDetailsText.text = "\(order.items ?? "")"
        lblOrderDetailsText.isHidden = true
            let imgUrl = takeAwayImageUrl
            
//            if (order.selfPickup == true)  {
//
//                let imagePath = imgUrl
//                takeAwayImageView.isHidden = false
//                takeAwayImageView.setIndicatorStyle(.gray)
//                takeAwayImageView.setShowActivityIndicator(true)
//                takeAwayImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "takeAway")) { (image, error, type, url) in
//                    self.takeAwayImageView.setShowActivityIndicator(false)
//                }
//            } else {
//                takeAwayImageView.isHidden = true
//            }
            
            vwwBtncancelOrder.isHidden = true
            btnCancelOrder.isHidden = true
//            let isCancel = order.cancelOrder ?? false
//
//            cancelOrder = isCancel
//
//            if isCancel == true {
//                vwwBtncancelOrder.isHidden = false
//                btnCancelOrder.isHidden = false
//            } else  {
//                vwwBtncancelOrder.isHidden = true
//                btnCancelOrder.isHidden = true
//            }
            if order.order_status == "Pending" {
                btnCancelOrder.backgroundColor = .clear
                btnCancelOrder.setTitle("CANCEL ORDER", for: .normal)
                btnCancelOrder.layer.borderWidth = 1
                btnCancelOrder.layer.borderColor = UIColor.red.cgColor
            }
            
//        } else {
//            orderDetailStackView.isHidden = true
//            takeAwayImageView.isHidden = true
//            vwwBtncancelOrder.isHidden = true
//            btnCancelOrder.isHidden = true
//        }
        
        labelOrderNumber.text = "\(orderNoText) \(order.invoice_id ?? "")"
        labelOrderPrice.text = "\(self.controller.priceFormat(pricedouble: order.total_amount ?? 0.0))\(currencySymbol)"
        
        
        labelStatus.text = (order.order_status ?? "").capitalized
        
        labelEstimatedDelivery.text = order.order_date
        
    }
}
