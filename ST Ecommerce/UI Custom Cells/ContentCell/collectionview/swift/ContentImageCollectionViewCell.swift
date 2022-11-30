//
//  ContentImageCollectionViewCell.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/22/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class ContentImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    
    var data : Cover?{
        didSet{
            if let image = data {
                thumbnailView.downloadImage(url: image.url, fileName: image.fileName, size: .medium)
            }else{
                thumbnailView.downloadImage()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    

}
