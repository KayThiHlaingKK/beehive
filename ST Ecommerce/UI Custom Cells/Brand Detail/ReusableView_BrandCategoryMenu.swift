//
//  ReusableView_BrandCategoryMenu.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 22/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class ReusableView_BrandCategoryMenu: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    private var categories = [ShopCategory]()
    var selectedCategoryIndex = 0
    var controller: VC_BrandDetail?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "Cell_CV_CategoryMenuName", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell_CV_CategoryMenuName")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
    }
    
    func setData(categories: [ShopCategory]) {
        self.categories = categories
        
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_CategoryMenuName", for: indexPath) as! Cell_CV_CategoryMenuName
        cell.categoryNameLabel.text = categories[indexPath.item].name
        
        if selectedCategoryIndex == indexPath.item {
            cell.categoryNameLabel.textColor = UIColor().HexToColor(hexString: "#FFBB00")
            cell.lineView.isHidden = false
        }else {
            cell.categoryNameLabel.textColor = UIColor.darkGray
            cell.lineView.isHidden = true
        }

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (categories[indexPath.item].name!.width(withConstrainedHeight: 40, font: UIFont(name: "Lexend-Medium", size: 16)!))
        let height: CGFloat = 40
        return CGSize(width: width + 16, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.item
        controller?.loadProductsByCategory(index: selectedCategoryIndex)
    }


}
