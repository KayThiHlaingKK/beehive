//
//  Cell_TV_Review_Header.swift
//  ST Ecommerce
//
//  Created by necixy on 13/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Review_Header: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(){
       // labelTitle.text = "\(customerReviewsText) (\(self.controller.productDetails?.reviewCount ?? 0))"
    }

}
