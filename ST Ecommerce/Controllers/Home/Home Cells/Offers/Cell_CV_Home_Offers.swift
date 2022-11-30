//
//  Cell_CV_Home_Offers.swift
//  ST Ecommerce
//
//  Created by necixy on 13/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Home_Offers: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageViewBanner: UIImageView!
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViewBanner.layer.cornerRadius = 5
        imageViewBanner.clipsToBounds = true
    }
    
 //MARK: - Helper Functions
    func setData(bannerImage:Banner){
        
        imageViewBanner.setIndicatorStyle(.gray)
        imageViewBanner.setShowActivityIndicator(true)
       // imageViewBanner.image = UIImage(named: bannerImage)
//        imageViewBanner.sd_setImage(with: URL(string: bannerImage), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
//            self.imageViewBanner.setShowActivityIndicator(false)
//        }
        
        if let banner = bannerImage.images, banner.count > 0 {
            imageViewBanner.downloadImage(url: banner[0].url, fileName: banner[0].file_name, size: .medium)
        }
        
    }
    
    
    
}
