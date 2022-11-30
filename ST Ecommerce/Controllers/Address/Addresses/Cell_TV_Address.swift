//
//  Cell_TV_Address.swift
//  ST Ecommerce
//
//  Created by necixy on 28/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import CoreLocation


class Cell_TV_Address: UITableViewCell {

    //MARK: - IBOutlets
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewSelection: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    var labelName = ["Home", "Work", "School", "Partner", "Gym"]
    var labelOff = ["home_on", "work_on", "school_on", "partner_on", "gym_on"]
    
    //MARK: - Variables
    var controller : VC_User_Addresses!
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Helper functions
    func setData(address:Address){
        
        
//        if address.is_primary ?? false {
//            imageViewSelection.image = #imageLiteral(resourceName: "radio_button_selected")
//        }
        imageViewSelection.image = UIImage(named: "home")
        if Singleton.shareInstance.selectedAddress?.slug == address.slug {
            imageViewSelection.image = UIImage(named: "\(address.label ?? "")_on")
            labelTitle.textColor = UIColor().HexToColor(hexString: "#FFBB00")
        }
        else {
            imageViewSelection.image = UIImage(named: address.label ?? "")
            labelTitle.textColor = UIColor().HexToColor(hexString: "#000000")
        }
        
        labelTitle.text = address.label ?? ""
        labelAddress.text = Util.getFormattedAddress(address: address)
//        labelAddress.text = address.address1
    }
    
    func showDeletionPrompt(addressId:String){
        
        self.controller.presentAlertWithTitle(title: warningText, message: addressDeletePromptText, options: noText, yesText) { (option) in

            switch(option) {
                case 1:
                print("willllll delete")
//                    self.controller.deleteAddress(addressSlug: addressId)
                default:
                    break
            }
        }

    }
    
    func showMoreOptions(index:Int){
        
        let address = self.controller.addresses[index]
        let actionSheetController: UIAlertController = UIAlertController(title: app_name, message: choose_your_option, preferredStyle: .actionSheet)
        let deleteAction: UIAlertAction = UIAlertAction(title: deleteText, style: .destructive) { action -> Void in

            if let addressId = address.slug{
                self.showDeletionPrompt(addressId: addressId)
            }
        }

        let editAction: UIAlertAction = UIAlertAction(title: EditText, style: .default) { action -> Void in

            
            
            if let lat = address.latitude, let long = address.longitude, let addressId = address.slug{
                
//                let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
                let storyboard = UIStoryboard(name: "AddAddress", bundle: nil)
                let vc = storyboard.instantiateViewController(ofType: AddAddressViewController.self)
                vc.userCoordinates = CLLocationCoordinate2D(latitude: Double(lat) ?? 0, longitude: Double(long) ?? 0)
                vc.address = address
                vc.profileData = self.controller.profileData
                //vc.addressId = addressId
                
                vc.fromEdit = true
                self.controller.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }

        let cancelAction: UIAlertAction = UIAlertAction(title: cancelText, style: .cancel) { action -> Void in }

        // add actions
        actionSheetController.addAction(editAction)
        actionSheetController.addAction(deleteAction)
        actionSheetController.addAction(cancelAction)


        self.controller.present(actionSheetController, animated: true) {
        }
    }
    
    //MARK: - Action Functions
    @IBAction func more(_ sender: UIButton) {
        
        self.showMoreOptions(index: sender.tag)
    }
    
    func editAddress(index:Int){
        let address = self.controller.addresses[index]
        print("address == " , address)
        if let lat = address.latitude, let long = address.longitude, let addressSlug = address.slug{
            
//            let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
            let storyboard = UIStoryboard(name: "AddAddress", bundle: nil)
            let vc = storyboard.instantiateViewController(ofType: AddAddressViewController.self)
            vc.userCoordinates = CLLocationCoordinate2D(latitude: Double(lat) , longitude: Double(long))
            vc.address = address
            vc.profileData = self.controller.profileData
            vc.slug = addressSlug
            vc.fromEdit = true
            
            self.controller.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func deleteAddress(index:Int){
        let address = self.controller.addresses[index]
        if let slug = address.slug{
            self.showDeletionPrompt(addressId: slug)
        }
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        print("edit click")
        self.editAddress(index: sender.tag)
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        print("delete click !!!")
        self.deleteAddress(index: sender.tag)
        
    }
}
