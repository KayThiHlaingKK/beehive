//
//  Cell_TV_Restro_Continue.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 03/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Continue: UITableViewCell {
    
    var controller:CartViewController!
    
    
    
    @IBAction func continueClicked(_ sender: UIButton) {
        controller.addItemInRestroCart()
    }
}
