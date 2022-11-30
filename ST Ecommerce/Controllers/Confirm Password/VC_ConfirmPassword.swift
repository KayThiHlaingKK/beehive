//
//  VC_ConfirmPassword.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 30/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class VC_ConfirmPassword: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var newPasswordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showPasswordLabel: UIView!
    @IBOutlet weak var radioButton: UIButton!
    
    private var isShowingPassword = false
    
    
    // MARK: - Properties
    
    var phoneNumber: String?
    var otpCode: String?
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRadioButtonGesture()
    }
    
   
    private func setupRadioButtonGesture() {
        [radioButton, showPasswordLabel].forEach {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(toggleShowPassword(_:)))
            $0?.addGestureRecognizer(gesture)
        }
    }
    
    
    @objc private func toggleShowPassword(_ tap: UITapGestureRecognizer) {
        isShowingPassword = !isShowingPassword
        
        let img = isShowingPassword ? UIImage(named: "checked_radio_login") : UIImage(named: "unchecked_radio_login")
        img?.withRenderingMode(.alwaysOriginal)
        radioButton.setImage(img, for: .normal)
        
        [newPasswordTextField, confirmPasswordTextField].forEach {
            $0.isSecureTextEntry = !isShowingPassword
        }
    }
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        nextButton.isEnabled = false
        resetPassword(completion: handleResponse(response:))
    }
    
    
    
    // MARK: - Network Request Functions
    
    private func resetPassword(completion: @escaping (Any?) -> Void) {
        hideHud()
        guard let phone = phoneNumber,
              let otp = otpCode,
              let password = newPasswordTextField.text,
              password == confirmPasswordTextField.text
        else {
            completion(nil)
            return
        }
        
        let param = [
            "phone_number": phone,
            "password": password,
            "otp_code": otp
        ]
        
        showHud(message: loadingText)
        
        APIUtils.APICall(postName: APIEndPoint.reset_password.caseValue, method: .post, parameters: param, controller: self, onSuccess: { response in
            completion(response)
        }) { (reason, statusCode)  in
            completion(nil)
        }
    }
    
    private func handleResponse(response: Any?) {
        nextButton.isEnabled = true
        hideHud()
        guard let response = response else {
            presentAlert(title: "", message: passwordValidateAlertText)
            return
        }

        let data = response as? [String:Any] ?? [:]
        let status = data["status"] as? Int
        
        if status == 200 {
            let successVC = storyboardSignIn.instantiateViewController(withIdentifier: "VC_ResetSuccess") as! VC_SuccessMessage
            navigationController?.pushViewController(successVC, animated: true)
        } else {
            let message = data["message"] as? String
            self.presentAlert(title: attentionText, message: message ?? "Internal Server Error")
        }
        
    }
    
}



