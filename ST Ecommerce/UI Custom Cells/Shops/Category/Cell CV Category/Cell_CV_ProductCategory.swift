//
//  Cell_CV_ProductCategory.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 15/11/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_ProductCategory: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
    }
    
    func setData(category: ShopCategory) {
        label.text = category.name
        if category.images?.count ?? 0 > 0,
           let urlString = category.images?[0].url {
            imageView.downloadImage(url: urlString, fileName: category.images?[0].file_name)
            
            print("category = ", category.name , ",", category.images?[0].url)
        }
        else {
            imageView.image = UIImage(named: "placeholder2")
        }
    }

}
