//
//  VC_AccountNotLoggedIn.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 28/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_AccountNotLoggedIn: UIViewController {
    
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAppVersion()
    }
    
    private func showAppVersion() {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        else { return }
        #if DEBUG
        let env = "-debug"
        #elseif STAGING
        let env = "-staging"
        #else
        let env = ""
        #endif
        
        versionLabel.text = "Version : \(appVersion)\(env)"
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        Util.makeSignInRootController()
    }
    
}
