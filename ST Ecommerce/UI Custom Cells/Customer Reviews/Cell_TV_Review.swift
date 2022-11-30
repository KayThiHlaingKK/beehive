//
//  Cell_TV_Review.swift
//  ST Ecommerce
//
//  Created by necixy on 13/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_TV_Review: UITableViewCell {

    //MARK: - IBOutlets
     @IBOutlet weak var ratingView: CosmosView!
     @IBOutlet weak var labelTitle: UILabel!
     @IBOutlet weak var labelName: UILabel!
     @IBOutlet weak var labelDate: UILabel!
     @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var labelBottomLine: UILabel!
    //MARK: - Variables
     
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper Functions
    
    func setData(review:Review){
        
        labelTitle.text = review.review ?? ""
        labelName.text = review.user?.name ?? ""
        
        labelDate.text = Util.getDateFrom(timeStampInString: "\(review.createdAt ?? 0)", format: "dd MMMM yyyy")
        
        let imagePath = review.user?.profilePic ?? ""
        imageViewProfile.setIndicatorStyle(.gray)
        imageViewProfile.setShowActivityIndicator(true)
        imageViewProfile.downloadImage(url: imagePath)
        
        ratingView.rating = Double(review.rating ?? "") ?? 0
    }
    
}
