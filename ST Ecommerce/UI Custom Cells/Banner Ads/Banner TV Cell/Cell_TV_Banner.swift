//
//  Cell_TV_Banner.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 15/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Banner: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    private var timer : Timer?
    var controller: UIViewController!
    private var banners = [Banner]()
    private let cellId = "Cell_CV_Banner"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
    }
    
    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = 0
        pageControl.hidesForSinglePage = true
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
    }
    
    func setData(banners: [Banner]) {
        self.banners = banners
        setupCollectionView()
        setupPageControl()
        pageControl.numberOfPages = self.banners.count
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
    
}



extension Cell_TV_Banner: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let banner = self.banners[indexPath.row]
        switch banner.targetType {
        case .restaurantBranch: goToRestaurantBranch(item: banner)
        case .product: goToProductDetail(item: banner)
        case .brand: goToBrand(item: banner)
        case .link: openLink(item: banner)
        case .shop: goToShop(item: banner)
        default: break
        }
    }
    
    private func goToProductDetail(item: Banner) {
        if let slug = item.value {
            let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.slug = slug
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func goToRestaurantBranch(item: Banner) {
        if let slug = item.value {
            let vc = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
            vc.slug = slug
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func goToBrand(item: Banner) {
        guard let slug = item.value,
              let vc = storyboardBrandDetail.instantiateViewController(withIdentifier: "VC_BrandDetail") as? VC_BrandDetail
        else { return }
        vc.brandId = slug
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openLink(item: Banner) {
        guard let url = item.value else {
            return
        }
        let vc = webViewStoryboard.instantiateViewController(withIdentifier: "VC_WebView") as! VC_WebView
        
        vc.url = url
        vc.titleText = item.label
        vc.controller = self.controller
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToShop(item: Banner) {
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        var shop = Shop()
        shop.slug = item.value
        vc.shopSlug = item.value
        vc.shop = shop
        self.controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? Cell_CV_Banner else {
            return UICollectionViewCell() }
        cell.setupData(banner: banners[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frame.size.width - 32
        let height = width * (186 / 376)
        return CGSize(width: width + 32, height: height + 32)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
}



extension Cell_TV_Banner {
    
    
    func startTimer() {
        stopTimer()
        timer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func scrollAutomatically(_ timer: Timer) {
        for cell in collectionView.visibleCells {
            let indexPath: IndexPath? = collectionView.indexPath(for: cell)
            if ((indexPath?.row)! < self.banners.count - 1){
                let indexPath1: IndexPath?
                indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                
                collectionView.scrollToItem(at: indexPath1!, at: .right, animated: true)
            }
            else{
                let indexPath1: IndexPath?
                indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                collectionView.scrollToItem(at: indexPath1!, at: .left, animated: true)
            }
        }
        
    }
    
}
