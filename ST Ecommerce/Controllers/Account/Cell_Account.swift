//
//  Cell_Account.swift
//  ST Ecommerce
//
//  Created by necixy on 02/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit


class Cell_Account: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var imageViewPhoneVerified: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var labelPrimaryAddress: UILabel!
    @IBOutlet weak var labelPrimaryAddressName: UILabel!
    @IBOutlet weak var textPhoneNumber: UITextField!
    @IBOutlet weak var imageViewAddEditAddress: UIImageView!
    @IBOutlet weak var buttonAddEditAddress: UIButton!
    @IBOutlet weak var labelAddEditAddress: UILabel!
    
    @IBOutlet weak var textFieldDOB: UITextField!
    @IBOutlet weak var buttonEditProfile: UIImageView!
    
    @IBOutlet weak var btnGenderSelect: UIButton!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var textFieldGender: UITextField!
    @IBOutlet weak var imageViewPencil: UIImageView!
    
    @IBOutlet weak var imgGenderSelect: UIImageView!
    @IBOutlet weak var imgDot: UIImageView!
    @IBOutlet weak var btnImageSelect: UIButton!
    //MARK:- variables
    var controller:VC_Account!
    var isProfileEditing: Bool?
    
    //MARK:- Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureProfileView()
        self.configureView(status: false)
//        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTab(notification:)), name: Notification.Name("DidChangeTab"), object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
     func didChangeTab(notification: Notification) {
        configureView(status:  false)
        isProfileEditing = false
    }
    
    //MARK:- Helper Functions
    func configureProfileView(){
        
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.size.width/2
        imageViewProfile.clipsToBounds = true
        buttonAddEditAddress.layer.cornerRadius = 5
        
    }
    
    func configureView(status: Bool) {
        self.isProfileEditing = status
        textFieldName.isUserInteractionEnabled = status
        textPhoneNumber.isUserInteractionEnabled = false
        textFieldDOB.isUserInteractionEnabled = status
        textFieldGender.isUserInteractionEnabled = status
        btnGenderSelect.isUserInteractionEnabled = status
        imgGenderSelect.isHidden = !status
        btnImageSelect.isUserInteractionEnabled = status
        buttonAddEditAddress.isUserInteractionEnabled = !status
        if status  {
            buttonAddEditAddress.backgroundColor = .lightGray
            btnEditProfile.setTitle("Update Profile", for: .normal)
        } else {
            buttonAddEditAddress.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
            btnEditProfile.setTitle("Edit Profile", for: .normal)
        }
        
        
    }
    
    @IBAction func btnEditProfile(_ sender: UIButton) {
        if isProfileEditing == false {
            configureView(status: true)
            self.controller.abc = true
        } else {
            self.controller.updateProfile(image: imageViewProfile?.image, name: textFieldName.text ?? "", gender: textFieldGender.text ?? "", dob: textFieldDOB.text ?? "")
            self.controller.abc = false
        }
    }
    
    func setData(userProfile:Profile) {
        if let img = self.controller.profileImage{
            
            imageViewProfile.image = img
        }else{
//            let imagePath = userProfile.profilePic ?? ""
//            imageViewProfile.setIndicatorStyle(.gray)
//            imageViewProfile.setShowActivityIndicator(true)
//            imageViewProfile.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "Path 23")) { (image, error, type, url) in
//                self.imageViewProfile.setShowActivityIndicator(false)
//            }
        }
        textFieldName.text = userProfile.name ?? ""
        
        textPhoneNumber.text = "\(userProfile.phone_number ?? "")"
        
        
        
        labelPrimaryAddress.text = ""
        labelPrimaryAddressName.text = ""
        imgDot.isHidden = true
        
        if let address = self.controller.primaryAddress{
            imgDot.isHidden = false
            ///////labelPrimaryAddress.text = address.address1
            ///////labelPrimaryAddressName.text = address.title ?? ""
        }
        
        if self.controller.primaryAddress == nil {
            buttonAddEditAddress.setTitle("Add Address", for: .normal)
        }else {
            buttonAddEditAddress.setTitle("Change Address", for: .normal)
            
        }
        if let gender = self.controller.gender{
            self.textFieldGender.text = gender
        }else{
            self.textFieldGender.text = (userProfile.gender ?? "").capitalized
        }
        
        
        if let dob = self.controller.dob{
            textFieldDOB.text = dob
        }else{
            textFieldDOB.text = userProfile.date_of_birth ?? ""
        }
        
    }
    //MARK:- Action Methods
    @IBAction func addEditAddress(_ sender: UIButton) {
        
        
        if self.controller.primaryAddress == nil {
//            let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
//            //////vc.profileData = self.controller.userProfile
//            self.controller.navigationController?.pushViewController(vc, animated: true)
            self.controller.navigationController?.pushView(AddAddressRouter())
        }else{
            let vc : VC_User_Addresses = storyboardAddress.instantiateViewController(withIdentifier: "VC_User_Addresses") as! VC_User_Addresses
            vc.profileData = self.controller.userProfile
            vc.primaryAddress = self.controller.primaryAddress
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        Util.resetDefaults()
        Util.makeHomeRootController()
        if self.controller.readLogin() != 0 {
            self.controller.tableContainerView.isHidden = false
        }else{
            self.controller.tableContainerView.isHidden = true
            
        }
    }
    
    @IBAction func editProfile(_ sender: UIButton) {
        
        
        GalleryUtil.presentActionSheetImagePicker(viewController: self.controller)
    }
    
    @IBAction func dob(_ sender: UIButton) {
    }
    
    @IBAction func gender(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select your gender", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Male", style: .default , handler:{ (UIAlertAction)in
            self.controller.gender = maleText
            self.textFieldGender.text = maleText
        }))
        
        alert.addAction(UIAlertAction(title: "Female", style: .default , handler:{ (UIAlertAction)in
            self.controller.gender  = femaleText
            self.textFieldGender.text = femaleText
        }))
        
        alert.addAction(UIAlertAction(title: "Other", style: .default , handler:{ (UIAlertAction)in
            self.textFieldGender.text = "Other"
            self.controller.gender = "Other"
        }))
        self.controller.present(alert, animated: true, completion: {
        })
    }
    @IBAction func settings(_ sender: UIButton) {
        
        let vc : VC_Settings = storyboardSettings.instantiateViewController(withIdentifier: "VC_Settings") as! VC_Settings
        self.controller.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension Cell_Account{
    func configureDatePicker(){
        
        self.textFieldDOB.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //
    }
    @objc func tapDone() {
        if let datePicker = self.textFieldDOB.inputView as? UIDatePicker { // 2-1
            let dateformatter = DateFormatter() // 2-2
            dateformatter.dateStyle = .medium // 2-3
            dateformatter.dateFormat = "yyyy-MM-dd"
            self.textFieldDOB.text = dateformatter.string(from: datePicker.date) //2-4
            self.controller.dob = self.textFieldDOB.text
        }
        self.textFieldDOB.resignFirstResponder() // 2-5
    }
    
}

