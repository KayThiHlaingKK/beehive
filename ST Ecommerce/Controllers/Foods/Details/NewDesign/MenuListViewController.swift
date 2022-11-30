//
//  MenuListViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 28/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation
import UIKit

class MenuListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
                           ScrollViewContained {
    
    @IBOutlet weak var tableViewFoodsDetails: UITableView!
    @IBOutlet weak var collectionViewCuisine : UICollectionView!
    var available_categories : [Available_categories] = [Available_categories]()
    var slug = ""

    // used to connect the scrolling to the containing controller
    weak var scrollDelegate: ScrollViewContainingDelegate?

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // pass scroll events to the containing controller
        scrollDelegate?.scrollViewDidScroll(scrollView)
        
    }
    
    
    override func viewDidLoad() {
        print("menu list view controller")
//        if let parent = self.parent as? RestaurantDetailViewController {
//            print("yes parent")
//            loadReastaurantItems(slug: parent.slug)
//        }
        loadReastaurantItems(slug: slug)
        tableViewFoodsDetails.delegate = self
        tableViewFoodsDetails.dataSource = self
        tableViewFoodsDetails.register(UINib(nibName: "Cell_Store_Product_Header", bundle: nil), forCellReuseIdentifier: "Cell_Store_Product_Header")
    }
    func loadReastaurantItems(slug:String){
        
        let param : [String:Any] = [:]
        var lat = 0.0
        var long = 0.0
        
        if Singleton.shareInstance.defaultAddress?.latitude != nil {
            print("default address")
            lat = Singleton.shareInstance.defaultAddress?.latitude ?? 0.0
            long = Singleton.shareInstance.defaultAddress?.longitude ?? 0.0
        }
        else {
            print("current address")
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
        
        print("rest detial ==== menu \(APIEndPoint.restaurants.caseValue)/\(slug)/\(APIEndPoint.getMenu.caseValue)?lat=\(lat)&lng=\(long)")
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurants.caseValue)/\(slug)/\(APIEndPoint.getMenu.caseValue)?lat=\(lat)&lng=\(long)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200 {
                if let restaurant = data.value(forKeyPath: "data") as? NSDictionary{
                    APIUtils.prepareModalFromData(restaurant, apiName: APIEndPoint.restaurants.caseValue, modelName:"Restaurant", onSuccess: { (anyData) in
                        
                        self.hideHud()
                        
                        DispatchQueue.main.async {
                            var restaurantBranch = anyData as? RestaurantBranch
                            if let restro = restaurantBranch{
                                
                                self.available_categories = restro.available_categories ?? []
                            }
                            self.tableViewFoodsDetails.isHidden = false
                            self.tableViewFoodsDetails.reloadData()
                            
                            self.checkSize()
                        }
                        
                    }) { (error, endPoint) in
                        self.hideHud()
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                    
                }
                
            }else{
                self.hideHud()
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            //self.hideHud()
        }
        
    }
    
    func checkSize(){
        var size = 0
        let count = self.available_categories.count ?? 0
        for i in 0..<count {
            let menucount = self.available_categories[i].menus?.count ?? 0
            size = menucount + size
        }
        if size < 3 {
            self.tableViewFoodsDetails.isScrollEnabled = false
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.available_categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.available_categories[section].menus?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Restaurant_Details") as! Cell_Restaurant_Details
        cell.selectionStyle = .none
        cell.menucontroller = self
        
        if let item = self.available_categories[indexPath.section].menus?[indexPath.row]{
            cell.setData(item: item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        //lets ensure there are visible rows.  Safety first!
//            guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
//                let lastPath = pathsForVisibleRows.last else { return }
//
//            //compare the section for the header that just disappeared to the section
//            //for the bottom-most cell in the table view
//            if lastPath.section >= section {
//                self.collectionViewCuisine.selectItem(at: IndexPath(row: section , section: 0), animated: true, scrollPosition: .left)
//            }
//
//        for i in 0..<available_categories.count{
//            if i == section{
//                available_categories[i].selected = true
//            }
//            else {
//                available_categories[i].selected = false
//            }
//
//        }
//        self.collectionViewCuisine.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //lets ensure there are visible rows.  Safety first!
            guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let firstPath = pathsForVisibleRows.first else { return }

            //compare the section for the header that just appeared to the section
            //for the top-most cell in the table view
//            if firstPath.section == section {
//                if section != 0 {
//                    self.collectionViewCuisine.selectItem(at: IndexPath(row: section - 1 , section: 0), animated: true, scrollPosition: .left)
//                }
//                else {
//                    self.collectionViewCuisine.selectItem(at: IndexPath(row: 0 , section: 0), animated: true, scrollPosition: .left)
//                }
//                for i in 0..<available_categories.count{
//                    if i == section{
//                        available_categories[i].selected = true
//                    }
//                    else {
//                        available_categories[i].selected = false
//                    }
//
//                }
//                self.collectionViewCuisine.reloadData()
//            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Store_Product_Header") as! Cell_Store_Product_Header
        var title = ""
        if self.available_categories.count != 0{
            title = self.available_categories[section].name ?? ""
        }

        cell.labelTitle.text = title
        cell.labelTitle.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
   
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if available_categories[indexPath.section].menus?[indexPath.row].menu_variants?.count ?? 0 > 1 || available_categories[indexPath.section].menus?[indexPath.row].menu_toppings?.count ?? 0 > 0 {
//            chooseVariation(section: indexPath.section, row: indexPath.row)
//
//        }
//        else {
//            chooseMenu = self.available_categories[indexPath.section].menus?[indexPath.row] ?? Available_menus()
//            addItemInCart()
//        }
    }
    
    func chooseVariation(section: Int, row: Int) {
//        let vc: VC_FoodCustomisation = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "VC_FoodCustomisation") as! VC_FoodCustomisation
//
//        let item = self.available_categories[section].menus?[row] ?? Available_menus()
//        vc.restaurantBranch = self.restaurantBranch
//        vc.menu = item
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//extension MenuListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//
//    func collectionViewSetUP(){
//
//        collectionViewCuisine.dataSource = self
//        collectionViewCuisine.delegate = self
//
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return available_categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell : CategoryNameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryNameCell", for: indexPath) as! CategoryNameCell
//        cell.labelCategory.text = available_categories[indexPath.row].name
//
//        if available_categories[indexPath.row].selected {
//            cell.labelCategory.textColor = UIColor().HexToColor(hexString: "#FFBB00")
//            cell.lineView.isHidden = false
//        }else {
//            cell.labelCategory.textColor = UIColor.darkGray
//            cell.lineView.isHidden = true
//        }
////        if let cuisine = self.restaurantBranch?.cuisine?[indexPath.row]{
////            cell.setData(cuisine: cuisine)
////        }
//
//        return cell
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.size.width/5
//        let height = width/3.1 + 8
////        let name = self.restaurantBranch?.cuisine?[indexPath.row].name ?? ""
////        let strWidth = name.width(withConstrainedHeight: height, font: UIFont.latoRegular(size: 12))
//
//        return CGSize(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        collectionViewCuisine.scrollToItem(at: indexPath, at: .left, animated: true)
//
//        let indexPath = IndexPath(item: 0, section: indexPath.row)
//        self.tableViewFoodsDetails.scrollToRow(at: indexPath, at: .top, animated: true)
//
//    }
//}

// MARK:- Protocols

protocol ScrollViewContainingDelegate: NSObject {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

protocol ScrollViewContained {
    var scrollDelegate: ScrollViewContainingDelegate? { get set }
}

// MARK:- TableView Cell
class TVC: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

}
