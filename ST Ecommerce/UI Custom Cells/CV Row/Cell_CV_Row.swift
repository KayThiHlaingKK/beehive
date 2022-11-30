//
//  Cell_CV_Row.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 04/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_CV_Row: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var products = [Product]()
    var index: Int!
    var productType: ProductType!
    var controller: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "Cell_CV_ProductHome", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_ProductHome")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_ProductHome", for: indexPath) as? Cell_CV_ProductHome
        else { return UICollectionViewCell() }
        cell.productType = self.productType
        cell.indexPath = indexPath
        cell.index = indexPath.item
        cell.controller = self.controller
        cell.setData(product: products[indexPath.item])
        cell.favouriteListener = self
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func setupData(products: [Product]) {
        self.products = products
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        calculateSizeForProductCell()
    }
    
    func calculateSizeForProductCell() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = (screenWidth - (32 + 12 + 4)) / 2
        let cellHeight = (cellWidth*1.6) + 20
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let controller = controller as? ProductDetailViewController {
            controller.goToDetailView(product: products[indexPath.item])
        }
    }
}




extension Cell_CV_Row: FavoriteListener {
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        
        if let index = index {
            self.products[index].is_favorite = isFavourite
        }
    }
    
}
