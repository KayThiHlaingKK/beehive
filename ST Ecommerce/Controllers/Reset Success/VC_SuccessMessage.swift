//
//  VC_ResetSuccess.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 30/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class VC_SuccessMessage: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    // MARK: - Properties
    
    var titleText: String?
    var messageText: String?
    
    
    
    // MARK: - LifeCycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleText ?? "Password reset successful!"
        messageLabel.text = messageText ?? "You have successfully reset your password."
    }

    
    // MARK: - IBActions
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
//        Util.makeHomeRootController()
        Util.makeSignInRootController()
    }
    
}
