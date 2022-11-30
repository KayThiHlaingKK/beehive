//
//  AddToCartViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 17/08/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import CoreLocation


class AddToCartViewController : UIViewController {
   
    @IBOutlet weak var instructionTV: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var crossPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var extraChargeLbl: UILabel!
    @IBOutlet weak var extraAmtLbl: UILabel!
    @IBOutlet weak var extraChargeLblTwo: UILabel!
    @IBOutlet weak var extraChargeLblThree: UILabel!
    @IBOutlet weak var extraChargeLblFour: UILabel!
    @IBOutlet weak var extraAmtTwoLbl: UILabel!
    @IBOutlet weak var extraAmtThreeLbl: UILabel!
    @IBOutlet weak var extraAmtFourLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    @IBOutlet weak var wholeConstraint: NSLayoutConstraint!
    
    var orderCount = 1
    var chooseMenu: Available_menus?
    var menuData: MenuDetailData?
    var restaurantBranch: RestaurantBranch?
    var restaurantController: RestaurantDetailViewController?
    var chooseVariant: [Menu_variants] = [Menu_variants]()
    var deliDateTime: DeliDateTime?

    
    override func viewDidLoad() {
        guard let chooseMenu = chooseMenu else {
            return
        }
        setData(data: chooseMenu)
        UISetup()
        
    }
    
    func setData(data: Available_menus){
        menuLabel.text = data.name
        desLabel.text = data.description
        
        priceLabel.text = "\(priceFormat(pricedouble: data.price ?? 0))\(currencySymbol)"
        
        crossPriceLabel.isHidden = true
        if (chooseMenu?.discount != 0) {
        
            let discount = data.discount ?? 0.0
            let orgPrice = data.price ?? 0.0
            let actualPrice = orgPrice - discount
            
            crossPriceLabel.isHidden = false
            //let originalPrice_ = actualPrice.replacingOccurrences(of: ".00", with: "")
            let attributedString = NSAttributedString(string: "\(priceFormat(pricedouble: orgPrice))\(currencySymbol)").withStrikeThrough()
            crossPriceLabel.attributedText = attributedString
       
            priceLabel.text = "\(priceFormat(pricedouble: actualPrice))\(currencySymbol)"
            
        }
        
        if let images = chooseMenu?.images,
           images.count > 0 {
            imgView.isHidden = false
            imageConstraint.constant = UIScreen.main.bounds.width
            wholeConstraint.constant = UIScreen.main.bounds.width + 280
            let imagePathItem = "\(images.first?.url ?? "")?size=large"
            imgView.setIndicatorStyle(.gray)
            imgView.setShowActivityIndicator(true)
            imgView.downloadImage(url: imagePathItem, fileName: images.first?.file_name)
        }
        else {
            imgView.isHidden = true
            imageConstraint.constant = 0
            wholeConstraint.constant = 280
        }
        
        if let des = data.description, des.count > 40 {
            wholeConstraint.constant = wholeConstraint.constant + 50
        }
        
        let extraCharges = chooseMenu?.menu_variants?[0].extra_charges ?? [ExtraCharges]()
        if !extraCharges.isEmpty{
            if extraCharges.count == 4{
                extraChargeLbl.text = extraCharges[0].name
                extraChargeLblTwo.text = extraCharges[1].name
                extraChargeLblThree.text = extraCharges[2].name
                extraChargeLblFour.text = extraCharges[3].name
                extraAmtLbl.text = "\(extraCharges[0].value ?? "") MMK"
                extraAmtTwoLbl.text = "\(extraCharges[1].value ?? "") MMK"
                extraAmtThreeLbl.text = "\(extraCharges[2].value ?? "") MMK"
                extraAmtFourLbl.text = "\(extraCharges[3].value ?? "") MMK"
            }
            else if extraCharges.count == 3{
                extraChargeLbl.text = extraCharges[0].name
                extraChargeLblTwo.text = extraCharges[1].name
                extraChargeLblThree.text = extraCharges[2].name
                extraAmtLbl.text = "\(extraCharges[0].value ?? "") MMK"
                extraAmtTwoLbl.text = "\(extraCharges[1].value ?? "") MMK"
                extraAmtThreeLbl.text = "\(extraCharges[2].value ?? "") MMK"
            }
            else if extraCharges.count == 2{
                extraChargeLbl.text = extraCharges[0].name
                extraChargeLblTwo.text = extraCharges[1].name
                extraAmtLbl.text = "\(extraCharges[0].value ?? "") MMK"
                extraAmtTwoLbl.text = "\(extraCharges[1].value ?? "") MMK"
            }
            else if extraCharges.count == 1{
                extraChargeLbl.text = extraCharges[0].name
                extraAmtLbl.text = "\(extraCharges[0].value ?? "") MMK"
            }
        }
        
    }
    
    func UISetup() {
        imgView.roundCorners(corners: [.topRight, .topLeft], amount: 10)
        wholeView.roundCorners(corners: [.topRight, .topLeft], amount: 10)
        
        instructionTV.text = "Special Instruction"
        instructionTV.textColor = UIColor.lightGray
        instructionTV.delegate = self
        instructionTV.layer.borderWidth = 0.5
        instructionTV.layer.borderColor = UIColor.lightGray.cgColor
        instructionTV.layer.cornerRadius = 5
    }
    

    @IBAction func addToCartClicked(_ sender: UIButton) {
        print("when addtocart = ", readLogin())
        if readLogin() != 0 {
            self.callAddtocartAPI()
        }
        else{
            self.showNeedToLoginApp()
        }
    }
    
    func callAddtocartAPI() {
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
        
        let inst = instructionTV.text ?? ""
        let variantSlug = chooseMenu?.menu_variants?.compactMap{$0.slug}
        let param : [String:Any] = [
            "customer_slug": Singleton.shareInstance.userProfile?.slug ?? "",
            "restaurant_branch_slug": restaurantBranch?.slug ?? "",
            "quantity": orderCount,
            "variant_slug": variantSlug ?? "" ,
            "toppings": [],
            "option_items" : [],
            "address": addressItem,
            "special_instruction": inst == "Special Instruction" ? "" : inst
            
        ]
        
        print("callAddtocartAPI " , param)
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantMenuCart.caseValue)\(chooseMenu?.slug ?? "")", method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            print("response food " , response)
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
                        
            if status == 200{
                if let saveDeliDateTime = self.deliDateTime {
                    self.saveToUserDefault(deliTime: saveDeliDateTime.deliTime, deliDateTime: saveDeliDateTime.deliDateTime, deliMode: saveDeliDateTime.deliMode, deliDate: saveDeliDateTime.deliDate)
                }
                self.showToast(message: "added to cart", font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))
                self.restaurantController?.loadRestaurantCart()
                
            }
            else if status == 400 {
//                let message = data.value(forKey: key_message) as? String
                self.presentAlertWithTitle(title: warningText, message: replaceCartAlertText, options: "Yes", "No") { (option) in
                    switch(option) {
                    case 0:  
                        self.deleteCart()
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
    
    func deleteCart() {
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        print("param ", param)
        
        APIUtils.APICall(postName: "\(APIEndPoint.restaurantCart.caseValue)", method: .delete,  parameters: param, controller: self, onSuccess: { (response) in
            print("delete response " , response)
            
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
    
    @IBAction func plusClicked(_ sender: UIButton) {
        orderCount = orderCount + 1
        countLabel.text = "\(orderCount)"
    }
    
    @IBAction func minusClicked(_ sender: UIButton) {
        if orderCount > 1 {
            orderCount = orderCount - 1
            countLabel.text = "\(orderCount)"
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
        {
            let touch = touches.first
            if touch?.view != self.wholeView
            { self.dismiss(animated: true, completion: nil) }
        }
    
    
}

extension AddToCartViewController: UITextViewDelegate {
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
