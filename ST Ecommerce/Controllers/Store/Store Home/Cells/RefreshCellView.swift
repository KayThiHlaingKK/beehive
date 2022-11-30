//
//  RefreshCellView.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 20/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import Foundation
import UIKit

class RefreshCellView : UITableViewCell
{
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    @IBOutlet weak var progressLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startStopLoading(_ isStart : Bool)
    {
        if(isStart)
        {
            progressView.startAnimating()
            progressLabel.text = "Loading"
        }
        else
        {
            progressView.stopAnimating()
            progressLabel.text = "Pull for more data"
        }
    }
}
