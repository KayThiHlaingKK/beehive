//
//  Cell_TV_Home_Offers.swift
//  ST Ecommerce
//
//  Created by necixy on 13/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Home_Offers: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionViewHomeOffers: UICollectionView!
    
    @IBOutlet weak var pageController: UIPageControl!
        
    //MARK: - Variables
    var controller:VC_Home!
    
    var timer : Timer?
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        NSLayoutConstraint.activate([
            collectionViewHomeOffers.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            collectionViewHomeOffers.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Supporting functions
    func configurePageView(){
        pageController.numberOfPages = self.controller.banner.count
        pageController.currentPage = 0
        pageController.hidesForSinglePage = true
        pageController.tintColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        pageController.pageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pageController.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
        
    }
    
    func startTimer() {

         timer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {

        if timer != nil {
            timer?.invalidate()
            timer = nil
           
        }
    }
    
    
    @objc func scrollAutomatically(_ timer1: Timer) {

        if let coll  = collectionViewHomeOffers {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < self.controller.banner.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)

                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }

            }
        }
    }
}


//MARK: - CollectionView Functions
extension Cell_TV_Home_Offers : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectionViewHomeOffers.dataSource = self
        collectionViewHomeOffers.delegate = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.banner.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Home_Offers", for: indexPath) as? Cell_CV_Home_Offers else { return UICollectionViewCell() }
        if indexPath.row < self.controller.banner.count {
            let bannerImagePath = self.controller.banner[indexPath.row]

            cell.setData(bannerImage: bannerImagePath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = width * (186 / 376)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.controller.banner[indexPath.item]
        switch item.targetType {
        case .product: goToProductDetail(item: item)
        case .restaurantBranch: goToRestaurantBranch(item: item)
        case .brand: goToBrand(item: item)
        case .link: openLink(item: item)
        case .shop: goToShop(item: item)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageController.currentPage = indexPath.row
    }
}



// MARK: - Navigation Functions

extension Cell_TV_Home_Offers {
   
    
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
}
