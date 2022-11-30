//
//  Cell_CV_Product_Image.swift
//  ST Ecommerce
//
//  Created by necixy on 25/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Product_Image: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageViewBanner: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private var timer : Timer?
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = 0
        pageControl.hidesForSinglePage = true
        pageControl.backgroundColor = .clear
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
    }
    
    //MARK: - Helper Functions
       func setData(productImage:Images){

           imageViewBanner.setIndicatorStyle(.gray)
           imageViewBanner.setShowActivityIndicator(true)
           
           print("image url == ", productImage.url)
           imageViewBanner.downloadImage(url: productImage.url, fileName: productImage.file_name, size: .large)

       }
    
}
