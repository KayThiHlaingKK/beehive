//
//  VC_PhoneNo.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 29/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import PhoneNumberKit

class VC_PhoneNo: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var agreeLbl: UILabel!
    
    
    
    // MARK: - Properties
    
    private var isRadioButtonChecked = false
    var isForgetPassword: Bool = false

    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showPwd))
        agreeLbl.addGestureRecognizer(tap)
        
        phoneNoTextField.addTarget(self, action: #selector(checkInputs), for: .editingChanged)
        disableRadioButton()
    }
    
    private func disableRadioButton() {
        nextButton.backgroundColor = UIColor(displayP3Red: 227/255, green: 224/255, blue: 224/255, alpha: 1)
        nextButton.isEnabled = false
    }
    
    private func enableButton() {
        nextButton.backgroundColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 0/255, alpha: 1)
        nextButton.isEnabled = true
    }
    
    @objc func showPwd(){
        changeRadio()
    }
    
    func changeRadio() {
        isRadioButtonChecked = !isRadioButtonChecked
        let img = isRadioButtonChecked ? UIImage(named: "checked_radio_login") : UIImage(named: "unchecked_radio_login")
        img?.withRenderingMode(.alwaysOriginal)
        radioButton.setImage(img, for: .normal)
        
        print("phone count = ", phoneNoTextField.text?.count)
        print("is radio = ", isRadioButtonChecked)
        if phoneNoTextField.text?.count ?? 0 > 0 && isRadioButtonChecked {
            enableButton()
        }
        else {
            disableRadioButton()
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func nextButtonPressed(_ sender: Any) {
        requestOtp()
    }
    
    @IBAction func toggleRadioButton(_ sender: Any) {
        changeRadio()
    }
    
    @objc private func checkInputs() {
    
//        guard phoneNoTextField.text?.count ?? 0 > 0,
//              isRadioButtonChecked
//        else {
//            disableRadioButton()
//            return
//        }
        if phoneNoTextField.text?.count ?? 0 > 0 && isRadioButtonChecked {
            enableButton()
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Request OTP
    
    private func requestOtp() {
        
        guard let phone = phoneNoTextField.text
        else { return }
        
        guard isRadioButtonChecked
        else {
            self.presentAlert(title: "", message: agreeTermsAndConditions)
            return
        }
        
        let param: [String: Any] = [ "phone_number": phone]
        
        showHud(message: loadingText)
        let endPoint = isForgetPassword ? APIEndPoint.forgot_password: APIEndPoint.send_OTP
        
        APIUtils.APICall(postName: endPoint.caseValue, method: .post, parameters: param, controller: self, onSuccess: { [unowned self] (response) in
            
            self.hideHud()
            let data = response as? [String:Any] ?? [:]
            let status = data["status"] as? Int
            
            if status == 200 {
                let otpVC = storyboardSignIn.instantiateViewController(withIdentifier: "VC_OTP") as! VC_OTP
                otpVC.phoneNumber = phoneNoTextField.text
                otpVC.isForgetPassword = self.isForgetPassword
                self.navigationController?.pushViewController(otpVC, animated: true)
                
                
            } else {
                let message = data["message"] as? String
                self.alert(title: attentionText, message: message ?? "Something went wrong.")
            }
            
        }) { (reason, statusCode)  in
            self.hideHud()
        }
    }
    
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default)
        
        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }
    
    
    
    
    // MARK: - Utility Functions
    
    private func validateInput() -> Bool {
        do {
            let phoneNumberKit = PhoneNumberKit()
            _ = try phoneNumberKit.parse(phoneNoTextField.text ?? "")
            if !isRadioButtonChecked {
                self.presentAlert(title: "", message: agreeTermsAndConditions)
            }
            
            return isRadioButtonChecked
        } catch {
            self.presentAlert(title: attentionText, message: enterValidPhoneNumberAlertText)
            return false
        }
        
    }
    
}
