//
//  VC_Settings.swift
//  ST Ecommerce
//
//  Created by Shashi on 17/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class VC_Settings: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewSettings: UITableView!
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    
    @IBOutlet weak var tableviewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewUserInfo: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelLine: UILabel!
    @IBOutlet weak var labelUserNumber: UILabel!
    
    //MARK: - Varibles

    var settings : [SettingOption] = [SettingOption]()
    var selectedSetting = ""
    
    var name = ""
    var image: String = ""
    var number = ""
    
    var deviceId : String!
    
    //MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSetUP()
        
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        
        self.settingsDataSource()
        tableViewSettings.tableFooterView = UIView()
        
        
        self.loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    //MARK: - Private Functions
    
    func loadData() {

        viewUserInfo.layer.cornerRadius = 10
        viewUserInfo.layer.borderColor = UIColor.lightGray.cgColor
        viewUserInfo.layer.borderWidth = 0.5
        
        self.labelUserName.text = name
        self.labelUserNumber.text = number
        
        let imagePath = self.image
        userImage.setIndicatorStyle(.gray)
        userImage.setShowActivityIndicator(true)
        userImage.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "Path 23")) { (image, error, type, url) in
            self.userImage.setShowActivityIndicator(false)
        }
        self.userImage.layer.cornerRadius = userImage.frame.size.width/2
        self.userImage.clipsToBounds = true
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.borderColor = UIColor.orange.cgColor
        
        self.tableViewSettings.layer.cornerRadius = 10
        self.tableViewSettings.layer.borderWidth = 0.5
        self.tableViewSettings.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func tableViewSetUP(){
        
        tableViewSettings.dataSource = self
        tableViewSettings.delegate = self
        
    }
    
    func settingsDataSource(){
        
        settings.append(SettingOption(title: ChangePasswordText, image: #imageLiteral(resourceName: "Path 23") ))
        settings.append(SettingOption(title: "My Favourites", image: #imageLiteral(resourceName: "heart")))
        settings.append(SettingOption(title: PrivacyPolicyText, image: #imageLiteral(resourceName: "shield")))
        settings.append(SettingOption(title: Terms_ConditionsText, image: #imageLiteral(resourceName: "list")))
        settings.append(SettingOption(title: PaymentSettingsText, image: #imageLiteral(resourceName: "image (4)")))
        settings.append(SettingOption(title: HelpDeskText, image: #imageLiteral(resourceName: "question-mark-on-a-circular-black-background-1")))
        settings.append(SettingOption(title: logoutText, image: #imageLiteral(resourceName: "logout-2")))
        
    }
    
    func logoutPrompt(){
        
        self.presentAlertWithTitle(title: "Are You Sure", message: logoutpromptText, options: noText, yesText) { (option) in

            switch(option) {
                case 1:
                    self.deviceId =  UIDevice.current.identifierForVendor?.uuidString
                    self.logoutAPI()
                default:
                    break
            }
        }
    }
    
    func openWebViewController(_ stringURL: String) {
        let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_CustomWebView") as! VC_CustomWebView
        vc.htmlString = (stringURL)
        vc.lblText = selectedSetting
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - Action Functions
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - API Calling Methods
    func logoutAPI(){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        APIUtils.APICall(postName: APIEndPoint.logout.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if status{
                //Success from our server
                
                Util.resetDefaults()
                Util.makeHomeRootController()
                DEFAULTS.removeObject(forKey: keyPlayerId)
        
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func loadPolicy(url:String){
        let param : [String:Any] = [:]
        print("param \(param)")
        
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: url, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status{
                
                //Success from our server
                let dictionary = data.value(forKey: "data") as? Dictionary ?? [:]
                
                self.openWebViewController((dictionary["content"] as! String))
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_Settings : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : Cell_Settings = tableView.dequeueReusableCell(withIdentifier: "Cell_Settings") as! Cell_Settings
        cell.selectionStyle = .none
        cell.controller = self
        cell.imageBackground.layer.cornerRadius = 5
        
        cell.labelTitle.text = self.settings[indexPath.row].title
        cell.titleImage.image = self.settings[indexPath.row].image
        cell.titleImage.setImageColor(color: .white)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = self.settings[indexPath.row].title.lowercased()
        selectedSetting = self.settings[indexPath.row].title
        
        switch title {
        case logoutText.lowercased():
            self.logoutPrompt()
            
        case privacyPolicy.lowercased():
            self.loadPolicy(url: "\(APIEndPoint.policy.caseValue)")
            
        case termsAndConditions.lowercased():
            self.loadPolicy(url: "\(APIEndPoint.termsAndcondition.caseValue)")
        
        case "my favourites":
            guard let vc: FavouritesViewController = storyboardSettings.instantiateViewController(withIdentifier: "FavouritesViewController") as? FavouritesViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        case HelpDeskText.lowercased():
            guard let vc: HelpViewController = storyboardMyOrders.instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            presentAlert(title: app_name, message: comingSoonText)
        }
    }
    
}







