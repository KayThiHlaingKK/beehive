//
//  RoundedView.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 29/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

@IBDesignable class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var borderColor:UIColor? {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    override func prepareForInterfaceBuilder() {
        updateUI()
    }
    
    func updateUI() {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = cornerRadius > 0
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
    }
}
