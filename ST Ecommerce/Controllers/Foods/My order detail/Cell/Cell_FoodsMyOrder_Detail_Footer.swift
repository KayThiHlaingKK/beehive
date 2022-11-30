//
//  Cell_FoodsMyOrder_Detail_Footer.swift
//  ST Ecommerce
//
//  Created by necixy on 02/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_FoodsMyOrder_Detail_Footer: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTax: UILabel!
    @IBOutlet weak var labelTaxPercentage: UILabel!
    
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var labelSpecialInstructions: UILabel!
    @IBOutlet weak var specialInstructionHeading: UILabel!
    @IBOutlet weak var bottomConstraintSpecialLabel: NSLayoutConstraint!
    
    @IBOutlet weak var reOrderStackView: UIStackView!
    @IBOutlet weak var vwRateOrder: UIView!
    
    
    @IBOutlet weak var vwReviewView: UIView!
    @IBOutlet weak var driverReviewView: UIView!
    @IBOutlet weak var foodReviewView: UIView!
    @IBOutlet weak var lblDriverReview: UILabel!
    @IBOutlet weak var driverReviewText: UILabel!
    @IBOutlet weak var lblFoodReview: UILabel!
    @IBOutlet weak var foodReviewText: UILabel!
    
    @IBOutlet weak var vwCancel: UIView!
    @IBOutlet weak var lblCancellation: UILabel!
    @IBOutlet weak var lblCancellationTitle: UILabel!
    

    @IBOutlet weak var btnReorder: UIButton!
    @IBOutlet weak var btnRateOrder: UIButton!
    @IBOutlet weak var imgFoodRating: UIImageView!
    @IBOutlet weak var lblDriverRating: UILabel!
    @IBOutlet weak var imgDriverStar: UIImageView!
    @IBOutlet weak var lblFoodRating: UILabel!
    @IBOutlet weak var lblSeperator: UILabel!
    
    @IBOutlet weak var bottomConstraintTextView: NSLayoutConstraint!
    @IBOutlet weak var bottomContraintTotalAmountLabel: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintSpecialInstruction: NSLayoutConstraint!
    
    //Promocode discount
    @IBOutlet weak var lblPromoCodeApplied: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var topConstraintLblDiscount: NSLayoutConstraint!
    
    //Download Invoice
    @IBOutlet weak var btnDownloadInvoice: UIButton!
    @IBOutlet weak var btnDownloadInvoiceHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var controller:VC_FoodsMyOrder_Detail!
    var delegate: DataPass?
    
    //MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(restaurantOrder:RestaurantOrder){
        
        
        if restaurantOrder.promocode_amount != 0 {

            lblDiscountPrice.text = "\(self.controller.priceFormat(pricedouble: restaurantOrder.promocode_amount ?? 0))\(currencySymbol)"
            
        }
        else {
            lblDiscountPrice.text = "0\(currencySymbol)"
        }
        
        labelAmount.text = "\(self.controller.priceFormat(pricedouble: restaurantOrder.amount ?? 0))\(currencySymbol)"
        labelTax.text = "\(self.controller.priceFormat(pricedouble: restaurantOrder.tax ?? 0))\(currencySymbol)"

        labelTotalAmount.text = "\(self.controller.priceFormat(pricedouble: restaurantOrder.total_amount ?? 0))\(currencySymbol)"
        labelDeliveryCharge.text = "\(self.controller.priceFormat(pricedouble: restaurantOrder.delivery_fee ?? 0))\(currencySymbol)"
        

       
        btnDownloadInvoice.layer.cornerRadius = 15
        
//        let deliveryCharge = restroOrderDetails. ?? ""
//        labelDeliveryCharge.text = "\(deliveryCharge)\(currencySymbol)"
                
        let instructions = restaurantOrder.special_instruction ?? ""
        labelSpecialInstructions.text = instructions
        if instructions == ""{
            specialInstructionHeading.text = ""
            heightConstraintSpecialInstruction.constant = 0
            labelSpecialInstructions.text = ""

//            bottomConstraintTextView.constant = 0
            bottomConstraintSpecialLabel.constant = 0
        }
        btnReorder.layer.cornerRadius = 0
        btnReorder.layer.borderWidth = 1
        btnReorder.layer.borderColor = #colorLiteral(red: 1, green: 0.7174214125, blue: 0.2454458475, alpha: 1)
        
        btnRateOrder.layer.cornerRadius = 0
        btnRateOrder.layer.borderWidth = 1
        
//        if (restroOrderDetails.rating == 0) {
//            lblDriverRating.textColor = .lightGray
//            lblFoodRating.textColor = .lightGray
//            lblFoodRating.text = "No ratings yet"
//            lblDriverRating.text = "No ratings yet"
//        } else {
//            lblDriverRating.text = "\(restroOrderDetails.driverRating ?? 0).0"
//            lblFoodRating.text = "| \(restroOrderDetails.foodRating ?? 0)"
//        }
        
       
        // Promo code applied
//        let coupon = restroOrderDetails.couponCode ?? ""
//        lblPromoCodeApplied.text = ""
//        if coupon != ""{
//            lblPromoCodeApplied.text = "• Promocode \(coupon) Applied."
//        }
    }

}
