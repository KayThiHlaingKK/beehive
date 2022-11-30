//
//  Cell_CV_AvailableShop.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 22/03/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_AvailableShop: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    private var shop: Shop!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
    }

    func setData(shop: Shop) {
        shopNameLabel.text = shop.name
        if let firstImage = shop.images?.first {
            imageView.downloadImage(url: "\(firstImage.url)?size=xsmall", fileName: firstImage.file_name, size: .xsmall)
        }
        else {
            imageView.downloadImage()
        }
        
    }
}
