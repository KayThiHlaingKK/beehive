//
//  VC_SignIn.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Comets
import JGProgressHUD
import TKSubmitTransition
import PhoneNumberKit
import Alamofire


class VC_Login: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonSignIn: TKTransitionSubmitButton!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var showPasswordLbl: UILabel!
    
    @IBOutlet weak var stackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var myanmarCountryCode: RoundedView!
    
    
    //MARK: - Properties
    var controller:VC_Login!
    private var isChoosingCountryCode = false
    let hud = JGProgressHUD(style: .dark)
    
    
    //MARK: - LifeCycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        setupKeyboardObservers()
        setupDismiss()
    }
    
    override func viewDidLayoutSubviews() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showPwd))
        showPasswordLbl.addGestureRecognizer(tap)
        
    }
    
   
    // MARK: - Keyboard Observer Functions
    fileprivate func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide(sender:)), name:UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        if stackViewTopConstraint.constant == 0 {
            stackViewTopConstraint.constant -= 80
            stackViewBottomConstraint.constant += 80
        }
    }

    @objc private func keyboardWillHide(sender: NSNotification) {
        stackViewTopConstraint.constant = 0
        stackViewBottomConstraint.constant = 0
    }
    
    // MARK: DismissCountryCode
    fileprivate func setupDismiss() {
        let views: [UIView] = [fadeView, myanmarCountryCode]
        views.forEach {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissCountryCodeView))
            $0.addGestureRecognizer(gesture)
        }
    }
    
    @objc private func dismissCountryCodeView() {
        toggleCountryCode()
    }
    
    
    // MARK: ShowPassword Tap
    @objc func showPwd(){
        let isShow = passwordTextField.isSecureTextEntry
        let img = isShow ? UIImage(named: "checked_radio_login") : UIImage(named: "unchecked_radio_login")
        img?.withRenderingMode(.alwaysOriginal)
        radioButton.setImage(img, for: .normal)
        passwordTextField.isSecureTextEntry = !isShow
    }

    // MARK: Toggle CountryCode
    fileprivate func toggleCountryCode() {
        if isChoosingCountryCode == false {
            fadeView.isHidden = false
            countryCodeView.isHidden = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) { [unowned self] in
            fadeView.alpha = self.isChoosingCountryCode ? 0: 1
            countryCodeView.alpha = self.isChoosingCountryCode ? 0: 1
        } completion: { [unowned self] success in
            if self.isChoosingCountryCode {
                self.fadeView.isHidden = true
                self.countryCodeView.isHidden = true
            }
            
            self.isChoosingCountryCode = !self.isChoosingCountryCode
        }
    }
    
    // MARK: Segue To PhoneNoView as ForgetPassword
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let phoneNoVC = segue.destination as! VC_PhoneNo
        phoneNoVC.isForgetPassword = segue.identifier == "forgetPassword"
    }
    
    // MARK: - IBActions
    @IBAction func toggleShowPassword(_ sender: UIButton) {
        let isShow = passwordTextField.isSecureTextEntry
        let img = isShow ? UIImage(named: "checked_radio_login") : UIImage(named: "unchecked_radio_login")
        img?.withRenderingMode(.alwaysOriginal)
        radioButton.setImage(img, for: .normal)
        passwordTextField.isSecureTextEntry = !isShow
    }
    
   
    @IBAction func login(_ sender: UIButton) {
        
        if phoneNoTextField.text == ""{
            self.presentAlert(title: attentionText, message: enterPhoneNumberAlertText)
        } else if passwordTextField.text == ""{
            self.presentAlert(title: attentionText, message: enterPasswordAlertText)
        } else {
            buttonSignIn.isEnabled = false
            showHud(message: "")
            LoginAPICall {
                self.hideHud()
            }

        }
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        Util.makeHomeRootController()
    }
    
    @IBAction func onCountryCodeButtonPressed(_ sender: UIButton) {
        toggleCountryCode()
    }
    
}

// MARK: Login APICall
extension VC_Login {
    
    fileprivate func LoginAPICall(completion: @escaping () -> Void) {
        APIClient.fetchLogin(request: LoginAuthentication(phoneNumber: phoneNoTextField.text ?? "", password: passwordTextField.text ?? "")).execute { data in
            if data.status == 200 {
                self.buttonSignIn.isEnabled = true
                if let token = data.data?.token {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.dateFormat = "dMMyyyy"
                    let currentDateString = dateFormatter.string(from: date)
                    
                    UserDefaults.standard.set(currentDateString, forKey: UD_Token)
                    UserDefaults.standard.set(token, forKey: UD_APITOKEN)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loginNoti"), object: nil)
                    
                    self.writeToken(token: token)
                    self.changeLoginState(newState: 1)
                    Util.navigateToHomeRootController(toastMessage: "Login Success")
                }
                completion()
            }else{
                if let message = data.message {
                    self.presentAlert(title: errorText, message: message)
                }
                self.buttonSignIn.isEnabled = true
                completion()
            }
            completion()
        } onFailure: { error in
            self.presentAlert(title: errorText, message: error.localizedDescription)
            completion()
        }

    }
    
}



