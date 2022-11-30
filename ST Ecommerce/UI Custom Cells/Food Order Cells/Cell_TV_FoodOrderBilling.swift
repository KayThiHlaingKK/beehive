//
//  Cell_TV_FoodOrderBilling.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 04/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_FoodOrderBilling: UITableViewCell {

    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var subtotalLable: UILabel!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    private var restaurantOrder: RestaurantOrder!
    @IBOutlet weak var voucherStackView: UIStackView!
    @IBOutlet weak var extraChargeTableView: SelfSizingTableView!
    
    
    var controller: UIViewController!
    var foodOrderQuantity = 0
    var extraCharges = [ExtraCharges]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableViewSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func tableViewSetup() {
        extraChargeTableView.delegate = self
        extraChargeTableView.dataSource = self
        extraChargeTableView.registerCell(type: ExtraChargeListTableViewCell.self)
    }
    
    func setFoodOrderData(foodOrder: RestaurantCart){
       
        totalQuantityLabel.text = "\(foodOrderQuantity) item(s)"
        
        if let tax = self.controller?.priceFormat(pricedouble: foodOrder.total_tax ?? 0) {
            taxLabel.text = "\(tax)\(currencySymbol)"
        }
        
        if let promotion = self.controller?.priceFormat(pricedouble: foodOrder.promo_amount ?? 0) {
            promotionLabel.text = "\(promotion)\(currencySymbol)"
        }
        let subTotal = (foodOrder.sub_total ?? 0.0) 
        if let subTotalString = self.controller?.priceFormat(pricedouble: subTotal) {
            subtotalLable.text = "\(subTotalString)\(currencySymbol)"
        }
        if let total = self.controller?.priceFormat(pricedouble: foodOrder.total_amount ?? 0) {
            totalLabel.text = "\(total)\(currencySymbol)"
        }
        
        let deliveryFee = self.controller.priceFormat(pricedouble: foodOrder.delivery_fee ?? 0)
        deliveryFeeLabel.text = "\(deliveryFee)\(currencySymbol)"
        
        self.extraCharges = foodOrder.extra_charges ?? [ExtraCharges]()
        self.extraChargeTableView.reloadData()
        
        if Singleton.shareInstance.willdeli == DeliveryMode.pickup
        {
            deliveryFeeLabel.text = "\(0)\(currencySymbol)"
            let new = Double(foodOrder.total_amount ?? 0) - Double(foodOrder.delivery_fee ?? 0) - Double(foodOrder.promo_amount ?? 0)
            totalLabel.text = "\(self.controller.priceFormat(pricedouble: new))\(currencySymbol)"
        }
        else {
            if let total = self.controller?.priceFormat(pricedouble: foodOrder.total_amount ?? 0) {
                totalLabel.text = "\(total)\(currencySymbol)"
            }
            
            let deliveryFee = self.controller.priceFormat(pricedouble: foodOrder.delivery_fee ?? 0)
            deliveryFeeLabel.text = "\(deliveryFee)\(currencySymbol)"
        }
    
    }
    
    
    func setData(restaurantOrder: RestaurantOrder?) {
        guard let restaurantOrder = restaurantOrder else {
            return
        }

        self.restaurantOrder = restaurantOrder
        var itemsCount = 0
        restaurantOrder.restaurant_order_items?.forEach {
            itemsCount += $0.quantity ?? 0
        }
        totalQuantityLabel.text = "\(itemsCount) item(s)"
        
        if let tax = self.controller?.priceFormat(pricedouble: restaurantOrder.tax ?? 0) {
            taxLabel.text = "\(tax)\(currencySymbol)"
        }
        
        if let promotion = self.controller?.priceFormat(pricedouble: restaurantOrder.promocode_amount ?? 0) {
            promotionLabel.text = "\(promotion)\(currencySymbol)"
        }
        let subTotal = (restaurantOrder.amount ?? 0.0) - (restaurantOrder.discount ?? 0.0)
        if let subTotalString = self.controller?.priceFormat(pricedouble: subTotal) {
            subtotalLable.text = "\(subTotalString)\(currencySymbol)"
        }
        if let total = self.controller?.priceFormat(pricedouble: restaurantOrder.total_amount ?? 0) {
            totalLabel.text = "\(total)\(currencySymbol)"
        }
        
        let deliveryFee = self.controller.priceFormat(pricedouble: restaurantOrder.delivery_fee ?? 0)
        deliveryFeeLabel.text = "\(deliveryFee)\(currencySymbol)"
        
        self.extraCharges = restaurantOrder.extra_charges ?? [ExtraCharges]()
        self.extraChargeTableView.reloadData()
        
//        restaurantOrder.extra_charges?.forEach {
//            createExtraChargesRow(description: $0.name, value: $0.value)
//        }
    }
    
    private func createExtraChargesRow(description key: String?, value: String?) {
        guard let key = key,
        let value = Double(value ?? "0")
        else {
            return
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        let descriptionLabel = createLabel(key, textAlignment: .left)
        let price = self.controller.priceFormat(pricedouble: value)
        let priceLabel = createLabel(price, textAlignment: .right)
        priceLabel.text = "\(price)\(currencySymbol)"
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        voucherStackView.insertArrangedSubview(stackView, at: 1)
    }
    
    private func createLabel(_ title: String, textAlignment: NSTextAlignment) -> UILabel {
        let lbl = UILabel()
        lbl.text = title
        lbl.textAlignment = textAlignment
        lbl.textColor = .black
        lbl.font = UIFont(name: "Lexend-Regular", size: 14)
        return lbl
    }
    
}

extension Cell_TV_FoodOrderBilling: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraCharges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExtraChargeListTableViewCell.identifier, for: indexPath)as? ExtraChargeListTableViewCell else {
            return UITableViewCell()
        }
        cell.extraChargeNameLbl.text = extraCharges[indexPath.row].name
        let price = "\(priceFormat(pricedouble: Double(extraCharges[indexPath.row].value ?? "") ?? 0.0))\(currencySymbol)"
        cell.extraChargePriceLbl.text = price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
}

