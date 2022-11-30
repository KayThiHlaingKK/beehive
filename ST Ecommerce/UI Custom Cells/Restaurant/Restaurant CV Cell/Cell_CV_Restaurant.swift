//
//  Cell_CV_Restaurant.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 15/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//


import UIKit
import Lottie
import Alamofire

class Cell_CV_Restaurant: UICollectionViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    
    @IBOutlet weak var favoriteButton: RoundedView!
    private var isFavorite = false
    var serviceAnnouncement: ServiceAnnouncement?
    var indexPath: IndexPath!
    weak var favoriteDelegate: FavoriteListener?
    private var restaurantBranch: RestaurantBranch!
    
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        layer.cornerRadius = 5
        clipsToBounds = true
        favoriteButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        favoriteButton.addGestureRecognizer(tapGesture)
    }
    
    func setupData(restaurantBranch: RestaurantBranch) {
        self.restaurantBranch = restaurantBranch
        self.isFavorite = restaurantBranch.restaurant?.is_favorite ?? false
        var nameText = ""
        if let name = restaurantBranch.restaurant?.name {
            nameText = name
            if let place = restaurantBranch.name {
                nameText += " (\(place))"
            }
        }
        titleLabel.text = nameText
        let tip: Double = restaurantBranch.distance ?? 0.0
        let tipText: String = String(format: "%.2f", tip)
        subtitleLabel.text = "\(tipText) km away"
        
        if let firstImage = restaurantBranch.restaurant?.covers?.first {
            let imageUrl = "\(firstImage.url!)?size=small"
            imageView.downloadImage(url: imageUrl, fileName: firstImage.file_name, size: .small)
        }
        else {
            imageView.image = UIImage(named: "placeholder2")
        }
        

        
        if let rating = restaurantBranch.restaurant?.rating {
            ratingLabel.text = "\(rating)"
            ratingLabel.isHidden = false
            ratingImage.isHidden = false
        } else {
            ratingLabel.isHidden = true
            ratingImage.isHidden = true
        }
        checkServiceAvailability()
        checkIsFavorite()
    }
    
    @objc private func toggleFavorite() {
        guard let slug = restaurantBranch.restaurant?.slug else { return }
        let apiStr: String = "\(APIEndPoint.restaurant.caseValue)\(slug)/favorites"
        favoriteButton.isUserInteractionEnabled = false
        
        APIUtils.APICall(postName: apiStr, method: isFavorite ? .delete: .post,  parameters: [String:Any](), controller: nil, onSuccess: { (response) in
            DispatchQueue.main.async {
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
            
                if status == 200 {
                    self.isFavorite = !self.isFavorite
                    self.checkIsFavorite()
                    self.favoriteDelegate?.isFavorited(index: self.indexPath.item, productType: .suggestionsProduct, isFavourite: self.isFavorite)
                }
                
                self.favoriteButton.isUserInteractionEnabled = true
            }
        }) { (reason, statusCode) in
        }
    }
    
    private func checkIsFavorite() {
        self.favoriteButton.backgroundColor = self.isFavorite ? #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    private func checkServiceAvailability() {
        let isAvailable = serviceAnnouncement?.restaurant_service ?? true
        overlayView.isHidden = isAvailable
    }
}


