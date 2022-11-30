//
//  Cell_TV_Restro_Address.swift
//  ST Ecommerce
//
//  Created by necixy on 05/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Restro_Address: UITableViewCell {
    
    //MARK: - IBOUtlets
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewAddEditAddress: UIImageView!
    @IBOutlet weak var buttonAddEditAddress: UIButton!
    @IBOutlet weak var labelDeliveryDetails: UILabel!
    @IBOutlet weak var buttonEditAddress: UIButton!
    
    //MARK: - Variables
    var controller_:VC_Cart!
    var controller:CartViewController!
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(addressStr: String){
        
        if self.controller.addresses.count == 0{
            
            labelDeliveryDetails.text = addAddressText
            imageViewAddEditAddress.image = #imageLiteral(resourceName: "plus")
        }
        else{
            labelDeliveryDetails.text = changeAddressText
            imageViewAddEditAddress.image = #imageLiteral(resourceName: "pencil")
        }
//        labelAddress.text = "Address Not Available"
        labelAddress.text = addressStr
//        let addressCount = Singleton.shareInstance.address?.count ?? 0
//        print("address count == " , Singleton.shareInstance.address?.count)
//        if addressCount > 0 {
//            for i in 0..<addressCount {
//                print("is primary = " , Singleton.shareInstance.address?[i].is_primary)
//                if (Singleton.shareInstance.address?[i].is_primary == true) {
//                    labelAddress.text = Util.getFormattedAddress(address: Singleton.shareInstance.address?[i] ?? Address())
//                }
//            }
//        }
    }
    
    //MARK: - Action Functions
    @IBAction func editAddress(_ sender: UIButton) {
        
        if self.controller.addresses.count == 0{
        
//            let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
            self.controller.navigationController?.pushView(AddAddressRouter())
            ///////vc.profileData = self.controller.userProfile
//            self.controller.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc : VC_User_Addresses = storyboardAddress.instantiateViewController(withIdentifier: "VC_User_Addresses") as! VC_User_Addresses
            //////vc.profileData = self.controller.userProfile
            /////if let address = self.controller.addresses.filter({$0.isPrimary == true}).first{
            /////    vc.primaryAddress = address
            /////}
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
