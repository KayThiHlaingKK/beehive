//
//  VC_Profile.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 07/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_Profile: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var credtiView: GradientView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAppVersion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfLogin()
    }
    
    private func checkIfLogin() {
        guard readLogin() != 0 else {
            showNeedToLoginApp()
            return
        }
        loadUserProfile()
        getCreditAPICall()
    }
    
    
    private func showAppVersion() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        else { return }
        #if DEBUG
        let env = "-debug"
        #elseif STAGING
        let env = "-staging"
        #else
        let env = ""
        #endif
        
        versionLabel.text = "Version : \(appVersion)\(env)"
    }
    
    
    @IBAction func qrButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "VC_QRCode") as! VC_QRCode
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToAccountInformation(_ sender: UIButton) {
        guard let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_AccountInformation") as? VC_AccountInformation else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToSettings(_ sender: UIButton) {
        guard let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_ProfileSettings") as? VC_ProfileSettings else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func goToFavorite(_ sender: UIButton) {
        guard let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_Favorite") as? VC_Favorite else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToOrders(_ sender: UIButton) {
//        let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
//        vc.cartType = Cart.restaurant
//        vc.fromHome = false
//        self.navigationController?.pushViewController(vc, animated: true)

        navigationController?.pushView(MyOrderScreenRouter(.orderMenu, .store))
    }
    
    @IBAction func goToChangeAddress(_ sender: UIButton) {
        let vc = storyboardSettings.instantiateViewController(withIdentifier: "VC_ManageAddress") as! VC_ManageAddress
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToCredit(_ sender: UIButton){
        navigationController?.pushView(CreditCardRouter())
    }
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        self.presentAlertWithTitle(title: "Are You Sure", message: logoutpromptText, options: noText, yesText) { (option) in
            switch(option) {
            case 1:
                self.showHud(message: loadingText)
                self.logout()
            default:
                break
            }
        }
    }
    
    private func getCreditAPICall() {
        APIClient.fetchUserCredit().execute(onSuccess: { data in
            if data.status == 200 {
                if data.data?.amount != nil {
                    self.credtiView.isHidden = false
                }else{
                    self.credtiView.isHidden = true
                }
            }else{
                if data.message == "Unauthenticated." {
                    self.unAuthenticatedOptoin(toastMessage: data.message ?? "")
                }else{
                    self.presentAlert(title: "Warning!", message: data.message ?? "")
                }
            }
            
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }
    
    private func loadUserProfile() {
        let param : [String:Any] = [:]
        self.showHud(message: loadingText)
        print("load user profile")
        APIUtils.APICall(postName: APIEndPoint.userProfile.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            print("data == " , data)
            if status == 200 {
                if let profile = data.value(forKeyPath: "data") as? NSDictionary {
                    
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (profile) in
                        DispatchQueue.main.async { [unowned self] in
                            Singleton.shareInstance.userProfile = profile as? Profile
                            self.userNameLabel.text = Singleton.shareInstance.userProfile?.name
                        }
                        
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }else{
                self.unAuthenticatedOptoin(toastMessage: "Unauthenticated.")
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
            print("Error in fetching UserProfile: \(reason)")
        }
        
    }
    
    private func logout(){
        
        APIUtils.APICall(postName: APIEndPoint.logout.caseValue, method: .post,  parameters: [String:Any]() , controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                
                DEFAULTS.removeObject(forKey: keyPlayerId)
                let temp = UserDefaults.standard.string(forKey: UD_Popup)
                Util.resetDefaults()
                UserDefaults.standard.set(temp, forKey: UD_Popup)
                
                Singleton.shareInstance.address = []
                Singleton.shareInstance.selectedAddress = nil
                Util.navigateToLoginRootController(toastMessage: "Logout!!")
                
                self.changeLoginState(newState: 0)
                self.writeToken(token: "")
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    
}

