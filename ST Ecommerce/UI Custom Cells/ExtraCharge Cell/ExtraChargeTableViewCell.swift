//
//  ExtraChargeTableViewCell.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class ExtraChargeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblVariationName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var imgSelect: UIImageView!
    
    @IBOutlet weak var extraChargeTitleLbl: UILabel!
    @IBOutlet weak var extraChargeTitleLblTwo: UILabel!
    @IBOutlet weak var extraChargeTitleLblThree: UILabel!
    @IBOutlet weak var extraChargeTitleLblFour: UILabel!

    @IBOutlet weak var extraAmtLbl: UILabel!
    @IBOutlet weak var extraAmtLblTwo: UILabel!
    @IBOutlet weak var extraAmtLblThree: UILabel!
    @IBOutlet weak var extraAmtLblFour: UILabel!
    
    var controller: VC_FoodCustomisation?
    var rowIndex : Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            imgSelect.image = #imageLiteral(resourceName: "radio_button_selected")
            self.controller?.chooseVariat = controller?.menu?.menu_variants?[rowIndex]
            let count = controller?.menu?.menu_variants?.count ?? 0
            for i in 0..<count{
                controller?.menu?.menu_variants?[i].isSelected = true
            }
        }
        else {
            imgSelect.image = #imageLiteral(resourceName: "radio_button_un_selected")
        }
        // Configure the view for the selected state
    }
    
//    fileprivate func setupUI(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(didChoose))
//        addGestureRecognizer(tap)
//    }
    
   
    
//    @objc private func didChoose() {
//        if controller?.menu?.menu_variants?[rowIndex].isSelected == false {
//            let count = controller?.menu?.menu_variants?.count ?? 0
//            for i in 0..<count {
//                if i == rowIndex {
//                    controller?.menu?.menu_variants?[i].isSelected = true
//                }
//                else {
//                    controller?.menu?.menu_variants?[i].isSelected = false
//                }
//            }
//
//            self.controller?.chooseVariat = controller?.menu?.menu_variants?[rowIndex]
//
//            self.controller?.tableViewVariationCustomisation.reloadData()
//        }
//    }
    
}
