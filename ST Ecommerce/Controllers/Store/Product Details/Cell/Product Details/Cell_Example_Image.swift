//
//  Cell_Example_Image.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 29/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_Example_Image: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageViewBanner: UIImageView!
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    //MARK: - Helper Functions
       func setData(productImage:String){
        let imagePath = BASEURL.replacingOccurrences(of: "v3", with: "v2") + "/images/" + productImage
        print("image path " , imagePath)
           imageViewBanner.setIndicatorStyle(.gray)
           imageViewBanner.setShowActivityIndicator(true)
           imageViewBanner.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
               self.imageViewBanner.setShowActivityIndicator(false)
           }
       }
}
