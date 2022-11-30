//
//  VC_Account.swift
//  ST Ecommerce
//
//  Created by necixy on 02/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import CropViewController


class VC_Account: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewAccount: UITableView!
    @IBOutlet weak var bottomConstraintTableContainerView: NSLayoutConstraint!
    
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableContainerView: GradientView!
    @IBOutlet weak var viewUserNeedToLoginPopUp: UIView!
    
    //MARK: - Varibles
    let hud = JGProgressHUD(style: .dark)
    var userProfile : Profile?
//    var addresses : [Address] = [Address]()
    var primaryAddress : Address?
    var profileImage : UIImage?
    var gender : String?
    var dob : String?
    var success: Bool = false
    var cellAccount: Cell_Account? = Cell_Account()
    var abc: Bool?
//    let callBack: ((_ result: String)->(String))?

    
    /*discard success update*/
    /*disacard configure v**/
    
    
//    var fullname, dateofBirth, gender, image: String?
    
    //MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.configureTopViewPosition(heightConstraint: topViewHeightConstraint)
        self.tableViewSetUP()
//        NotificationCenter.default.addObserver(self, selector: #selector(didChangeTab(notification:)), name: Notification.Name("DidChangeTab"), object: nil)
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.dob = nil
        self.gender = nil
//        self.presentAlert(title: "Test", message: "Test")
        guard let cell = self.tableViewAccount.cellForRow(at: IndexPath(row: 0, section: 0)) as? Cell_Account else { return }
        cell.configureView(status: false)
//        cellAccount?.configureEditView()
    }
    
    //MARK: - Private Functions
    func refreshUI(){
        if readLogin() != 0 {
            self.tableContainerView.isHidden = false
            self.loadUserProfile()
//            self.loadAddresses()
            btnSettings.isHidden = false
        }else{
            self.tableContainerView.isHidden = true
            showNeedToLoginApp()
            btnSettings.isHidden = true
            
            
        }
    }
    
    private func tableViewSetUP(){
        
        tableViewAccount.dataSource = self
        tableViewAccount.delegate = self
        
    }
    
    //MARK: - Action Functionst
    
    @IBAction func login(_ sender: UIButton) {
        
        Util.makeSignInRootController()
    }

    @IBAction func btnSettings(_ sender: Any) {
        guard let cell = self.tableViewAccount.cellForRow(at: IndexPath(row: 0, section: 0)) as? Cell_Account else { return }
        if cell.isProfileEditing == true {
            self.presentAlertWithTitle(title: "Changes Made", message: "Save the updated profile or discard changes", options: "Discard", "Save") { (option) in
                switch(option) {
                case 0:
                    self.loadUserProfile()
                    cell.configureView(status: false)
                case 1:
                    self.updateProfile(image: cell.imageViewProfile.image, name: cell.textFieldName.text ?? "", gender: cell.textFieldGender.text ?? "", dob: cell.textFieldDOB.text ?? "")
                    cell.configureView(status: false)
                default:
                    print("OOkk")
                }
            }
        } else {
            let vc : VC_Settings = storyboardSettings.instantiateViewController(withIdentifier: "VC_Settings") as! VC_Settings
          
            vc.name = self.userProfile?.name ?? ""
            //vc.number = self.userProfile?.phone ?? ""
            //vc.image = self.userProfile?.profilePic ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func cart(_ sender: UIButton) {
        if readLogin() != 0
        {
            let vc : VC_Cart = storyboardCart.instantiateViewController(withIdentifier: "VC_Cart") as! VC_Cart
            vc.cartType = Cart.store
            vc.isTappedFromStore = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            self.showNeedToLoginApp()
            
        }
        
    }
    
    
    
    //MARK: - API Calling Methods
    func loadUserProfile(){
        /*
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                //Success from our server
                if let address = data.value(forKeyPath: "data.address") as? NSDictionary {
                    APIUtils.prepareModalFromData(address, apiName: APIEndPoint.userProfile.caseValue, modelName:"Address", onSuccess: { (anyData) in
                        self.primaryAddress = anyData as?  Address_ ?? nil

                        let lastScrollOffset = self.tableViewAccount.contentOffset
                        self.tableViewAccount.reloadData()
                        self.tableViewAccount.layoutIfNeeded()
                        self.tableViewAccount.setContentOffset(lastScrollOffset, animated: false)
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    
                    }
                }
                
                if let profile = data.value(forKeyPath: "data.profile") as? NSDictionary{
                    
                    
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                        
                        //self.userProfile = anyData as? ProfileData ?? nil
                       
                        let lastScrollOffset = self.tableViewAccount.contentOffset
                        self.tableViewAccount.reloadData()
                        self.tableViewAccount.layoutIfNeeded()
                        self.tableViewAccount.setContentOffset(lastScrollOffset, animated: false)

                        
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
        }*/
        
    }
    
    func updateProfile(image:UIImage?,name:String, gender:String, dob:String){
        /*
        let param : [String:Any] = ["name":name.capitalized,
                                    "gender":gender.lowercased(),
                                    "dob":dob]
        print("param \(param)")
        
        self.showHud(message: loadingText)
        if let imageData = image?.pngData(){
            
            APIUtils.APICallWithImageUpload(imageData: imageData, postName: APIEndPoint.updateprofile.caseValue, method: .post, parameters: param, controller: self, onSuccess: { (response) in
                self.hideHud()
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Bool ?? true
                
                if status{
                    if let address = data.value(forKeyPath: "data.address") as? NSDictionary{
                        APIUtils.prepareModalFromData(address, apiName: APIEndPoint.userProfile.caseValue, modelName:"Address", onSuccess: { (anyData) in
                            self.primaryAddress = anyData as?  Address_ ?? nil
                            self.tableViewAccount.reloadData()
                        }) { (error, endPoint) in
                            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                        
                        }
                    }
                    
                    if let profile = data.value(forKeyPath: "data.profile") as? NSDictionary{
                        
                        
                        APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                            
                            self.userProfile = anyData as? ProfileData ?? nil
                            
                            self.tableViewAccount.reloadData()
                            
                        }) { (error, endPoint) in
                            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                        }
                    }
                    
                    let message = data[key_message] as? String ?? serverError
                    
                    self.success = status
                    DispatchQueue.main.async {
                        guard let cell = self.tableViewAccount.cellForRow(at: IndexPath(row: 0, section: 0)) as? Cell_Account else { return }
                        cell.configureView(status: false)
                    }
                    
                } else{
                    let message = data[key_message] as? String ?? serverError
                    self.presentAlert(title: errorText, message: message)
                }
                
            }
            ) { (reason, statusCode) in
                self.hideHud()
            }
        }*/
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_Account : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Account") as! Cell_Account
        cell.selectionStyle = .none
        cell.controller = self
        if let userProfile = self.userProfile{
            cell.configureDatePicker()
            //cell.setData(userProfile: userProfile)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
extension VC_Account: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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


extension VC_Account: CropViewControllerDelegate{
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        var cropedImage = image
        let imageSizeMB = GalleryUtil.calculateSizeInMB(image: cropedImage)
        if imageSizeMB >= imageMinLimitNotToCompress {
            cropedImage = cropedImage.resized(withPercentage: imageCompressionPercent)!
        }
        self.profileImage = cropedImage
        self.tableViewAccount.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
}
