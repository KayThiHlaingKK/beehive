//
//  HelpViewController.swift
//  ST Ecommerce
//
//  Created by Necixy on 07/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    //  MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwTblView: UIView!
    
    @IBOutlet weak var vwEmpty: UIView!
    @IBOutlet weak var tableViewSupport: UITableView!
    var supportApiFetched = false
    
    //  MARK: - Variables
    
    var support: [Supports] = [Supports]()
    
    var num : String? = ""
    
    //  MARK: - Internal Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSupport.layer.cornerRadius = 10
        tableViewSupport.tableFooterView = UIView()
        
        Util.configureTopViewPosition(heightConstraint: topViewHeightConstraint)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        supportApiFetched = false
       self.loadSupportNumberFromServer()
    }
    
    func showEmptyView() {
        if supportApiFetched == true && support.isEmpty {
            vwEmpty.isHidden = false
            vwTblView.isHidden = true
        } else {
            vwEmpty.isHidden = true
            vwTblView.isHidden = false
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCall(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: self.tableViewSupport)
        guard let customIndexPath = self.tableViewSupport.indexPathForRow(at: point) else {
            return
        }
       
        let number = self.support[customIndexPath.row].number ?? ""
        dialNumber(number: number)
    }
    
    
    //  MARK: - Helping Functions
    
    func dialNumber(number: String) {
        
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
              if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
               } else {
                   UIApplication.shared.openURL(url)
               }
           } else {

           }
        }
    
    //  MARK: - Get API Call
    
    func loadSupportNumberFromServer() {
        
        let param : [String:Any] = [:]
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.supports.caseValue)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            self.supportApiFetched = true
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status {

                
                if let item = data.value(forKeyPath: "data.supports") as? NSArray {
                    
                    APIUtils.prepareModalFromData(item, apiName: APIEndPoint.supports.caseValue, modelName: "SupportElement", onSuccess: { (anyData) in
                        
                        self.support = anyData as! [Supports]
                        
                        DispatchQueue.main.async {
                            
                            self.tableViewSupport.reloadData()
                        }
                
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                } else {
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            self.showEmptyView()
        }) { (reason, statusCode) in
            self.showEmptyView()
            self.hideHud()
        }
        
    }
    
}

//  MARK: - Table View Delagate and DataSource

extension HelpViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
    return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)  -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.support.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpViewController_Cell") as! HelpViewController_Cell
        
        cell.lblName.text = self.support[indexPath.row].name
        cell.lblNumber.text = self.support[indexPath.row].number
        
        cell.lblUnderline.layer.borderWidth = 2
        cell.lblUnderline.layer.borderColor = UIColor.black.cgColor
        cell.lblUnderline.backgroundColor = .black
        
        cell.btnCall.tag = indexPath.row
        
        return cell
    }
}
