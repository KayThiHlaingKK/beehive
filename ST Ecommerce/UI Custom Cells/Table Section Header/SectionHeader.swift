//
//  SectionHeader.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 18/02/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {

    var titleText: String = "" {
        didSet {
            sectionTitle.text = titleText
        }
    }
    @IBOutlet weak var sectionTitle: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
