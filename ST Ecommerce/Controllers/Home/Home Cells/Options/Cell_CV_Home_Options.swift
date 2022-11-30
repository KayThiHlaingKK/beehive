//
//  Cell_CV_Home_Options.swift
//  ST Ecommerce
//
//  Created by necixy on 13/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Home_Options: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var imageViewLogoBackground: UIImageView!
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func imageLogoProperties(){
        DispatchQueue.main.async {
            self.imageViewLogoBackground.layer.cornerRadius = self.imageViewLogoBackground.frame.size.width/2
            self.imageViewLogoBackground.clipsToBounds = true
        }
        
    }
    
    func setData(option:HomeOption){
        
        imageViewLogo.image = option.image
        labelTitle.text = option.title
        imageViewLogo.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //imageViewLogoBackground.backgroundColor = option.color
    }
}
