//
//  Cell_CV_Cuisine.swift
//  ST Ecommerce
//
//  Created by necixy on 04/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Cuisine: UICollectionViewCell {
    
    @IBOutlet weak var viewCuisineContainer: UIView!
    @IBOutlet weak var labelCuisine: UILabel!
    
    
    func setProperties(){
        
        viewCuisineContainer.roundCorners(corners: [.topLeft, .bottomRight], amount: 5)
    }
    
    func setData(cuisine:Cuisine){
        
        labelCuisine.text = cuisine.name ?? ""
    }
}
