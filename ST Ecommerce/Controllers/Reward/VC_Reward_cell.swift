//
//  VC_Reward_cell.swift
//  ST Ecommerce
//
//  Created by Necixy on 07/12/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD

class VC_Reward_cell: UITableViewCell {
    
    @IBOutlet weak var lblCellTitle: UILabel!
    @IBOutlet weak var btnPromoCode: UIButton!
    @IBOutlet weak var lblValidityDate: UILabel!
    
    @IBOutlet weak var lblExpired: UILabel!
    
    var controller : VC_Reward?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 5
        btnPromoCode.layer.borderWidth = 1
        btnPromoCode.layer.borderColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1).cgColor
        btnPromoCode.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnCopyPromoCode(_ sender: Any) {
       
    }
}
//    func showToast(message : String) {
//
//        let toastLabel = UILabel(frame: CGRect(x: controller?.view.frame.size.width ?? 300/2 - 75, y: controller?.view.frame.size.height ?? 800-100, width: 150, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.textAlignment = .center;
//        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds  =  true
//        controller?.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//    }
    
//    func setData(reward: RewardCode) {
//        print("reward is \(reward)")
//    }
    

