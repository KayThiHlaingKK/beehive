//
//  Cell_CV_Restro_Banner.swift
//  ST Ecommerce
//
//  Created by necixy on 31/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Restro_Banner: UICollectionViewCell {
    @IBOutlet weak var imageViewBanner: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    
    func setData(imagePath:String){
        print("image path = " , imagePath)
        imageViewBanner.setIndicatorStyle(.gray)
        imageViewBanner.setShowActivityIndicator(true)
//        imageViewBanner.image = UIImage(named: imagePath)
        imageViewBanner.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
            self.imageViewBanner.setShowActivityIndicator(false)
        }
        
        
    }
}
