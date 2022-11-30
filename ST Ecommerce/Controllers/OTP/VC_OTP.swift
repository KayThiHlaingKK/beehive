//
//  VC_OTP.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 29/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class VC_OTP: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    
    
    // MARK: - Properties
    
    var phoneNumber: String?
    var isForgetPassword: Bool = false
    private var timer: Timer?
    private var timerTime = 60
    
    
    
    // MARK: - LifeCycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resendButton.setTitle("60s", for: .normal)
        resendButton.setTitleColor(UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1), for: .disabled)
        captionLabel.text = "Enter 6-digit code sent to \(phoneNumber!)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpTextField.becomeFirstResponder()
        requestOtp()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendButtonPressed(_ sender: Any) {
        requestOtp()
        setResendButtonTimer()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        validateOtp()
    }
    
    
    
    // MARK: - Navigation Functions
    
    private func validateOtp() {
        guard let otp = otpTextField.text,
              otp.count == 6
        else {
            presentAlert(title: incorrectOtpTitle, message: incorrectOtpMessage)
            return
        }
        
        checkOTP()
    }
    
    private func checkOTP() {
        guard let phone = phoneNumber else { return }
        guard let otp = otpTextField.text else { return }
        let param: [String: Any] = [ "phone_number": phone, "otp_code": otp]
        
        showHud(message: loadingText)
        let endPoint = APIEndPoint.check_OTP
        
        APIUtils.APICall(postName: endPoint.caseValue, method: .post, parameters: param, controller: self, onSuccess: { [unowned self] (response) in
            
            self.hideHud()
            let data = response as? [String:Any] ?? [:]
            let status = data["status"] as? Int
            print(response)
            if status == 406 {
                let message = data["message"] as? String
                self.alert(title: attentionText, message: message ?? "Something went wrong.")
            }
            else {
                isForgetPassword ? goToConfirmPassword(): goToSignUpForm()
            }
            
        }) { (reason, statusCode)  in
            self.hideHud()
        }
    }
   
    private func goToConfirmPassword() {
        let confirmPasswordVC = storyboardSignIn.instantiateViewController(withIdentifier: "VC_ConfirmPassword") as! VC_ConfirmPassword
        confirmPasswordVC.phoneNumber = self.phoneNumber
        confirmPasswordVC.otpCode = otpTextField.text
        navigationController?.pushViewController(confirmPasswordVC, animated: true)
    }
    
    private func goToSignUpForm() {
        let signUpVC = storyboardSignIn.instantiateViewController(withIdentifier: "VC_SignUp") as! VC_SignUp
        signUpVC.phoneNumber = self.phoneNumber
        signUpVC.otpCode = otpTextField.text
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    
    
    // MARK: - Request OTP
    
    private func requestOtp() {
        guard let phone = phoneNumber else { return }
        let param: [String: Any] = [ "phone_number": phone]
        
        showHud(message: loadingText)
        let endPoint = isForgetPassword ? APIEndPoint.forgot_password: APIEndPoint.send_OTP
        
        APIUtils.APICall(postName: endPoint.caseValue, method: .post, parameters: param, controller: self, onSuccess: { [unowned self] (response) in
            
            self.hideHud()
            let data = response as? [String:Any] ?? [:]
            let status = data["status"] as? Int
            
            if status == 422 {
                let message = data["message"] as? String
                self.alert(title: attentionText, message: message ?? "Something went wrong.")
            }
            
            self.setResendButtonTimer()
        }) { (reason, statusCode)  in
            self.hideHud()
        }
    }
    
    
    private func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { [unowned self] _ in
            self.dismiss(animated: false) {
//                self.navigationController?.popViewController(animated: true)
            }
        }
        
        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }
    
    
    
    
    // MARK: - Timer and Resend Button Functions
    
    private func setResendButtonTimer() {
        timer?.invalidate()
        timer = nil
        timerTime = 60
        checkResendOtp()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkResendOtp), userInfo: nil, repeats: true)
    }
    
    @objc private func checkResendOtp() {
        if timerTime != 0 {
            disableResendButton()
            return
        }
        enableResendButton()
    }
    
    
    private func disableResendButton() {
        let text = timerTime != 0 ? "\(timerTime)s" : "Resend new code"
        resendButton.setTitle(text, for: .normal)
        resendButton.isEnabled = false
        timerTime -= 1
    }
    
    private func enableResendButton() {
        timer?.invalidate()
        timer = nil
        resendButton.setTitle("Resend new code", for: .normal)
        resendButton.isEnabled = true
    }
    
    
    
    
}
