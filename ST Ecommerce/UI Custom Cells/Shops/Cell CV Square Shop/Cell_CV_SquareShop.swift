//
//  Cell_CV_SquareShop.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 13/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_SquareShop: UICollectionViewCell {
    
    
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shopNameLabel.text = ""
        shopImage.layer.cornerRadius = 5
        shopImage.clipsToBounds = true
    }
    
    func setData(shop: Shop) {
        shopNameLabel.text = shop.name
        shopNameLabel.backgroundColor = .clear
        if let images = shop.images,
           images.count > 0 {
            shopImage.downloadImage(url: images[0].url, fileName: images[0].file_name)
        } else {
            shopImage.downloadImage()
        }
    }

}
