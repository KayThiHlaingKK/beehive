//
//  Cell_CV_Variant_Button.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 24/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Variant_Button: UICollectionViewCell {
    
    @IBOutlet weak var variantBtn: UIButton!
    
    func cellConfiguration(){
        variantBtn.setTitleColor(UIColor.black, for: .normal)
        variantBtn.layer.cornerRadius = 4
        variantBtn.layer.borderWidth = 1
        variantBtn.layer.borderColor = UIColor().HexToColor(hexString: "#EFC610").cgColor
    }
    
    func setData(title: String) {
        cellConfiguration()
        variantBtn.setTitle(" \(title) ", for: .normal)
    }
}
