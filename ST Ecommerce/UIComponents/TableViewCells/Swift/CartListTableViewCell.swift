//
//  CartListTableViewCell.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 19/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class CartListTableViewCell: UITableViewCell {

    @IBOutlet weak var stepperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setupUI(){
        stepperView.layer.borderWidth = 0.5
        stepperView.layer.borderColor = UIColor.systemYellow.cgColor
        stepperView.layer.cornerRadius = 5
    }
    
}
