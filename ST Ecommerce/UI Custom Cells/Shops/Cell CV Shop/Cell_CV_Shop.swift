//
//  Cell_CV_Shop.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 19/11/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Shop: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!

    private var shop: Shop!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
    }


    func setData(shop: Shop) {
        self.shop = shop

        nameLabel.text = shop.name
        if let images = shop.images,
           images.count > 0 {
            imageView.downloadImage(url: images[0].url, fileName: images[0].file_name)
        } else {
            imageView.downloadImage()
        }
        if let rating = shop.rating {
            starImage.isHidden = false
            ratingLabel.isHidden = false
            ratingLabel.text = "\(rating)"
        }
    }
}
