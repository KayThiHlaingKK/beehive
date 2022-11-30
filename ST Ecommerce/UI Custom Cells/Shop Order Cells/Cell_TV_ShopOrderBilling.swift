//
//  Cell_TV_ShopOrderBilling.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 19/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_ShopOrderBilling: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var deliFeeLabel: UILabel!
    
    var controller: UIViewController!
    private var productOrder: ProductOrder!
    var productQuantity: [ProductCart] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func setShopOrderData(shopCart: ShopCart){

        var itemsCount = 0
        
        productQuantity.forEach {
            itemsCount += $0.quantity ?? 0
        }
        quantityLabel.text = "\(itemsCount) item(s)"
        
        if let tax = self.controller?.priceFormat(pricedouble: shopCart.total_tax ?? 0) {
            taxLabel.text = "\(tax)\(currencySymbol)"
        }
        
        if let promotion = self.controller?.priceFormat(pricedouble: shopCart.promo_amount ?? 0) {
            promotionLabel.text = "\(promotion)\(currencySymbol)"
        }
        
        if let deliFee = self.controller?.priceFormat(pricedouble: shopCart.delivery_fee ?? 0.0) {
            deliFeeLabel.text = "\(deliFee)\(currencySymbol)"
        }
        
        let subTotal = (shopCart.sub_total ?? 0.0)
        if let subTotalString = self.controller?.priceFormat(pricedouble: subTotal) {
            subtotalLabel.text = "\(subTotalString)\(currencySymbol)"
        }
        
        if let total = self.controller?.priceFormat(pricedouble: shopCart.total_amount ?? 0.0){
            totalAmountLabel.text = "\(total)\(currencySymbol)"
        }
    }
    
    func setData(productOrder: ProductOrder?) {
        guard let productOrder = productOrder else {
            return
        }

        self.productOrder = productOrder
        var itemsCount = 0
        
        productOrder.items?.forEach {
            itemsCount += $0.quantity ?? 0
        }
        quantityLabel.text = "\(itemsCount) item(s)"
        
        if let tax = self.controller?.priceFormat(pricedouble: productOrder.tax ?? 0) {
            taxLabel.text = "\(tax)\(currencySymbol)"
        }
        
        if let promotion = self.controller?.priceFormat(pricedouble: productOrder.promocode_amount ?? 0) {
            promotionLabel.text = "\(promotion)\(currencySymbol)"
        }
        
        if let deliFee = self.controller?.priceFormat(pricedouble: productOrder.delivery_fee ?? 0.0) {
            deliFeeLabel.text = "\(deliFee)\(currencySymbol)"
        }
        
        let subTotal = (productOrder.amount ?? 0.0) - (productOrder.discount ?? 0.0)
        if let subTotalString = self.controller?.priceFormat(pricedouble: subTotal) {
            subtotalLabel.text = "\(subTotalString)\(currencySymbol)"
        }
        
        if let total = self.controller?.priceFormat(pricedouble: productOrder.total_amount ?? 0.0){
            totalAmountLabel.text = "\(total)\(currencySymbol)"
        }
        
    }
}
