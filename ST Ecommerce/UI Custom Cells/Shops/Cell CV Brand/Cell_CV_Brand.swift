//
//  Cell_CV_Brand.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 22/11/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Brand: UICollectionViewCell {

    private var brand: Brand!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
    }

    
    func setData(brand: Brand) {
        self.brand = brand
        if let image = brand.images?.first {
            imageView.downloadImage(url: image.url, fileName: image.file_name)
        } else {
            imageView.image = UIImage(named: "placeholder2")
        }
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        brandLabel.text = brand.name
    }
}
