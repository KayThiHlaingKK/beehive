//
//  VC_Store_RateOrder.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD


class VC_Store_RateOrder: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var labelOrderNo: UILabel!
    @IBOutlet weak var tableViewStoreRateOrder: UITableView!
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var orderId : Int!
    var rateOrder : RateOrder?
    
    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSetUP()
        
        self.loadMyRatingOrdersFromServer(orderId: orderId)
        
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
    }
    
    //MARK: - Private Functions
    private func tableViewSetUP(){
        
        tableViewStoreRateOrder.dataSource = self
        tableViewStoreRateOrder.delegate = self
        
        tableViewStoreRateOrder.register(UINib(nibName: "Cell_Store_Product_Header", bundle: nil), forCellReuseIdentifier: "Cell_Store_Product_Header")
        
    }
    
    //MARK: - Action Methods
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        self.rateMyOrders(orderId: orderId)
    }
    

    //MARK: - API Call Functions
    func loadMyRatingOrdersFromServer(orderId:Int){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.orderDetails.caseValue)\(orderId)/rate", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status{
                //Success from our server
                if let rateOrder = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(rateOrder, apiName: APIEndPoint.orderDetails.caseValue, modelName:"RateOrder", onSuccess: { (anyData) in
                        self.rateOrder = anyData as? RateOrder ?? nil
                        
                        self.tableViewStoreRateOrder.reloadData()
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                    
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    //MARK: - API Call Functions
    func rateMyOrders(orderId:Int){
        
        if let products = self.rateOrder?.rateProducts{
            
            var rateProducts = [[String:Any]]()
            for rate in products{
                
                let rateProduct : [String:Any] = ["id":rate.id ?? "",
                                   "review":rate.review ?? "",
                                   "rating":rate.rating ?? 0]
                rateProducts.append(rateProduct)
            }

            let param : [String:Any] = ["rate_products":rateProducts]
            print("param \(param)")
            self.showHud(message: loadingText)
            
            APIUtils.APICall(postName: "\(APIEndPoint.orderDetails.caseValue)\(orderId)/rate", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
                
                self.hideHud()
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Bool ?? false
                
                if status{
                    //Success from our server

                    let message = data.value(forKey: key_message) as? String ?? ""
                    
                    self.presentAlertWithTitle(title: successText, message: message, options: goBackText) { (option) in

                        switch(option) {
                            case 0:
                                self.navigationController?.popViewController(animated: true)
                            default:
                                break
                        }
                    }
                    
                }else{
                    let message = data[key_message] as? String ?? serverError
                    self.presentAlert(title: errorText, message: message)
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
            }
            
        }else{
        }
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_Store_RateOrder : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rateOrder?.rateProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : Cell_Store_RateOrder = tableView.dequeueReusableCell(withIdentifier: "Cell_Store_RateOrder") as! Cell_Store_RateOrder
        cell.selectionStyle = .none
        cell.controller = self
        cell.configureTextView()
        cell.textViewReview.tag = indexPath.row
        cell.ratingView.tag = indexPath.row
        
        if let rateProduct = self.rateOrder?.rateProducts?[indexPath.row]{
            cell.setData(product: rateProduct)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

