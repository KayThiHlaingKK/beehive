//
//  Cell_TV_PaymentMode.swift
//  ST Ecommerce
//
//  Created by necixy on 27/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_PaymentMode: UITableViewCell {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelTotalAmount: UILabel!
    
    @IBOutlet weak var labelCOD: UILabel!
    @IBOutlet weak var labelOnline: UILabel!
    
    @IBOutlet weak var buttonCOD: UIButton!
    @IBOutlet weak var buttonKbz: UIButton!
    @IBOutlet weak var labelExpectedDelivery: UILabel!
    
    //MARK: - Variable
    var controller_:VC_Cart!
    var controller:CartViewController!
    
    //MARK: -  Inbuilt Functions
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helping Functions
    func setData(storeCart:StoreCart){
        labelTotalAmount.text = "\(storeCart.total ?? "")\(currencySymbol)"
        
        ///////labelExpectedDelivery.text = "\(estimatedDeliveryText) \(storeCart.deliveredBy ?? "")"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let next2Date = Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        let localDate = dateFormatter.string(from: next2Date)
        
        labelExpectedDelivery.text = "\(estimatedDeliveryText) \(localDate )"
        
        self.toggleCODandOnline()
        
    }
    
//    func setData(restroCart:CartRestaurantBranch){
//
//        ///////labelExpectedDelivery.text = "\(estimatedDeliveryText) \(restroCart.deliveredBy ?? "")"
//        labelExpectedDelivery.text = "\(estimatedDeliveryText) 45 min"
//
//        self.toggleCODandOnline()
//    }
    
    func toggleCODandOnline(){
        
        self.buttonCOD.setImage(#imageLiteral(resourceName: "radio_button_un_selected"), for: .normal)
        //self.buttonOnline.setImage(#imageLiteral(resourceName: "radio_button_un_selected"), for: .normal)
        self.buttonKbz.setImage(#imageLiteral(resourceName: "radio_button_un_selected"), for: .normal)
        
//        self.labelCOD.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        self.labelOnline.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        if self.controller.paymentMode == PaymentMode.cash{
            self.buttonCOD.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
//            self.labelCOD.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        else if self.controller.paymentMode == PaymentMode.kbz{
            self.buttonKbz.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
//            self.labelOnline.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        }
//        else if self.controller.paymentMode == PaymentMode.online{
//            self.buttonOnline.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
//            self.labelOnline.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            
//        }
    }
    
    
    @IBAction func cod(_ sender: UIButton) {
        self.controller.paymentMode = PaymentMode.cash
        toggleCODandOnline()
        //self.controller.tableViewCart.reloadData()
    }
    
    @IBAction func kbzpay(_ sender: UIButton) {
        self.controller.paymentMode = PaymentMode.kbz
        toggleCODandOnline()
        //self.controller.tableViewCart.reloadData()
    }
}
