//
//  CreditCardViewController.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 26/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.

//

import Foundation
import UIKit

class CreditCardViewController: UIViewController {
    
    // MARK: Delegate initialization
    var presenter: CreditCardViewToPresenterProtocol?
    
    // MARK: Outlets
    
    @IBOutlet weak var avialableAmountLbl: UILabel!
    @IBOutlet weak var remainAmmountLbl: UILabel!
    
    // MARK: Custom initializers go here
  
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.started()
    }
    
    // MARK: User Interaction - Actions & Targets
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Additional Helpers
    
}

// MARK: - Extension
/**
 - Documentation for purpose of extension
 */
extension CreditCardViewController {
    
}

// MARK: - Presenter to View
extension CreditCardViewController: CreditCardPresenterToViewProtocl {
    
    func initialControlSetup() {
        presenter?.getUserCredit()
    }
    
    func setUserCreditData(_ data: CreditCardModel) {
        print(data)
        let respones = data.data
        guard let amount = respones?.amount,
        let remainAmount = respones?.remaining_amount else { return }
        avialableAmountLbl.text = String(amount.withCommas()) + "MMK"
        remainAmmountLbl.text = String(remainAmount.withCommas()) + "MMK"
    }

    
}
