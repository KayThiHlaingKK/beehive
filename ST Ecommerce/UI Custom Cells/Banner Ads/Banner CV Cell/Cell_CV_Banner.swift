//
//  Cell_CV_Banner.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 15/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Banner: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        backgroundColor = .clear
    }
    
    func setupData(banner: Banner) {
        guard let images = banner.images,
              let firstImage = images.first
        else {
            imageView.image = UIImage(named: "placeholder2")
            return
        }
        imageView.downloadImage(url: firstImage.url, fileName: firstImage.file_name, size: .medium)
    }
}
