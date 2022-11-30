//
//  Cell_Foods_Search.swift
//  ST Ecommerce
//
//  Created by JASWANT SINGH on 11/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_Foods_Search: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var openLbl: UILabel!
    
    var restaurant : RestaurantBranch?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(){
        if let images = restaurant?.restaurant?.images,
           images.count > 0 {
            let imagePathItem = "\(images.first?.url ?? "")?size=thumbnail"
            imgView.setIndicatorStyle(.gray)
            imgView.setShowActivityIndicator(true)
            imgView.downloadImage(url: imagePathItem, fileName: images.first?.file_name, size: .xsmall)
        }
        
        if let resName = restaurant?.restaurant?.name, let branchName = restaurant?.name {
            nameLbl.text = "\(resName) (\(branchName))"
        }
        
        //categoryLbl.text = restaurant?.excerpt
        timeLbl.text = "\(restaurant?.opening_time ?? "") - \(restaurant?.closing_time ?? "")"
        addressLbl.text = "\(restaurant?.address ?? "")"
        
        let date = Date()
        dateFormatter.dateFormat = "HH:mm:ss"
                
        let openingTime_DateFormat = dateFormatter.date(from: restaurant?.opening_time ?? "") ?? Date()
        let closingTime_DateFormat = dateFormatter.date(from: restaurant?.closing_time ?? "") ?? Date()
        
       
        let currentTime = 60*Calendar.current.component(.hour, from: date) + Calendar.current.component(.minute, from: date)
        let openingTime =  60*Calendar.current.component(.hour, from: openingTime_DateFormat) + Calendar.current.component(.minute, from: openingTime_DateFormat)
        let closingTime =  60*Calendar.current.component(.hour, from: closingTime_DateFormat) + Calendar.current.component(.minute, from: closingTime_DateFormat)
        
        openView.isHidden = true
        if currentTime < openingTime {
            openView.isHidden = false
            if let openTime = restaurant?.opening_time {
                openLbl.text = "Open at : \(openTime)"
            }
        }
        if currentTime > closingTime {
            openView.isHidden = false
            if let closeTime = restaurant?.closing_time {
                openLbl.text = "Close at : \(closeTime)"
            }
        }
        
    }
}
