//
//  Cell_TV_AnnouncementDetail.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 11/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import Down

class Cell_TV_AnnouncementDetail: UITableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var announcementImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyNowBtn: UIButton!
    
    
    
    // MARK: - LifeCycle Functions
    
    var controller: UIViewController!
    private var announcement: Announcement!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func orderNowButtonPressed(_ sender: UIButton) {
        switch announcement.targetType {
        case .product: goToProductDetail(item: announcement)
        case .restaurantBranch: goToRestaurantBranch(item: announcement)
        case .link: openLink(item: announcement)
        case .brand: goToBrand(item: announcement)
        case .shop: goToShop(item: announcement)
        case .collection : goToContentDetail(item: announcement)
        default: goToContentDetail(item: announcement)
        }
    }
    
    // MARK: - Initialization
    
    func setData(announcement: Announcement) {
        self.announcement = announcement
        titleLabel.text = announcement.title
        dateLabel.text = announcement.createdAt?.convertStringToDate()
        
        let down = Down(markdownString: announcement.description ?? "")
        do {
            descriptionLabel.attributedText = try down.toAttributedString()
        } catch let err {
            print("error in markdown=====\(err.localizedDescription)")
            descriptionLabel.text = announcement.description
        }
        
        if let firstImage = announcement.covers?.first {
            announcementImage.downloadImage(url: firstImage.url, fileName: firstImage.fileName, size: .medium)
        }
        else {
            announcementImage.downloadImage()
        }
    }
    
}


// MARK: - Navigation Functions

extension Cell_TV_AnnouncementDetail {
    
    private func goToContentDetail(item: Announcement){
        self.controller.navigationController?.pushView(ContentRouter(slug: item.slug ?? "",announcement: item))
    }
    
    private func goToProductDetail(item: Announcement) {
        let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.slug = item.value ?? ""
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToRestaurantBranch(item: Announcement) {
        let vc = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.slug = item.value ?? ""
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func goToBrand(item: Announcement) {
        guard let slug = item.value,
              let vc = storyboardBrandDetail.instantiateViewController(withIdentifier: "VC_BrandDetail") as? VC_BrandDetail
        else { return }
        vc.brandId = slug
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openLink(item: Announcement) {
        let vc = webViewStoryboard.instantiateViewController(withIdentifier: "VC_WebView") as! VC_WebView
        
        vc.url = item.value
        vc.titleText = item.label
        vc.controller = self.controller
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToShop(item: Announcement) {
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        var shop = Shop()
        shop.slug = item.value
        vc.shopSlug = item.value
        vc.shop = shop
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
}
