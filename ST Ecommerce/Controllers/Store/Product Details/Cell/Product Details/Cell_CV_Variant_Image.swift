//
//  Cell_CV_Variant_Image.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 24/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Variant_Image: UICollectionViewCell {
    @IBOutlet weak var variantImageView: UIImageView!
    @IBOutlet weak var imageBtn: UIButton!
    
    func setData(image:String) {
        let imagePath = BASEURL.replacingOccurrences(of: "v3", with: "v2") + "/images/" + image
        variantImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "placeholder2")) { (image, error, type, url) in
            self.variantImageView.setShowActivityIndicator(false)
        }
    }
}
