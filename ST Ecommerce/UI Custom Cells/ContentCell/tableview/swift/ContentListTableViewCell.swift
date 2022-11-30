//
//  ContentListTableViewCell.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/14/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class ContentListTableViewCell: UITableViewCell {

    @IBOutlet weak var contentListCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var data : Announcement?{
        didSet{
            if let _ = data {
                pageControl.numberOfPages = data?.covers?.count ?? 0
                contentListCollectionView.reloadData()
            }
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    fileprivate func setupCollectionView(){
        contentListCollectionView.delegate = self
        contentListCollectionView.dataSource = self
        contentListCollectionView.registerCell(type: ContentImageCollectionViewCell.self)
    }
    
}

extension ContentListTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data?.covers?.count == 0 {
            return 1
        }else{
            return data?.covers?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentImageCollectionViewCell.identifier, for: indexPath)as? ContentImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let annoucementData = data {
            cell.data = annoucementData.covers?[indexPath.row]
        }
        return cell
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

extension ContentListTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
}
