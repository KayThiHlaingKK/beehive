//
//  Cell_TV_Restro_Cart_Item.swift
//  ST Ecommerce
//
//  Created by necixy on 04/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

protocol DeleteSuccessOptionDelegate{
    func deleteSucess(option: Bool)
}

class Cell_TV_Restro_Cart_Item: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var buttonMinus: UIButton!
    @IBOutlet weak var labelItemQty: UILabel!
    @IBOutlet weak var buttonPlus: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var buttonRemoveItem: UIButton!
    @IBOutlet weak var labelRestname: UILabel!
    @IBOutlet weak var labelVariant: UILabel!
    @IBOutlet weak var labelSpecialInstruction: UILabel!
    
    @IBOutlet weak var extraChargeTableView: SelfSizingTableView!
    @IBOutlet weak var extraChargeHightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var headerView: UIView!
    
    
    //MARK: - Variables
    var controller_:VC_Cart!
    weak var controller:CartViewController!
    var menu: MenusCart?
    var extraCharge = [ExtraCharges]()
    var deleteDelegate: DeleteSuccessOptionDelegate?
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    
    func setupUI() {
        extraChargeTableView.dataSource = self
        extraChargeTableView.delegate = self
        extraChargeTableView.registerCell(type: ExtraChargeListTableViewCell.self)
        
    }
    
    
    //MARK: - Helper Functions
    private func setVariantLabel(_ cartItem: MenusCart) {
        var textForVariant = ""
        labelVariant.isHidden = true
        if let itemVariant = cartItem.variant?.variant {
            let variants = itemVariant.compactMap { $0.value }
            let variantText = variants.joined(separator: "\n")
            textForVariant += variantText
        }
        if let itemTopinngs = cartItem.toppings, itemTopinngs.count > 0 {
            textForVariant += "\n"
            let toppings = itemTopinngs.compactMap{ $0.name }
            let toppingText = toppings.joined(separator: ", ")
            textForVariant += toppingText
        }
        if let menuOptions = cartItem.options, menuOptions.count > 0 {
            textForVariant += "\n"
            let options = menuOptions.compactMap{ $0.name }
            let optionsText = options.joined(separator: ", ")
            textForVariant += optionsText
        }
        labelVariant.text = textForVariant
        labelVariant.isHidden = textForVariant == ""
    }
    
    func setData(cartItem:MenusCart){
        labelTitle.text = (cartItem.name ?? "").trunc(length: 40)
        let count = cartItem.variant?.variant?.count ?? 0
        labelPrice.text = "\(self.controller.priceFormat(pricedouble: cartItem.amount ?? 0))\(currencySymbol)"


        if cartItem.discount != 0 {
            let discount = cartItem.discount ?? 0
            let orgPrice = cartItem.amount ?? 0
            let actualPrice = orgPrice - discount
            labelPrice.text = "\(self.controller.priceFormat(pricedouble: actualPrice))\(currencySymbol)"

        }
        
        labelItemQty.text = "\(cartItem.quantity?.description ?? "")"
        labelSpecialInstruction.text = cartItem.specialInstruction
        setVariantLabel(cartItem)
        guard let extraCharge = cartItem.variant?.extra_charges else { return}
        if extraCharge.count > 0 {
            extraChargeTableView.isHidden = false
            self.extraCharge = extraCharge
            extraChargeTableView.reloadData()
        }else{
            extraChargeTableView.isHidden = true
        }
    }
    
    func changeQty(qty: Int, row: Int) {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? "", "key" : menu?.key ?? "", "quantity" : qty]
            print("param ", param)
            
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantMenuCart.caseValue)\(menu?.slug ?? "")", method: .put,  parameters: param, controller: self.controller, onSuccess: { (response) in
                print("plus response " , response)
                
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                            
                if status == 200{
                    
                    if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                        APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.restaurantMenuCart.caseValue, modelName: "Menu", onSuccess: { (anyData) in
                            
                            self.controller.cartData?.restaurant = anyData as? RestaurantCart
                            let indexPosition = IndexPath(row: row, section: 0)
                            let indexPosition1 = IndexPath(row: 0, section: 1)
                            self.controller.tableViewCart.reloadRows(at: [indexPosition, indexPosition1], with: .none)
                            self.controller.totalAmtLbl.text = "\(self.controller.priceFormat(pricedouble: self.controller.cartData?.restaurant?.total_amount ?? 0))\(currencySymbol)"
                            
                        }) { (error, endPoint) in
                            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                        }
                    }
                
                }
                else {
                    DEFAULTS.set(false, forKey: UD_isContainAdd)
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
            }
    }
    
    //MARK: - Action Functions
    @IBAction func minus(_ sender: UIButton) {
        var qty: Int = menu?.quantity ?? 1
        if qty > 1 {
            qty = qty - 1
            changeQty(qty: qty, row: sender.tag)
        
        }
        else {
            self.controller.presentAlertWithTitle(title: warningText, message: removeItemFromCartAlertText, options: noText, yesText) { (option) in
                
                switch(option) {
                case 1:
                    self.deleteCartMenu()
                    
                default:
                    break
                }
            }
            
        }
    }
    
    @IBAction func plus(_ sender: UIButton) {
        
        var qty: Int = menu?.quantity ?? 1
        qty = qty + 1
        changeQty(qty: qty, row: sender.tag)
        
    }
    
    @IBAction func removeItemFromCart(_ sender: UIButton) {
                
        self.controller.presentAlertWithTitle(title: warningText, message: removeItemFromCartAlertText, options: noText, yesText) { (option) in
            
            switch(option) {
            case 1:
                let room: Int = sender.tag
                print("to remove " , room)
               // self.controller.foodOrderRestaurant?.choose_menus.remove(at: room)
                CustomUserDefaults.shared.removeAll()
                self.deleteCartMenu()
                
            default:
                break
            }
        }
        
        
    }
    
    
    func deleteCartMenu() {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? "", "key" : menu?.key ?? ""]
            print("param ", param)
        
        print(param)
            
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantMenuCart.caseValue)\(menu?.slug ?? "")", method: .delete,  parameters: param, controller: self.controller, onSuccess: { (response) in
                print("delete response " , response)
                
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                            
                if status == 200{
                    self.deleteDelegate?.deleteSucess(option: true)
                }
                else {
                    DEFAULTS.set(false, forKey: UD_isContainAdd)
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
            }
        
    }
    
}

extension Cell_TV_Restro_Cart_Item: UITableViewDelegate,UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        layoutIfNeeded()
//    }
//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraCharge.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExtraChargeListTableViewCell.identifier, for: indexPath)as? ExtraChargeListTableViewCell else {
            return UITableViewCell()
        }
        cell.extraChargeNameLbl.text = extraCharge[indexPath.row].name
        let price = "\(priceFormat(pricedouble: Double(extraCharge[indexPath.row].value ?? "") ?? 0.0))\(currencySymbol)"
        cell.extraChargePriceLbl.text = price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}


