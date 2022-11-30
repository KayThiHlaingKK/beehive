//
//  HelpViewController_Cell.swift
//  ST Ecommerce
//
//  Created by Necixy on 07/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class HelpViewController_Cell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblUnderline: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnCall.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
