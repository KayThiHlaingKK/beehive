//
//  Cell_TV_Restro_TakeAway.swift
//  ST Ecommerce
//
//  Created by necixy on 05/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Restro_TakeAway: UITableViewCell {

    //MARK: -  IBOutlets
    @IBOutlet weak var SwitchTakeOut: UISwitch!
    
    @IBOutlet weak var labelTakeAway: UILabel!
    
    //MARK: - Variables
    var controller_:VC_Cart!
    var controller:CartViewController!
    
    //MARK: - INternal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func handelUI(){
        
//        if let selfPickup = self.controller.restroCart?.restaurant?.selfPickup{
//            if selfPickup{
//                SwitchTakeOut.setOn(self.controller.isGiveAwayOn, animated: false)
//            }
//        }
        
        if self.controller.isGiveAwayOn{
            SwitchTakeOut.onTintColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            
        }else{
            SwitchTakeOut.tintColor = .lightGray
            SwitchTakeOut.layer.cornerRadius = SwitchTakeOut.frame.height / 2.0
            SwitchTakeOut.backgroundColor = .lightGray
            SwitchTakeOut.clipsToBounds = true

        }
    }
    
    //MARK: - Action Functions
    @IBAction func takeOut(_ sender: UISwitch) {
        
        self.controller.isGiveAwayOn.toggle()
        self.controller.tableViewCart.reloadData()
        
    }
    
}
