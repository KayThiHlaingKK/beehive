//
//  Cell_CV_Store_H_Linear.swift
//  ST Ecommerce
//
//  Created by necixy on 14/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Store_H_Linear: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageViewproduct: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var viewProductNotAvailable: UIView!
    @IBOutlet weak var labelNotAvailable: UILabel!
    
    //MARK: -
    
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

