//
//  ExtraChargeListTableViewCell.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/11/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class ExtraChargeListTableViewCell: UITableViewCell {

    @IBOutlet weak var extraChargePriceLbl: UILabel!
    @IBOutlet weak var extraChargeNameLbl: UILabel!
    
    @IBOutlet weak var nameLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var priceLabelConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
