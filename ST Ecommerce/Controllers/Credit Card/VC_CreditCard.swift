//
//  VC_CreditCard.swift
//  ST Ecommerce
//
//  Created by necixy on 06/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class VC_CreditCard: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var creditCardview: TinyCreditCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creditCardview.delegate = self
        
    }
    
    
    
}


extension VC_CreditCard : TinnyDoneDelegate{
    
    func fillingDetailsDone() {
        
        let vc : VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
        vc.cartType = Cart.store
        vc.fromHome = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
