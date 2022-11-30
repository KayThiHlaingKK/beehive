//
//  BuyNowViewController.swift
//  ST Ecommerce
//
//  Created by Necixy on 29/10/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD

class BuyNowViewController: UIViewController {
    
    //  MARK: - Outlets
    
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemSubtitle: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var lblNotAvailable: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var buttonMinus: UIButton!
    
    @IBOutlet weak var lblTaxPercentage: UILabel!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var taxAmount: UILabel!
    @IBOutlet weak var deliveryAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var btnChangeAddress: UIButton!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var btnCash: UIButton!
    @IBOutlet weak var btnCreditCard: UIButton!
    
    @IBOutlet weak var lblChangeAddress: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var lblCreditCard: UILabel!
    @IBOutlet weak var lblExpectedDelivery: UILabel!
    
    @IBOutlet weak var btnOrderConfrm: UIButton!
    
    @IBOutlet weak var viewItemDetails: UIView!
    @IBOutlet weak var viewPriceDetails: UIView!
    @IBOutlet weak var viewDeliveryDetails: UIView!
    @IBOutlet weak var viewPaymentOptions: GradientView!
    
    //Promocode start
    @IBOutlet weak var containerViewPromoCode: GradientView!
    
    @IBOutlet weak var containerViewApplyPromoCode: UIView!
    @IBOutlet weak var btnApplyPromoCode: UIButton!
    @IBOutlet weak var tfInputPromoCode: UITextField!
    
    @IBOutlet weak var containerViewAppliedPromoCode: UIView!
    @IBOutlet weak var lblCongratsPromoCodeApplied: UILabel!
    @IBOutlet weak var lblPromoCodeApplied: UILabel!
    @IBOutlet weak var btnRemovePromoCode: UIButton!
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var topConstraintLblDiscountPrice: NSLayoutConstraint!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    
    @IBOutlet weak var heightConstraintPriceDetails: NSLayoutConstraint!
    
    //Promocode end
    
    
    //  MARK: - Variables
    
    var addresses : [Address_] = [Address_]()
    var primaryAddress : Address_?
    var userProfile : ProfileData?
    var paymentMode = PaymentMode.cash
    var productDetails: ProductDetails?
    var storeCart : StoreCart?
    var buyNow : BuyNow?
    
    var qty = 1
    var productId:Int = 0
    
    var customization : [MyCustomization] = []
    
    //  MARK: - Internal Functins
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.configureTopViewPosition(heightConstraint: gradientViewHeight)
        
        btnOrderConfrm.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        deliveryAddress.text = "Address not found"
        
        self.loadBuyNowDetailsFromServer()
        self.loadAddresses()
        self.loadUserProfile()
        
        btnCash.isSelected = false
        btnCreditCard.isSelected = false
        
        if buyNow?.product?.available == false {
            presentAlertWithTitle(title: "Sorry", message: "Currently item is not availabel", options: "Go Back") {_ in
                
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: VC_Store_MyOrders_Detail.self){
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                        
                    }
                }
            }
        }
        setData()
   
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func plusQuantity(_ sender: UIButton) {
        self.qty = qty + 1
        self.loadBuyNowDetailsFromServer()
    }
    
    @IBAction func lessQuantity(_ sender: UIButton) {
        if self.qty > 1 {
            self.qty = qty - 1
            self.loadBuyNowDetailsFromServer()
        }
        
    }
    
    func updateItemInCart(qty:Int) {
        
        let param : [String:Any] = ["qty":qty]
        print("param \(param)")
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.updateItemInCartStore.caseValue)/update", method: .patch,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status {
            } else {
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
    @IBAction func changeAddress(_ sender: Any) {
        
        if self.addresses.count == 0{
//            let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
//            ////////vc.profileData = self.userProfile
//            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.pushView(AddAddressRouter())
        }else{
            let vc : VC_User_Addresses = storyboardAddress.instantiateViewController(withIdentifier: "VC_User_Addresses") as! VC_User_Addresses
            ///////vc.profileData = self.userProfile
            /*if let address = self.addresses.filter({$0.isPrimary == true}).first{
                vc.primaryAddress = address
            }*/
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cashOnDelivery(_ sender: Any) {
        
        self.paymentMode = PaymentMode.cash
        toggleCODandOnline()
    }
    
    @IBAction func orderConfirm(_ sender: Any) {
        
        self.placeOrder(payment_mode: "cod")
    }
    
    //  MARK: - Payment Helping Functions
    
    func setData(buy_Now:BuyNow) {
        totalAmount.text = "\(buy_Now.total ?? "")\(currencySymbol)"
        self.toggleCODandOnline()
    }
    
    func toggleCODandOnline() {
        
        self.btnCash.setImage(#imageLiteral(resourceName: "radio_button_un_selected"), for: .normal)
        self.btnCreditCard.setImage(#imageLiteral(resourceName: "radio_button_un_selected"), for: .normal)
        
        self.lblCash.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.lblCreditCard.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        if self.paymentMode == PaymentMode.cash{
            self.btnCash.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
            self.lblCash.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else if self.paymentMode == PaymentMode.credit{
            self.btnCreditCard.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
            self.lblCreditCard.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    //  MARK: -  Get Item Details
    
    func loadBuyNowDetailsFromServer() {
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        
        var path = "\(APIEndPoint.product.caseValue)/\(productId)\(APIEndPoint.buy_Now.caseValue)\(qty)"
        
        if !customization.isEmpty {
            
                let customization1 = self.customization[0]
                var text = customization1.text
                if customization1.text.contains(" "){
                    text = customization1.text.replacingOccurrences(of: " ", with: "%20")
                }

                path = path.appending("&\(customization1.option_type)=\(text)")
                
                if path.contains("+"){
                    path = path.replacingOccurrences(of: "+", with: "%2B")
                }
                
            
            
//            let customization1 = self.customization[0]
//            path = path.appending("&\(customization1.option_type)=\(customization1.text)")
            
        }
        if customization.count > 1 {
            
                let customization1 = self.customization[1]
                var text = customization1.text

                if customization1.text.contains(" "){
                    text = customization1.text.replacingOccurrences(of: " ", with: "%20")
                }
                
                path = path.appending("&\(customization1.option_type)=\(text)")
                
                if path.contains("+"){
                    path = path.replacingOccurrences(of: "+", with: "%2B")
                }
            
            
//            let customization1 = self.customization[1]
//            path = path.appending("&\(customization1.option_type)=\(customization1.text)")
            
        }
        
        APIUtils.APICall(postName: path, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status {
                if let buynowData = data.value(forKeyPath: "data.buy_now") as? NSDictionary{
                    self.buyNowDataGet(buynowData: buynowData)
                }
                
            } else {
                
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    //MARK: - Get Address
    
    func loadAddresses(){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        
        APIUtils.APICall(postName: APIEndPoint.getAllAddresses.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                if let addresses = data.value(forKeyPath: "data.addresses") as? NSArray{
                    if addresses.count == 0 {
                        self.addresses.removeAll()
                        self.primaryAddress = nil
                    }
                    APIUtils.prepareModalFromData(addresses, apiName: APIEndPoint.userProfile.caseValue, modelName:"Address", onSuccess: { (anyData) in
                        self.addresses = anyData as? [Address_] ?? []
                        let primaryAddress = self.addresses.filter({$0.isPrimary == true})
                        self.primaryAddress = primaryAddress.first
                        self.setData()
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                    
                }
                
            } else {
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
    func loadUserProfile(){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        
        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                if let addresses = data.value(forKeyPath: "data.addresses") as? NSArray{
                    
                    if addresses.count == 0{
                        self.addresses.removeAll()
                        self.primaryAddress = nil
                        
                    }
                    APIUtils.prepareModalFromData(addresses, apiName: APIEndPoint.userProfile.caseValue, modelName:"Address", onSuccess: { (anyData) in
                        self.addresses = anyData as? [Address_] ?? []
                        let primaryAddress = self.addresses.filter({$0.isPrimary == true})
                        self.primaryAddress = primaryAddress.first
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
                if let profile = data.value(forKeyPath: "data.profile") as? NSDictionary{
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                        self.userProfile = anyData as? ProfileData ?? nil
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    //MARK: - Post Order Details
    
    func placeOrder(payment_mode:String){
        
        if let shipping_address_id = self.primaryAddress?.id{
            
            var promo_code = ""
            if let coupon = self.buyNow?.coupon{
                promo_code = coupon
            }
            
            let param : [String:Any] = ["shipping_address_id":shipping_address_id,
                                        "billing_address_id":shipping_address_id,
                                        "payment_mode":payment_mode,
                                        "qty": qty,
                                        "promo_code":promo_code]
            print("param \(param)")
            self.showHud(message: loadingText)
            
            APIUtils.APICall(postName: "\(APIEndPoint.product.caseValue)/\(productId)/buy-now", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
                
                self.hideHud()
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Bool ?? false
                
                let messaages = "Thank you! We are processing your order"
                if status {
                    let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
                    vc.cartType = Cart.store
                    vc.fromHome = false
                    
                    self.presentAlertWithTitle(title: "Order Placed", message: messaages, options: "Ok") { (option) in
                        switch(option) {
                        case 0:
                            self.navigationController?.pushViewController(vc, animated: true)
                        default:
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        
                    }
                    
                }
                else {
                    let message = data[key_message] as? String ?? serverError
                    self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (value) in
                    }
                }
            }) { (reason, statusCode) in
                self.hideHud()
            }
        }
        else{
            self.presentAlert(title: attentionText, message: addressalertText)
        }
    }
    
    //   MARK: - Set Address
    
    func setData(){
        
        deliveryAddress.text = "Address not found"
        
        guard let primaryAddress = primaryAddress else {
            return
        }
        if self.addresses.count == 0 || self.addresses.isEmpty == true {
            
            lblChangeAddress.text = addAddressText
            btnChangeAddress.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        }else{
            lblChangeAddress.text = changeAddressText
            btnChangeAddress.setImage(#imageLiteral(resourceName: "pencil"), for: .normal)
        }
    }
}

//MARK: - Promocode work
extension BuyNowViewController{
    
    //MARK: - Functions
    func refreshPromoCodeUI(){
        
        configurePromoInputTextField()
        
        if let buyNow = self.buyNow{
            
            
            let discount = buyNow.discount ?? ""
            let coupon = buyNow.coupon ?? ""
            self.heightConstraintPriceDetails.constant = 250.5
            if coupon != ""{
                
                self.heightConstraintPriceDetails.constant = 280
            }
            
            containerViewApplyPromoCode.isHidden = false
            containerViewAppliedPromoCode.isHidden = true
            if coupon != ""{
                containerViewApplyPromoCode.isHidden = true
                containerViewAppliedPromoCode.isHidden = false
            }
            
            let congratstext = "Congrats! You saved \(discount)\(currencySymbol)."
            lblCongratsPromoCodeApplied.text = congratstext
            
            let promoCodeAppliedText = "\(coupon.uppercased()) APPLIED."
            lblPromoCodeApplied.text = promoCodeAppliedText
            
            self.refreshApplyCodeButton()
            
            if discount == "0.00"{
                lblDiscount.text = ""
                lblDiscountPrice.text = ""
                topConstraintLblDiscountPrice.constant = 0
            }else{
                lblDiscount.text = "Discount"
                lblDiscountPrice.text =  "(-)" + String(format: "%.2f",Double(discount) ?? 0) + currencySymbol
                topConstraintLblDiscountPrice.constant = 10
            }
        }
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
    
    //MARK: - Action Methods
    
    @IBAction func applyPromoCode(_ sender: UIButton) {
        
        if let pId = self.buyNow?.product?.id, let pc = self.tfInputPromoCode.text{
            self.applyPromoCode(productId: pId, qty: self.qty, promo_code: pc)
        }
        
        
    }
    
    @IBAction func removePromoCode(_ sender: UIButton) {
        self.tfInputPromoCode.text = ""
        self.loadBuyNowDetailsFromServer()
    }
    
    
    //MARK: - API callings
    func applyPromoCode(productId:Int, qty:Int, promo_code:String){
        
        let param : [String:Any] = ["promo_code":promo_code]
        print("param \(param)")
        
        APIUtils.APICall(postName: "\(APIEndPoint.product.caseValue)/\(productId)\(APIEndPoint.applyPromoCode.caseValue)?qty=\(qty)", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                
                if let message = data.value(forKeyPath: "message") as? String{
                    self.presentAlert(title: app_name, message: message)
                }else{
                    
                    if let promoCode = data.value(forKeyPath: "data.promo_code") as? NSDictionary{
                        
                        APIUtils.prepareModalFromData(promoCode, apiName: APIEndPoint.applyPromoCode.caseValue, modelName: "PromoCode") { (anyData) in
                            
                            if let promoCode = anyData as? PromoCode{
                                
                                let nrc_required = promoCode.nrcRequired ?? false
                                
                                if nrc_required{
                                    
                                    if let vc = storyboardCart.instantiateViewController(withIdentifier: "VC_NRC_Popup") as? VC_NRC_Popup{
                                        vc.promoCode = promoCode
                                        vc.delegate = self
                                        vc.qty = self.qty
                                        vc.productID = productId
                                        vc.fromBuyNow = true
                                        self.add(vc, frame: self.view.bounds)
                                    }
                                }
                            }
                            
                            
                        } onFailure: { (error, reason) in
                            
                        }
                        
                    }
                    else{
                        
                        if let buynowData = data.value(forKeyPath: "data.buy_now") as? NSDictionary{
                            self.buyNowDataGet(buynowData: buynowData)
                        }
                        
                    }
                    
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func buyNowDataGet(buynowData:NSDictionary){
        
        APIUtils.prepareModalFromData(buynowData, apiName: APIEndPoint.product.caseValue, modelName:"BuyNow", onSuccess: { (anyData) in
            
            self.buyNow = anyData as? BuyNow
            
            self.refreshPromoCodeUI()
            
            let imagePath = self.buyNow?.product?.image ?? ""
            
            self.itemImage.setIndicatorStyle(.gray)
            self.itemImage.setShowActivityIndicator(true)
            self.itemImage.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
                self.itemImage.setShowActivityIndicator(true)
            }
            
            self.itemImage.layer.cornerRadius = 15
            
            self.itemTitle.text = self.buyNow?.product?.name
            self.itemSubtitle.text = self.buyNow?.product?.subtitle
            self.storeName.text = self.buyNow?.product?.store?.name

            var customizeText = "\(self.buyNow?.product?.store?.name ?? "")\n"
        
            if let options = self.buyNow?.options{
               
                for option in options{
                    let op = option.option ?? ""
                    let value = option.value ?? ""
                    customizeText.append("\(op): \(value)\n")
                }
            }
            
            self.storeName.attributedText = Util.getAttributedStringApplyVerticalLineSpacing(spacing: 8, string: String(customizeText.dropLast()))
            
            
            self.itemPrice.text = (self.buyNow?.product?.price ?? "") + currencySymbol
            
            self.lblQuantity.text = String(self.qty)
            
            self.itemAmount.text = (self.buyNow?.subtotal ?? "") + currencySymbol
            
            if self.buyNow?.taxPercentage != "" {
                if let taxPercentage = self.buyNow?.taxPercentage {
                    self.lblTaxPercentage.text = "Tax (\(taxPercentage)%)"
                }
            }
            
            self.taxAmount.text = (self.buyNow?.tax ?? "") + currencySymbol
            
            self.totalAmount.text = (self.buyNow?.total ?? "") + currencySymbol
            
            self.lblTotalAmount.text = (self.buyNow?.total ?? "") + currencySymbol
            self.lblExpectedDelivery.text = self.buyNow?.deliveredBy
            
            
            if self.buyNow?.product?.isDeliveryFree == true {
                
                self.lblDelivery.isHidden = true
                self.deliveryAmount.isHidden = true
            }
            
            if self.buyNow?.deliveryCharge != nil {
                self.deliveryAmount.text = (self.buyNow?.deliveryCharge ?? "") + currencySymbol
            }
            
            if self.buyNow?.product?.available == true {
                
                if self.buyNow?.product?.quantity != 0 {
                    self.lblNotAvailable.isHidden = true
                    
                }else {
                    self.lblNotAvailable.text = productOutOfStockText
                }
            }
            
        }) { (error, endPoint) in
            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
        }
    }
    
}


extension BuyNowViewController : NRCDelegate{
    
    
    func nrcValidated(buynowData: NSDictionary?) {
        
        if let data = buynowData{
            self.buyNowDataGet(buynowData: data)
        }
        
    }
    
    func discard() {
        self.refreshPromoCodeUI()
    }
}

/*------------------------------------------Code written by shashi--------------------------------*/
