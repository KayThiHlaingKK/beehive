//
//  Cell_Register.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import TKSubmitTransition

import PhoneNumberKit
import JGProgressHUD

class Cell_Register: UITableViewCell, UIViewControllerTransitioningDelegate {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var buttonRegister: TKTransitionSubmitButton!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhone: PhoneNumberTextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var confirmpwdTF: UITextField!
    @IBOutlet weak var otpTF: UITextField!
    
    //MARK: - Varables
    var controller:VC_Register!
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pwdTF.isSecureTextEntry = true
        confirmpwdTF.isSecureTextEntry = true
        
        UISetup()
       
    }
    
    func UISetup() {
        
        //self.buttonRegister.isEnabled = false
        self.configureTextField()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Functions
    func didStartYourLoading() {
        buttonRegister.startLoadingAnimation()
    }
    
    func configureTextField(){
//        if #available(iOS 11.0, *) {
//            PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["IN"]
//            textFieldPhone.withDefaultPickerUI = true
//        }
//        textFieldPhone.withFlag = true
//        textFieldPhone.withExamplePlaceholder = true
//        textFieldPhone.withPrefix = true
        
        textFieldPhone.resignFirstResponder()
        textFieldName.resignFirstResponder()
        pwdTF.resignFirstResponder()
        confirmpwdTF.resignFirstResponder()
    }
    
    @objc func didFinishYourLoading() {
        
        buttonRegister.startFinishAnimation(0) {
            let verifyOTP = storyboardVerifyOTP.instantiateViewController(withIdentifier: "VC_VerifyOTP")
            verifyOTP.transitioningDelegate = self
            self.controller.navigationController?.pushViewController(verifyOTP, animated: true)
        }
    }
    
    //MARK: - Action Functions
    
    @IBAction func signIn(_ sender: UIButton) {
        
        Util.makeSignInRootController()
        
    }
    
    func validateTextField() -> Bool {
        if textFieldName.text == ""{
            self.controller.presentAlert(title: "", message: enterNameText)
        }else if textFieldPhone.text == ""{
            self.controller?.presentAlert(title: attentionText, message: enterPhoneNumberAlertText)
        }else if otpTF.text == ""{
            self.controller?.presentAlert(title: attentionText, message: enterOTPAlertText)
        }else if pwdTF.text == ""{
            self.controller?.presentAlert(title: attentionText, message: enterPasswordAlertText)
        }else if confirmpwdTF.text == ""{
            self.controller?.presentAlert(title: attentionText, message: enterConfirmPasswordAlertText)
        }else if pwdTF.text != confirmpwdTF.text {
            self.controller?.presentAlert(title: attentionText, message: passwordValidateAlertText)
        }
//        else if !(textFieldPhone.text?.isValidContact ?? true){
//            self.controller.presentAlert(title: attentionText, message: enterValidPhoneNumberAlertText)
//        }
        else {
            return true
        }
        return false
    }
    
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }
    
    func isValidPhoneNumber() -> Bool {
        let PHONE_REGEX = "^09[0-9'@s]{9,9}$"
                let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: textFieldPhone.text)
                return result
    }
    
    @IBAction func register(_ sender: UIButton) {
        
//        if validateTextField(){
            self.registerCustomer()
//
//        }
//        else {
//            print("validate false")
//        }
    }
    
    @IBAction func requestClick(_ sender: UIButton) {
//        if isValidPhoneNumber() {
            self.requestOTP()
//        }
//        else {
//            self.controller.presentAlert(title: attentionText, message: enterValidPhoneNumberAlertText)
//        }
    }
    
    func requestOTP() {
        let param : [String:Any] = [
            "phone_number": textFieldPhone.text
            ]
        self.controller.showHud(message: loadingText)
        APIUtils.APICall(postName: APIEndPoint.send_OTP.caseValue, method: .post, parameters: param, controller: self.controller, onSuccess: { (response) in
  
            print("otp response" , response)
              self.controller.hideHud()
            let data = response as? [String:Any] ?? [:]
            let status = data["status"] as? Int
                if status == 422 {
                    print("it is 422")
                    let message = data["message"] as? String
                    self.controller.presentAlert(title: attentionText, message: message ?? "")
                }
              
  
          }) { (reason, statusCode)  in
              self.controller.hideHud()
        }
    }
    
    
    //MARK: - APi calls
    func registerCustomer(){
        
        let name = textFieldName.text
        let number = textFieldPhone.text
        let pwd = pwdTF.text
        let otp = "\(otpTF.text ?? "")"
             
        let param : [String:Any] = ["otp_code": otp,
                                    "email": "",
                                    "name": name ?? "",
                                    "phone_number": number ?? "",
                                    "password": pwd ?? ""]
        self.controller.showHud(message: loadingText)
        
        APIUtils.APICall(postName: APIEndPoint.register.caseValue, method: .post,  parameters: param, controller: self.controller, onSuccess: { (response) in
            
            self.controller.hideHud()
            self.buttonRegister.isEnabled = true
            let response = response as? [String:Any] ?? [:]
            let status = response["status"] as? Int
            let data = response["data"] as? [String:Any] ?? [:]
                        
            if status == 200 {
                if let token = data["token"] as? String{
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.dateFormat = "dMMyyyy"
                    let currentDateString = dateFormatter.string(from: date)
                    
                    UserDefaults.standard.set(currentDateString, forKey: UD_Token)
                    
                    UserDefaults.standard.set(token, forKey: UD_APITOKEN)
                        //UserDefaults.standard.set(role, forKey: UD_role)
    
                    DEFAULTS.set(token, forKey: UD_APITOKEN)
                    self.controller.changeLoginState(newState: 1)
                    Util.makeHomeRootController()
                }
            }
            
//            if status{
//                let verifyOTP = storyboardVerifyOTP.instantiateViewController(withIdentifier: "VC_VerifyOTP") as! VC_VerifyOTP
//                verifyOTP.transitioningDelegate = self
//                verifyOTP.phoneNumber = phoneNumber
//                self.controller.navigationController?.pushViewController(verifyOTP, animated: true)
//            }else{
//
//                let message = data[key_message] as? String ?? serverError
//                self.controller.presentAlert(title: errorText, message: message)
//            }
            
        }) { (reason, statusCode) in
            self.controller.hideHud()
            self.buttonRegister.isEnabled = true
        }
        
    }
}

