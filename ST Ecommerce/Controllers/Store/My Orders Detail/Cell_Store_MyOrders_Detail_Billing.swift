//
//  Cell_Store_MyOrders_Detail_Billing.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_Store_MyOrders_Detail_Billing: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTax: UILabel!
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    
    @IBOutlet weak var lblTaxPercentage: UILabel!
  
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var topConstraintLblDiscount: NSLayoutConstraint!
    
    
    
    //MARK: - Variable
    var controller : VC_Store_MyOrders_Detail!
    
    //MARK: - INternal functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    //MARK: -  Helping Functions
    func mul(lhs: Int, rhs: Double) -> Double {
        return Double(lhs) * rhs
    }
    
    func setData(orderDetails:ProductOrder){
       
        
//        var Total = 0.0
//        var allTax = 0.0
//        var subTotal = 0.0
//        let count = orderDetails.items?.count ?? 0
//        if count > 0 {
//            for i in 0..<count {
//
//                let price = orderDetails.items?[i].amount ?? 0.0
//                let subdiscount = orderDetails.items?[i].discount ?? 0.0
//                let unitPrice = price - subdiscount
//
//                let qty = Double(orderDetails.items?[i].quantity ?? 1)
//                let oneTotal = unitPrice * qty
//
//                let tax = orderDetails.items?[i].tax ?? 0.0
//                let oneTax = tax * qty
//                allTax = allTax + oneTax
//
//                subTotal = oneTotal + subTotal
//            }
//        }
//
//        Total = subTotal + allTax
//
        if orderDetails.promocode_amount != nil {
//            let promotion = orderDetails.promocode_amount ?? 0.0
//            Total = Total - promotion
            lblDiscountPrice.text = "\(self.controller.priceFormat(pricedouble:  orderDetails.promocode_amount ?? 0.0))\(currencySymbol)"
        }
        else {
            lblDiscountPrice.text = "0\(currencySymbol)"
        }
        
        if let discount = orderDetails.discount, discount > 0 {
            let org = orderDetails.amount ?? 0
            let price = org - discount
            labelAmount.text = "\(self.controller.priceFormat(pricedouble: price))\(currencySymbol)"
        }
        else {
            labelAmount.text = "\(self.controller.priceFormat(pricedouble: orderDetails.amount ?? 0))\(currencySymbol)"
        }
        
        
        labelTax.text = "\(self.controller.priceFormat(pricedouble: orderDetails.tax ?? 0))\(currencySymbol)"
        
//        if orderDetails.selfPickup == true {
//            labelDeliveryCharge.text = "0.00\(currencySymbol)"
//        } else {
//            let deliveryCharge = orderDetails.deliveryCharge ?? ""
//            labelDeliveryCharge.text = "\(deliveryCharge)\(currencySymbol)"
//        }
        
        
        labelTotalAmount.text = "\(self.controller.priceFormat(pricedouble: orderDetails.total_amount ?? 0))\(currencySymbol)"
        let date: String = orderDetails.order_date ?? ""
        lblOrderDate.text = date
        lblPaymentMethod.text = "\((orderDetails.payment_mode)?.uppercased() ?? "")"
        lblDeliveryAddress.text = "\(orderDetails.contact?.street_name ?? "")"
        
//        let discount = orderDetails.discount ?? ""
//
//        lblDiscount.text = ""
//        lblDiscountPrice.text = ""
//        topConstraintLblDiscount.constant = 0
//        if discount != "0.00"{
//            lblDiscount.text = "Discount"
//            lblDiscountPrice.text = "(-)\(discount)\(currencySymbol)"
//            topConstraintLblDiscount.constant = 12
//        }
        
       // lblTaxPercentage.text = "Tax ( \(orderDetails.t ?? "") %)"
    }
        
    }
    

