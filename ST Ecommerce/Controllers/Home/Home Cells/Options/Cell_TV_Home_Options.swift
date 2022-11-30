//
//  Cell_TV_Home_Options.swift
//  ST Ecommerce
//
//  Created by necixy on 13/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit


class Cell_TV_Home_Options: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionViewHomeOptions: UICollectionView!
    
    //MARK: - Variables
    var controller : VC_Home!
    
    //MARK: - Inbuilt Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        NSLayoutConstraint.activate([
            collectionViewHomeOptions.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            collectionViewHomeOptions.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
   
    }
    
}



//MARK: - CollectionView Functions
extension Cell_TV_Home_Options : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectionViewHomeOptions.dataSource = self
        collectionViewHomeOptions.delegate = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.homeOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : Cell_CV_Home_Options = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Home_Options", for: indexPath) as! Cell_CV_Home_Options
        cell.imageLogoProperties()
        cell.setData(option: self.controller.homeOptions[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.width/2
        let width = collectionView.frame.size.width/2 // currently there is just 2 option (foods, shop)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let option = self.controller.homeOptions[indexPath.row]
        
        if option.title.lowercased() == storeText.lowercased(){
            
            let vc : VC_Store = storyboardStore.instantiateViewController(withIdentifier: "VC_Store") as! VC_Store
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
        else if option.title.lowercased() == foodsText.lowercased(){
            
            let vc : VC_Restaurant = storyboardRestaurant.instantiateViewController(withIdentifier: "VC_Restaurant") as! VC_Restaurant
            if Singleton.shareInstance.currentLat == 0.0 {
//                self.controller.showHud(message: fetchingLocationText)
//                self.controller.getUserCurrentLocation()
                let seconds = 2.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    self.controller.hideHud()
                    if Singleton.shareInstance.currentLat != 0.0 {
                        self.controller.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.controller.presentAlertWithTitle(title: "", message: unableToFetchLocationText, options: okayText, settingsText) { (value) in
                         
                            if value == 1{
                                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                            }
                        }
                    }
                    
                }
            } else {
                self.controller.hideHud()
                self.controller.navigationController?.pushViewController(vc, animated: true)
            }

        }
        
//        else if option.title.lowercased() == rewardsText.lowercased(){
//
//            if !DEFAULTS.bool(forKey: UD_isUserLogin) {
//                self.controller.presentAlert(title: moreGiftsText, message: rewardMessageText)
//            } else {
//            let vc : VC_Reward = storyboardRewards.instantiateViewController(withIdentifier: "VC_Reward") as! VC_Reward
//            controller.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
//
//        else if option.title.lowercased() == donationsText.lowercased(){
//
//            let vc : VC_Donation = storyboardDonation.instantiateViewController(withIdentifier: "VC_Donation") as! VC_Donation
//
//            controller.navigationController?.addChild(vc)
//
//            controller.navigationController?.view.addSubview(vc.view)
//            vc.didMove(toParent: controller.navigationController)
//
//        }
        
    }
    
}
