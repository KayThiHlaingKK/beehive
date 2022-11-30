//
//  AddressTableViewCell.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 16/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var lableLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindAddressData(address: Address,selectedAddress: Address) {
        lableLbl.text = address.label
        addressLbl.text = Util.getFormattedAddress(address: address)
        print("address == ", address.slug)
        print("share address = ", selectedAddress.slug)
        if selectedAddress.slug == address.slug {
            optionImage?.image = #imageLiteral(resourceName: "option_on")
            subView.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
        }
        else {
            optionImage?.image = #imageLiteral(resourceName: "option_off")
            subView.backgroundColor = UIColor.white
        }
    }
}


class AddressTableHeaderCell: UITableViewCell {
    @IBOutlet weak var subView: UIView!
}


class AddressTableFooterCell: UITableViewCell {
    
    var controller: UIViewController!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var addnewView: UIView!
    
}



class CartAddressTableFooterCell: UITableViewCell {
    
//    @IBOutlet weak var subView: UIView!
//    @IBOutlet weak var instructionTextView: UITextView!
//    @IBOutlet weak var placeHolderInstructions: UILabel!
//    @IBOutlet weak var instTextField: UITextField!
    
    var controller: ContinuePaymentViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        instTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
//    @IBAction func clickedPlaceOrder(_ sender: UIButton) {
//        print("click place order")
//        self.controller.placeOrderAPI()
//    }
}

//extension CartAddressTableFooterCell: UITextViewDelegate{
//
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        print("begin editing")
//        if textView.text == ""{
//            placeHolderInstructions.isHidden = false
//        }else{
//            placeHolderInstructions.isHidden = true
//        }
//
//        return true
//    }
//
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        print("end editing")
//        return true
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        let specialInstructionsText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//
//        if specialInstructionsText == ""{
//            placeHolderInstructions.isHidden = false
//            textView.resignFirstResponder()
//
//        }else{
//            placeHolderInstructions.isHidden = true
//        }
//
//        return true
//
//
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        if textView.text == ""{
//            placeHolderInstructions.isHidden = false
//        }else{
//            placeHolderInstructions.isHidden = true
//
//        }
//        controller.instText = textView.text ?? ""
//        print("table height ", instructionTextView.isHidden)
//
//    }
//
//
//
//    func getCurrentEditingWord() ->String? {
//        let selectedRange: UITextRange? = self.instructionTextView.selectedTextRange
//        var cursorOffset: Int? = nil
//        if let aStart = selectedRange?.start {
//            cursorOffset = self.instructionTextView.offset(from: self.instructionTextView.beginningOfDocument, to: aStart)
//        }
//        let text = self.instructionTextView.text
//        let substring = (text as NSString?)?.substring(to: cursorOffset!)
//        let editedWord = substring?.components(separatedBy: " ").last
//        return editedWord
//    }
//}
