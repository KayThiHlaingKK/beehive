//
//  VC_WebView.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 08/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import WebKit

class VC_WebView: UIViewController, WKNavigationDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var controller: UIViewController!
    var url: String!
    var titleText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = titleText
        let request = URL(string: url)
        let urlRequest = URLRequest(url: request!)
        webView.load(urlRequest)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
    
    @IBAction func onDismiss(_ sender: Any) {
       self.controller.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
     
        
    }
}
