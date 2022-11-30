//
//  Cell_TV_Cart_Restro_Special_Instructions.swift
//  ST Ecommerce
//
//  Created by necixy on 05/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Cart_Restro_Special_Instructions: UITableViewCell {
    
    //MARK: - IBOUtlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewInstructions: UITextView!
    @IBOutlet weak var placeHolderInstructions: UILabel!
    
    //MARK: - Variables
    var controller_:VC_Cart!
    var controller:CartViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configuretextView(){
        
        self.textViewInstructions.delegate = self
    }
    
}


extension Cell_TV_Cart_Restro_Special_Instructions : UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == ""{
            placeHolderInstructions.isHidden = false
        }else{
            placeHolderInstructions.isHidden = true
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let specialInstructionsText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        self.controller.special_instruction = specialInstructionsText
        
        if specialInstructionsText == ""{
            placeHolderInstructions.isHidden = false
            
        }else{
            placeHolderInstructions.isHidden = true
        }
        
        return true
        
        
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            placeHolderInstructions.isHidden = false
        }else{
            placeHolderInstructions.isHidden = true
            
            controller.special_instruction = textView.text
            
        }
    }
    
    func getCurrentEditingWord() ->String? {
        let selectedRange: UITextRange? = self.textViewInstructions.selectedTextRange
        var cursorOffset: Int? = nil
        if let aStart = selectedRange?.start {
            cursorOffset = self.textViewInstructions.offset(from: self.textViewInstructions.beginningOfDocument, to: aStart)
        }
        let text = self.textViewInstructions.text
        let substring = (text as NSString?)?.substring(to: cursorOffset!)
        let editedWord = substring?.components(separatedBy: " ").last
        return editedWord
    }
}
