//
//  VC_CustomWebView.swift
//  ST Ecommerce
//
//  Created by JASWANT SINGH on 20/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD

class VC_CustomWebView: UIViewController,WKNavigationDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var webVw: WKWebView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    
    //MARK: - Varibles
    let hud = JGProgressHUD(style: .dark)
    var htmlString : String?
    var lblText = ""
    
    //MARK: - Class functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpWebView()
        
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        
        lblHeader.text = lblText
        showHud(message: "")
        webVw.loadHTMLString(htmlString ?? "", baseURL: nil)
    }
    
    //MARK: - Methods
    func setUpWebView(){
        webVw.navigationDelegate = self
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webVw.configuration.userContentController.addUserScript(script)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideHud()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideHud()
    }
    
    func setData(str:String){
        webVw.loadHTMLString(str, baseURL: nil)
    }
    
    //MARK: - Actions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


