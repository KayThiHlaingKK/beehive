//
//  SelfSizingTableView.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/11/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
       setNeedsLayout()
       layoutIfNeeded()
       let height = min(contentSize.height, maxHeight)
       return CGSize(width: contentSize.width, height: height)
    }
}

class SelfSizingTableView: UITableView {
      
    override var contentSize:CGSize {
            didSet {
                invalidateIntrinsicContentSize()
            }
        }

        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            sizeToFit()
            return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        }

}
