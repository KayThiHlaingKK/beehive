//
//  VC_User_Addresses.swift
//  ST Ecommerce
//
//  Created by Shashi KUmar Gupta on 28/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD


class VC_User_Addresses: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewAddresses: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var buttonChangeAddress: UIButton!
    @IBOutlet weak var buttonAddAddress: UIButton!
    
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    let sing = Singleton.shareInstance
    var addresses : [Address] = [Address]()
    var primaryAddress: Address?
    var profileData : Profile?
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //addresses.append(primaryAddress!)
        tableViewSetUp()
        
        
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.loadUserProfile()
        self.loadUserAddressFromServer()
    }
    
    //MARK: - Private functions
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func setDefaultClicked(_ sender: UIButton) {
        
//        if let userProfile = self.profileData, let address = self.addresses.filter({$0.is_primary == true}).first{
//            print("set primary")
        self.setPrimaryAddress(address: self.addresses[sender.tag])
//        }
//        else {
//            print("not primary")
//        }
        
    }
    
    @IBAction func addAddress(_ sender: UIButton) {
        
//        let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
        let storyboard = UIStoryboard(name: "AddAddress", bundle: nil)
        let vc = storyboard.instantiateViewController(ofType: AddAddressViewController.self)
        vc.profileData = self.profileData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - API callings
    
    func loadUserAddressFromServer(){
                    
            let param : [String:Any] = [:]
            APIUtils.APICall(postName: "\(APIEndPoint.Address.caseValue)", method: .get, parameters: param, controller: self, onSuccess: { (response) in
                                
                let data = response as! NSDictionary
                let status = data[key_status] as? Int
                
                if status == 200{
                    
                    if let addresses = data.value(forKeyPath: "data") as? NSArray{
                        
                        APIUtils.prepareModalFromData(addresses, apiName: APIEndPoint.Address.caseValue, modelName:"Address", onSuccess: { (anyData) in
                            Singleton.shareInstance.address = anyData as? [Address] ?? []
                            self.addresses = Singleton.shareInstance.address ?? []
                            
                            self.tableViewAddresses.reloadData()
                        }) { (error, endPoint) in
                            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                        }
                    }
                    
                }else{
                }
            }) { (reason, statusCode) in
                self.hideHud()
            }
    }
    
    func setPrimaryAddress(address: Address){
        print("call primary")
        
        Singleton.shareInstance.selectedAddress = address
        
        
//        let param : [String:Any] = [:]
//        self.showHud(message: loadingText)
//
//        APIUtils.APICall(postName: "\(APIEndPoint.Address.caseValue)/\(address.slug ?? "")/\(APIEndPoint.makePrimary.caseValue)", method: .patch, parameters: param, controller: self, onSuccess: { (response) in
//
//            self.hideHud()
//            let data = response as! NSDictionary
//            let status = data[key_status] as? Int
//
//            if status == 200 {
//                self.tableViewAddresses.reloadData()
//
//                let message = data.value(forKey: key_message) as? String ?? ""
//
//                self.presentAlertWithTitle(title: successText, message: message, options: okayText) { (option) in
//
//                    switch(option) {
//                        case 0:
////                                self.loadUserProfile()
//                            self.loadUserAddressFromServer()
//                        default:
//                            break
//                    }
//                }
//
////                //DEFAULTS.set(userAddressId, forKey: UD_Address_Id)
////
//
//                self.presentAlertWithTitle(title: successText, message: message, options: "OK") { (option) in
//
//                    switch(option) {
//                        case 0:
//                            self.navigationController?.popViewController(animated: true)
//                        default:
//                            break
//                    }
//                }
//
//            }else{
//
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlert(title: errorText, message: message)
//            }
//
//        }) { (reason, statusCode) in
//            self.hideHud()
//
//        }
        
    }
    
    func deleteAddress(addressSlug:String){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.Address.caseValue)/\(addressSlug)", method: .delete, parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data[key_status] as? Int
            
            if status == 200{
                
                if let index = self.addresses.firstIndex(where: {$0.slug == addressSlug}){
                    
                    self.addresses.remove(at: index)
                    self.tableViewAddresses.reloadData()
                    
                    let message = data.value(forKey: key_message) as? String ?? ""
                    
                    self.presentAlertWithTitle(title: successText, message: message, options: okayText) { (option) in

                        switch(option) {
                            case 0:
//                                self.loadUserProfile()
                                self.loadUserAddressFromServer()
                            default:
                                break
                        }
                    }
                    
                }
                
                
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
extension VC_User_Addresses : UITableViewDelegate, UITableViewDataSource{
    
    func tableViewSetUp(){
        
        tableViewAddresses.delegate = self
        tableViewAddresses.dataSource = self
        tableViewAddresses.estimatedRowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : Cell_TV_Address = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Address") as! Cell_TV_Address
        cell.controller = self
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        
        cell.setData(address: addresses[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105.0//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.addresses = self.addresses.map(resetPrimary(address:))
//        self.addresses[indexPath.row].is_primary = true
//        primaryAddress = self.addresses[indexPath.row]
        Singleton.shareInstance.selectedAddress = self.addresses[indexPath.row]
        self.tableViewAddresses.reloadData()
    }
    
    func resetPrimary(address: Address) -> Address{
        var a = address
        a.is_primary = false
        return a
    }
    
    
}


