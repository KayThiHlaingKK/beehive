//
//  Cell_Store_Cart_Product.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

//protocol ProductCountDelegate {
//    func changeProductCount()
//}

class Cell_Store_Cart_Product: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var labelItemQty: UILabel!
    @IBOutlet weak var buttonPlus: UIButton!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    @IBOutlet weak var labelStorename: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelActualAmount: UILabel!
    @IBOutlet weak var labelVarient: UILabel!
    
    @IBOutlet weak var imageViewProduct: UIImageView!
    
    @IBOutlet weak var buttonRemoveItem: UIButton!
    @IBOutlet weak var labelItemNotAvailble: UILabel!
    @IBOutlet weak var labelFreeDelivery: UILabel!
    
    @IBOutlet weak var containerViewPromoCode: GradientView!
    @IBOutlet weak var heightContainerViewPromocode: NSLayoutConstraint!
    @IBOutlet weak var btnExpandCollaspe: UIButton!
    
    @IBOutlet weak var lblPromoCode: UILabel!
    
    @IBOutlet weak var containerViewApplyPromoCode: UIView!
    @IBOutlet weak var btnApplyPromoCode: UIButton!
    @IBOutlet weak var tfInputPromoCode: UITextField!
    
    @IBOutlet weak var containerViewAppliedPromoCode: UIView!
    @IBOutlet weak var lblCongratsPromoCodeApplied: UILabel!
    @IBOutlet weak var lblPromoCodeApplied: UILabel!
    @IBOutlet weak var btnRemovePromoCode: UIButton!
    
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    
    @IBOutlet weak var orderBgView: UIView!
    
    //MARK: - Variables
    var controller_:VC_Cart!
    var controller:CartViewController!
    var itemQty = 1
    var isExpanded: Bool = false
    var shopCart: ShopCart?
    var productCart: ProductCart?
    
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
   
//    func setData(shop: Shop){
//
//        if productCart?.name?.count ?? 0 > 20 {
//            cellHeight.constant = 150
//        }
//        else {
//            cellHeight.constant = 130
//        }
//        self.labelTitle.text = (productCart?.name ?? "").trunc(length: 40)
//
//        self.labelStorename.text = (shop.name ?? "").trunc(length: 20)
//
//        if let discount = productCart?.discount {
//            let org = productCart?.amount ?? 0
//            let price = org - discount
//            print("discount = ", discount)
//            labelPrice.text = "\(self.controller.priceFormat(price: price))\(currencySymbol)"
//        }
//        else {
//            labelPrice.text = "\(self.controller.priceFormat(price: productCart?.amount ?? 0))\(currencySymbol)"
//        }
//
//
//
//        labelItemQty.text = "\(productCart?.quantity ?? 1)"
//
//
//    }
    
    func setData(productCart: ProductCart){
        self.productCart = productCart
        if productCart.name?.count ?? 0 > 20 {
            cellHeight.constant = 170
        }
        else {
            cellHeight.constant = 170
        }
        self.labelTitle.text = (productCart.name ?? "").trunc(length: 40)
  
        self.labelStorename.text = (productCart.shopName ?? "").trunc(length: 20)
        
        if let discount = productCart.discount {
            let org = productCart.amount ?? 0
            let price = org - discount
            print("discount = ", discount)
            labelPrice.text = "\(self.controller.priceFormat(pricedouble: price))\(currencySymbol)"
        }
        else {
            labelPrice.text = "\(self.controller.priceFormat(pricedouble: productCart.amount ?? 0))\(currencySymbol)"
        }
    
        let varient = productCart.variant?.variant?[0].value ?? ""
        labelVarient.text = varient
        labelItemQty.text = "\(productCart.quantity ?? 1)"
            
    }
    
    func refreshPromoCodeUI(item:CartProduct_){
        
        configurePromoInputTextField()
        
        self.refreshApplyCodeButton()
    }
    
    func configurePromoInputTextField(){
        tfInputPromoCode.addTarget(self, action: #selector(self.textFieldPromoDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldPromoDidChange(_ textField: UITextField) {
        self.refreshApplyCodeButton()
    }
    
    func refreshApplyCodeButton(){
        btnApplyPromoCode.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        btnApplyPromoCode.isUserInteractionEnabled = false
        if let promoText = tfInputPromoCode.text{
            if promoText != ""{
                btnApplyPromoCode.setTitleColor(#colorLiteral(red: 0.937254902, green: 0.5921568627, blue: 0.01568627451, alpha: 1), for: .normal)
                btnApplyPromoCode.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK: - Action Functions
    @IBAction func minus(_ sender: UIButton) {
        var qty: Int = productCart?.quantity ?? 1
        if qty > 1 {
            qty = qty - 1
            changeQty(qty: qty, row: sender.tag)
        
        }
        else {
            self.controller.presentAlertWithTitle(title: warningText, message: removeItemFromCartAlertText, options: noText, yesText) { (option) in
                
                switch(option) {
                case 1:
                    self.deleteCartProduct()
                    
                default:
                    break
                }
            }
        }
        
    }
    
    @IBAction func plus(_ sender: UIButton) {
        var qty: Int = productCart?.quantity ?? 1
        qty = qty + 1
        changeQty(qty: qty, row: sender.tag)
       
    }
    
    func changeQty(qty: Int, row: Int) {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? "", "key" : productCart?.key ?? "", "quantity" : qty]
            
        APIUtils.APICall(postName: "\(APIEndPoint.productCart.caseValue)/\(productCart?.slug ?? "")", method: .put,  parameters: param, controller: self.controller, onSuccess: { (response) in
                
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                            
                if status == 200{
                    
                    if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                        APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.productCart.caseValue, modelName: "Shop", onSuccess: { (anyData) in
                           
                            let shopCart = anyData as? ShopCart
                            self.controller.cartData?.shop = shopCart
                            self.controller.productCartList.removeAll()
                                                        
                           
                            if let shopCount = shopCart?.shops?.count , shopCount > 0 {
                                for i in 0..<shopCount{
                                    if let productCartCount = shopCart?.shops?[i].productCarts?.count , productCartCount > 0 {
                                        for j in 0..<productCartCount {
                                            var productCart = shopCart?.shops?[i].productCarts?[j]
                                            productCart?.shopName = shopCart?.shops?[i].name
                                            productCart?.shopSlug = shopCart?.shops?[i].slug
                                            self.controller.productCartList.append(productCart ?? ProductCart())
                                        }
                                    }
                                    
                                }
                            }
                            
                            print("plist =====", self.controller.productCartList)
//                            self.controller.shopRoom = 0
                            
                            let indexPosition = IndexPath(row: row, section: 0)
                            let indexPosition1 = IndexPath(row: 0, section: 1)
                            self.controller.tableViewCart.reloadRows(at: [indexPosition, indexPosition1], with: .none)
                            self.controller.totalAmtLbl.text = "\(self.controller.priceFormat(pricedouble: self.controller.cartData?.shop?.total_amount ?? 0))\(currencySymbol)"
                            
                        }) { (error, endPoint) in
                            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                        }
                    }
                
                }
                else {
                    DEFAULTS.set(false, forKey: UD_isContainAdd)
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
            }
    }
    
    @IBAction func removeItemFromCart(_ sender: UIButton) {
        self.controller.presentAlertWithTitle(title: warningText, message: removeItemFromCartAlertText, options: noText, yesText) { (option) in
            
            switch(option) {
            case 1:
                self.deleteCartProduct()
                
            default:
                break
            }
        }
        
    }
    
    func deleteCartProduct() {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? "", "key" : productCart?.key ?? ""]
            
        APIUtils.APICall(postName: "\(APIEndPoint.productCart.caseValue)/\(productCart?.slug ?? "")", method: .delete,  parameters: param, controller: self.controller, onSuccess: { (response) in
                
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                            
                if status == 200{
                    self.controller.loadCartData()
                }
                else {
                    DEFAULTS.set(false, forKey: UD_isContainAdd)
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
            }
        
    }
    
}
