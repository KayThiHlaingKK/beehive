//
//  VC_AccountInformation.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 12/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit
import AlgoliaSearchClient

class VC_AccountInformation: UIViewController {
    
    @IBOutlet weak var overlayBlurView: UIVisualEffectView!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var maleRadioButton: UIButton!
    @IBOutlet weak var femaleRadioButton: UIButton!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var overlayView: UIView!
    
    private var selectedGender: Gender?
    private var userProfile: UserProfileData?
    private var updateProfileRequest: UpdateUserProfile?
    private var dateOfBirth = ""
    
    private enum Gender: String {
        case male, female
    }
    
    // MARK: View LifeCycyle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareForUI()
        userProfileAPICall()
    }
    
    // MARK: UI Setup
    private func prepareForUI() {
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        
        dateTextField.isEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        dateTextField.addGestureRecognizer(tapGesture)
        datePicker.maximumDate = Date()
        datePicker.calendar = Calendar(identifier: .gregorian)
    }
    
    // MARK: UIBindWith Data
    private func updateUIWithData() {
        guard let userProfile = userProfile else {
            return
        }

        nameTextField.text = userProfile.name
        emailTextField.text = userProfile.email
        phoneTextField.text = userProfile.phoneNumber
        if let dob = userProfile.dateOfBirth {
            dateOfBirthTextField.text = dob.convertDateStringFormat(from: "yyyy-M-d", to: "d / MMM / yyyy")
            dateLabel.text = dob.convertDateStringFormat(from: "yyyy-M-d", to: "MMM d, yyyy")
            if let date = convertStringToDate(dob, from: "yyyy-M-d") {
                datePicker.calendar = Calendar(identifier: .gregorian)
                datePicker.date = date
            }
        }
        
        if let gender = userProfile.gender {
            let tag = gender == Gender.male.rawValue.capitalized ? 0: 1
            selectedGender = gender == Gender.male.rawValue.capitalized ? .male : .female
            updateRadioButtons(tag: tag)
        }
    }
    
    // MARK: Show Datepicker
    @objc private func showDatePicker() {
        [nameTextField, phoneTextField, emailTextField, dateTextField].forEach { $0?.resignFirstResponder() }
//        self.overlayBlurView.isHidden = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [unowned self] in
//            self.overlayBlurView.effect = UIBlurEffect(style: .regular)
            self.overlayView.isHidden = false
        } completion: { [unowned self] success in
            self.datePickerView.alpha = 1
        }

    }
    
    // MARK: IBAction
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        self.datePickerView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [ unowned self ] in
        } completion: { [unowned self] success in
            self.overlayView.isHidden = true
            datePicker.calendar = Calendar(identifier: .gregorian)
            let stringDate = self.convertDateToString(date: datePicker.date, format: "d / MMM / yyyy")
            self.dateTextField.text = stringDate
            self.dateLabel.text = self.convertDateToString(date: datePicker.date, format: "MMM d, yyyy")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.datePickerView.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { [ unowned self ] in
        } completion: { [unowned self] success in
            self.overlayView.isHidden = true
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        updateProfileAPICall()
    }
    
    @IBAction func selectRadio(_ sender: UIButton) {
        selectedGender = sender.tag == 0 ? .male : .female
        updateRadioButtons(tag: sender.tag)
    }
    
    private func updateRadioButtons(tag: Int?) {
        guard let tag = tag else {
            return
        }

        let checkedImage = UIImage(named: "checked_radio_login")
        let uncheckedImage = UIImage(named: "unchecked_radio_login")
        
        [maleRadioButton, femaleRadioButton].forEach {
            let img = $0?.tag == tag ? checkedImage : uncheckedImage
            img?.withRenderingMode(.alwaysOriginal)
            $0?.setImage(img, for: .normal)
        }
    }
}


// MARK: APICall
extension VC_AccountInformation {
    
    fileprivate func userProfileAPICall() {
        showHud(message: "")
        APIClient.fetchUserProfile().execute { data in
            if data.status == 200 {
                DispatchQueue.main.async { [unowned self] in
                    self.userProfile = data.data
                    self.updateUIWithData()
                    self.hideHud()
                }
            }else{
                let message = data.message ?? ""
                self.presentAlert(title: errorText, message: message)
            }
        } onFailure: { error in
            self.hideHud()
            self.presentAlert(title: "", message: error.localizedDescription)
        }
    }
    
    fileprivate func updateProfileAPICall() {
        showHud(message: "")
        if let dob = dateOfBirthTextField.text, dob != "" {
            dateOfBirth = dob.convertDateStringFormat(from: "d / MMM / yyyy", to: "yyyy-MM-dd")
        }
        APIClient.fetchUpdateUserProfile(request: UpdateUserProfile(email: emailTextField.text ?? "", name: nameTextField.text ?? "", gender: selectedGender?.rawValue.capitalized ?? "", date_of_birth: dateOfBirth, image_slug: "")).execute { data in
            if data.status == 200 {
                self.handleSucessUpdate(message: data.message ?? "")
            }else{
                self.userProfileAPICall()
                self.presentAlert(title: "", message: data.message ?? "")
            }
            self.hideHud()
        } onFailure: { error in
            self.hideHud()
            self.presentAlert(title: errorText, message: error.localizedDescription)
        }

    }
    
    fileprivate func handleSucessUpdate(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: okayText, style: .cancel) { [unowned self] action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }
}


