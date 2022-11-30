//
//  Cell_CV_BrandHeader.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 22/03/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_BrandHeader: UICollectionViewCell {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var labelCartCount: UILabel!
    weak var controller: VC_BrandDetail!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        controller.goBack()
    }
    
    
    @IBAction func cartButton(_ sender: UIButton) {
        controller.goToCartView()
    }
    
    func setData(brand: Brand, cartCount: Int) {
        backgroundColor = .white
        if let image = brand.images?.first {
            let imageUrl = "\(image.url)?size=thumbnail"
            headerImage.downloadImage(url: imageUrl, fileName: image.file_name, size: .medium)
        }
        else {
            headerImage.downloadImage()
        }
        brandNameLabel.text = brand.name
        
        self.labelCartCount.text = "\(cartCount)"
        
        if cartCount > 10 {
            self.labelCartCount.text = "10+"
        } else if cartCount == 0 {
            self.labelCartCount.isHidden = true
        } else {
            self.labelCartCount.isHidden = false
        }
    }
    
}
