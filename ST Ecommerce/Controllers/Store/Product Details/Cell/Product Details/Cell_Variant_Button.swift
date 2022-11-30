//
//  Cell_Variant_Button.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 24/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

//protocol ProductVariationDelegate {
//    func chooseVariant(room: Int)
//}
class Cell_Variant_Button: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var variantNameLbl: UILabel!
    @IBOutlet weak var variantBtnCollectionView: UICollectionView!
    var variants: Variants!
    var productVariants: [ProductVariant]? = []
    var controller: ProductVariationViewController!
    var variantRoom = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
extension Cell_Variant_Button : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionViewSetUP(){
        
        print("button ", variantRoom)
        
        variantBtnCollectionView.dataSource = self
        variantBtnCollectionView.delegate = self
        variantBtnCollectionView.showsHorizontalScrollIndicator = false
        variantBtnCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 16);
       
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("variant value == " , self.variants.values_)
        return self.variants.values_?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("variant cell")
        let cell : Cell_CV_Variant_Button = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Variant_Button", for: indexPath) as! Cell_CV_Variant_Button
        
        let title = self.variants.values_?[indexPath.item].value ?? ""
        print("title == " , title)
        cell.setData(title: title)
        
        if self.variants.values_?[indexPath.row].value == self.variants.selectedValue {
            cell.variantBtn.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
        } else {
            cell.variantBtn.backgroundColor = UIColor().HexToColor(hexString: "#FFFFFF")
        }
        cell.variantBtn.addTarget(self, action: #selector(chooseVariation(sender:)), for: .touchUpInside)
        cell.variantBtn.tag = indexPath.row
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 200, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    @objc func chooseVariation(sender:UIButton){
        
        print("click " , sender.tag)
        self.variants.selectedValue = self.variants.values_?[sender.tag].value
        self.variants.qty = 1
        print("selected ", self.variants.values_?[sender.tag].value)
        
        //for background color
        DispatchQueue.main.async {
            self.variantBtnCollectionView.reloadSections([0])
        }
        
        self.controller.chooseVariantArray[variantRoom] = self.variants
        print(self.controller.chooseVariantArray[variantRoom] )
        self.controller.countLbl.text = "1"
//        self.controller.chooseVariant(room: sender.tag, selectedType: "color")
        self.controller.chooseVariants(name: self.variants.name ?? "", value: self.variants.values_?[sender.tag].value ?? "")
        variantNameLbl.text = "\(self.variants.name ?? "") : \(self.variants.values_?[sender.tag].value ?? "")"
       
    }
    
   
}
  
