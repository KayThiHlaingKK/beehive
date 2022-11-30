//
//  CancelOrderViewController.swift
//  ST Ecommerce
//
//  Created by necixy on 30/10/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

protocol CancelOrderViewControllerDelegate {
    func callCancelAPI(cancellationReason: String?)
}

class CancelOrderViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var vWCancel: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    @IBOutlet weak var lblReason: UILabel!
    @IBOutlet weak var txtCancelReason: UITextView!
    
    @IBOutlet weak var btnDismiss: UIButton!
    @IBOutlet weak var btnYes: UIButton!

    var delegate: CancelOrderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        txtCancelReason.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
        txtCancelReason.delegate = self
    }
    
    func setupView() {
        vWCancel.clipsToBounds = true
        btnDismiss.clipsToBounds = true
        btnDismiss.layer.borderWidth = 1
        txtCancelReason.layer.cornerRadius = 10
        vWCancel.layer.cornerRadius = 10
        
        btnDismiss?.layer.borderColor = UIColor.lightGray.cgColor
        btnYes?.clipsToBounds = true
        btnYes?.layer.borderWidth = 1
        btnYes?.layer.borderColor = UIColor.lightGray.cgColor
        txtCancelReason?.text = "Enter Cancellation Reason"
        txtCancelReason?.textColor = .lightGray
        self.view.endEditing(true)
    }
    
    @IBAction func btnDismiss(_ sender: Any) {
        self.remove()
    }
    
    @IBAction func btnYes(_ sender: UIButton) {
        self.showHud(message: loadingText)
        self.delegate?.callCancelAPI(cancellationReason: self.txtCancelReason.text)
        self.remove()   
    }
}

extension CancelOrderViewController: UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (txtCancelReason.text == "Enter Cancellation Reason" && txtCancelReason.textColor == .lightGray)
            {
            txtCancelReason.text = ""
            txtCancelReason.textColor = .black
            }
        txtCancelReason.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if (txtCancelReason.text == "")
            {
            txtCancelReason.text = "Enter Cancellation Reason"
            txtCancelReason.textColor = .lightGray
            }
        txtCancelReason.resignFirstResponder()
    }
}
