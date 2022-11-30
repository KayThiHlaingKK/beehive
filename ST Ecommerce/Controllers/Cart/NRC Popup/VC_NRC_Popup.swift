//
//  VC_NRC_Popup.swift
//  ST Ecommerce
//
//  Created by Necixy on 07/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

protocol NRCDelegate : NSObjectProtocol {
    func nrcValidated(buynowData:NSDictionary?)
    func discard()
}

class VC_NRC_Popup: UIViewController {

    //MARK: - IBoutlets
    @IBOutlet weak var lblInformationRequired: UILabel!
    @IBOutlet weak var lblNRC: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    
    @IBOutlet weak var tfInputNRC: UITextField!
    @IBOutlet weak var tfInputDOB: UITextField!
    
    @IBOutlet weak var containerViewButtons: GradientView!
    
    @IBOutlet weak var btnDiscard: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK: - Variables
    var promoCode : PromoCode!
    var rowid = ""
    var delegate : NRCDelegate?
    var cartType = Cart.store
    var fromBuyNow = false
    
    //only for buy now
    var productID = Int()
    var qty = Int()

    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        initialConfig()
        
        configureInputTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        localText()
    }

    
    //MARK: - Functions
    func initialConfig(){
        containerViewButtons.roundCorners(corners: [.bottomLeft, .bottomRight])
    }
    
    func localText(){
        
    }
    
    func configureInputTextField(){
        
        self.tfInputDOB.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //
        tfInputNRC.addTarget(self, action: #selector(self.textFieldNRCDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldNRCDidChange(_ textField: UITextField) {

        if let nrcText = textField.text{
            
        }
    }
    
    //MARK: - Action Functions
    @IBAction func discard(_ sender: UIButton) {
        self.delegate?.discard()
        self.remove()
    }
    
    @IBAction func done(_ sender: UIButton) {
        
        if tfInputNRC.text == ""{

            self.presentAlert(title: app_name, message: "Please enter NRC.")
        }
        else if tfInputDOB.text == ""{
           
            self.presentAlert(title: app_name, message: "Please select your date of birth.")
        }
        else{
        
            if fromBuyNow{
                if let promoCode = self.promoCode.promoCode, let nrc = tfInputNRC.text, let dob = tfInputDOB.text{
                    validatePromoCodeBuyNow(promoCode: promoCode, nrc: nrc, dob: dob, productId: self.productID, qty: self.qty)
                }
            }
            else{
                if cartType == Cart.store{
                    if let promoCode = self.promoCode.promoCode, let nrc = tfInputNRC.text, let dob = tfInputDOB.text{
                        self.validatePromoCode(rowid: self.rowid, promoCode: promoCode, nrc: nrc, dob: dob)
                    }
                }
                else if cartType == Cart.restaurant{
                    
                    if let promoCode = self.promoCode.promoCode, let nrc = tfInputNRC.text, let dob = tfInputDOB.text{
                        self.validatePromoCodeRestro(promoCode: promoCode, nrc: nrc, dob: dob)
                    }
                }
            }
            
            
            
        }
    }
    
    //MARK: - API Functions
    func validatePromoCode(rowid:String, promoCode:String, nrc:String, dob:String){
        
        let param : [String:Any] = ["promo_code":promoCode,
                                    "nrc":nrc,
                                    "dob":dob]
        print("param \(param)")
        
        APIUtils.APICall(postName: "\(APIEndPoint.storeCartPath.caseValue)\(rowid)\(APIEndPoint.validateCode.caseValue)", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                
                if let message = data.value(forKeyPath: "message") as? String{
                    self.presentAlert(title: app_name, message: message)
                }else{
                    self.delegate?.nrcValidated(buynowData: nil)
                    self.remove()
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func validatePromoCodeRestro(promoCode:String, nrc:String, dob:String){
        
        let param : [String:Any] = ["promo_code":promoCode,
                                    "nrc":nrc,
                                    "dob":dob]
        print("param \(param)")
        
        APIUtils.APICall(postName: "\(APIEndPoint.cartPathRestro.caseValue)\(APIEndPoint.validateCodeRestro.caseValue)", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                
                if let message = data.value(forKeyPath: "message") as? String{
                    self.presentAlert(title: app_name, message: message)
                }else{
                    self.delegate?.nrcValidated(buynowData: nil)
                    self.remove()
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func validatePromoCodeBuyNow(promoCode:String, nrc:String, dob:String, productId:Int, qty:Int){
        
        let param : [String:Any] = ["promo_code":promoCode,
                                    "nrc":nrc,
                                    "dob":dob]
        print("param \(param)")
        
        APIUtils.APICall(postName: "\(APIEndPoint.product.caseValue)/\(productId)\(APIEndPoint.validateCode.caseValue)?qty=\(qty)", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                
                if let message = data.value(forKeyPath: "message") as? String{
                    self.presentAlert(title: app_name, message: message)
                }else{
                    if let buyNowData = data.value(forKeyPath: "data.buy_now") as? NSDictionary{
                        self.delegate?.nrcValidated(buynowData: buyNowData)
                        self.remove()
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
    
    
}
extension VC_NRC_Popup{
    
    @objc func tapDone() {
        if let datePicker = self.tfInputDOB.inputView as? UIDatePicker { 
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "yyyy-MM-dd"
            self.tfInputDOB.text = dateformatter.string(from: datePicker.date)
        }
        self.tfInputDOB.resignFirstResponder()
    }
    
}
