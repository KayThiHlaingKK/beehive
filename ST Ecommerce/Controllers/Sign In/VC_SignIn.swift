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


class VC_SignIn: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonSignIn: TKTransitionSubmitButton!
    @IBOutlet weak var phoneNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var radioButton: UIButton!
    
    //MARK: - Properties
    var controller:VC_SignIn!
    let hud = JGProgressHUD(style: .dark)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        textFieldPhone.resignFirstResponder()
//        pwdTF.resignFirstResponder()
        
        self.configureTextFieldPhone()
    }
    
    
    func configureTextFieldPhone(){
        
//        if #available(iOS 11.0, *) {
//            PhoneNumberKit.CountryCodePicker.commonCountryCodes = ["IN"]
//            textFieldPhone.withDefaultPickerUI = true
//        }
        
//        textFieldPhone.delegate = self
        
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
    @IBAction func toggleShowPassword(_ sender: UIButton) {
        let isShow = passwordTextField.isSecureTextEntry
        let img = isShow ? UIImage(named: "checked_radio_login") : UIImage(named: "unchecked_radio_login")
        img?.withRenderingMode(.alwaysOriginal)
        radioButton.setImage(img, for: .normal)
        passwordTextField.isSecureTextEntry = !isShow
    }
    
    @IBAction func signUp(_ sender: UIButton) {
//        Util.makeRegisterRootController()
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        
        if phoneNoTextField.text == ""{
            self.presentAlert(title: attentionText, message: enterPhoneNumberAlertText)
        } else if passwordTextField.text == ""{
            self.presentAlert(title: attentionText, message: enterPasswordAlertText)
        } else {
            let phoneNumberKit = PhoneNumberKit()
            
            do {
                let phoneNumber = try phoneNumberKit.parse(phoneNoTextField.text ?? "")
                
                buttonSignIn.isEnabled = false
                self.signIn()
            }
            catch {
                self.presentAlert(title: attentionText, message: enterValidPhoneNumberAlertText)
            }
        }
        
    }
    
    
    //MARK: - APi calls
    func signIn(){
        
        let param : [String:Any] = [
            "phone_number": phoneNoTextField.text ?? "",
            "password": passwordTextField.text ?? ""]
        
        showHud(message: loadingText)
        
        APIUtils.APICall(postName: APIEndPoint.login.caseValue, method: .post, parameters: param, controller: self, onSuccess: { (response) in
            print("login response = " , response)
            
            self.hideHud()
            self.buttonSignIn.isEnabled = true
            let response = response as? [String:Any] ?? [:]
            let status = response["status"] as? Int
            let data = response["data"] as? [String:Any] ?? [:]
            
            if status == 200{
                if let token = data["token"] as? String {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.dateFormat = "dMMyyyy"
                    let currentDateString = dateFormatter.string(from: date)
                    
                    UserDefaults.standard.set(currentDateString, forKey: UD_Token)
                    UserDefaults.standard.set(token, forKey: UD_APITOKEN)
                    //UserDefaults.standard.set(role, forKey: UD_role)
                    
                    self.changeLoginState(newState: 1)
                    self.writeToken(token: token)
                    Util.makeHomeRootController()
                }
            }
            else {
                self.hideHud()
                let message = response[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
            //                        let verifyOTP = storyboardVerifyOTP.instantiateViewController(withIdentifier: "VC_VerifyOTP") as! VC_VerifyOTP
            //                        verifyOTP.phoneNumber = phoneNumber
            //                        verifyOTP.transitioningDelegate = self
            //                        self.controller.navigationController?.pushViewController(verifyOTP, animated: true)
            
            
        }) { (reason, statusCode)  in
            self.hideHud()
            self.buttonSignIn.isEnabled = true
        }
    }
    
    
    
    //MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
    }
    
   
    // MARK: - IBActions
    
    @IBAction func btnBack(_ sender: Any) {
        
        Util.makeHomeRootController()
    }
    
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let phoneNoVC = segue.destination as! VC_PhoneNo
        phoneNoVC.isForgetPassword = segue.identifier == "forgetPassword"
    }
}

/*

 
 
 class VC_SignIn: UIViewController {
     
     //MARK: - IBOutlets
 //    @IBOutlet weak var tableViewSignIn: UITableView!
     @IBOutlet weak var bottomConstraintTableContainerView: NSLayoutConstraint!
     
     @IBOutlet weak var btnBack: UIButton!
     
     
     let hud = JGProgressHUD(style: .dark)
     
     //MARK: - Internal Functions
     override func viewDidLoad() {
         super.viewDidLoad()
         
         tableViewSetUp()
         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
         
         //        makeCommetAndAnimate()
         
         bottomConstraintTableContainerView.constant = 44
         if DeviceUtils.isDeviceIphoneXOrlatter(){
             bottomConstraintTableContainerView.constant = 90
         }
         
         btnBack.layer.cornerRadius = btnBack.frame.width / 2
     }
     
     //MARK: - Private functions
     fileprivate func tableViewSetUp(){
         
         tableViewSignIn.delegate = self
         tableViewSignIn.dataSource = self
     }
    
     //  MARK: - Helping Function
     
     @IBAction func btnBack(_ sender: Any) {
         
         Util.makeHomeRootController()
     }
 }

 //MARK: - UITableViewDelegate and UITableViewDataSource Functions
 extension VC_SignIn : UITableViewDelegate, UITableViewDataSource{
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_SignIn") as! Cell_SignIn
         
         cell.controller = self
         cell.selectionStyle = .none
         
         return cell
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableView.automaticDimension
     }
     
 }
 
 
 
 */





