//
//  Cell_CV_RestaurantRow.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 07/12/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

protocol Cell_CV_RestaurantRowDelegate: class {
    func isFavorite(indexPath: IndexPath, isFavorite: Bool)
}

class Cell_CV_RestaurantRow: UICollectionViewCell {
    
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coditionLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var favoriteButton: RoundedView!
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var preorderView: UIView!
//    @IBOutlet weak var preorderLabel: UILabel!
    @IBOutlet weak var openingTimeLabel: UILabel!
    //@IBOutlet weak var overlayView: RoundedView!
    @IBOutlet weak var overlayView: UIView!
    private var restaurantBranch: RestaurantBranch!
    private var isFavorite = false
    var serviceAnnouncement: ServiceAnnouncement?
    var indexPath: IndexPath!
    var controller: UIViewController!
    var favoriteDelegate: Cell_CV_RestaurantRowDelegate!
    @IBOutlet weak var cellOverLayView: RoundedView!
    @IBOutlet weak var temporaryCloseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        restaurantImage.layer.cornerRadius = 5
        restaurantImage.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        favoriteButton.addGestureRecognizer(tapGesture)
       
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
        titleLabel.text = ""
        locationLabel.text = ""
        coditionLabel.text = ""
        restaurantImage.image = nil
        isFavorite = false
        checkIsFavorite()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        favoriteButton.addGestureRecognizer(tapGesture)
    }
    
    func setData(restaurantBranch: RestaurantBranch) {
        self.restaurantBranch = restaurantBranch
        self.isFavorite = restaurantBranch.restaurant?.is_favorite ?? false
        
        titleLabel.text = restaurantBranch.restaurant?.name
        locationLabel.text = restaurantBranch.name
        coditionLabel.text = "\(round(restaurantBranch.distance! * 10) / 10.0) km away"
        coditionLabel.textColor = UIColor.gray
        if let firstImage = restaurantBranch.restaurant?.images?.first {
            restaurantImage.downloadImage(url: firstImage.url, fileName: firstImage.file_name, size: .xsmall)
            restaurantImage.isHidden = false
            titleTrailingConstraint.constant = frame.size.width - (frame.size.height + 48)
        } else {
            restaurantImage.image = UIImage(named: "placeholder2")
            restaurantImage.isHidden = true
            titleTrailingConstraint.constant = 32
        }
        checkIsFavorite()
        
        checkOpeningTimeAndPreorder()
        checkServiceAvailability()
    }
    
    private func checkServiceAvailability() {
        let isAvailable = serviceAnnouncement?.restaurant_service ?? true
        if isAvailable == false {
            openingTimeLabel.isHidden = true
            preorderView.isHidden = true
            coditionLabel.isHidden = true
        }
        overlayView.backgroundColor = !isAvailable ? .init(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.5): .clear
        temporaryCloseLabel.isHidden = isAvailable
        cellOverLayView.isHidden = isAvailable
    }
    
    private func checkOpeningTimeAndPreorder() {
        guard let openingTime = restaurantBranch.opening_time,
              let closingTime = restaurantBranch.closing_time
        else { return }
        let preorder = restaurantBranch.pre_order ?? true
        let instantOrder = restaurantBranch.instant_order ?? true
        
        let openingTimeString = removeColmn(string: openingTime)
        let closingTimeString = removeColmn(string: closingTime)
        let currentTimeString = removeColmn(string: getCurrentTime())
        
        let beforeOpeningTime = currentTimeString <= openingTimeString
        let afterClosingTime = currentTimeString >= closingTimeString
        
        
        preorderView.isHidden = true
        
        if beforeOpeningTime || afterClosingTime {
            overlayView.isHidden = false
            openingTimeLabel.isHidden = false
            
            if beforeOpeningTime {
                let timeText = prepareTextForOpeningLabel(timeText: openingTime)
//                let amPm = (Int(openingTimeString) ?? 0) > 120000 ? "PM" : "AM"
                openingTimeLabel.text = "Open At: \(timeText)"
            } else {
                let timeText = prepareTextForOpeningLabel(timeText: closingTime)
//                let amPm = (Int(closingTimeString) ?? 0) > 120000 ? "PM" : "AM"
                openingTimeLabel.text = "Closed At: \(timeText)"
            }
            preorderView.isHidden = !(preorder)
            coditionLabel.textColor = UIColor.red
            
        } else {
            overlayView.isHidden = true
            openingTimeLabel.isHidden = true
            if !(instantOrder) {
                overlayView.isHidden = !(preorder)
                preorderView.isHidden = !(preorder)
                coditionLabel.textColor = UIColor.red
            }
        }
        
    }
    
    private func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        
        var hour = String(calendar.component(.hour, from: date))
        var minutes = String(calendar.component(.minute, from: date))
        var seconds = String(calendar.component(.second, from: date))
        var timeString = "9:15:00"
            
        if hour.count <= 1 {
            hour = "0\(hour)"
        }
        if minutes.count <= 1 {
            minutes = "0\(minutes)"
        }
        if seconds.count <= 1 {
            seconds = "0\(seconds)"
        }
        timeString = "\(hour):\(minutes):\(seconds)"
        return timeString
    }
    
    private func removeColmn(string: String) -> String {
        string.replacingOccurrences(of: ":", with: "")
    }
    
    private func prepareTextForOpeningLabel(timeText: String) -> String {
        let timeString = getHourString(timeText)
        openingTimeLabel.isHidden = false
        return timeString
    }
    
    private func createTagLabel(tag: String) -> UILabel {
        let label = UILabel()
        label.text = tag
        label.numberOfLines = 1
        label.textColor = .black
        label.backgroundColor = UIColor(red: 255/255, green: 187/255, blue: 0/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func isEnoughSpace(for size: CGSize) -> Bool {
        let imageWidth = restaurantImage.frame.size.height - 16
        return imageWidth > size.width
    }
    
    
    @objc private func toggleFavorite() {
        guard let slug = restaurantBranch.restaurant?.slug else { return }
        let apiStr: String = "\(APIEndPoint.restaurant.caseValue)\(slug)/favorites"
        guard self.controller.readLogin() != 0 else {
            self.controller?.showNeedToLoginApp()
            return
        }
        
        favoriteButton.isUserInteractionEnabled = false
        APIUtils.APICall(postName: apiStr, method: isFavorite ? .delete: .post,  parameters: [String:Any](), controller: nil, onSuccess: { (response) in
            
            DispatchQueue.main.async {
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                
                if status == 200 {
                    self.isFavorite = !self.isFavorite
                    self.checkIsFavorite()
                    self.favoriteDelegate.isFavorite(indexPath: self.indexPath, isFavorite: self.isFavorite)
                }
                self.favoriteButton.isUserInteractionEnabled = true
            }
        }) { (reason, statusCode) in
            if statusCode == 401 {
                self.controller?.showNeedToLoginApp()
            }
        }
    }
    
    private func checkIsFavorite() {
        self.favoriteButton.backgroundColor = self.isFavorite ? #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    private func isOpening() {
        
    }
        
    private func stringToDate(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "hh:mm:ss"
        dateFormatter.locale = .current
        return dateFormatter.date(from: string)
    }
    
    func stringTimeToInt(time: String) -> Int {
        Int(time.replacingOccurrences(of: ":", with: "")) ?? 0
    }
}
