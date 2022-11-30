//
//  Cell_TV_Food_Row.swift
//  ST Ecommerce
//
//  Created by necixy on 30/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Restaurant_Row: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var collectionViewResturent: UICollectionView!
    @IBOutlet weak var labelCategory: UILabel!
    
    //MARK: - Variables
    var controller:VC_Restaurant!
    var index = 0
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//MARK: - CollectionView Functions
extension Cell_TV_Restaurant_Row : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectionViewResturent.dataSource = self
        collectionViewResturent.delegate = self
        
        collectionViewResturent.register(UINib.init(nibName: "Cell_CV_Restaurant_Row", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Restaurant_Row")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controller.restaurantBranches.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : Cell_CV_Restaurant_Row = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Restaurant_Row", for: indexPath) as! Cell_CV_Restaurant_Row
        
        if indexPath.row == 0{
            cell.leadingContainerViewConstraint.constant = 12
        }else{
            cell.leadingContainerViewConstraint.constant = 0
        }
        
        //if let restaurant = self.controller.restaurantBranches[indexPath.row]{
            cell.setData(restaurant: self.controller.restaurantBranches[indexPath.row])
        //}
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/2.1
        var height = width/0.70
        if !DeviceUtils.isDeviceIphoneXOrlatter(){
            height = width/0.69
        }
        if #available(iOS 14.2, *) {
            height = width/0.63
        } else {
            height = width/0.63
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // if let restro = self.controller.restaurantBranches[indexPath.row]{
            
            if let restroID = self.controller.restaurantBranches[indexPath.row].slug{
                
                
                let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
               vc.slug = restroID
                vc.restaurantBranch = self.controller.restaurantBranches[indexPath.row]
                vc.restaurantSlug = self.controller.restaurantBranches[indexPath.row].restaurant?.slug ?? ""
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }
            
       // }
        
    }
    
}
