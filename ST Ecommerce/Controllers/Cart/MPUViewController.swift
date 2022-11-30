//
//  MPUViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 11/02/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class MPUViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var link = ""
    var cartType = Cart.restaurant
    var payment = PaymentMode.mpu
    var url = ""
    
    override func viewDidLoad() {
        print("BASE = ", BASEURL)
        let base = BASEURL.replacingOccurrences(of: "/api/v3", with: "")
        
        if payment == PaymentMode.mpu {
            url = base + APIEndPoint.mpuCheckout.caseValue + link
            print("url mpu = " , url)
        }
        else if payment == PaymentMode.mpgs {
            url = base + APIEndPoint.mpgsCheckout.caseValue + link
            print("url mpgs = " , url)
        }
        
        webView.load(URLRequest(url: URL(string: url)!))
    }
    
    @IBAction func closeWeb(_ sender: UIButton) {
//        goOrderPage()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func goOrderPage() {
        let vc :  VC_MyOrders = storyboardHome.instantiateViewController(withIdentifier: "VC_MyOrders") as! VC_MyOrders
        if cartType == Cart.restaurant {
            vc.cartType = Cart.restaurant
        }
        else {
            vc.cartType = Cart.store
        }
        vc.fromHome = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
