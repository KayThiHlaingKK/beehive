//
//  Cell_TV_ProductRow.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 15/11/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_ProductRow: UITableViewCell {

    @IBOutlet weak var itemCollectionView: UICollectionView!

    private var categories = [ShopCategory]()
    private var products = [Product]()
    private var shops = [Shop]()
    private var brands = [Brand]()
    private var allProducts = [Product]()
    private var currentCellType = CellType.Cell_CV_ProductCategory
    weak var controller: UIViewController!
    var currentIndexPath: IndexPath!
    var type = ""

    private var shopSlug: String?

    private enum CellType: String, CaseIterable {
        case Cell_CV_ProductCategory, Cell_CV_ProductHome, Cell_CV_SquareShop, Cell_CV_Brand, Cell_CV_AllProducts
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func setData(categories: [ShopCategory]) {
        currentCellType = .Cell_CV_ProductCategory
        self.setupCollectionView()
        self.categories = categories
        self.itemCollectionView.reloadData()
    }

    func setData(shopSlug: String?, categories: [ShopCategory]) {
        guard let shopSlug = shopSlug else {
            return
        }

        self.shopSlug = shopSlug
        self.categories = categories
        self.currentCellType = .Cell_CV_ProductCategory
        self.setupCollectionView()
        self.categories = categories
        self.itemCollectionView.reloadData()
    }

    func setData(products: [Product]) {
        currentCellType = .Cell_CV_ProductHome
        self.setupCollectionView()
        self.products = products
        self.itemCollectionView.reloadData()

    }


    func setData(shops: [Shop]) {
        currentCellType = .Cell_CV_SquareShop
        self.setupCollectionView()
        self.shops = shops
        self.itemCollectionView.reloadData()
    }


    func setData(brands: [Brand]) {
        currentCellType = .Cell_CV_Brand
        self.setupCollectionView()
        self.brands = brands
        self.itemCollectionView.reloadData()
    }


    func setData(allProducts: [Product]) {
        currentCellType = .Cell_CV_AllProducts
        self.setupCollectionView()
        self.allProducts = allProducts
        self.itemCollectionView.reloadData()
    }


    private func setupCollectionView() {
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self

        CellType.allCases.forEach {
            if $0 != .Cell_CV_AllProducts {
            itemCollectionView.register(UINib(nibName: $0.rawValue, bundle: nil), forCellWithReuseIdentifier: $0.rawValue)
            }
        }

    }

}

extension Cell_TV_ProductRow: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch currentCellType {
        case .Cell_CV_ProductHome: return createProductCell(indexPath: indexPath)
        case .Cell_CV_ProductCategory: return createCategoryCell(indexPath: indexPath)
        case .Cell_CV_SquareShop: return createShopCell(indexPath: indexPath)
        case .Cell_CV_Brand: return createBrandCell(indexPath: indexPath)
        case .Cell_CV_AllProducts: return createAllProductCell(indexPath: indexPath)
        }
    }

    private func createCategoryCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: currentCellType.rawValue, for: indexPath) as! Cell_CV_ProductCategory
        cell.setData(category: categories[indexPath.item])
        return cell
    }

    private func createShopCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: currentCellType.rawValue, for: indexPath) as! Cell_CV_SquareShop
        cell.setData(shop: shops[indexPath.item])
        return cell
    }

    private func createProductCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: currentCellType.rawValue, for: indexPath) as! Cell_CV_ProductHome
        cell.indexPath = IndexPath(item: indexPath.item, section: self.currentIndexPath.section)
        cell.controller = self.controller
        cell.setData(product: products[indexPath.item])
        return cell
    }

    private func createBrandCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: currentCellType.rawValue, for: indexPath) as! Cell_CV_Brand
        cell.setData(brand: brands[indexPath.item])
        return cell
    }

    private func createAllProductCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: CellType.Cell_CV_ProductHome.rawValue, for: indexPath) as! Cell_CV_ProductHome
        cell.indexPath = IndexPath(item: indexPath.item + (currentIndexPath.row * 2), section: self.currentIndexPath.section)
        cell.controller = self.controller
        cell.setData(product: allProducts[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentCellType {
        case .Cell_CV_ProductHome: return products.count
        case .Cell_CV_ProductCategory: return categories.count
        case .Cell_CV_SquareShop: return shops.count
        case .Cell_CV_Brand: return brands.count
        case .Cell_CV_AllProducts: return allProducts.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        let productCellWidthRatio : CGFloat = 2.3
        let width = screenWidth / productCellWidthRatio

        switch currentCellType {
        case .Cell_CV_ProductCategory: return CGSize(width: collectionView.frame.width / 3 - 30, height: 140)
        case .Cell_CV_ProductHome: return CGSize(width: collectionView.frame.width / 2 - 30, height: width*1.6)
        case .Cell_CV_SquareShop: return CGSize(width: 150, height: 200)
        case .Cell_CV_Brand: return CGSize(width: 172, height: 150)
        case .Cell_CV_AllProducts:
            let cellWidth = (screenWidth - 25) / 2
            let cellHeight = cellWidth*1.6
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let index = indexPath.row
        switch currentCellType {
        case .Cell_CV_AllProducts: goToDetail(room: index, productList: allProducts)
        case .Cell_CV_ProductHome: goToDetail(room: index, productList: products)
        case .Cell_CV_ProductCategory: goToProductList(room: index)
        case .Cell_CV_Brand: goToBrandDetail(index: index)
        case .Cell_CV_SquareShop: goToShop(index: index)
    }

}

    func goToProductList(room: Int) {
        let vc = storyboardStoreSearch.instantiateViewController(withIdentifier: "VC_Store_Search") as! VC_Store_Search
        vc.type = StoreProduct.viewAll
        vc.categoryName = self.categories[room].name ?? ""

        if let productId = self.categories[room].slug {
            vc.categorySlug = productId
            vc.shopSlug = self.shopSlug
            controller.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func goToBrandDetail(index: Int) {
        let vc = storyboardBrandDetail.instantiateViewController(withIdentifier: "VC_BrandDetail") as! VC_BrandDetail
        vc.brandId = self.brands[index].slug
        controller.navigationController?.pushViewController(vc, animated: true)
    }

    func goToDetail(room: Int, productList: [Product]) { //(indexPath: IndexPath) {
        print("Deselct")
        if type == "shop" {
            guard let controller = controller as? ShopViewController,
            let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
            else { return }


            vc.fromCart = controller.fromCart
            if let productId = productList[room].slug {
                vc.slug = productId
                controller.navigationController?.pushViewController(vc, animated: true)
            }

        }else if type == "contentShop"{
            guard let controller = controller as? ContentViewController,
            let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
            else { return }


            vc.fromCart = controller.fromCart

            if let productId = productList[room].slug {
                vc.slug = productId
                controller.navigationController?.pushViewController(vc, animated: true)
            }

        }
        else {

            guard let controller = controller as? VC_Store,
            let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
            else { return }


            vc.fromCart = controller.fromCart
//            let data = products.count > 0 ? products : allProducts
            if let productId = productList[room].slug {
                vc.slug = productId
                controller.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func goToDetail(room: Int) { //(indexPath: IndexPath) {

        if type == "shop" {
            guard let controller = controller as? ShopViewController,
            let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
            else { return }


            vc.fromCart = controller.fromCart
            let data = products.count > 1 ? products : allProducts

            if let productId = data[room].slug {
                vc.slug = productId
                controller.navigationController?.pushViewController(vc, animated: true)
            }

        }
        else {

            guard let controller = controller as? VC_Store,
            let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
            else { return }


            vc.fromCart = controller.fromCart
            let data = products.count > 0 ? products : allProducts

            if let productId = data[room].slug {
                vc.slug = productId
                controller.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    private func goToShop(index: Int) {
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        vc.shop = shops[index]
        controller.navigationController?.pushViewController(vc, animated: true)
    }

}
