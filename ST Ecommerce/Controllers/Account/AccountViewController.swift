//
//  AccountViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 05/02/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import DropDown
import CropViewController

class AccountViewController: UIViewController {
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var phLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var favouriteLbl: UILabel!
    @IBOutlet weak var awardLbl: UILabel!
    @IBOutlet weak var promoLbl: UILabel!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var changeAddressBtn: UIButton!
    @IBOutlet weak var editProfileView: UIImageView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var primaryAddress : Address?
    var userProfile : Profile?
    var success: Bool = false
    let dropDown = DropDown()
    var edit = false
    var dob : String?
    var profileImage : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        refreshUI()
    }
    
    func refreshUI(){
        print("refresh !!" , readLogin())
        
        if readLogin() != 0 {
            self.loadUserProfile()
//            self.loadAddresses()
        }else{
            showNeedToLoginApp()
        }
    }
    override func viewDidLoad() {
        profileView.layer.cornerRadius = profileView.frame.size.width/2
        profileView.clipsToBounds = true
        
        nameTF.isEnabled = false
        dobTF.isEnabled = false
        cameraImageView.isHidden = true
        genderBtn.isHidden = true
        changeAddressBtn.isEnabled = false
        
        genderSetup()
        configureDatePicker()
        
        clickEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+100)

    }
    
    func clickEvent() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editProfileClicked(tapGestureRecognizer:)))
        editProfileView.isUserInteractionEnabled = true
        editProfileView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapPhoto = UITapGestureRecognizer(target: self, action: #selector(editImageClicked(tapGestureRecognizer:)))
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(tapPhoto)
        
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(logoutClicked(tapGestureRecognizer:)))
        logoutView.isUserInteractionEnabled = true
        logoutView.addGestureRecognizer(tapLogout)
        
//        let tapSetting = UITapGestureRecognizer(target: self, action: #selector(logoutClicked(tapGestureRecognizer:)))
//        settingView.isUserInteractionEnabled = true
//        settingView.addGestureRecognizer(tapSetting)
    }
    
    func nameFieldEditable() {
        let border = CALayer()
        let border_ = CALayer()
        let width = CGFloat(0.5)
        
        if edit {
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: nameTF.frame.size.height - width, width:  nameTF.frame.size.width - 10, height: nameTF.frame.size.height)
            border.borderWidth = width
            nameTF.layer.addSublayer(border)
            nameTF.layer.masksToBounds = true
            nameTF.isEnabled = true
            
            border_.frame = CGRect(x: 0, y: dobTF.frame.size.height - width, width:  dobTF.frame.size.width - 10, height: dobTF.frame.size.height)
            border_.borderWidth = width
            dobTF.layer.addSublayer(border_)
            dobTF.layer.masksToBounds = true
            dobTF.isEnabled = true
            
            editProfileView.image = #imageLiteral(resourceName: "diskette")
            
            changeAddressBtn.isEnabled = true
        }
        else {
            nameTF.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            //nameTF.isEnabled = false
            
            dobTF.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            dobTF.isEnabled = false
            
            editProfileView.image = #imageLiteral(resourceName: "edit")
        }
        
    }
    
    func genderSetup() {
        dropDown.anchorView = genderLbl
        dropDown.dataSource = ["Male", "Female"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            genderLbl.text = item
        }
    }
    
    @objc func editImageClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        GalleryUtil.presentActionSheetImagePicker(viewController: self)
    }
    
    @objc func settingClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
    }
    
    @objc func logoutClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.presentAlertWithTitle(title: "Are You Sure", message: logoutpromptText, options: noText, yesText) { (option) in
            
            switch(option) {
            case 1:
                self.logoutAPI()
            
            default:
                break
            }
        }
    }
    
    func logoutAPI(){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        APIUtils.APICall(postName: APIEndPoint.logout.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            print(data)
            let status = data.value(forKey: key_status) as? Int
            if status == 200{
                //Success from our server
                DEFAULTS.removeObject(forKey: keyPlayerId)
//                print("ppppp = " , UserDefaults.standard.string(forKey: UD_Popup))
                let temp = UserDefaults.standard.string(forKey: UD_Popup)
                Util.resetDefaults()
                UserDefaults.standard.set(temp, forKey: UD_Popup)
                Singleton.shareInstance.address = []
                //Util.makeHomeRootController()
                
                Util.makeSignInRootController()
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    @objc func editProfileClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        edit = !edit
        nameFieldEditable()
        if(edit){
            
            cameraImageView.isHidden = false
            genderBtn.isHidden = false
            changeAddressBtn.backgroundColor = UIColor.appDarkYelloColor()
        }
        else {
            
            cameraImageView.isHidden = true
            genderBtn.isHidden = true
            changeAddressBtn.backgroundColor = UIColor.appLightGrayColor()
            updateProfile(image: profileImage, name: nameTF.text ?? "", gender: genderLbl.text ?? "", dob: dobTF.text ?? "")
            
        }
    }
    
    @IBAction func changeGenderBtnClicked(_ sender: UIButton) {
        dropDown.show()
        
    }
    
    @IBAction func changeAddressBtnClicked(_ sender: UIButton) {
        if self.primaryAddress == nil {
            self.navigationController?.pushView(AddAddressRouter())
        }else{
            let vc : VC_User_Addresses = storyboardAddress.instantiateViewController(withIdentifier: "VC_User_Addresses") as! VC_User_Addresses
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func configureDatePicker(){
        
        self.dobTF.setInputViewDatePicker(target: self, selector: #selector(tapDone)) //
    }
    @objc func tapDone() {
        if let datePicker = self.dobTF.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "yyyy-MM-dd"
            self.dobTF.text = dateformatter.string(from: datePicker.date)
            dob = self.dobTF.text
        }
        self.dobTF.resignFirstResponder()
    }
    
    
    //MARK: - API Calling Methods
    func loadUserProfile(){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        print(BASEURL)
        print(APIEndPoint.userProfile.caseValue)
        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            if status == 200{
                //Success from our server
                if let profile = data.value(forKeyPath: "data") as? NSDictionary{
                    print("profile == ", profile)
                    
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                        
                        self.userProfile = anyData as? Profile ?? nil
                        Singleton.shareInstance.userProfile = self.userProfile
                        
                        self.setData(userProfile:self.userProfile!)
                        
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (option) in
                    
                    switch(option) {
                    case 0:
                        print("Okay tapped")
                        break
                    default:
                        break
                    }
                }
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func updateProfile(image:UIImage?,name:String, gender:String, dob:String){
        
        let param : [String:Any] = [
                                    "email": "",
                                        "name": name,
                                        "gender": gender,
                                        "date_of_birth": dob]
        print("update param \(param)")
        
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .put,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let profile = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                        
                        self.userProfile = anyData as? Profile ?? nil
                        
                        self.setData(userProfile:self.userProfile!)
                        self.nameTF.isEnabled = false
                        Singleton.shareInstance.userProfile = self.userProfile
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (option) in
                    
                    switch(option) {
                    case 0:
                        print("Okay tapped")
                        break
                    default:
                        break
                    }
                }
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    func setData(userProfile:Profile) {
        print("setData")
        profileView.setIndicatorStyle(.gray)
        profileView.setShowActivityIndicator(true)
        

        print("userProfile = " , userProfile)
        self.nameTF.text = "\(userProfile.name ?? "")"
        
        self.phLbl.text = "\(userProfile.phone_number ?? "")"
        
        let addressCount: Int = userProfile.addresses?.count ?? 0
        print("address count == " , addressCount)
        if addressCount > 1 {
        for i in 0..<addressCount {
            
            let address = userProfile.addresses?[i]
//            print("address == " , address)
            let isPrimary = address?.is_primary ?? false
            if isPrimary {
                print("primary !!!")
                self.addressLbl.text = "\(address?.house_number ?? "") \(address?.street_name ?? "") \(address?.township?.name ?? "")"
                self.primaryAddress = address
            }
            
        }
    }
        else if addressCount == 1 {
            
            let address = userProfile.addresses?[0]
            self.addressLbl.text = "\(address?.house_number ?? "") \(address?.street_name ?? "") \(address?.township?.name ?? "")"
            self.primaryAddress = address
        }
  
        if let gender = userProfile.gender{
            if gender != "" || gender != nil {
                self.genderLbl.text = gender
            }else {
                self.genderLbl.text = "Male"
            }
        }else{
            self.genderLbl.text = (userProfile.gender ?? "Male")
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-dd-MM"
        formatter.calendar = Calendar(identifier: .gregorian)
        let currentDate = formatter.string(from: date)
        
        if let dob = userProfile.date_of_birth{
            if dob != "" {
                self.dobTF.text = dob
            }else {
                self.dobTF.text = currentDate
            }
        }else{
            self.dobTF.text = userProfile.date_of_birth ?? currentDate
        }
    }
    
}
extension AccountViewController: UIScrollViewDelegate{
}

extension AccountViewController: CropViewControllerDelegate{
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        var cropedImage = image
        let imageSizeMB = GalleryUtil.calculateSizeInMB(image: cropedImage)
        if imageSizeMB >= imageMinLimitNotToCompress {
            cropedImage = cropedImage.resized(withPercentage: imageCompressionPercent)!
        }
        self.profileImage = cropedImage
        self.profileView.image = self.profileImage
        print("crop!")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        image = image.upOrientationImage()!
        
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.presentCropViewController(image: image)
            }
            
        }
    }
    
    func presentCropViewController(image:UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: image)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
}


