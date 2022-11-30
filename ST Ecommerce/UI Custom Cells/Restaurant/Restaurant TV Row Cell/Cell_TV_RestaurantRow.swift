//
//  Cell_TV_RestaurantRow.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 18/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_RestaurantRow: UITableViewCell {
    
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var backgroundGradient: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var coditionLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var favoriteButton: RoundedView!
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var temporaryCloseLabel: UILabel!
    
    private var tags = ["Rice", "Bubble Tea"]
    
    @IBOutlet weak var preorderView: UIView!
    @IBOutlet weak var preorderLabel: UILabel!
    @IBOutlet weak var openingTimeLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    private var restaurantBranch: RestaurantBranch!
    private var isFavorite = false
    var controller: VC_Restaurant!
    var serviceAnnouncement: ServiceAnnouncement?
    var searchController: VC_Food_Search!
    var option = "restaurant"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        restaurantImage.layer.cornerRadius = 5
        restaurantImage.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite))
        favoriteButton.addGestureRecognizer(tapGesture)
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        
        titleLabel.text = restaurantBranch.restaurant?.name?.trunc(length: 18)
        locationLabel.text = restaurantBranch.name?.trunc(length: 20)
        let tip: Double = restaurantBranch.distance ?? 0.0
        let tipText: String = String(format: "%.2f", tip)
        coditionLabel.text = "\(tipText) km"
        coditionLabel.textColor = UIColor.gray
        if let firstImage = restaurantBranch.restaurant?.images?.first {
            restaurantImage.downloadImage(url: firstImage.url, fileName: firstImage.file_name, size: .xsmall)
            restaurantImage.isHidden = false
            titleTrailingConstraint.constant = frame.size.width - (frame.size.height + 48)
        } else {
            restaurantImage.isHidden = true
            titleTrailingConstraint.constant = 32
        }
        
        checkIsFavorite()
        checkServiceAvailability()
        checkOpeningTimeAndPreorder()
        
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
                openingTimeLabel.text = "Open At: \(timeText)"
            } else {
                let timeText = prepareTextForOpeningLabel(timeText: closingTime)
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
    
    private func checkServiceAvailability() {
        let isAvailable = serviceAnnouncement?.restaurant_service ?? true
        if isAvailable == false {
            openingTimeLabel.isHidden = true
            preorderView.isHidden = true
            coditionLabel.isHidden = true
        }
        overlayView.isHidden = isAvailable
        overlayView.backgroundColor = !isAvailable ? .init(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.5): .clear
        temporaryCloseLabel.isHidden = isAvailable
        backgroundGradient.backgroundColor = !isAvailable ? .init(red: 67/255, green: 67/255, blue: 67/255, alpha: 0.5) : .white
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
            if option == "search" {
                self.searchController.showNeedToLoginApp()
            }  else {
                self.controller?.showNeedToLoginApp()
            }
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
                }
                self.favoriteButton.isUserInteractionEnabled = true
            }
        }) { (reason, statusCode) in
            if statusCode == 401 {
                if self.option == "search" {
                    self.searchController.showNeedToLoginApp()
                }  else {
                    self.controller?.showNeedToLoginApp()
                }
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
