//
//  Cell_Variant_Image.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 24/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_Variant_Image: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var variantNameLbl: UILabel!
    @IBOutlet weak var variantImageCollectionView: UICollectionView!
    
    var variants = Variants()
    var productVariants: [ProductVariant]? = []
    var controller: ProductVariationViewController!
    var variantRoom = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
extension Cell_Variant_Image : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionViewSetUP(){
        print("imaeg ", variantRoom)
        variantImageCollectionView.dataSource = self
        variantImageCollectionView.delegate = self
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.variants.values_?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : Cell_CV_Variant_Image = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Variant_Image", for: indexPath) as! Cell_CV_Variant_Image
        
        cell.setData(image: self.variants.values_?[indexPath.row].image_slug ?? "")
        cell.imageBtn.addTarget(self, action: #selector(chooseVariation(sender:)), for: .touchUpInside)
        cell.imageBtn.tag = indexPath.row
        
        if self.variants.values_?[indexPath.row].value == self.variants.selectedValue {
            cell.variantImageView.layer.borderColor = UIColor().HexToColor(hexString: "#FFBB00").cgColor
            cell.variantImageView.layer.borderWidth = 1
        } else {
            cell.variantImageView.layer.borderWidth = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = variantImageCollectionView.frame.size.width/4
        //return CGSize(width: width, height: width/storeVCellHeightRatio)
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
    }

    @objc func chooseVariation(sender:UIButton){
        print("click " , sender.tag)
        self.variants.selectedValue = self.variants.values_?[sender.tag].value
        print("selected ", self.variants.values_?[sender.tag].value)
        self.variants.qty = 1
        
        let imageName = self.variants.values_?[sender.tag].image_slug ?? ""
        let imagePath = BASEURL.replacingOccurrences(of: "v3", with: "v2") + "/images/" + imageName
//        let imagePath = BASEURL + "/images/" + imageName
        self.controller.productImageView.sd_setImage(with: URL(string: imagePath), placeholderImage: UIImage(named: "placeholder2")) { (image, error, type, url) in
            self.controller.productImageView.setShowActivityIndicator(false)
        }
        
        DispatchQueue.main.async {
            self.variantImageCollectionView.reloadSections([0])
        }
        
        self.controller.chooseVariantArray[variantRoom] = self.variants
        print(self.controller.chooseVariantArray[variantRoom] )
        self.controller.countLbl.text = "1"
//        self.controller.chooseVariant(room: sender.tag,selectedType: "size")
        self.controller.chooseVariants(name: self.variants.name ?? "", value: self.variants.values_?[sender.tag].value ?? "")
        variantNameLbl.text = "\(self.variants.name ?? "") : \(self.variants.values_?[sender.tag].value ?? "")"
       
    }
    
    
}
    

