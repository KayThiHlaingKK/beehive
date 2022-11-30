//
//  Cell_TV_Restro_Cart_Billing.swift
//  ST Ecommerce
//
//  Created by necixy on 05/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

protocol PromoRestaurantDelegate {
    func validatePromoRestaurant(promo: String,  completion: @escaping (Bool) -> Void)
    func validatePromoRestaurantNoAlert(promo: String,  completion: @escaping (Bool) -> Void)
    func removePromoMenu(isStore: Bool, completion: @escaping (Bool) -> Void)
}

protocol TotalDelegate{
    func getTotal(totalAmt: String)
}

class Cell_TV_Restro_Cart_Billing: UITableViewCell {
    
    //MARK: -  IBOutlets
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTax: UILabel!
    @IBOutlet weak var labelTaxPercentage: UILabel!
    
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!
    
    //Promocode start
    @IBOutlet weak var containerViewPromoCode: GradientView!
    
    @IBOutlet weak var containerViewApplyPromoCode: UIView!
    @IBOutlet weak var btnApplyPromoCode: UIButton!
    @IBOutlet weak var tfInputPromoCode: UITextField!
    
    @IBOutlet weak var containerViewAppliedPromoCode: UIView!
    @IBOutlet weak var lblCongratsPromoCodeApplied: UILabel!
    @IBOutlet weak var lblPromoCodeApplied: UILabel!
    @IBOutlet weak var btnRemovePromoCode: UIButton!
    //Promocode end
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var topConstraintLblDiscountPrice: NSLayoutConstraint!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var labelGroupStackView: UIStackView!
    
    
    var promoDelegate: PromoRestaurantDelegate!
    
    private var extraChargesStackViews = [UIStackView]()
    
    
    //MARK: - Variable
    var controller_:VC_Cart!
    var controller:CartViewController!
    var totalDelegate: TotalDelegate!
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setData(restaurant: RestaurantCart) {
        print("restaurant ", restaurant)
        if let promo = restaurant.promo_amount {
            lblDiscountPrice.text =  "\(self.controller.priceFormat(pricedouble: promo))\(currencySymbol)"
        }
        else {
            lblDiscountPrice.text =  "0\(currencySymbol)"
        }
        labelAmount.text = "\(self.controller.priceFormat(pricedouble: restaurant.sub_total ?? 0))\(currencySymbol)"
        labelTax.text = "\(self.controller.priceFormat(pricedouble: restaurant.total_tax ?? 0))\(currencySymbol)"
        
        
        if Singleton.shareInstance.willdeli == DeliveryMode.pickup
        {
            lblDiscountPrice.text = "\(self.controller.priceFormat(pricedouble: restaurant.promo_amount ?? 0))\(currencySymbol)"
            labelDeliveryCharge.text = "0\(currencySymbol)"
            let new = Double(restaurant.total_amount ?? 0) - Double(restaurant.delivery_fee ?? 0)// - Double(restaurant.promo_amount ?? 0)
            //let total = Double(restaurant.total_amount ?? 0)
            labelTotalAmount.text = "\(self.controller.priceFormat(pricedouble: new))\(currencySymbol)"
            totalDelegate.getTotal(totalAmt: "\(self.controller.priceFormat(pricedouble: new))\(currencySymbol)")
        }
        else {
            lblDiscountPrice.text = "\(self.controller.priceFormat(pricedouble: restaurant.promo_amount ?? 0))\(currencySymbol)"
            labelDeliveryCharge.text = "\(self.controller.priceFormat(pricedouble: restaurant.delivery_fee ?? 0))\(currencySymbol)"
            labelTotalAmount.text = "\(self.controller.priceFormat(pricedouble: restaurant.total_amount ?? 0))\(currencySymbol)"
           
            totalDelegate.getTotal(totalAmt: "\(self.controller.priceFormat(pricedouble: restaurant.total_amount ?? 0))\(currencySymbol)")
        }
        setupForExtraCharges(restaurantCart: restaurant)
    }
    
    private func setupForExtraCharges(restaurantCart: RestaurantCart) {
        extraChargesStackViews.forEach {
            $0.removeFromSuperview()
        }
        extraChargesStackViews.removeAll()
        
        guard let extraCharges = restaurantCart.extra_charges else { return }
        extraCharges.forEach {
            let doubleValue =  Double($0.value ?? "0")
            let value = "\(self.controller.priceFormat(pricedouble: doubleValue ?? 0.0))\(currencySymbol)"
            let name = $0.name?.capitalized
            
            let valueLabel = createLabel(text: value, alignment: .right)
            let nameLabel = createLabel(text: name ?? "")
            let stackView = createStackView(labels: nameLabel, valueLabel)
            extraChargesStackViews.append(stackView)
            labelGroupStackView.insertArrangedSubview(stackView, at: 1)
        }
    }
    
//    func refreshPromoCodeUI(item:RestroCart){
//
//        configurePromoInputTextField()
//
//        let discount = item.discount ?? ""
//        let coupon = item.coupon ?? ""
//
//        containerViewApplyPromoCode.isHidden = false
//        containerViewAppliedPromoCode.isHidden = true
//        if discount != "0.00"{
//            containerViewApplyPromoCode.isHidden = true
//            containerViewAppliedPromoCode.isHidden = false
//        }
//
//
//        let congratstext = "Congrats! You saved \(discount) \(currencySymbol)."
//        lblCongratsPromoCodeApplied.text = congratstext
//
//        let promoCodeAppliedText = "\(coupon.uppercased()) APPLIED."
//        lblPromoCodeApplied.text = promoCodeAppliedText
//
//        self.refreshApplyCodeButton()
//    }
    
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
    
    @IBAction func applyPromoCode(_ sender: UIButton) {
        if self.controller.appliedPromoMenu {
            self.promoDelegate.removePromoMenu(isStore: false) { [weak self] success in
                
            }
        }
        else {
            if let promoCode = tfInputPromoCode.text{
                self.tfInputPromoCode.resignFirstResponder()
                self.promoDelegate.validatePromoRestaurant(promo: promoCode) { [weak self] success in
                }
                containerViewApplyPromoCode.isHidden = true
            }
        }
        
    }
    
//    @IBAction func removePromoCode(_ sender: UIButton) {
//    
//        self.tfInputPromoCode.text = ""
//        self.controller.removePromoCodeRestro()
//        
//    }
//    
    @IBAction func openPromoCode(_ sender: UIButton) {
        if self.controller.appliedPromoMenu {
            self.promoDelegate.removePromoMenu(isStore: false) { [weak self] success in
                
            }
        }
        else {
            let vc : VC_Promotion = storyboardCart.instantiateViewController(withIdentifier: "VC_Promotion") as! VC_Promotion
            vc.promoResDelegate = self.promoDelegate
            self.controller.present(vc, animated: true, completion: nil)
        }
        
        
//        tfInputPromoCode.text = ""
//        containerViewApplyPromoCode.isHidden = false
    }
    
    private func createLabel(text: String, alignment: NSTextAlignment = .natural) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.numberOfLines = 1
        lbl.textColor = .darkGray
        lbl.textAlignment = alignment
        lbl.font = UIFont(name: "Lato-Regular", size: 15)
        return lbl
    }
    
    private func createStackView(labels: UILabel...) -> UIStackView {
        let sv = UIStackView()
        sv.spacing = 0
        sv.alignment = .fill
        sv.axis = .horizontal
        sv.distribution = .fillProportionally
        labels.forEach {
            sv.addArrangedSubview($0)
        }
        sv.backgroundColor = .clear
        return sv
    }
    
}
