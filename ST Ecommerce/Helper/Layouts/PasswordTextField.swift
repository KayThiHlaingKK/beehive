//
//  PasswordTextFiled.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 16/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Override becomeFirstResponder method to prevent auto clearing text in the textfield
class PasswordTextField: UITextField {
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
    
}
