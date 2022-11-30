//
//  Cell_TV_SpecialInstruction.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 20/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_SpecialInstruction: UITableViewCell {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var instructionHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(specialInstruction: String?) {
        guard let specialInstruction = specialInstruction else {
            return
        }
        instructionLabel.layer.cornerRadius = 5
        instructionLabel.clipsToBounds = true
        instructionLabel.text = specialInstruction
        let screenWidth = UIScreen.main.bounds.width
//        instructionHeight.constant = specialInstruction.height(withConstrainedWidth: screenWidth - 80, font: UIFont(name: "Lexend-Regular", size: 16)!)
    }
    
}
