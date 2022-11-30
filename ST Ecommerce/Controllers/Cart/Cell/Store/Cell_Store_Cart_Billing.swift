//
//  Cell_Store_Cart_Billing.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

protocol PromoProductDelegate {
    func validatePromoProduct(promo: String,  completion: @escaping (Bool) -> Void)
}

class Cell_Store_Cart_Billing: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelTax: UILabel!
    @IBOutlet weak var labelTaxPercentage: UILabel!

    @IBOutlet weak var labelDeliveryCharge: UILabel!
    @IBOutlet weak var labelTotalAmount: UILabel!

    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewAddEditAddress: UIImageView!
    @IBOutlet weak var buttonAddEditAddress: UIButton!
    @IBOutlet weak var labelDeliveryDetails: UILabel!
    @IBOutlet weak var buttonEditAddress: UIButton!

    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var topConstraintLblDiscountPrice: NSLayoutConstraint!
    @IBOutlet weak var lblDiscountPrice: UILabel!

    @IBOutlet weak var promoView: UIView!
    @IBOutlet weak var promoTextField: UITextField!
    @IBOutlet weak var btnApplyPromoCode: UIButton!
    @IBOutlet weak var labelGroupStackView: UIStackView!

    @IBOutlet weak var billingBgView: UIView!
    @IBOutlet weak var deliFeeStackView: UIStackView!

    var promoDelegate: PromoProductDelegate!
    private var extraChargesStackViews = [UIStackView]()


    //MARK: - Variables
    var controller_:VC_Cart!
    var controller:CartViewController!
    var subTotal = 0.0

    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(shopCart: ShopCart){

        if let promotion = shopCart.promo_amount { //Int(cartItems[0].promotion ?? 0.0)
            lblDiscountPrice.text = "\(self.controller.priceFormat(pricedouble: promotion))\(currencySymbol)"
        }
        print("before label amount = " , subTotal)

        labelAmount.text = "\(self.controller.priceFormat(pricedouble: shopCart.sub_total ?? 0))\(currencySymbol)"

        labelTax.text = "\(self.controller.priceFormat(pricedouble: shopCart.total_tax ?? 0))\(currencySymbol)"


        labelTotalAmount.text = "\(self.controller.priceFormat(pricedouble: shopCart.total_amount ?? 0))\(currencySymbol)"

        deliFeeStackView.isHidden = true
//        let deliFee = shopCart.delivery_fee ?? 0
//        if deliFee == 0 {
//            deliFeeStackView.isHidden = true
//        }else{
//            deliFeeStackView.isHidden = false
//            labelDeliveryCharge.text = "\(self.controller.priceFormat(pricedouble: shopCart.delivery_fee ?? 0))\(currencySymbol)"
//        }
        setupForExtraCharges(shopCart: shopCart)

    }

    //MARK: - Helper Functions
    func setData(cartItems:[CartProduct], addressStr: String){

        print("setData")
        var subTotal: Double = 0.0
        var allTotal: Double = 0.0
        var allTax: Double = 0.0

        if cartItems.count > 0 {
            for i in 0..<cartItems.count {
                let sub: Double = Double(cartItems[i].total ?? 0)
                subTotal = subTotal + sub

                if var tax = cartItems[i].tax {
                    if tax != 0 {
                        tax = ( sub / 100) * tax
                        allTax = allTax + tax
                    }
                }
            }

            allTotal = subTotal + allTax


            if let promo = cartItems[0].promotion {
                allTotal = allTotal - Double(promo)
            }

        }
        if let promotion = cartItems[0].promotion { //Int(cartItems[0].promotion ?? 0.0)
            lblDiscountPrice.text = "\(self.controller.priceFormat(price: promotion))\(currencySymbol)"
        }
        print("before label amount = " , subTotal)

        labelAmount.text = "\(self.controller.priceFormat(price: Int(subTotal)))\(currencySymbol)"

        labelTax.text = "\(self.controller.priceFormat(price: Int(allTax)))\(currencySymbol)"

        if allTotal < 0 {
            labelTotalAmount.text = "0\(currencySymbol)"
        }
        else {
            labelTotalAmount.text = "\(self.controller.priceFormat(pricedouble: allTotal))\(currencySymbol)"
        }

        self.controller.subTotalAmount = subTotal


        labelDeliveryCharge.text = "0\(currencySymbol)"

    }


    //MARK:- Action Functions

    @IBAction func editAddress(_ sender: UIButton) {


        if self.controller.addresses.count == 0{

//            let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
            //////vc.profileData = self.controller.userProfile
            self.controller.navigationController?.pushView(AddAddressRouter())
//            self.controller.navigationController?.pushViewController(vc, animated: true)
        }else{            let vc : VC_User_Addresses = storyboardAddress.instantiateViewController(withIdentifier: "VC_User_Addresses") as! VC_User_Addresses
            ///////vc.profileData = self.controller.userProfile
            /*if let address = self.controller.addresses.filter({$0.isPrimary == true}).first{
                vc.primaryAddress = address
            }*/
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
    }

//    @IBAction func applyPromoCode(_ sender: UIButton) {
//        print("apply promo")
//
//        if let promoCode = promoTextField.text{
//
//            self.promoTextField.resignFirstResponder()
//            self.promoDelegate.validatePromoProduct(promo: promoCode)
//            //promoView.isHidden = true
//            self.controller.dismiss(animated: false, completion: nil)
//        }
//
//
//
////        if let rowid = self.controller.productOrderList?[sender.tag].slug, let promoCode = tfInputPromoCode.text{
////            print("promoText is \(promoCode)")
////            self.tfInputPromoCode.endEditing(true)
////
////            self.controller.applyPromoCode(rowid: rowid, promoCode: promoCode)
////        }
//
//    }

    @IBAction func openPromoCode(_ sender: UIButton) {

        print("open Promocode")
        if self.controller.appliedPromoProduct {
//            self.promoDelegate.removePromoProduct()
        }
        else {

            let vc : VC_Promotion = storyboardCart.instantiateViewController(withIdentifier: "VC_Promotion") as! VC_Promotion
            vc.promoProductDelegate = self.promoDelegate
            vc.type = "Product"
            self.controller.present(vc, animated: true, completion: nil)
        }
//        promoTextField.text = ""
//        promoView.isHidden = false
    }


    private func setupForExtraCharges(shopCart: ShopCart) {
        extraChargesStackViews.forEach {
            $0.removeFromSuperview()
        }
        extraChargesStackViews.removeAll()

        guard let extraCharges = shopCart.extra_charges else { return }
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
