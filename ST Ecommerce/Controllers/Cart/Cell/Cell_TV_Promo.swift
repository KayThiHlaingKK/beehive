//
//  Cell_TV_Promo.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 10/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Promo: UITableViewCell {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var promoTextField: UITextField!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var promoCodeTextView: UIView!
    
    @IBOutlet weak var appliedPromoCodeLabel: UILabel!
    //MARK: - Variable
    var controller: CartViewController!
    var isStore: Bool?
    
    //MARK: -  Inbuilt Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func checkPromo(resPromoCode: String,shopPromoCode: String){
        guard let isStore = isStore else {
            return
        }
       if isStore {
           if !shopPromoCode.isEmpty {
               promoCodeTextView.isHidden = false
               promoTextField.text = shopPromoCode
               appliedPromoCodeLabel.text = shopPromoCode
               Singleton.shareInstance.isPromoUse = true
           }else{
               promoCodeTextView.isHidden = true
               promoTextField.text = ""
               appliedPromoCodeLabel.text = promoTextField.text
               Singleton.shareInstance.isPromoUse = false
               
           }
       }else{
           if !resPromoCode.isEmpty {
               promoCodeTextView.isHidden = false
               promoTextField.text = resPromoCode
               appliedPromoCodeLabel.text = resPromoCode
           }else{
               promoCodeTextView.isHidden = true
               promoTextField.text = ""
               appliedPromoCodeLabel.text = promoTextField.text
               
           }
       }
        
        
    }
    
    func configuretextField(){
        self.promoTextField.delegate = self
    }
    
    @IBAction func applyPromo(_ sender: UIButton) {
        if let promo = promoTextField.text {
            if self.controller.isFromStore {
                controller.validatePromoProduct(promo: promo, completion: didApplyPromoCode(success:))
            }
            else {
                controller.validatePromoRestaurant(promo: promo, completion: didApplyPromoCode(success:))
            }
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        guard let isStore = isStore else {
            return
        }
        controller.removePromoMenu(isStore: isStore) { [weak self] success in
            self?.promoTextField.text = ""
            self?.didRemovePromoCode(success: success)
        }
        
    }
    
}

protocol PromoCodeUsable: AnyObject {
    func didApplyPromoCode(success: Bool)
    func didRemovePromoCode(success: Bool)
}

extension Cell_TV_Promo: PromoCodeUsable {
    func didApplyPromoCode(success: Bool) {
        promoCodeTextView.isHidden = !success
        appliedPromoCodeLabel.text = promoTextField.text ?? ""
    }
    
    func didRemovePromoCode(success: Bool) {
        promoCodeTextView.isHidden = success
        appliedPromoCodeLabel.text = success ? "" : promoTextField.text
        if success {
            promoTextField.text = ""
        }
    }
}

extension Cell_TV_Promo: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        applyBtn.backgroundColor = UIColor().HexToColor(hexString: "FFBB00")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        applyBtn.backgroundColor = UIColor().HexToColor(hexString: "FFBB00")
    }
    
}
