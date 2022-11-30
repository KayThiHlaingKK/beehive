//
//  Cell_TV_AddressRow.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 13/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

protocol AddressRowDelegate: class {
    func editAddress(indexPath: IndexPath)
    func deleteAddress(indexPath: IndexPath)
}

class Cell_TV_AddressRow: UITableViewCell {
    
    
    @IBOutlet weak var addressTypeImage: UIImageView!
    @IBOutlet weak var addressTypeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var indexPath: IndexPath!
    private var address: Address!
    weak var delegate: AddressRowDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        delegate?.editAddress(indexPath: indexPath)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.deleteAddress(indexPath: indexPath)
    }
    
    func setData(address: Address) {
        addressTypeLabel.text = address.label?.capitalized
        addressLabel.text = Util.getFormattedAddress(address: address)
        if let image = UIImage(named: address.label?.capitalized ?? "") {
            addressTypeImage.image = image
        }
        else {
            addressTypeImage.image = UIImage(named: "placeholder2")
        }
    }
}
