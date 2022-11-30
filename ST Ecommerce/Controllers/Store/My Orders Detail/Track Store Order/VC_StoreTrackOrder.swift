//
//  VC_StoreTrackOrder.swift
//  ST Ecommerce
//
//  Created by Necixy on 06/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD

class VC_StoreTrackOrder: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewStoreTrackOrder: UITableView!
    @IBOutlet weak var btnReload: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var trackingData : TrackStoreOrderData?
    var orderId = Int()
    
    //MARK: - Internal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewSetUP()
        
        self.loadMyOrderTrackingData(orderId: orderId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        localizedText()
    }
    
    
    //MARK: - Private Functions
    func localizedText(){
        lblTitle.text = OrderTimeline
    }
    
    //MARK: - Action Functions
    @IBAction func back(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReload(_ sender: Any) {
        
        if trackingData == nil {
            
            self.navigationController?.popViewController(animated: true)
            
        }
        
        loadMyOrderTrackingData(orderId: orderId)
    }
    
    //MARK: - API Call Functions
    func loadMyOrderTrackingData(orderId:Int){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.storeOrders.caseValue)\(orderId)\(APIEndPoint.trackOrderStore.caseValue)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status{
                //Success from our server
                if let trackingData = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(trackingData, apiName: APIEndPoint.trackOrderStore.caseValue, modelName:"TrackStoreOrderData", onSuccess: { (anyData) in
                        
                        self.trackingData = anyData as? TrackStoreOrderData
                        self.tableViewStoreTrackOrder.reloadData()
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                    
                }
                
            }else{
                
                self.navigationController?.popViewController(animated: true)
                
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_StoreTrackOrder : UITableViewDelegate, UITableViewDataSource{
    
    private func tableViewSetUP(){
        tableViewStoreTrackOrder.dataSource = self
        tableViewStoreTrackOrder.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.trackingData != nil{
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Track_Store") as? Cell_Track_Store{
            cell.selectionStyle = .none
            cell.controller = self
            if let trackData = self.trackingData{
                cell.setData(track: trackData)
            }
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }

}



