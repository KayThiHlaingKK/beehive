//
//  DonationVC.swift
//  ST Ecommerce
//
//  Created by JASWANT SINGH on 18/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD

class VC_Donation: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    loadProductsFromServer()
        
    }
    
    //MARK: - API Call Functions
       func loadProductsFromServer(){
           let param : [String:Any] = [:]
           print("param \(param)")
           
          
           self.showHud(message: loadingText)
          
           
           APIUtils.APICall(postName: "\(APIEndPoint.donation.caseValue)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
               
               self.hideHud()
               
               
               
               let data = response as! NSDictionary
               let status = data.value(forKey: key_status) as? Bool ?? false
               
               if status{
                
                   //Success from our server
                let dictionary = data.value(forKey: "data") as? Dictionary ?? [:]
                let imagePathItem = dictionary["donation"] ?? ""
                self.imgView.setIndicatorStyle(.gray)
                self.imgView.setShowActivityIndicator(true)
                self.imgView.sd_setImage(with: URL(string: imagePathItem as! String), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
                         self.imgView.setShowActivityIndicator(false)
                     }
                
               }else{
                   let message = data[key_message] as? String ?? serverError
                   self.presentAlert(title: errorText, message: message)
               }
               
           }) { (reason, statusCode) in
               self.hideHud()
           }
           
       }

    //MARK: - Action Functions
    @IBAction func cancel(_ sender: Any) {
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }


}



