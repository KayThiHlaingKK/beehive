//
//  Cell_TV_RestaurantHeader.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 18/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

public protocol Cell_TV_HeaderDelegate: UIViewController {
    func onTapViewAll(section: Int)
}

class Cell_TV_Header: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var viewAllLabel: UILabel!
    var section: Int = 0
    weak var delegate: Cell_TV_HeaderDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapViewAll))
        viewAllLabel.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapViewAll))
        viewAllLabel.addGestureRecognizer(tapGesture)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapViewAll))
        viewAllLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func onTapViewAll() {
        delegate?.onTapViewAll(section: section)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
