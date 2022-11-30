//
//  Cell_CV_Announcement.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 06/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import Down

class Cell_CV_Announcement: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    
    func setupData(announcement: Announcement) {
        titleLabel.text = announcement.title
        let down = Down(markdownString: announcement.description ?? "")
        do {
            descriptionLabel.attributedText = try down.toAttributedString()
        } catch {
            descriptionLabel.text = announcement.description
        }
        
        dateLabel.text = announcement.createdAt?.convertStringToDate()
        if let firstImage = announcement.covers?.first {
            imageView.downloadImage(url: firstImage.url, fileName: announcement.covers?.first?.fileName, size: .medium)
        } else {
            imageView.image = UIImage(named: "placeholder2")
        }
    }
    
}
