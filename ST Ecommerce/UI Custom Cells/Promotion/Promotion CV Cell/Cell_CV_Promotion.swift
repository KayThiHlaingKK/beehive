//
//  Cell_CV_Promotion.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 06/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Promotion: UICollectionViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    
    func setupData(promotion: Promotion) {
        if let images = promotion.images,
            images.count > 0 {
            imageView.downloadImage(url: images.first?.url, fileName: images.first?.fileName, size: .medium)
        } else {
            imageView.image = UIImage(named: "placeholder2")
        }
    }
    
    
}
