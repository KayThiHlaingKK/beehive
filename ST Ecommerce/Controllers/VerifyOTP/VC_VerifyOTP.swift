//
//  VC_VerifyOTP.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import SVPinView
import PhoneNumberKit
import JGProgressHUD


class VC_VerifyOTP: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewVerifyOTP: UITableView!
    @IBOutlet weak var bottomConstraintTableContainerView: NSLayoutConstraint!
    
    @IBOutlet weak var btnBack: UIButton!
    
    
    //MARK: - Variables
    var phoneNumber : PhoneNumber!
    let hud = JGProgressHUD(style: .dark)
    let sing = Singleton.shareInstance
    
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnBack.layer.backgroundColor = UIColor.clear.cgColor
        btnBack.layer.cornerRadius = btnBack.frame.width / 2
        
        tableViewSetUp()
        
        bottomConstraintTableContainerView.constant = 44
        if DeviceUtils.isDeviceIphoneXOrlatter(){
            bottomConstraintTableContainerView.constant = 90
        }
    }
    
    //MARK: - Private functions
    fileprivate func tableViewSetUp(){
        
        tableViewVerifyOTP.delegate = self
        tableViewVerifyOTP.dataSource = self
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_VerifyOTP : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_VerifyOTP") as! Cell_VerifyOTP
        cell.controller = self
        cell.selectionStyle = .none
        cell.prefillMobileNo()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


