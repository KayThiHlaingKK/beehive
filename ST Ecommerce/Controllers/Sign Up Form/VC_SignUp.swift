//
//  VC_SignUp.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 30/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class VC_SignUp: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    // MARK: - Properties
    private var isShow = false
    var phoneNumber: String?
    var otpCode: String?
    
    
    
    
    // MARK: - LifeCycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func radioButtonChecked(_ sender: UIButton) {
        let isShow = passwordTextField.isSecureTextEntry
        let img = isShow ? UIImage(named: "checked_radio_login") : UIImage(named: "unchecked_radio_login")
        img?.withRenderingMode(.alwaysOriginal)
        radioButton.setImage(img, for: .normal)
        passwordTextField.isSecureTextEntry = !isShow
        confirmPasswordTextField.isSecureTextEntry = !isShow
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        nextButton.isEnabled = false
        registerUser(completion: handleResponse(response:))
    }

    @IBAction func showPwdClicked(_ sender: UIButton) {
        let isShow = passwordTextField.isSecureTextEntry
        let img = isShow ? UIImage(named: "checked_radio_login") : UIImage(named: "unchecked_radio_login")
        img?.withRenderingMode(.alwaysOriginal)
        radioButton.setImage(img, for: .normal)
        passwordTextField.isSecureTextEntry = !isShow
        confirmPasswordTextField.isSecureTextEntry = !isShow
    }
    
    
    
    // MARK: - Validation and Request
    
    private func validateInputs() -> String? {
        if fullNameTextField.text!.count <= 0 {
            return fullNameEmptyAlertText
        } else if passwordTextField.text!.count <= 0 {
            return passwordEmptyAlertText
        } else if confirmPasswordTextField.text!.count <= 0 {
            return confirmPasswordEmptyAlertText
        } else if passwordTextField.text != confirmPasswordTextField.text {
            return passwordValidateAlertText
        } else {
            return nil
        }
    }
    
    
    private func registerUser(completion: @escaping (Any?) -> Void) {
       
        if let alertText = validateInputs() {
            presentAlert(title: "", message: alertText)
            nextButton.isEnabled = true
            completion(nil)
            return
        }

        guard let phone = phoneNumber,
              let otp = otpCode,
              let fullName = fullNameTextField.text,
              let password = passwordTextField.text,
              password == confirmPasswordTextField.text
        else {
            completion(nil)
            return
        }

        let param = [
            "name": fullName,
            "phone_number": phone,
            "password": password,
            "otp_code": otp,
            "gender": "Male"
        ]

        showHud(message: loadingText)

        APIUtils.APICall(postName: APIEndPoint.register.caseValue, method: .post, parameters: param, controller: self, onSuccess: { [weak self] response in
            print("sign up response = ", response)
            self?.hideHud()
            completion(response)
        }) { [weak self]  (reason, statusCode)  in
            self?.hideHud()
            completion(nil)
        }
    }
    
    private func handleResponse(response: Any?) {
        nextButton.isEnabled = true
        self.hideHud()
        
        guard let response = response else {
            return
        }

        let res = response as? [String:Any] ?? [:]
        let status = res["status"] as? Int
        let message = res["message"] as? String
        let data = res["data"] as? [String:Any] ?? [:]
        
        print("login response == ", response)
        
        if status == 200 {
            if let token = data["token"] as? String{
                print("token ===  " , token)
                self.writeToken(token: token)
            }
            self.changeLoginState(newState: 1)
            
            let successVC = storyboardSignIn.instantiateViewController(withIdentifier: "VC_ResetSuccess") as! VC_SuccessMessage
            successVC.titleText = "Successful!"
            successVC.messageText = "Congratulations, your Account has been successfully created."
            navigationController?.pushViewController(successVC, animated: true)
        } else {
//            let message = data["message"] as? String
            self.presentAlert(title: attentionText, message: message ?? "Internal Server Error")
        }
        
    }
}
