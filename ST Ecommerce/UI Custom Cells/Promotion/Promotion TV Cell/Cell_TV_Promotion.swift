//
//  Cell_TV_Promotion.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 06/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Promotion: UITableViewCell {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // MARK: - Properties
    var controller: UIViewController!
    private let cellId = "Cell_CV_Promotion"
    private var promotions = [Promotion]()
    
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    // MARK: - Setup Funtions
    
    func setData(promotions: [Promotion]) {
        self.promotions = promotions
        setupCollectionView()
    }
    
    func setupCollectionView() {
        backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
}




extension Cell_TV_Promotion: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? Cell_CV_Promotion else {
            return UICollectionViewCell()
        }
        cell.setupData(promotion: promotions[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        promotions.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = promotions[indexPath.item]
        
        switch item.targetType {
        case .shop: goToShopDetail(item: item)
        case .product: goToProductDetail(item: item)
        case .restaurantBranch: goToRestaurantBranch(item: item)
            //            case .link: openLink(item: item)
        case .brand: goToBrandDetail(item: item)
        default: break
        }
        
    }
}

// MARK: - Navigation Functions

extension Cell_TV_Promotion {
  
    private func goToBrandDetail(item: Promotion) {
        guard let slug = item.value,
            let brandVC = storyboardBrandDetail.instantiateViewController(withIdentifier: "VC_BrandDetail") as? VC_BrandDetail else { return }
        brandVC.brandId = slug
        controller.navigationController?.pushViewController(brandVC, animated: true)
        
    }
    
    private func goToShopDetail(item: Promotion) {
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        var shop = Shop()
        shop.slug = item.value
        vc.shopSlug = item.value
        vc.shop = shop
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToProductDetail(item: Promotion) {
        let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.slug = item.value ?? ""
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToRestaurantDetail(item: Promotion) {
        let vc = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.slug = item.value ?? ""
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func goToRestaurantBranch(item: Promotion) {
        let vc = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.slug = item.value ?? ""
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openLink(item: Promotion) {
        let vc = webViewStoryboard.instantiateViewController(withIdentifier: "VC_WebView") as! VC_WebView
        
        vc.url = item.value
//        vc.titleText = item.
        vc.controller = self.controller
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
}
