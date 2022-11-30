//
//  Delivery_Date.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 03/11/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Delivery_Date: UIView {
    
    @IBOutlet weak var content_View: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            print("common !!!")
//            Bundle.main.loadNibNamed("Delivery_Date", owner: self, options: nil)
        }

}
