//
//  MyOrderListTableViewCell.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit


class MyOrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var shopTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    var controller: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func setupUI(){
        bgView.dropShadow()
    }

    func setShopData(data: OrderData){
        noLabel.text = "#\(data.order_no ?? "")"
        if let priceString = self.controller?.priceFormat(pricedouble: data.total_amount ?? 0.0) {
            priceLabel.text = "\(priceString)\(currencySymbol)"
        }
//        priceLabel.text = "\(Int(data.total_amount ?? 0.0))\(currencySymbol)"
        itemLabel.text = "\(data.items?.count ?? 0) Item"
        orderStatusLabel.text = data.order_status
        dateTimeLabel.text = changeOrderDate(data.order_date ?? "")
        iconImageView.isHidden = true
        shopTitleLabel.isHidden = true
        checkOrderStatus(orderStatus: data.order_status ?? "")
    }
    
    
    func setFoodData(data: OrderData){
        iconImageView.isHidden = false
        shopTitleLabel.isHidden = false
        noLabel.text = "#\(data.order_no ??  "")"
        if let priceString = self.controller?.priceFormat(pricedouble: data.total_amount ?? 0.0) {
            priceLabel.text = "\(priceString)\(currencySymbol)"
        }
//        priceLabel.text = "\(Int(data.total_amount ?? 0.0))\(currencySymbol)"
        itemLabel.text = "\(data.restaurant_order_items?.count ?? 0) Item"
        shopTitleLabel.text = "\(data.restaurant_branch_info?.restaurant?.name ?? "")"
        dateTimeLabel.text = changeOrderDate(data.order_date ?? "")
        orderStatusLabel.text = data.order_status
        guard let orderImage = data.restaurant_branch_info?.restaurant else { return }
        guard let images = orderImage.images else { return }
        if images.count == 0{
            iconImageView.image = UIImage(named: "")
        }else{
            iconImageView.setIndicatorStyle(.gray)
            iconImageView.setShowActivityIndicator(true)
            let imagePathItem = "\(images.first?.url ?? "")"
            let imageFileName = "\(images.first?.file_name ?? "")"
            iconImageView.setIndicatorStyle(.gray)
            iconImageView.setShowActivityIndicator(true)
            iconImageView.downloadImage(url: imagePathItem, fileName: imageFileName, size: .small)
        }
        checkOrderStatus(orderStatus: data.order_status ?? "")
    }
    
    
    func checkOrderStatus(orderStatus: String){
        if orderStatus == "cancelled"{
            orderStatusLabel.textColor = .red
        }else if orderStatus == "delivered"{
            orderStatusLabel.textColor = .green
        }else{
            orderStatusLabel.textColor = .systemYellow
        }
    
    }
    
}
