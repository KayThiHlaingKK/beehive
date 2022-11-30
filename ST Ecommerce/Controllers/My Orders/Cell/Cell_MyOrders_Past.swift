//
//  Cell_Store_MyOrders_Past.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos


class Cell_MyOrders_Past: UITableViewCell {

    @IBOutlet weak var viewRateOrder: GradientView!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var lblSeperator: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var takeAwayImageView: UIImageView!
    @IBOutlet weak var labelOrderNumber: UILabel!
    @IBOutlet weak var labelOrderPrice: UILabel!
    
    @IBOutlet weak var btnRateOrder: UIButton!
    @IBOutlet weak var btnReorder: UIButton!
    @IBOutlet weak var lblOrderRestaurantTitle: UILabel!
    @IBOutlet weak var labelDeliveredAt: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var lblOrderDetailsText: UILabel!
    
    @IBOutlet weak var vwButtonReorder: UIView!
    @IBOutlet weak var orderDetailStackView: UIStackView!
    
    @IBOutlet weak var rateOrderView: UIView!
    @IBOutlet weak var imgStar: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblFoodRatingText: UILabel!
    @IBOutlet weak var imgFoodRating: UIImageView!
    var controller:VC_MyOrders!
    var delegate: DataPass?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func rateMyOrder(_ sender: UIButton) {

        if let type = self.controller.cartType{

            if type == Cart.store{
                if let deliveredOrderID = self.controller.deliveredOrders[sender.tag].id{
                    let vc :  VC_Store_RateOrder = storyboardMyOrders.instantiateViewController(withIdentifier: "VC_Store_RateOrder") as! VC_Store_RateOrder
                    vc.orderId = deliveredOrderID
                    self.controller.navigationController?.pushViewController(vc, animated: true)
                }else{
                }
            }
        
            else if type == Cart.restaurant{
                
                if let _ = self.controller.deliveredOrders[sender.tag].id{
                }
            }
        }
    }
    
    
    func setData(order:MyOrder){
        
        takeAwayImageView.isHidden = false
        if !(self.controller.isFromStore) {
            switch (order.status) {
            case "Cancelled":
                labelOrderPrice.text = "\(order.amount ?? "")\(currencySymbol)"
                                labelDeliveredAt.text  = ""
                orderDetailStackView.isHidden = false
                lblOrderRestaurantTitle.text  = "\(order.restaurantDetails?.name ?? "")"
                lblOrderDetailsText.text = "\(order.items ?? "")"
                vwButtonReorder.isHidden = true
                rateOrderView.isHidden = true
                labelStatus.textColor = #colorLiteral(red: 1, green: 0.7176470588, blue: 0.2470588235, alpha: 1)
                
            case "Delivered":
                
                labelOrderPrice.text = "\(order.amount ?? "")\(currencySymbol)"
                orderDetailStackView.isHidden = false
                lblOrderRestaurantTitle.text  = "\(order.restaurantDetails?.name ?? "")"
                lblOrderDetailsText.text = "\(order.items ?? "")"
                vwButtonReorder.isHidden = false
                btnReorder.layer.borderWidth = 1
                btnReorder.layer.borderColor = #colorLiteral(red: 1, green: 0.7174214125, blue: 0.2454458475, alpha: 1)
                rateOrderView.isHidden = false
                btnRateOrder.isHidden = false
                imgStar.isHidden = false
                imgFoodRating.isHidden = false
                //MARK: - LOGICS FOR FOOD RATING EMOJI
                
                switch (order.foodRating) {
                case 5:
                    imgFoodRating.isHidden = false
                    lblSeperator.isHidden = false
                    imgFoodRating.image = UIImage(named: "great")
                    lblFoodRatingText.textColor = .black
                    lblFoodRatingText.text = "Great"
                    
                case 4:
                    imgFoodRating.isHidden = false
                    lblSeperator.isHidden = false
                    imgFoodRating.image = UIImage(named: "good")
                    lblFoodRatingText.textColor = .black
                    lblFoodRatingText.text = "Good"
                case 3:
                    imgFoodRating.isHidden = false
                    lblSeperator.isHidden = false
                    imgFoodRating.image = UIImage(named: "okay")
                    lblFoodRatingText.textColor = .black
                    lblFoodRatingText.text = "Okay"
                case 2:
                    imgFoodRating.isHidden = false
                    lblSeperator.isHidden = false
                    imgFoodRating.image = UIImage(named: "bad")
                    lblFoodRatingText.textColor = .black
                    lblFoodRatingText.text = "Bad"
                case 1:
                    imgFoodRating.isHidden = false
                    lblSeperator.isHidden = false
                    imgFoodRating.image = UIImage(named: "terrible")
                    lblFoodRatingText.textColor = .black
                    lblFoodRatingText.text = "Terrible"
                case 0:
                    imgFoodRating.isHidden = true
                    lblSeperator.isHidden = true
                    lblFoodRatingText.textColor = .lightGray
                    lblFoodRatingText.text = "Not rated yet"
                default:
                    if (order.foodRating == nil) {
                        imgFoodRating.isHidden = true
                        lblSeperator.isHidden = true
                        lblFoodRatingText.textColor = .lightGray
                        lblSeperator.isHidden = true
                        lblFoodRatingText.text = "Not rated yet"
                    }
                    
                }
                
                if order.selfPickup == true {
                    lblRating.text = "Not Applicable"
                    lblRating.textColor = UIColor.lightGray
                    if order.foodRating == 0 || order.foodRating == nil {
                        btnRateOrder.setTitle("RATE FOOD", for: .normal)
                        btnRateOrder.layer.borderWidth = 1
                        btnRateOrder.layer.borderColor = UIColor.black.cgColor
                        lblFoodRatingText.text = "Not Rated Yet"
                        lblSeperator.isHidden = true
                        lblFoodRatingText.textColor = UIColor.lightGray
                    } else {
                        btnRateOrder.isHidden = true
                        lblSeperator.isHidden = false
                    }
                } else {
                    if order.driverRating == 0 || order.driverRating == nil {
                        imgStar.isHidden = true
                        lblRating.text = "Not Rated Yet"
                        lblRating.textColor = UIColor.lightGray
                        btnRateOrder.setTitle("RATE ORDER", for: .normal)
                        btnReorder.layer.borderWidth = 1
                        btnRateOrder.layer.borderColor = UIColor.black.cgColor
                        
                    } else if order.foodRating == 0 || order.foodRating == nil {
                        lblRating.text = "\(order.driverRating ?? 0).0"
                        lblRating.textColor = UIColor.black
                        btnRateOrder.setTitle("RATE FOOD", for: .normal)
                        btnRateOrder.layer.borderWidth = 1
                        btnRateOrder.layer.borderColor = UIColor.black.cgColor
                        lblFoodRatingText.text = "Not Rated Yet"
                        lblFoodRatingText.textColor = UIColor.lightGray
                        lblSeperator.isHidden = true
                        lblFoodRatingText.textColor = UIColor.lightGray
                    } else {
                        lblRating.text = "\(order.driverRating ?? 0).0"
                        lblRating.textColor = UIColor.black
                        btnRateOrder.isHidden = true
                    }
                }
            case .none:
                print("None")
            case .some(_):
                print("Some")
            }
            
            let imgUrl = takeAwayImageUrl
            
            if (order.selfPickup == true)  {
                
                let imagePath = imgUrl
                imgStar.isHidden = true
                takeAwayImageView.isHidden = false
                takeAwayImageView.setIndicatorStyle(.gray)
                takeAwayImageView.setShowActivityIndicator(true)
                takeAwayImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "takeAway")) { (image, error, type, url) in
                    self.takeAwayImageView.setShowActivityIndicator(false)
                }
            } else {
                takeAwayImageView.isHidden = true
            }
        }else{
            labelOrderPrice.text = "\(order.amount ?? "")\(currencySymbol)"
            takeAwayImageView.isHidden = true
            lblOrderRestaurantTitle.text = ""
            lblOrderDetailsText.text = ""
            vwButtonReorder.isHidden = true
            rateOrderView.isHidden = true
            labelDeliveredAt.isHidden = true
            if lblOrderDetailsText.text == "" && lblOrderRestaurantTitle.text == "" {
                orderDetailStackView.isHidden = true
            } else {
                orderDetailStackView.isHidden = false
            }
        }
        
        labelOrderNumber.text = "\(orderNoText) \(order.orderSerial ?? "")"
        labelStatus.text = (order.status ?? "").capitalized
    }
}
