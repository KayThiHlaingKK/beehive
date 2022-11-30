//
//  RadioButtonController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation Dev on 8/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit

class RadioButtonController: NSObject {
    
    var buttonsArray: [UIButton]! {
        didSet {
            for b in buttonsArray {
                b.setImage(UIImage(named: "radio_button_un_selected"), for: .normal)
                b.setImage(UIImage(named: "radio_button_selected"), for: .selected)
            }
        }
    }
    var selectedButton: UIButton?
    var defaultButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaultButton)
        }
    }

    func buttonArrayUpdated(buttonSelected: UIButton) {
        for b in buttonsArray {
            if b == buttonSelected {
                selectedButton = b
                b.isSelected = true
            } else {
                b.isSelected = false
            }
        }
    }
}
