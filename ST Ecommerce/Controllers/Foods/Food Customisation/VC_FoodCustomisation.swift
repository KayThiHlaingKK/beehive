//
//  VC_FoodCustomisation.swift
//  ST Ecommerce
//
//  Created by Necixy on 22/12/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import Toast_Swift



protocol ChangeMenu {
    func clickApplyforAdd()
    func clickApplyforSub()
}
class VC_FoodCustomisation: UIViewController {
    
//  MARK: - Varibles
    let hud = JGProgressHUD(style: .dark)
    var menu : Available_menus?
    var restroCart : RestroCart?
    
    var range: [Int : Int] = [:]
    
    var menuVariants: [Menu_variants]?
    var variants: [Variant]?
    var addons: String?
    var topping: [MenuTopping]?
    var menuOptions = [MenuOption]()
    var deliDateTime: DeliDateTime?
    
    var selectedElement = [Int : String]()
    
    var isFirstTimeVariation: Bool = true
    var chooseVariat: Menu_variants?
    var chooseTopping: [MenuTopping]? = []
    var chooseOptions = [VariantOption]()
    
    var isFirstTimeAddons: Bool = true
    var selectedAddons = [[String:Any]]()
    var valuess = [[String:Int]]()
        
    var cartLabel: UILabel!
    
    var optionns = [String:Any]()
    var addonQty: Int = 0
    var toppingQty: Int = 0
    
    var restaurantBranch : RestaurantBranch?
    var addMenuProtocol: ChangeMenu?
    var qty = 1
    var willHide: [Bool] = [Bool]()
    var restaurantController: RestaurantDetailViewController?
    
//  MARK: - Outlets
    @IBOutlet weak var viewCustomisationDetails: UIView!
    @IBOutlet weak var customizationMainView: UIView!
   
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var toppingTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionTV: UITextView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCrossPrice: UILabel!
    @IBOutlet weak var crossPriceStackView: UIStackView!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var tableViewVariationCustomisation: UITableView!
    
    @IBOutlet weak var defaultExtraChargeTableView: SelfSizingTableView!
    @IBOutlet weak var tableViewToppingsCustomisation: UITableView!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var tableVariationHeight: NSLayoutConstraint!
    @IBOutlet weak var tableToppingHeight: NSLayoutConstraint!
    @IBOutlet weak var tableExtraChargeHeight: NSLayoutConstraint!
    @IBOutlet weak var dataViewHeight: NSLayoutConstraint!
    @IBOutlet weak var variationLineView: UIView!
    @IBOutlet weak var toppingLineView: UIView!
    
    private enum CellType: String, CaseIterable {
        case VC_FoodCustomisation_Variation_Cell, VC_FoodCustomisation_Toppings_Cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
  
        menuVariants = menu?.menu_variants
        topping = menu?.menu_toppings
        menuOptions = menu?.menu_options ?? []

        
        if menu?.menu_variants?.count ?? 0 > 0 {
            self.chooseVariat = menu?.menu_variants?[0]
        }
        
        if let discount = menu?.discount , discount != 0{
            let orgPrice = menu?.price ?? 0
            let actualPrice = orgPrice - discount
            lblPrice.text = "\(priceFormat(pricedouble: actualPrice))\(currencySymbol)"
            
            crossPriceStackView.isHidden = false
            let attributedString = NSAttributedString(string: "\(priceFormat(price: Int(orgPrice)) )\(currencySymbol)").withStrikeThrough()
            lblCrossPrice.attributedText = attributedString
        }
        else {
            crossPriceStackView.isHidden = true
            if let price = menu?.price {
                lblPrice.text = "\(priceFormat(pricedouble: price))\(currencySymbol)"
            }
        }
        
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.tableVariationHeight.constant = self.tableViewVariationCustomisation.contentSize.height
            self.tableToppingHeight.constant = self.tableViewToppingsCustomisation.contentSize.height
            self.tableExtraChargeHeight.constant = self.defaultExtraChargeTableView.contentSize.height
        }
    }
    
    //  MARK: - Action Functions
    @IBAction func btnApply(_ sender: Any) {
        if readLogin() != 0{
            self.callAddtocartAPI()
//            addMenuProtocol?.clickApplyforAdd()
        }
        else{
            self.showNeedToLoginApp()
        }
    }
      
    @IBAction func btnBack(_ sender: Any) {
        Singleton.shareInstance.isBack = false
        navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        //        tableViewVariationCustomisation.register(VC_FoodCustomisation_Variation_Cell.self, forCellReuseIdentifier: "VC_FoodCustomisation_Variation_Cell")
        tableViewToppingsCustomisation.delegate = self
        tableViewToppingsCustomisation.dataSource = self
        tableViewVariationCustomisation.delegate = self
        tableViewVariationCustomisation.dataSource = self
        
        tableViewVariationCustomisation.registerCell(type: VariantsListTableViewCell.self)
        tableViewToppingsCustomisation.register(VC_FoodCustomisation_Toppings_Cell.self, forCellReuseIdentifier: "VC_FoodCustomisation_Toppings_Cell")
        defaultExtraChargeTableView.registerCell(type: ExtraChargeListTableViewCell.self)
//        tableViewToppingsCustomisation.registerCell(type: VC_FoodCustomisation_Toppings_Cell.self)
        tableViewVariationCustomisation.reloadData()
        defaultExtraChargeTableView.reloadData()
        self.lblItemName.text = self.menu?.name ?? ""
        self.lblDes.text = self.menu?.description ?? ""
        
        if menuVariants?.count ?? 0 > 1{
            tableViewVariationCustomisation.isHidden = false
            variationLineView.isHidden = false
        }else{
            tableViewVariationCustomisation.isHidden = true
            variationLineView.isHidden = true
            if menuVariants?[0].extra_charges?.count ?? 0 > 1{
                defaultExtraChargeTableView.isHidden = false
            }else{
                defaultExtraChargeTableView.isHidden = true
            }
        }
        
        if topping?.isEmpty == true && menuOptions.isEmpty == true {
            tableViewToppingsCustomisation.isHidden = true
            self.tableToppingHeight.constant = 0
            variationLineView.isHidden = true
        }
        

        instructionTV.text = "Special Instruction"
        instructionTV.textColor = UIColor.lightGray
        instructionTV.delegate = self
        instructionTV.layer.borderWidth = 0.5
        instructionTV.layer.borderColor = UIColor.lightGray.cgColor
        instructionTV.layer.cornerRadius = 5
       
        let tcount: Int = self.menu?.menu_toppings?.count ?? 0
        for i in 0..<tcount {
            if ((self.menu?.menu_toppings?[i].is_incremental) != nil) {
                willHide.append(true)
            }
            else {
                willHide.append(false)
            }
        }
        
        if #available(iOS 15.0, *) {
            tableViewToppingsCustomisation.sectionHeaderTopPadding = 0
        }
    }
    
//    override func viewDidLayoutSubviews() {
//        dataViewHeight.constant = lblItemName.bounds.size.height + lblDes.bounds.size.height + 50
//    }
//
    
    @IBAction func plusClicked(_ sender: UIButton) {
        qty = qty + 1
        lblQty.text = "\(qty)"
    }
     
    @IBAction func minusClicked(_ sender: UIButton) {
        if qty > 1 {
            qty = qty - 1
            lblQty.text = "\(qty)"
        }
    }
    

    func callAddtocartAPI() {
        var toppingParam: [[String: Any]] = []
        let topcount = chooseTopping?.count ?? 0
        if topcount > 0 {
            for i in 0..<topcount {
                var t:[String: Any] = [:]
                t["slug"] = chooseTopping?[i].slug
                t["quantity"] = chooseTopping?[i].quantity
                toppingParam.append(t)
            }
        }
        
        var addressItem: [String: Any] = [:]
        if Singleton.shareInstance.selectedAddress?.latitude != nil {
            let add = Singleton.shareInstance.selectedAddress
            addressItem["house_number"] = add?.house_number
            addressItem["floor"] = add?.floor
            addressItem["street_name"] = add?.street_name
            addressItem["latitude"] = add?.latitude
            addressItem["longitude"] = add?.longitude
        }
        else {
            print("nearest address is nil")
            addressItem["street_name"] = Singleton.shareInstance.currentAddress
            addressItem["latitude"] = Singleton.shareInstance.currentLat
            addressItem["longitude"] = Singleton.shareInstance.currentLong
        }

        let specialInstructions = instructionTV.text
        let chooseMenuOptions = chooseOptions.compactMap { $0.slug }
        let param : [String:Any] = [
            "customer_slug": Singleton.shareInstance.userProfile?.slug ?? "",
            "restaurant_branch_slug": restaurantBranch?.slug ?? "",
            "quantity": qty,
            "variant_slug": chooseVariat?.slug ?? "",
            "toppings": toppingParam,
            "option_items" : chooseMenuOptions,
            "address": addressItem,
            "special_instruction": instructionTV.text == "Special Instruction" ? "": specialInstructions as Any
            
        ]
        
        print("restaurant param = " , param)
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantMenuCart.caseValue)\(menu?.slug ?? "")", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            print("response food " , response)
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
                        
            if status == 200{
                self.showToast(message: "added to cart", font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))
                if let saveDeliDateTime = self.deliDateTime {
                    self.saveToUserDefault(deliTime: saveDeliDateTime.deliTime, deliDateTime: saveDeliDateTime.deliDateTime , deliMode: saveDeliDateTime.deliMode, deliDate: saveDeliDateTime.deliDate)
                }
                self.navigationController?.popViewController(animated: true)

            }
            else if status == 400 {
                self.presentAlertWithTitle(title: warningText, message: replaceCartAlertText, options: "Yes", "No") { (option) in
                    switch(option) {
                    case 0:  
                        self.deleteFoodCart()
                        CustomUserDefaults.shared.removeAll()
                        self.dismiss(animated: true, completion: nil)
                    case 1:
                        CustomUserDefaults.shared.removeAll()
                        self.dismiss(animated: true, completion: nil)
                    default:
                        break
                    }
                }
            }
            
            else if status == 422 {
                self.showNeedToLoginApp()
            }
            else {
                DEFAULTS.set(false, forKey: UD_isContainAdd)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
    func deleteFoodCart() {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantCart.caseValue)", method: .delete,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
                        
            if status == 200{
                
                self.callAddtocartAPI()
            }
            else {
                DEFAULTS.set(false, forKey: UD_isContainAdd)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }

    func getItemsFromCart(){

        let param : [String:Any] = [:]
        self.showHud(message: loadingText)

        APIUtils.APICall(postName: "\(APIEndPoint.cartPathRestro.caseValue)\(APIEndPoint.getItems.caseValue)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in

            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false

            if status{
                if let cart = data.value(forKeyPath: "data.cart") as? NSDictionary{

                    APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cartPathRestro.caseValue, modelName:"RestroCart", onSuccess: { (anyData) in

                        self.restroCart = anyData as? RestroCart ?? nil

                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }

                }
                else{
                }

            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }

        }) { (reason, statusCode) in
            self.hideHud()
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame: CGRect = self.view.frame
        frame.origin.y = scrollView.contentOffset.y
        view.frame = frame

        view.bringSubviewToFront(view)
    }
    
}

//  MARK: - TableView Set_Up
extension VC_FoodCustomisation: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tableViewVariationCustomisation {
            return 1//menu?.menu_variations?.count ?? 0
        } else if tableView == tableViewToppingsCustomisation {
            if topping?.count ?? 0 > 0 {
                return 1 + menuOptions.count
            }
            else {
                return menuOptions.count
            }
        }else if tableView == defaultExtraChargeTableView{
            return 1
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView != defaultExtraChargeTableView{
            let view = UIView()
            let lineView = UIView()
            let label = UILabel()
            let optionLbl = UILabel()
            let maxChoiceLabel = UILabel()
            
            view.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: 40)
            lineView.frame = CGRect.init(x: 20, y: -20, width: UIScreen.main.bounds.width - 40, height: 1.5)
            label.frame = CGRect.init(x: 16, y: 10, width: UIScreen.main.bounds.width - 120, height: 20)
            maxChoiceLabel.frame = CGRect.init(x: 16, y: 40, width: UIScreen.main.bounds.width - 120, height: 20)
            label.font.withSize(10)
            label.numberOfLines = 0
            label.font = UIFont(name: AppConstants.Font.Lexend.Medium, size: 17)
            
            optionLbl.frame = CGRect.init(x: UIScreen.main.bounds.width - 110, y: 10, width: 100, height: 30)
            optionLbl.font.withSize(10)
            optionLbl.textAlignment = NSTextAlignment.center
            optionLbl.layer.backgroundColor = UIColor.appLightYelloColor().cgColor
            optionLbl.layer.cornerRadius = 3
            
            if #available(iOS 13.0, *) {
                lineView.backgroundColor = .systemGray5
            } else {
                // Fallback on earlier versions
            }
            
            if tableView == tableViewVariationCustomisation {
                label.text = self.menuVariants?[section].variant?[0].name//self.variation?[section].name
                optionLbl.text = "1 Required"
            } else {
                
                var room = 0
                if self.topping?.count ?? 0 > 0 {
                    room = section - 1
                    label.text = section == 0 ? "Toppings": menuOptions[room].name
                }
                else {
                    room = section
                    label.text = menuOptions[room].name
                }
                
                optionLbl.text = "Optional"
                if section > 0 {
                    view.addSubview(lineView)
                    if let maxChoice = menu?.menu_options?[room].max_choice {
                        maxChoiceLabel.text = "At most \(maxChoice) item(s)"
                    }
                }
            }
            
            view.addSubview(label)
            view.addSubview(optionLbl)
            view.addSubview(maxChoiceLabel)
            
            return view
        }

       return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tableViewToppingsCustomisation && section > 0 {
            return 80
        }else if tableView == defaultExtraChargeTableView{
            return 0
        }
        return 40
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableViewVariationCustomisation{
            return UITableView.automaticDimension
        } else if tableView == tableViewToppingsCustomisation {
            return 85
        }else if tableView == defaultExtraChargeTableView{
//            return tableView.estimatedRowHeight
            return 20
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewVariationCustomisation {
            return self.menuVariants?.count ?? 0//self.variation?[section].menu_variation_values?.count ?? 5
        } else if tableView == tableViewToppingsCustomisation{
            
            if self.topping?.count ?? 0 > 0 {
                if section == 0 { return self.topping?.count ?? 0 }
                else {return menuOptions[section - 1].options?.count ?? 0 }
            }
            else {
                 return menuOptions[section].options?.count ?? 0
            }
            
        }else if tableView == defaultExtraChargeTableView{
            return self.menuVariants?[0].extra_charges?.count ?? 0
        }
        else {
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewVariationCustomisation {
            //            let cell = tableView.dequeueReusableCell(withIdentifier: CellType.VC_FoodCustomisation_Variation_Cell.rawValue) as! VC_FoodCustomisation_Variation_Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: VariantsListTableViewCell.identifier, for: indexPath)as! VariantsListTableViewCell
            cell.controller = self
            cell.setDataConfigure(variants: menuVariants?[indexPath.row].variant ?? [Variant]())
            let extraCharges = menuVariants?[indexPath.row].extra_charges ?? [ExtraCharges] ()
            cell.extraVariants = extraCharges
            cell.extraChargeTableView.reloadData()

            if let discount = menuVariants?[indexPath.row].discount , discount != 0{
                let orgPrice = menuVariants?[indexPath.row].price ?? 0
                let actualPrice = orgPrice - discount
                cell.lblAmount.text = "\(priceFormat(pricedouble: actualPrice))\(currencySymbol)"
            }
            else {
                if let price = menuVariants?[indexPath.row].price {
                    cell.lblAmount.text = ("\(priceFormat(pricedouble: price))\(currencySymbol)")
                }
            }
            
            cell.rowIndex = indexPath.row
            
            if isFirstTimeVariation{
                self.chooseVariat = menu?.menu_variants?[0]
                menu?.menu_variants?[0].isSelected = true
                cell.imgSelect.image =  #imageLiteral(resourceName: "radio_button_selected")
                isFirstTimeVariation = false
            }
            
            let selected = menu?.menu_variants?[indexPath.row].isSelected ?? false
            cell.imgSelect.image = selected ? #imageLiteral(resourceName: "radio_button_selected") : #imageLiteral(resourceName: "radio_button_un_selected")
            return cell

        }
        else if tableView == tableViewToppingsCustomisation {
            return createToppingCell(indexPath: indexPath)
        }else if tableView == defaultExtraChargeTableView{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExtraChargeListTableViewCell.identifier, for: indexPath)as? ExtraChargeListTableViewCell else { return  UITableViewCell() }
            let extraCharges = menuVariants?[indexPath.section].extra_charges ?? [ExtraCharges] ()
            cell.extraChargeNameLbl.text = extraCharges[indexPath.row].name
            let price = "\(priceFormat(pricedouble: Double(extraCharges[indexPath.row].value ?? "") ?? 0.0))\(currencySymbol)"
            cell.extraChargePriceLbl.text = price
            return cell
        }
        
        return UITableViewCell()
    }
    
   
    
    private func createToppingCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableViewToppingsCustomisation.dequeueReusableCell(withIdentifier: CellType.VC_FoodCustomisation_Toppings_Cell.rawValue) as? VC_FoodCustomisation_Toppings_Cell
        else { return UITableViewCell() }
        cell.controller = self
        let section = indexPath.section
        let row = indexPath.row
        cell.selectionStyle = .none
        if section == 0 && topping?.count ?? 0 > 0 {
            let menuToppings = menu?.menu_toppings?[row]
            let selected = menuToppings?.isSelected ?? false
            cell.imgSelect.image = selected ? #imageLiteral(resourceName: "verified"): #imageLiteral(resourceName: "blank-check-box")
            cell.lblToppingName.text = menuToppings?.name
            cell.shouldHideIncrementView = !(menuToppings?.is_incremental ?? false)
            let topPrice = menuToppings?.price
            cell.lblAmount.text = "\(priceFormat(pricedouble: topPrice ?? 0))\(currencySymbol)"
            
            cell.slug = menu?.menu_toppings?[section].slug ?? ""
            
            if let chooseTopping = chooseTopping {
                chooseTopping.forEach {
                    if $0.slug == menuToppings?.slug {
                        cell.lblCount.text = $0.quantity.description
                    }
                }
            }
            cell.increaseView.isHidden = willHide[indexPath.row]
        } else {
            var room = 0
            if topping?.count ?? 0 > 0 {
                room = section - 1
            }
            else {
                room = section
            }
            let option = menu?.menu_options?[room].options?[row]
            cell.lblToppingName.text = option?.name
            let price = option?.price
            cell.lblAmount.text = "\(priceFormat(pricedouble: price ?? 0))\(currencySymbol)"
            cell.imgSelect.image = option?.selected == true  ? #imageLiteral(resourceName: "verified"): #imageLiteral(resourceName: "blank-check-box")
            
            cell.increaseView.isHidden = true
        }
       
        cell.sectionIndex = indexPath.section
        cell.rowIndex = indexPath.row
        
        return cell
    }
}


extension VC_FoodCustomisation: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Special Instruction"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
}
