//
//  Cell_VerifyOTP.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import SVPinView
import TKSubmitTransition
import PhoneNumberKit
import MapKit

class Cell_VerifyOTP: UITableViewCell {
    
    @IBOutlet weak var buttonVerify: UIButton!
    
    
    //MARK: - Variables
    var controller:VC_VerifyOTP!
    var profileData : ProfileData?
    var sing = Singleton.shareInstance
    
    
    
    @IBOutlet weak var textFieldMobileNo: PhoneNumberTextField!
    
    @IBOutlet weak var pinView: SVPinView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configurePinView()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    //MARK: - Private Functions
    private func configurePinView() {
        
        pinView.style = .box
        pinView.shouldSecureText = false
        pinView.font = UIFont.boldSystemFont(ofSize: 20)
        pinView.keyboardType = .numberPad
        pinView.isContentTypeOneTimeCode = true
        
        pinView.borderLineColor = UIColor.lightGray
        pinView.activeBorderLineColor = UIColor.lightGray
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 1
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { pin in
        }
    }
    
    func didFinishEnteringPin(pin:String) {
        if pin.count == 6{
            self.verify(phoneNumber: self.controller.phoneNumber)
        }
    }
    
    func prefillMobileNo(){
        self.textFieldMobileNo.text = "\(self.controller.phoneNumber.nationalNumber)"
    }
    
    
    //MARK: - Action Function
    @IBAction func back(_ sender: UIButton) {
        controller.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        Util.makeRegisterRootController()
    }
    
    @IBAction func verify(_ sender: UIButton) {
        
        if pinView.getPin().count != 6{
            self.controller.presentAlert(title: attentionText, message: enterOTPAlertText)
        }else{
            self.verify(phoneNumber: self.controller.phoneNumber)
        }
        
    }
    
    //MARK: - APi calls
    func verify(phoneNumber:PhoneNumber){
        
//        if let userID = OneSignal.getPermissionSubscriptionState()?.subscriptionStatus.userId as? String {
//            if  userID != nil  || userID != ""  {
//                DEFAULTS.setValue(userID, forKey: keyPlayerId)
//            }
//        }
//
//        let number = "\(phoneNumber.nationalNumber)".replacingOccurrences(of: " ", with: "")
//        let playerId = DEFAULTS.value(forKey: keyPlayerId) ?? ""
//        let deviceId = UIDevice.current.identifierForVendor?.uuidString
//            let param : [String:Any] = ["country_code":phoneNumber.countryCode,
//                                        "phone":number,
//                                        "otp":pinView.getPin(),
//                                        "player_id":playerId,
//                                        "device_id":deviceId]
//
//
//
//        print("param \(param)")
//        self.controller.showHud(message: loadingText)
//
//        APIUtils.APICall(postName: APIEndPoint.verify_OTP.caseValue, method: .post, parameters: param, controller: self.controller, onSuccess: { (response) in
//
//            self.controller.hideHud()
//            let data = response as! NSDictionary
//            let status = data[key_status] as? Bool ?? false
//
//            if status{
//
//                if let role = data.value(forKeyPath: "data.role") as? String, let token = data.value(forKey: "auth_token") as? String{
//                    UserDefaults.standard.set(token, forKey: UD_APITOKEN)
//                    UserDefaults.standard.set(role, forKey: UD_role)
//
//                    DEFAULTS.set(true, forKey: UD_isUserLogin)
//                    Util.makeHomeRootController()
//
//                }else{
//                }
//            }else{
//
//                let message = data[key_message] as? String ?? serverError
//                self.controller.presentAlert(title: errorText, message: message)
//            }
//        }) { (reason, statusCode) in
//            self.controller.hideHud()
//            self.buttonVerify.isEnabled = true
//        }
    }
    
    func addAddress(phoneNumber:PhoneNumber, profile:ProfileData){
        
        let number = "\(phoneNumber.nationalNumber)".replacingOccurrences(of: " ", with: "")
        
        let param : [String:Any] = ["address_1":sing.currentAddress,
                                    "address_2":sing.streetNumber,
                                    "city":sing.city,
                                    "state":sing.state,
                                    "country":sing.country,
                                    "zipcode":sing.zip,
                                    "latitude":Singleton.shareInstance.userCurrentCoordinates.latitude,
                                    "longitude":Singleton.shareInstance.userCurrentCoordinates.longitude,
                                    "is_primary":"1",
                                    "phone":number,
                                    "country_code":phoneNumber.countryCode,
                                    "contact_person":profile.name ?? ""]
        self.controller.showHud(message: loadingText)
        
        APIUtils.APICall(postName: APIEndPoint.Address.caseValue, method: .post, parameters: param, controller: self.controller, onSuccess: { (response) in
            
            self.controller.hideHud()
            self.buttonVerify.isEnabled = true
            let data = response as! NSDictionary
            let status = data[key_status] as? Bool ?? false
            
            if status{
                
                let address = data.value(forKeyPath: "data.address") as? NSDictionary ?? [:]
                
                APIUtils.prepareModalFromData(address, apiName: APIEndPoint.Address.caseValue, modelName: "Address", onSuccess: { (addressModel) in
//                    self.sing.userAddress = addressModel as? Address_ ?? nil
//                    if let userAddressId = self.sing.userAddress?.id, let formattedAddress = self.sing.userAddress?.address1{
//                        DEFAULTS.set(userAddressId, forKey: UD_Address_Id)
//                        DEFAULTS.set(formattedAddress, forKey: UD_Formatted_User_Address)
//                        Util.makeHomeRootController()
//                    }
                    
                }) { (error, reason) in
                    print("error \(String(describing: error)), reason \(reason)")
                }
            }else{
                
                let message = data[key_message] as? String ?? serverError
                self.controller.presentAlert(title: errorText, message: message)
            }
        }) { (reason, statusCode) in
            self.controller.hideHud()
            self.buttonVerify.isEnabled = true
        }
    }
}
