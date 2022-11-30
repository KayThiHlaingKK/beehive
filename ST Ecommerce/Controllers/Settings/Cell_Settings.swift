//
//  Cell_Settings.swift
//  ST Ecommerce
//
//  Created by necixy on 17/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_Settings: UITableViewCell {

    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var imageBackground: UIView!
    
    var controller : VC_Settings!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
