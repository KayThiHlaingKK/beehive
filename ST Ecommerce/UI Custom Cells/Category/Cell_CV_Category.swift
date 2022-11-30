//
//  Cell_CV_Category.swift
//  ST Ecommerce
//
//  Created by Shashi KUmar Gupta on 24/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Category: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageVIewCategory: UIImageView!
    @IBOutlet weak var labelCategoryName: UILabel!
    
    @IBOutlet weak var topConstraintContainer: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintContainer: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintContainer: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraintContainer: NSLayoutConstraint!
    
    //MARK: - Variables
    var homeController:VC_Home!
    var storeController:VC_Store!
    var isLastCell = false
    private var menu: ShopCategoryMenu!
    
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                labelCategoryName.textColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
//            }else {
//                labelCategoryName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//            }
//        }
//    }
    
    func setData(menu: ShopCategoryMenu) {
        self.menu = menu
        if let images = menu.images,
           images.count > 0,
        let firstImage = images.first {
            let imageUrl = "\(firstImage.url)?size=thumbnail"
            imageVIewCategory.downloadImage(url: imageUrl, fileName: firstImage.fileName, size: .thumbnail)
        }
        else {
            imageVIewCategory.downloadImage()
        }
        labelCategoryName.text = menu.name
    }
    
    
    func setData(category:ShopCategory){
                
        if isLastCell{
            labelCategoryName.text = "View All"
            imageVIewCategory.isHidden = true
            imageVIewCategory.image = nil
            imageVIewCategory.backgroundColor = UIColor.lightGray
        }else{
            labelCategoryName.text = category.name ?? ""
            var imagePath = ""
            if let images = category.images,
               images.count > 0 {
                imageVIewCategory.setIndicatorStyle(.gray)
                imageVIewCategory.setShowActivityIndicator(true)
                
                imagePath = "\(images[0].url ?? "")?size=thumbnail"
                imageVIewCategory.downloadImage(url: imagePath, fileName: images[0].file_name, size: .xsmall)
                
                print("category = ", category.name , ",", category.images?[0].url)
            }
            else {
                imageVIewCategory.image = UIImage(named: "placeholder2")
            }
            imageVIewCategory.isHidden = false
            imageVIewCategory.layer.cornerRadius = 2
            imageVIewCategory.layer.masksToBounds = true
            
            
        }
    }
    
    //MARK: - Internal Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        labelCategoryName.highlightedTextColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
    }
    
    
    
}
