//
//  Cell_TV_CategoryMenu.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 17/12/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_CategoryMenu: UITableViewCell {
    
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var menu: ShopCategoryMenu!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(menu: ShopCategoryMenu) {
        self.menu = menu
        
        if let images = menu.images,
           images.count > 0,
        let firstImage = images.first {
            let imageUrl = "\(firstImage.url)?size=medium"
            categoryImage.downloadImage(url: imageUrl, fileName: firstImage.fileName, size: .medium)
        }
        else {
            categoryImage.downloadImage()
        }
        nameLabel.text = menu.name
    }
    
}
