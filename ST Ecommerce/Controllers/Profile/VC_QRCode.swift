//
//  VC_QRCode.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 14/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_QRCode: UIViewController {
    
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateUserQRCode()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func generateUserQRCode() {
        guard let userProfile = Singleton.shareInstance.userProfile,
              let name = userProfile.name,
              let slug = userProfile.slug,
              let phone = userProfile.phone_number else { return }
        
        let textForQR = "name: \(name), slug: \(slug), phone: \(phone)"
        qrCodeImageView.image = generateQRCodeImage(from: textForQR)
        
    }
    
    private func generateQRCodeImage(from text: String) -> UIImage? {
        let data = text.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
