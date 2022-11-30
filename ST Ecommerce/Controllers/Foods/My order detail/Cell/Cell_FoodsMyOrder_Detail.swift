//
//  Cell_FoodsMyOrder_Detail.swift
//  ST Ecommerce
//
//  Created by necixy on 02/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_FoodsMyOrder_Detail: UITableViewCell {

    //MARK: - IBOtlets
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labelCustomization: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelCustomizationHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var controller:VC_FoodsMyOrder_Detail!
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Helper Functions
    
    func setData(orderItem:Restaurant_Order_Item){
        
        if orderItem.images?.count ?? 0 > 0 {
            let imagePath = "\(orderItem.images?[0].url ?? "")?size=xsmall"
            imageViewItem.setIndicatorStyle(.gray)
            imageViewItem.setShowActivityIndicator(true)
            imageViewItem.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
                self.imageViewItem.setShowActivityIndicator(false)
            }
        }
        labelName.text = orderItem.menu_name ?? ""
        
        var unitPrice = 0.0
        var qty = 0.0
        var subTotal = 0.0
        var subdiscount = 0.0
        
        var price = orderItem.amount ?? 0.0
        qty = Double(orderItem.quantity ?? 1)
        subdiscount = orderItem.discount ?? 0.0
        
        unitPrice = price - subdiscount
        subTotal = unitPrice * qty
        
        labelPrice.text = "\(self.controller.priceFormat(pricedouble: unitPrice))\(currencySymbol)"
        labelQty.text = "\(orderItem.quantity ?? 0)"
        labelAmount.text = "\(self.controller.priceFormat(pricedouble: subTotal))\(currencySymbol)"
        
//        if orderItem.custom_option != nil && orderItem.custom_option != "" {
//            labelCustomization.text = orderItem.custom_option!
//        } else {
//            labelCustomization.isHidden = true
//            labelCustomizationHeight.constant = 0.0
//        }
        
    }
}
