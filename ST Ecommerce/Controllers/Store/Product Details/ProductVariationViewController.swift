//
//  ProductVariationViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 24/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import AudioToolbox


class ProductVariationViewController: UIViewController {
    
    var productDetailViewController: ProductDetailViewController!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var minusImage: UIImageView!
    @IBOutlet weak var plusImage: UIImageView!
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var disableLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    @IBOutlet weak var variationTableView: UITableView!
    @IBOutlet weak var discountHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var continuebtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    var chooseVariantArray: [Variants] = []
    var productVariant: ProductVariant?
    var variants: [DefaultVariant] = []
    var imagePath = ""
    var selectedSizeStr = ""
    var selectedColorStr = ""
    
    //33DA773F
    
    override func viewDidLoad() {
        jcgvSlugCheck()
        setupUI()
      
        
    }
    
    fileprivate func jcgvSlugCheck(){
        let productDetail = self.productDetailViewController.productDetails
        let slug = productDetail?.slug ?? ""
        if  slug == "A3E89A16"{
            minusBtn.isUserInteractionEnabled = false
            plusBtn.isUserInteractionEnabled = false
            minusBtn.tintColor = .gray
            plusBtn.tintColor = .gray
            minusImage.tintColor = .gray
            plusImage.tintColor = .gray
        }else{
            minusBtn.isUserInteractionEnabled = true
            plusBtn.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func setupUI(){
        getDefautlList()
        disableLbl.isHidden = true
        priceLbl.isHidden = false
        variationTableView.dataSource = self
        variationTableView.delegate = self
        variationTableView.reloadData()
        
        outerView.roundCorners(corners: [.topRight, .topLeft], amount: 20)
        priceView.roundCorners(corners: [.topRight, .topLeft], amount: 20)
        
        let productDetail = self.productDetailViewController.productDetails
        
        if let images = productDetail?.images,
           images.count > 0 {
            imagePath = "\(images[0].url ?? "")?size=thumbnail"
            productImageView.downloadImage(url: imagePath, fileName: images[0].file_name, size: .thumbnail)
        }
       
        priceLbl.text = "\(priceFormat(pricedouble: productDetail?.price ?? 0.0))\(currencySymbol)"
       
        if productDetail?.discount != 0 {
            print("yes discount ==  ")
            discountLbl.isHidden = false
            discountHeightConstraint.constant = 30
                
            let discount = productDetail?.discount ?? 0
            let orgPrice = productDetail?.price ?? 0
            let actualPrice = orgPrice - discount
            
            let mutableAttributedString = NSMutableAttributedString()
            let attributedString = NSAttributedString(string: "\(priceFormat(pricedouble: orgPrice))\(currencySymbol)").withStrikeThrough()
            let yousave = NSAttributedString(string: "You save : ")
            mutableAttributedString.append(yousave)
            mutableAttributedString.append(attributedString)
            discountLbl.attributedText = mutableAttributedString
            
            let act = Int(actualPrice)
            priceLbl.text = "\(priceFormat(price: act))\(currencySymbol)"
            
        }
    
        
    }
    
    
    @IBAction func plusClicked(_ sender: UIButton) {
        if self.chooseVariantArray.count > 0 {
            print(self.productVariant?.qty ?? 1)
            let qty = self.productVariant?.qty ?? 1
            print(qty)
            let new = qty + 1
            self.productVariant?.qty = new
            print(new)
            countLbl.text = "\(new)"
        }
        
    }
        
    @IBAction func minusClicked(_ sender: UIButton) {
        if self.chooseVariantArray.count > 0 {
            let qty = self.productVariant?.qty ?? 1
            if qty > 1 {
                let new = qty - 1
                self.productVariant?.qty = new
                countLbl.text = "\(new)"
            }
        }
        
    }
    
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToCartBtnClicked(_ sender: UIButton) {
        self.productDetailViewController.chooseProductVariant = self.productVariant
        self.productDetailViewController.addToCartStore()
        self.dismiss(animated: true, completion: nil)

    }
    
    
}

extension ProductVariationViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("variant count = ", self.productDetailViewController.productDetails?.variants?.count ?? 0)
        return self.productDetailViewController.productDetails?.variants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let p = self.productDetailViewController.productDetails?.variants?[indexPath.row]
        
        if p?.ui ?? "" == "image"{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Variant_Image") as! Cell_Variant_Image
            cell.controller = self
            cell.selectionStyle = .none
            cell.variants = p ?? Variants()
            cell.collectionViewSetUP()
            
            cell.variantRoom = indexPath.row
            cell.productVariants = self.productDetailViewController.productDetails?.product_variants
            cell.variants.selectedValue = p?.values_?[0].value
            chooseVariants(name: p?.name ?? "", value: p?.values_?[0].value ?? "")
            cell.variantNameLbl.text = "\(p?.name ?? "") : \(p?.values_?[0].value ?? "")"
            cell.variantImageCollectionView.reloadData()
            return cell
            
        }
        else if p?.ui ?? "" == "button"{
            print("it is button")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Variant_Button") as! Cell_Variant_Button
            cell.controller = self
            cell.selectionStyle = .none
            cell.variantRoom = indexPath.row
            
            cell.productVariants = self.productDetailViewController.productDetails?.product_variants
            cell.variants = p ?? Variants()
            cell.variants.selectedValue = p?.values_?[0].value
            cell.collectionViewSetUP()
            chooseVariants(name: p?.name ?? "", value: p?.values_?[0].value ?? "")
            cell.variantNameLbl.text = "\(p?.name ?? "") : \(p?.values_?[0].value ?? "")"
            cell.variantBtnCollectionView.reloadData()
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let p = self.productDetailViewController.productDetails?.variants?[indexPath.row]
        if p?.ui ?? "" == "image"{
            return 200
        }
        else if p?.ui ?? "" == "button"{
            print("height = 100")
            return 200
        }
        return 100
    }
        
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}


extension ProductVariationViewController {
    // MARK: Get DefaultList
    func getDefautlList() {
        let productLists = self.productDetailViewController.productDetails?.variants
        productLists?.forEach({ variants in
            let variantsList = DefaultVariant(name: variants.name ?? "", value: variants.values_?[0].value ?? "")
            self.variants.append(variantsList)
            
        })
    }
    
    // MARK: Filter For SelectedType
    func chooseVariants(name: String, value: String, positin: Int = 0) {
        self.variants.enumerated().map { (index,item) in
            if item.name == name {
                let test = DefaultVariant(name: name, value: value)
                self.variants[index] = test
            }
        }
//        print(self.variants)
        let productListsFilter = self.productDetailViewController.productDetails?.product_variants?.filter{ $0.variant == self.variants}
//        print(productListsFilter?.first?.is_enable)
        self.productVariant = productListsFilter?.first
        continuebtn.isUserInteractionEnabled = productListsFilter?.first?.is_enable ?? false
        continuebtn.backgroundColor = productListsFilter?.first?.is_enable ?? false ? .systemYellow : .gray
        if productListsFilter?.first?.discount == 0 {
            discountLbl.isHidden = true
            discountHeightConstraint.constant = 0
            if let price = productListsFilter?.first?.price {
                self.priceLbl.text = "\(priceFormat(pricedouble: price ))\(currencySymbol)"
            }
        }
        else {
            
            discountLbl.isHidden = false
            discountHeightConstraint.constant = 30
            
            let discount = productListsFilter?.first?.discount ?? 0
            let orgPrice = productListsFilter?.first?.price ?? 0
            let actualPrice = orgPrice - discount
            
            let mutableAttributedString = NSMutableAttributedString()
            let attributedString = NSAttributedString(string: "\(priceFormat(pricedouble: orgPrice))\(currencySymbol)").withStrikeThrough()
            let yousave = NSAttributedString(string: "You save : ")
            mutableAttributedString.append(yousave)
            mutableAttributedString.append(attributedString)
            discountLbl.attributedText = mutableAttributedString
            
            let act = Int(actualPrice)
            priceLbl.text = "\(priceFormat(price: act))\(currencySymbol)"
            
        }
    }

}

    
    

