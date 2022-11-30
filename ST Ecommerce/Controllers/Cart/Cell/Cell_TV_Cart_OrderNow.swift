//
//  Cell_TV_Cart_OrderNow.swift
//  ST Ecommerce
//
//  Created by necixy on 05/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Cart_OrderNow: UITableViewCell {
    
    //MARK: - Variable
    var controller_:VC_Cart!
    var controller:CartViewController!
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    //MARK: - Action Function
    
    @IBAction func orderConfirm(_ sender: UIButton) {
       /*
        if self.controller.cartType == Cart.store{
            self.controller.prepareProductParam(promo: self.controller.promocode)
            if self.controller.productOrderList?.count != 0{
                
                if DEFAULTS.bool(forKey: UD_isUserLogin){
//                    self.controller.placeShopOrder()

                }else{
                    self.controller.showNeedToLoginApp()
                }
                
                
                
            }
        }
        else if self.controller.cartType == Cart.restaurant{
            self.controller.prepareRestaurantParam(promo: self.controller.promocode)

            if DEFAULTS.bool(forKey: UD_isUserLogin){

//                    self.controller.placeFoodOrder()
            }else{
                self.controller.showNeedToLoginApp()
            }
                
                
            
        }*/
    }
        
}
    
    
    

