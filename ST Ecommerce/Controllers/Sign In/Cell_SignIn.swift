//
//  Cell_SignIn.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import TKSubmitTransition
import PhoneNumberKit
import Alamofire


class Cell_SignIn: UITableViewCell, UIViewControllerTransitioningDelegate {
    
    //MARK: - IBOutlet
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBOutlet weak var buttonSignIn: TKTransitionSubmitButton!
    @IBOutlet weak var textFieldPhone: PhoneNumberTextField!
    @IBOutlet weak var pwdTF: PhoneNumberTextField!
    
    //MARK: - Variables
    var controller:VC_SignIn!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textFieldPhone.resignFirstResponder()
        pwdTF.resignFirstResponder()
        
        //self.configureTextFieldPhone()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)    }
    
    func configureTextFieldPhone(){
        
        if #available(iOS 11.0, *) {
            PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["IN"]
            textFieldPhone.withDefaultPickerUI = true
        }
        
        textFieldPhone.delegate = self
        
        //        textFieldPhone.withFlag = true
        //        textFieldPhone.withExamplePlaceholder = true
        //        textFieldPhone.withPrefix = true
        //pwdTF.isSecureTextEntry = true
    }
    
    //    func didStartYourLoading() {
    //        buttonSignIn.startLoadingAnimation()
    //    }
    
    //    @objc func didFinishYourLoading() {
    //
    //        buttonSignIn.startFinishAnimation(0) {
    //            let verifyOTP = storyboardVerifyOTP.instantiateViewController(withIdentifier: "VC_VerifyOTP")
    //            verifyOTP.transitioningDelegate = self
    //            self.controller.navigationController?.pushViewController(verifyOTP, animated: true)
    //        }
    //
    //    }
    
    //MARK: - Action Functions
    
    @IBAction func signUp(_ sender: UIButton) {
        
        Util.makeRegisterRootController()
        
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        
        if textFieldPhone.text == ""{
            
            self.controller.presentAlert(title: attentionText, message: enterPhoneNumberAlertText)
        }
        else if pwdTF.text == ""{
            self.controller.presentAlert(title: attentionText, message: enterPasswordAlertText)
        }else{
            let phoneNumberKit = PhoneNumberKit()
            
            do {
                //                let phoneNumber = try phoneNumberKit.parse(textFieldPhone.text ?? "")
                
                buttonSignIn.isEnabled = false
                self.signIn()
            }
            catch {
                self.controller.presentAlert(title: attentionText, message: enterValidPhoneNumberAlertText)
            }
        }
        
    }
    
    
    //MARK: - APi calls
    func signIn(){
        
        let param : [String:Any] = [
            "phone_number": textFieldPhone.text ?? "",
            "password": pwdTF.text ?? ""]
        
        self.controller.showHud(message: loadingText)
        
        
        APIUtils.APICall(postName: APIEndPoint.login.caseValue, method: .post, parameters: param, controller: self.controller, onSuccess: { (response) in
            print("login response = " , response)
            self.controller.hideHud()
            self.buttonSignIn.isEnabled = true
            let response = response as? [String:Any] ?? [:]
            let status = response["status"] as? Int
            let data = response["data"] as? [String:Any] ?? [:]
            
            if status == 200{
                if let token = data["token"] as? String{
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.dateFormat = "dMMyyyy"
                    let currentDateString = dateFormatter.string(from: date)
                    
                    UserDefaults.standard.set(currentDateString, forKey: UD_Token)
                    UserDefaults.standard.set(token, forKey: UD_APITOKEN)
                    //UserDefaults.standard.set(role, forKey: UD_role)
                    
                    self.controller.changeLoginState(newState: 1)
                    self.controller.writeToken(token: token)
                    Util.makeHomeRootController()
                }
            }
            
            else{
                
                let message = response[key_message] as? String ?? serverError
                self.controller.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode)  in
            self.controller.hideHud()
            self.buttonSignIn.isEnabled = true
        }
    }
}
extension Cell_SignIn : UITextFieldDelegate{
    
}
