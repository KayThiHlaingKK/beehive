//
//  VC_ChangePassword.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 14/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_ChangePassword: UIViewController {

    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var showPasswordRadioButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var passwordShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareUI()
    }
    
    private func prepareUI() {
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        disableSaveButton()
        [oldPasswordTextField, newPasswordTextField, confirmPasswordTextField].forEach {
            $0?.addTarget(self, action: #selector(checkTextFields), for: .editingChanged)
        }
    }
    
    @objc private func checkTextFields() {
        guard let oldPassword = oldPasswordTextField.text,
              oldPassword.count > 0,
              let newPassword = newPasswordTextField.text,
              newPassword.count > 0,
              let confirmPassword = confirmPasswordTextField.text,
              confirmPassword.count > 0
        else {
            disableSaveButton()
            return
        }
        
        saveButton.backgroundColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 0/255, alpha: 1)
        saveButton.isEnabled = true
    }
    
    private func disableSaveButton() {
        saveButton.backgroundColor = UIColor(displayP3Red: 227/255, green: 224/255, blue: 224/255, alpha: 1)
        saveButton.isEnabled = false
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func togglePassword(_ sender: UIButton) {
        passwordShown = !passwordShown
        let imgName = passwordShown ? "checked_radio_login": "unchecked_radio_login"
        showPasswordRadioButton.setImage(UIImage(named: imgName), for: .normal)
        [oldPasswordTextField, newPasswordTextField, confirmPasswordTextField].forEach {
            $0?.isSecureTextEntry = !passwordShown
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let oldPassword = oldPasswordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              let newPassword = newPasswordTextField.text
        else { return }
        
        if confirmPassword != newPassword {
            presentAlert(title: "", message: "New password and confirm password do not match.")
            return
        }
        updatePassword(oldPassword: oldPassword, newPassword: newPassword)
    }
    
    private func updatePassword(oldPassword: String, newPassword: String) {
        let params = [
            "old_password": oldPassword,
            "new_password": newPassword,
        ]
        
        APIUtils.APICall(postName: APIEndPoint.change_password.caseValue, method: .patch, parameters: params, controller: self) { response in
            
            let data = response as? [String:Any] ?? [:]
            let status = data["status"] as? Int
            
            DispatchQueue.main.async { [unowned self] in
                if status == 200 {
                    self.handleSuccess()
                } else {
                    let message = data["message"] as? String
                    presentAlert(title: "Fail", message: message ?? "Something went wrong!")
                }
            }
        } onFailure: { reason, statusCode in
            
        }

        
    }
    
    private func handleSuccess() {
        [oldPasswordTextField, newPasswordTextField, confirmPasswordTextField].forEach {
            $0?.resignFirstResponder()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            self.showToast(message: "Change Success!", font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
