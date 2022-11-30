//
//  VC_ProfileSettings.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 14/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_ProfileSettings: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changePasswordButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Settings", bundle: nil).instantiateViewController(withIdentifier: "VC_ChangePassword") as! VC_ChangePassword
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func deleteAccountButtonPressed(_ sender: UIButton) {
        DeleteAlertView.instance.showAlert()
        DeleteAlertView.instance.delegate = self
    }
    
}

// MARK: DeleteAPI Call
extension VC_ProfileSettings: DeleteAPIDelegate{
    func deleteAPICall() {
        APIClient.fetchDeleteAccount().execute { data in
            if data.status == 200 {
                self.unAuthenticatedOptoin(toastMessage: data.message ?? "")
            }else{
                self.presentAlert(title: "Warning!", message: data.message ?? "")
            }
        } onFailure: { error in
            self.presentAlert(title: "Warning!", message: error.localizedDescription)
        }
    }
}

