//
//  VC_More.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class VC_More: UIViewController {
    
    //MARK: - IBOutlets
    var moreOptions : [MoreOptions] = []
    
    @IBOutlet weak var tableViewMore: UITableView!
    
    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSetUP()
    }
    
    
    //MARK: - Private Functions
    
    private func tableViewSetUP(){
        
        
//        moreOptions.append(MoreOptions(image: UIImage.init(systemName: "cart")!, title: "My Cart", subTitle: "Store", color: #colorLiteral(red: 0.8117647059, green: 0.1647058824, blue: 0.1529411765, alpha: 1)))
//        moreOptions.append(MoreOptions(image: UIImage.init(systemName: "cart")!, title: "My Cart", subTitle: "Food", color: #colorLiteral(red: 1, green: 0.6632423401, blue: 0, alpha: 1)))
//        moreOptions.append(MoreOptions(image: UIImage.init(systemName: "creditcard.fill")!, title: "My Orders", subTitle: "Store", color: #colorLiteral(red: 0.8117647059, green: 0.1647058824, blue: 0.1529411765, alpha: 1)))
//        moreOptions.append(MoreOptions(image: UIImage.init(systemName: "creditcard.fill")!, title: "My Orders", subTitle: "Food", color: #colorLiteral(red: 1, green: 0.6632423401, blue: 0, alpha: 1)))
//        moreOptions.append(MoreOptions(image: UIImage.init(systemName: "person.fill")!, title: "Account", subTitle: "Information", color: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)))
        
        tableViewMore.dataSource = self
        tableViewMore.delegate = self
        
    }
    
    //MARK: - Action Methods
    @IBAction func home(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_More : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_More") as! Cell_More
        cell.selectionStyle = .none
        
        cell.labelTitle.text = moreOptions[indexPath.row].title
        cell.labelSubTitle.text = moreOptions[indexPath.row].subTitle
        cell.imageViewIcon.image = moreOptions[indexPath.row].image
        cell.imageViewIcon.tintColor = moreOptions[indexPath.row].color
        cell.labelTitle.textColor = moreOptions[indexPath.row].color
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            if readLogin() != 0
            {
                let vc : VC_Cart = storyboardCart.instantiateViewController(withIdentifier: "VC_Cart") as! VC_Cart
                vc.cartType = Cart.store
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                self.showNeedToLoginApp()
                
            }
           
            
        }
        else if indexPath.row == 2{
            
            let vc : VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
            vc.cartType = Cart.store
            vc.fromHome = false
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        else if indexPath.row == 3{
            
//            let foodsDetailsContoller = storyboardFoodsMyOrders.instantiateViewController(identifier: "VC_FoodsMyOrders")
//            self.navigationController?.pushViewController(foodsDetailsContoller, animated: true)
        }
            
        else if indexPath.row == 4{
            
            let accountController = storyboardHome.instantiateViewController(withIdentifier: "VC_Account") as! VC_Account
            self.navigationController?.pushViewController(accountController, animated: true)
            
//            let accountController = storyboardHome.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
//                        self.navigationController?.pushViewController(accountController, animated: true)
        }
    }
    
}

