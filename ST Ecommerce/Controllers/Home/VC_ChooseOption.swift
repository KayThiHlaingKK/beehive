//
//  VC_ChooseOption.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 03/03/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import SwiftLocation

class VC_ChooseOption: UIViewController {
    
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var groceryView: UIView!
    @IBOutlet weak var doseView: UIView!
    @IBOutlet weak var shopImgView: UIImageView!
    @IBOutlet weak var foodImgView: UIImageView!
    @IBOutlet weak var groceryImgView: UIImageView!
    @IBOutlet weak var doseImgView: UIImageView!
    
    var chooseOptionDelegate: ChooseOpationDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        getUserCurrentLocation()
        touchSetUp()
    }
    
    override func viewDidLoad() {
        if readLogin() != 0 {
            loadUserProfile()
        }
        self.getUserCurrentLocation()
        loadUserAddressFromServer()
        UISetup()
    }
    
    func UISetup() {
    }
    
    func touchSetUp() {
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(closePopup(tapGestureRecognizer:)))
        closeView.isUserInteractionEnabled = true
        closeView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(chooseFood(tapGestureRecognizer:)))
        foodView.isUserInteractionEnabled = true
        foodView.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(chooseShop(tapGestureRecognizer:)))
        shopView.isUserInteractionEnabled = true
        shopView.addGestureRecognizer(tapGestureRecognizer3)
    }
    
    @objc func closePopup(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseFood(tapGestureRecognizer: UITapGestureRecognizer)
    {
        chooseOptionDelegate?.chooseFoodOption()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseShop(tapGestureRecognizer: UITapGestureRecognizer)
    {
        chooseOptionDelegate?.chooseShopOption()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func getUserCurrentLocation(){
        
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .room) { result in
            switch result {
            case .failure(let error):
                debugPrint("Received error: \(error)")
                switch error {
                case . requiredLocationNotFound( _, let lastLocation):
                    if let location = lastLocation{
                        Singleton.shareInstance.userCurrentCoordinates = location.coordinate
                    }
                    
                default:
                    break
                }
            case .success(let location):
                debugPrint("Location received: \(location)")
                Singleton.shareInstance.userCurrentCoordinates = location.coordinate
                
            }
        }
        print("home lat = " , Singleton.shareInstance.userCurrentCoordinates)
    }
    
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
                if let profile = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    
                    APIUtils.prepareModalFromData(profile, apiName: APIEndPoint.userProfile.caseValue, modelName:"ProfileData", onSuccess: { (anyData) in
                        
                        Singleton.shareInstance.userProfile = anyData as? Profile ?? nil
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
            }else{
//                self.changeLoginState(newState: false)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    func loadUserAddressFromServer(){
        
        // if let ID = DEFAULTS.value(forKey: UD_Address_Id) as? Int{
        
        let param : [String:Any] = [:]
        APIUtils.APICall(postName: "\(APIEndPoint.Address.caseValue)", method: .get, parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data[key_status] as? Int
            
            if status == 200{
                
                if let addresses = data.value(forKeyPath: "data") as? NSArray{
                    
                    APIUtils.prepareModalFromData(addresses, apiName: APIEndPoint.Address.caseValue, modelName:"Address", onSuccess: { (anyData) in
                        Singleton.shareInstance.address = anyData as? [Address] ?? []
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }
                
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
}
