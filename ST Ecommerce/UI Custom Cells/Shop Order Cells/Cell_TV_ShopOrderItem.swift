//
//  Cell_TV_ShopOrderItem.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 19/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_ShopOrderItem: UITableViewCell {
    
    @IBOutlet weak var variantLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var soldByLabel: UILabel!
    @IBOutlet weak var specialInstLabel: UILabel!
    @IBOutlet weak var reviewButton: RoundedView!
    @IBOutlet weak var reviewButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var extraChargeTableView: SelfSizingTableView!
    
    
    private var productItem: Shop_Order_Item!
    private var restaurantItem: Restaurant_Order_Item!
    var extraVariants: [ExtraCharges] = [ExtraCharges]()
    var menuVariants: [Menu_variants] = [Menu_variants]()
    var shopItemName = String()
    
    var controller: UIViewController?
    var productItemRatingDelegate: ProductItemRating?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(reviewButtonPressed(_:)))
        reviewButton.addGestureRecognizer(gesture)
        setupUI()
        extraChargeTableView.reloadData()
    }
    
    func setupUI() {
        extraChargeTableView.dataSource = self
        extraChargeTableView.delegate = self
        extraChargeTableView.registerCell(type: ExtraChargeListTableViewCell.self)
    }
    
    func setShopData(shopItem: ProductCart) {
        reviewButton.isHidden = true
        reviewButtonHeight.constant = true ? 0: 32
        
        if let quantity = shopItem.quantity {
            quantityLabel.text = "\(quantity)x"
        }
        itemNameLabel.text = ""
        if let productName = shopItem.name {
            itemNameLabel.text = productName
        }
        
        let actualPrice: Double? = ((shopItem.amount ?? 0.0) - (shopItem.discount ?? 0.0)) * Double(shopItem.quantity ?? 1)
        
        if let priceString = self.controller?.priceFormat(pricedouble: actualPrice ?? 0.0) {
            priceLabel.text = "\(priceString)\(currencySymbol)"
        }
        if let shopName = shopItem.shopName {
            soldByLabel.text = "Sold by \(shopName)"
        }
        
    }
    
    func setupData(productItem: Shop_Order_Item) {
        self.productItem = productItem
        let hideReviewButton = !(productItem.review == nil && productItem.order_status == "delivered")
        reviewButton.isHidden = hideReviewButton
        reviewButtonHeight.constant = hideReviewButton ? 0: 32
        
        if let quantity = productItem.quantity {
            quantityLabel.text = "\(quantity)x"
        }
        itemNameLabel.text = ""
        if let productName = productItem.product_name {
            itemNameLabel.text = productName
        }
        
        let actualPrice: Double? = ((productItem.amount ?? 0.0) - (productItem.discount ?? 0.0)) * Double(productItem.quantity ?? 1)
        
        if let priceString = self.controller?.priceFormat(pricedouble: actualPrice ?? 0.0) {
            priceLabel.text = "\(priceString)\(currencySymbol)"
        }
        if let shopName = productItem.shop?.name {
            soldByLabel.text = "Sold by \(shopName)"
        }
        
        
    }
    
    
    func setRestaurantOrderData(orderItem: MenusCart) {
        print(orderItem)
        reviewButton.isHidden = true
        reviewButtonHeight.constant = 0
        var textForVariant = ""
        variantLabel.isHidden = true
        if let itemVariant = orderItem.variant?.variant {
            let variants = itemVariant.compactMap { $0.value }
            let variantText = variants.joined(separator: "\n")
            textForVariant += variantText
        }
        if let itemTopinngs = orderItem.toppings, itemTopinngs.count > 0 {
            textForVariant += "\n"
            let toppings = itemTopinngs.compactMap{ $0.name }
            let toppingText = toppings.joined(separator: ", ")
            textForVariant += toppingText
        }
        if let menuOptions = orderItem.options, menuOptions.count > 0 {
            textForVariant += "\n"
            let options = menuOptions.compactMap{ $0.name }
            let optionsText = options.joined(separator: ", ")
            textForVariant += optionsText
        }
        variantLabel.text = textForVariant
        variantLabel.isHidden = textForVariant == ""
        if let quantity = orderItem.quantity {
            quantityLabel.text = "\(quantity)x"
        }
        itemNameLabel.text = ""
        if let menu = orderItem.name {
            itemNameLabel.text = menu
        }
        let actualPrice: Double? = ((orderItem.amount ?? 0.0) - (orderItem.discount ?? 0.0)) * Double(orderItem.quantity ?? 1)
        
        if let priceString = self.controller?.priceFormat(pricedouble: actualPrice ?? 0.0) {
            priceLabel.text = "\(priceString)\(currencySymbol)"
        }
        soldByLabel.isHidden = true
        if let specialInst = orderItem.specialInstruction {
            specialInstLabel.text = specialInst
        }else{
            specialInstLabel.isHidden = true
        }
        guard let extraCharge = orderItem.variant?.extra_charges else { return}
        if extraCharge.count > 0 {
            extraChargeTableView.isHidden = false
            self.extraVariants = extraCharge
            extraChargeTableView.reloadData()
        }else{
            extraChargeTableView.isHidden = true
        }
        
    }
    
    func setupData(restaurantItem: Restaurant_Order_Item) {
        self.restaurantItem = restaurantItem
        reviewButton.isHidden = true
        reviewButtonHeight.constant = 0
        var textForVariant = ""
        variantLabel.isHidden = true
        if let itemVariant = restaurantItem.variations {
            let variants = itemVariant.compactMap { $0.value }
            let variantText = variants.joined(separator: "\n")
            textForVariant += variantText
        }
        if let itemTopinngs = restaurantItem.toppings, itemTopinngs.count > 0 {
            textForVariant += "\n"
            let toppings = itemTopinngs.compactMap{ $0.name }
            let toppingText = toppings.joined(separator: ", ")
            textForVariant += toppingText
        }
        if let menuOptions = restaurantItem.options, menuOptions.count > 0 {
            textForVariant += "\n"
            let options = menuOptions.compactMap{ $0.name }
            let optionsText = options.joined(separator: ", ")
            textForVariant += optionsText
        }
        variantLabel.text = textForVariant
        variantLabel.isHidden = textForVariant == ""
        if let quantity = restaurantItem.quantity {
            quantityLabel.text = "\(quantity)x"
        }
        itemNameLabel.text = ""
        if let menu = restaurantItem.menu_name {
            itemNameLabel.text = menu
        }
        let actualPrice: Double? = ((restaurantItem.amount ?? 0.0) - (restaurantItem.discount ?? 0.0)) * Double(restaurantItem.quantity ?? 1)
        
        if let priceString = self.controller?.priceFormat(pricedouble: actualPrice ?? 0.0) {
            priceLabel.text = "\(priceString)\(currencySymbol)"
        }
        
        soldByLabel.numberOfLines = 0
        soldByLabel.text = restaurantItem.concatToppingsAndVariations()
        guard let extraCharge = restaurantItem.extracharges else { return}
        if extraCharge.count > 0 {
            extraChargeTableView.isHidden = false
            self.extraVariants = extraCharge
            extraChargeTableView.reloadData()
        }else{
            extraChargeTableView.isHidden = true
        }
    }
    
    @objc private func reviewButtonPressed(_ gesture: UITapGestureRecognizer) {
        if let slug = productItem.slug {
            productItemRatingDelegate?.didReviewProductItem(slug)
        }
    }
    
}

extension Cell_TV_ShopOrderItem: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraVariants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExtraChargeListTableViewCell.identifier, for: indexPath)as? ExtraChargeListTableViewCell else {
            return UITableViewCell()
        }
        cell.extraChargeNameLbl.text = extraVariants[indexPath.row].name
        let price = "\(priceFormat(pricedouble: Double(extraVariants[indexPath.row].value ?? "") ?? 0.0))\(currencySymbol)"
        cell.extraChargePriceLbl.text = price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

