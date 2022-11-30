//
//  VC_Promotion.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 04/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class VC_Promotion: UIViewController {
    @IBOutlet weak var promoTextField: UITextField!
    var promoProductDelegate: PromoProductDelegate!
    var promoResDelegate: PromoRestaurantDelegate!
    var type = ""
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func applyPromoCode(_ sender: UIButton) {
        print("apply promo")
        
        if let promoCode = promoTextField.text{

            self.promoTextField.resignFirstResponder()
            if type == "Product" {
                self.promoProductDelegate.validatePromoProduct(promo: promoCode) { [weak self] success in
                    
                }
            }
            else {
                self.promoResDelegate.validatePromoRestaurant(promo: promoCode) { [weak self] success in
                    
                }
            }
            //promoView.isHidden = true
            self.dismiss(animated: false, completion: nil)
        }
    }
}
