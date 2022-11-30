//
//  PaymentViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 05/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import KBZPayAPPPay


class ContinuePaymentViewController: UIViewController {
   
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var addressTitleLbl: UILabel!
    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var buttonCOD: UIButton!
    @IBOutlet weak var buttonKbz: UIButton!
    @IBOutlet weak var buttonMPU: UIButton!
    @IBOutlet weak var buttonCB: UIButton!
    @IBOutlet weak var buttonVisa: UIButton!
    @IBOutlet weak var buttonCredit: UIButton!
    @IBOutlet weak var buttonCreditView: UIButton!
    @IBOutlet weak var codLbl: UILabel!
    @IBOutlet weak var creditTitleLbl: UILabel!
    @IBOutlet weak var viewheight: NSLayoutConstraint!
    @IBOutlet weak var tableContainter: UIView!
    @IBOutlet weak var creditHeight: NSLayoutConstraint!
    @IBOutlet var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tableBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cbIconImageView: UIImageView!
    
    @IBOutlet weak var cbpayLabel: UILabel!
    @IBOutlet weak var kbzpayLabel: UILabel!
    @IBOutlet weak var mpupayLabel: UILabel!
    @IBOutlet weak var visaMasterLabel: UILabel!
    
    
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var instructionTextField: UITextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var editButtonLabel: UILabel!
    @IBOutlet weak var deliveryFeeDescription: UILabel!
    @IBOutlet var deliveryFeeDescriptionHeightConstraint: NSLayoutConstraint!
    
    var playerFooter: UIView?
    
    var addressList: [Address] = []
    var cartAddress : Address?
    var firstTime = true
    var controller: UIViewController!
    var product_param : [String:Any] = [:]
    var restaurant_param : [String:Any] = [:]
    var paymentMode = PaymentMode.cash
    var kbzPay: PaymentViewController?
    var promocode = ""
    var addressItem : [String: Any] = [:]
    var nearestAddress: Address?
    private var serviceAnnouncement: ServiceAnnouncement?
    var cartType = Cart.restaurant
    var changeAddress = false
    var editShow = false
    var instText = ""
    var orderSlug = ""
    var orderType = OrderType.instant
    var credit = false
    var currentDate: String = ""
    var chooseDateTime: String = ""
    let cbValue = UserDefaults.standard.string(forKey: UD_cbvalue)
    let kbzValue = UserDefaults.standard.string(forKey: UD_kbzvalue)
    let mpuValue = UserDefaults.standard.string(forKey: UD_mpuvalue)
    let mpgsValue = UserDefaults.standard.string(forKey: UD_mpgsvalue)
    
    private let dispatchGroup = DispatchGroup()
        
    override func viewWillAppear(_ animated: Bool) {
        controller = self.parent
        userSettingAPICall()
        loadServiceAnnouncement()
//        let address = Singleton.shareInstance.selectedAddress
//        updateAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: address?.house_number ?? "", floor: address?.floor ?? 0, street_name: address?.street_name ?? "", latitude: address?.latitude ?? 0.0, longitude: address?.longitude ?? 0.0, township_slug: address?.township?.slug ?? ""))
        self.addressTableView.reloadData()
        checkCredit()
        orderTypeCheck()
        checkAddress()
        setupUI()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        editShow = false
    }
    
    override func viewDidLoad() {
        firstTime = true
        setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    fileprivate func setupUI() {
        setupAddressLabel()
        editButton.isHidden = true
        editButtonLabel.textColor = UIColor(displayP3Red: 227/255, green: 224/255, blue: 224/255, alpha: 1)
        
        hideAddressTable(animated: false)
        deliveryFeeDescription.isHidden = product_param.isEmpty
        deliveryFeeDescriptionHeightConstraint.constant = product_param.isEmpty ? 16: 90
        cbIconImageView.layer.cornerRadius = 7
    }
  
    private func setupAddressLabel() {
        addressList = Singleton.shareInstance.address ?? []
        addressLbl.text = Util.getFormattedAddress(address: Singleton.shareInstance.selectedAddress ?? Address())
        addressTitleLbl.text = Singleton.shareInstance.selectedAddress?.label
        
        DispatchQueue.main.async {
            self.editButton.isHidden = false
            self.editButtonLabel.textColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 0/255, alpha: 1)
        }
    }
    
    private func checkAddress() {
        if let selectedAddress = Singleton.shareInstance.selectedAddress {
            addressLbl.text = Util.getFormattedAddress(address: selectedAddress)
            addressTitleLbl.text = selectedAddress.label
        } else {
            editShow = true
            useCurrentLocation()
        }
    }
    
    
    
    private func setupTableView() {
        addressTableView.dataSource = self
        addressTableView.delegate = self
        addressTableView.tag = 1
        
        addressTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
//        tableHeightConstraint.constant = 0
//        tableBottomConstraint.constant = 16
        instructionTextField.delegate = self
    }
    
    
    private func showAddressTable() {
//        tableHeightConstraint.isActive = false
//        tableBottomConstraint.isActive = true
        tableContainter.isHidden = false
        
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] completed in
            self?.editShow = true
        }
        
    }
    
    private func hideAddressTable(animated: Bool) {
        tableHeightConstraint.isActive = true
//        tableBottomConstraint.isActive = false
        let duration: CGFloat = animated ? 0.05: 0.0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] completed in
            self?.tableContainter.isHidden = true
            self?.editShow = false
        }

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
                self.view.frame.origin.y -= 150
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        
        addressTableView.tableFooterView = playerFooter
        playerFooter?.isHidden = true
        addressTableView.reloadData()
        
    }
   
    func orderTypeCheck() {
        if orderType == OrderType.pickup {
            setupPaymentButton(state: PaymentState.disable, button: buttonCOD, label: codLbl, payment: PaymentMode.cash)
            
            if kbzValue != "false" {
                setupPaymentButton(state: PaymentState.selected, button: buttonKbz, label: kbzpayLabel, payment: PaymentMode.kbz)
            }
            else if cbValue != "false" {
                setupPaymentButton(state: PaymentState.selected, button: buttonCB, label: cbpayLabel, payment: PaymentMode.cb)
            }
            else if mpuValue != "false" {
                setupPaymentButton(state: PaymentState.selected, button: buttonMPU, label: mpupayLabel, payment: PaymentMode.mpu)
            }
            else if mpgsValue != "false" {
                setupPaymentButton(state: PaymentState.selected, button: buttonVisa, label: visaMasterLabel, payment: PaymentMode.mpgs)
            }
            
        }
    }
    
  
    private func toggleEditAddressView() {
        editShow ? hideAddressTable(animated: true): showAddressTable()
//        addressTableView.tableHeaderView?.isHidden = !editShow
        addressTableView.reloadData()
    }
   
    
    @objc func useCurrentLocation(){
        self.getAddressFromLatLon(pdblLatitude: "\(Singleton.shareInstance.currentLat)", withLongitude: "\(Singleton.shareInstance.currentLong)")
        addressTableView.reloadData()
        hideAddressTable(animated: true)
    }
    
    @objc func createAddress(){
//        let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
        changeAddress = true
        self.navigationController?.pushView(AddAddressRouter())
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        var addressString : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = (placemarks ?? nil) as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]

                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    self.addressTitleLbl.text = "Home"
                    self.addressLbl.text = addressString
                    
                    var defaultAddress = Address()
                    defaultAddress.latitude = Double(pdblLatitude)
                    defaultAddress.longitude = Double(pdblLongitude)
                    defaultAddress.street_name = addressString
                    Singleton.shareInstance.selectedAddress = nil
                    self.changeAddress = true
//                    self.updateAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: Singleton.shareInstance.selectedAddress?.house_number ?? "", floor: Singleton.shareInstance.selectedAddress?.floor ?? 0, street_name: Singleton.shareInstance.selectedAddress?.street_name ?? "", latitude: Singleton.shareInstance.selectedAddress?.latitude ?? 0.0, longitude: Singleton.shareInstance.selectedAddress?.longitude ?? 0.0, township_slug: Singleton.shareInstance.selectedAddress?.township?.slug ?? ""))
              }
        })
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ContinuePaymentViewController {
    
    func prepareForParam() {
        
        if changeAddress {
            if Singleton.shareInstance.selectedAddress != nil {
                print("nearest address is not nil")
                addressItem["house_number"] = Singleton.shareInstance.selectedAddress?.house_number
                addressItem["floor"] = Singleton.shareInstance.selectedAddress?.floor
                addressItem["street_name"] = Singleton.shareInstance.selectedAddress?.street_name
                addressItem["latitude"] = Singleton.shareInstance.selectedAddress?.latitude
                addressItem["longitude"] = Singleton.shareInstance.selectedAddress?.longitude
            }
            else {
                addressItem["street_name"] = Singleton.shareInstance.currentAddress
                addressItem["latitude"] = Singleton.shareInstance.currentLat
                addressItem["longitude"] = Singleton.shareInstance.currentLong
            }
        }
        
        let formatter = DateFormatter()
        currentDate = Date.getCurrentDateTime()
        
        formatter.dateFormat =  "yyyy-MM-dd"
        var d = ""
        
        switch Singleton.shareInstance.deliDate {
        case .today:
            formatter.calendar = Calendar(identifier: .gregorian)
            d = formatter.string(from: Date())
          
        case .tomorrow:
            formatter.calendar = Calendar(identifier: .gregorian)
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
  
        case .thedayaftertomorrow:
            formatter.calendar = Calendar(identifier: .gregorian)
            d = formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date())
            
        }
        
        var t = ""
        
        if Singleton.shareInstance.deliTime == "ASAP" {
            formatter.dateFormat =  "HH:mm:ss"
            formatter.calendar = Calendar(identifier: .gregorian)
            t = formatter.string(from: Date())
        }
        else {
            formatter.dateFormat =  "hh:mm a"
            if Singleton.shareInstance.deliTime == ""{
                let temp = formatter.date(from:  UserDefaults.standard.string(forKey: UD_DeliTime) ?? "") ?? Date()
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.dateFormat =  "HH:mm:ss"
                t = formatter.string(from: temp)
            }else{
                let temp = formatter.date(from: Singleton.shareInstance.deliTime) ?? Date()
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.dateFormat =  "HH:mm:ss"
                t = formatter.string(from: temp)
            }
        }
        
        formatter.calendar = Calendar(identifier: .gregorian)
        chooseDateTime = "\(d) \(t)"
        
        print("current date = " , currentDate)
        print("choose date = ", chooseDateTime)
        
    }
    
    func placeOrderAPI(){
        self.showHud(message: loadingText)
        
        prepareForParam()
        
        if changeAddress {
            if cartType == Cart.restaurant {
                restaurant_param["address"] = addressItem
            }
            else {
                product_param["address"] = addressItem
            }
            
        }
        
        if cartType == Cart.restaurant {
            restaurant_param["special_instruction"] = instText
            restaurant_param["order_date"] = chooseDateTime
        }
        else {
            product_param["special_instruction"] = instText
            product_param["order_date"] = currentDate
        }
        
        let api = cartType == Cart.restaurant ? APIEndPoint.restaurantCheckout.caseValue : APIEndPoint.productCheckout.caseValue
        
        var param = cartType == Cart.restaurant ? restaurant_param : product_param
        
        param["payment_mode"] = String(describing: paymentMode.caseValue)
        
        print("param === " , param)
        
        
        APIUtils.APICall(postName: api, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            
            print("response ==== ", response)
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            let messaages = "We are processing your order"
            
            
            if status == 201 {
                if let data = data.value(forKeyPath: "data") as? NSDictionary {
                    
                    if let slug = data["slug"] as? String {
                        self.orderSlug = slug
                    }
//                    CustomUserDefaults.shared.removeAll()
                    if self.paymentMode == PaymentMode.kbz {
                        print("it is kbz", data)
                        if let prepayId = data["prepay_id"] as? String {
                            self.goToKBZPay(prepayId: prepayId)
                        }
                    }
                    else if self.paymentMode == PaymentMode.mpu {
                        self.goToMPU()
                    }
                    else if self.paymentMode == PaymentMode.mpgs {
                        self.goToVisa()
                    }
                    else if self.paymentMode == PaymentMode.cb {
                        if let refOrder = data["generate_ref_order"] as? String {
                            self.goToCBPay(reference: refOrder)
                        }
                    }
                    else {
                        self.goOrderPage(message: messaages)
                        
                    }
                    
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlertWithTitle(title: errorText, message: message, options: okayText) { (value) in
                }
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    func goOrderPage(message: String) {
        
        self.presentAlertWithTitle(title: "Order Placed", message: message, options: okayText) { (option) in
            switch(option) {
            case 0:
                if self.cartType == .restaurant{
                    self.navigationController?.pushViewController(MyOrderScreenRouter(.paymentOrderList,.restaurant).viewController, animated: true)
                }else{
                    self.navigationController?.pushViewController(MyOrderScreenRouter(.paymentOrderList,.store).viewController, animated: true)
                }
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
       
    }
    
    
    func checkCredit() {
        let param : [String:Any] = [:]
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: APIEndPoint.checkCredit.caseValue, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            print("response ===== ", response)
            self.hideHud()
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            if status == 200 {
                
                if let data = data.value(forKeyPath: "data") as? NSDictionary {
                    
                    if let amount = data["remaining_amount"] as? Double {
                        self.creditLbl.text = "Available amount : \(self.priceFormat(price: Int(amount))) MMK"
                        self.creditView.isHidden = false
                        self.creditHeight.constant = 50
                        self.viewheight.constant = 330
                        self.credit = true
//                        self.toggleCODandOnline()
                    }
                    else {
                        self.hideCredit()
                    }
                    
                }
                else {
                    self.hideCredit()
                }
            }
            else {
                self.hideCredit()
            }
            self.toggleCODandOnline()
        }) { (reason, statusCode) in
            print("Error in fetching UserProfile: \(reason)")
        }
        
        
    }
    
    private func updateUIForServiceAnnouncement() {
        guard let serviceAnnouncement = self.serviceAnnouncement,
              let announcement = serviceAnnouncement.announcement
        else { return }
        
        let screenWidth = UIScreen.main.bounds.width
        if serviceAnnouncement.announcement_service == true {
            deliveryFeeDescription.text = announcement
            deliveryFeeDescription.isHidden = false
            deliveryFeeDescriptionHeightConstraint.constant = announcement.height(withConstrainedWidth: screenWidth - 32, font: UIFont(name: "Lato-Regular", size: 15)!) + 32
        }
        
        let isRestaurantOrder = product_param.isEmpty
        confirmButton.isEnabled = (isRestaurantOrder ? serviceAnnouncement.restaurant_service: serviceAnnouncement.shop_service) ?? true
        
    }
    
    
    private func loadServiceAnnouncement() {
        APIUtils.APICall(postName: APIEndPoint.serviceAnnouncement.caseValue, method: .get, parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            
            if status == 200 {
                if let home_popups = data.value(forKeyPath: "data") as? NSDictionary {
                    
                    APIUtils.prepareModalFromData(home_popups, apiName: APIEndPoint.serviceAnnouncement.caseValue, modelName: "ServiceAnnouncement", onSuccess: { (anyData) in
                        if let serviceAnnouncement = anyData as? ServiceAnnouncement {
                            self.serviceAnnouncement = serviceAnnouncement
                        }
                        DispatchQueue.main.async {
                            self.updateUIForServiceAnnouncement()
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            }
        }) { (reason, statusCode) in
            
        }
    }
    
    private func userSettingAPICall(){
        self.dispatchGroup.enter()
        let param : [String:Any] = [:]
        APIUtils.APICall(postName: APIEndPoint.userSetting.caseValue, method: .get,  parameters: param, controller: self, onSuccess: {  [unowned self] (response) in
                        
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            if status == 200{
                let settingData = data.value(forKeyPath: "data") as? NSArray ?? []
                
                APIUtils.prepareModalFromData(settingData, apiName: APIEndPoint.userSetting.caseValue, modelName:"UserSetting", onSuccess: { (products) in
                    let data = products as? [UserSetting] ?? []
                    for i in data{
                        if i.key == "cbpay" {
                            UserDefaults.standard.set(i.value, forKey: UD_cbvalue)
                        }else if i.key == "kbzpay"{
                            UserDefaults.standard.set(i.value, forKey: UD_kbzvalue)
                        }else if i.key == "mpu"{
                            UserDefaults.standard.set(i.value, forKey: UD_mpuvalue)
                        }else if i.key == "restaurant_order_lead_time"{
                            UserDefaults.standard.set(i.value, forKey: UD_OrderLeadTime)
                        }else if i.key == "lead_time_minute"{
                            UserDefaults.standard.set(i.value, forKey: UD_LeadTimeMinute)
                        }else if i.key == "mpgs"{
                            UserDefaults.standard.set(i.value, forKey: UD_mpgsvalue)
                        }
                    }
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
            }
            
            self.dispatchGroup.leave()
        }) { (reason, statusCode) in
        }
    }
    
    
    func hideCredit() {
//        creditView.isHidden = true
//        creditHeight.constant = 0
//        self.viewheight.constant = 250
        credit = false
//        self.buttonCredit.setImage(#imageLiteral(resourceName: "radio"), for: .normal)
        self.buttonCreditView.isUserInteractionEnabled = false
        self.buttonCredit.isUserInteractionEnabled = false
        self.creditLbl.text = ""
        self.creditTitleLbl.textColor = UIColor.gray
        
    }
}

extension ContinuePaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shareInstance.address?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        
        let address = Singleton.shareInstance.address?[indexPath.row]
        
        cell.lableLbl.text = address?.label
        cell.addressLbl.text = Util.getFormattedAddress(address: address ?? Address())
        if Singleton.shareInstance.selectedAddress?.slug == address?.slug {
            cell.optionImage?.image = #imageLiteral(resourceName: "option_on")
            cell.subView.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
        }
        else {
            cell.optionImage?.image = #imageLiteral(resourceName: "option_off")
            cell.subView.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addresses = Singleton.shareInstance.address
        Singleton.shareInstance.selectedAddress = addresses?[indexPath.row]
        changeAddress = true
        let address = addressList[indexPath.row]
//        updateAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: address.house_number ?? "", floor: address.floor ?? 0, street_name: address.street_name ?? "", latitude: address.latitude ?? 0.0, longitude: address.longitude ?? 0.0, township_slug: address.township?.slug ?? ""))
        addressTableView.reloadData()
        
        addressLbl.text = Util.getFormattedAddress(address: Singleton.shareInstance.selectedAddress ?? Address())
        addressTitleLbl.text = Singleton.shareInstance.selectedAddress?.label
        hideAddressTable(animated: true)
    }
    
//    func updateAddressAPICall(request: AddressRequest) {
//        APIClient.fetchUpdateAddress(request: request).execute(onSuccess: { data in
//            if data.status == 200 {
//                self.cartAddress = data.data?.address
//                Singleton.shareInstance.selectedAddress = data.data?.address
//                if self.cartAddress?.township_name == nil {
//                    self.addressAlertAction()
//                }
//                self.addressTableView.reloadData()
//            }
//        }, onFailure: { error in
//            print(error.localizedDescription)
//        })
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableHeaderCell") as! AddressTableHeaderCell
        cell.subView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.useCurrentLocation))
        cell.subView.addGestureRecognizer(tap)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableFooterCell") as! AddressTableFooterCell
        cell.controller = self
        cell.subView.isUserInteractionEnabled = true
        playerFooter = cell.subView
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.createAddress))
        cell.addnewView.addGestureRecognizer(tap)
//        cell.instTextField.text = instText
        
//        let orderTap = UITapGestureRecognizer(target: self, action: #selector(self.placeOrder))
//        cell.orderView.addGestureRecognizer(orderTap)
//        cell.orderView.isUserInteractionEnabled = true
//
//        if !editShow {
//            cell.addnewView.isHidden = true
//            cell.addnewViewHeight.constant = 0
//        }
//        else {
//            cell.addnewView.isHidden = false
//            cell.addnewViewHeight.constant = 50
//        }
//
//        cell.deliveryFeeDescriptionTopConstraint.isActive = product_param.isEmpty
        
//            cell.deliveryInvoiceDescriptionLabel.isHidden = true
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        50
    }
    
}




// MARK: - Radio Button Functions

extension ContinuePaymentViewController {
    
    //Button CheckStatus
    func toggleCODandOnline(){
        
        if orderType == OrderType.pickup {
            setupPaymentButton(state: PaymentState.disable, button: buttonCOD, label: codLbl, payment: PaymentMode.cash)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: buttonCOD, label: codLbl, payment: PaymentMode.cash)
        }
        
        if self.credit{
            setupPaymentButton(state: PaymentState.enable, button: buttonCredit, label: creditTitleLbl, payment: PaymentMode.credit)
        }else{
            setupPaymentButton(state: PaymentState.disable, button: buttonCredit, label: creditTitleLbl, payment: PaymentMode.credit)
        }
        
        if kbzValue == "false"{
            setupPaymentButton(state: PaymentState.disable, button: buttonKbz, label: kbzpayLabel, payment: PaymentMode.kbz)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: buttonKbz, label: kbzpayLabel, payment: PaymentMode.kbz)
        }

        if cbValue == "false"{
            setupPaymentButton(state: PaymentState.disable, button: buttonCB, label: cbpayLabel, payment: PaymentMode.cb)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: buttonCB, label: cbpayLabel, payment: PaymentMode.cb)
        }

        if mpuValue == "false"{
            setupPaymentButton(state: PaymentState.disable, button: buttonMPU, label: mpupayLabel, payment: PaymentMode.mpu)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: buttonMPU, label: mpupayLabel, payment: PaymentMode.mpu)
        }

        if mpgsValue == "false"{
            setupPaymentButton(state: PaymentState.disable, button: buttonVisa, label: visaMasterLabel, payment: PaymentMode.mpgs)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: buttonVisa, label: visaMasterLabel, payment: PaymentMode.mpgs)
        }

        if self.paymentMode == PaymentMode.cash {
            setupPaymentButton(state: PaymentState.selected, button: buttonCOD, label: codLbl, payment: PaymentMode.cash)
        }
        else if self.paymentMode == PaymentMode.kbz {
            setupPaymentButton(state: PaymentState.selected, button: buttonKbz, label: kbzpayLabel, payment: PaymentMode.kbz)
        }
        else if self.paymentMode == PaymentMode.credit {
            setupPaymentButton(state: PaymentState.selected, button: buttonCredit, label: creditLbl, payment: PaymentMode.credit)
        }
        else if self.paymentMode == PaymentMode.mpu {
            setupPaymentButton(state: PaymentState.selected, button: buttonMPU, label: mpupayLabel, payment: PaymentMode.mpu)
        }
        else if self.paymentMode == PaymentMode.cb {
            setupPaymentButton(state: PaymentState.selected, button: buttonCB, label: cbpayLabel, payment: PaymentMode.cb)
        }
        else if self.paymentMode == PaymentMode.mpgs {
            setupPaymentButton(state: PaymentState.selected, button: buttonVisa, label: visaMasterLabel, payment: PaymentMode.mpgs)
        }
    }
    
    func setupPaymentButton(state: PaymentState, button: UIButton, label: UILabel, payment: PaymentMode)  {
        if state == PaymentState.disable {
            button.isUserInteractionEnabled = false
            button.isSelected = false
            button.setImage(UIImage(named: "option_off"), for: .normal)
            label.textColor = UIColor().HexToColor(hexString: "#D1D1D6")
        }
        else if state == PaymentState.selected {
            label.textColor = .black
            button.isUserInteractionEnabled = true
            button.setImage(UIImage(named: "radio_button_selected"), for: .normal)
            self.paymentMode = payment
        }
        else {
            button.setImage(#imageLiteral(resourceName: "radio_button_un_selected"), for: .normal)
        }
    }
    
    func checkAddressNavigate() {
        if cartType == .store {
            if Singleton.shareInstance.selectedAddress == nil {
                addressAlertAction()
            }else if Singleton.shareInstance.selectedAddress?.township_name == nil {
                addressAlertAction()
            }else{
                placeOrderAPI()
            }
        }else{
            placeOrderAPI()
        }
        
    }
    
    func addressAlertAction() {
        self.presentAlertWithTitle(title: warningText, message: addressWarningText, options: cancelText, yesText) { (option) in
            
            switch(option) {
            case 1:
                self.navigationController?.pushView(AddAddressRouter())
            default:
                break
            }
        }
    }
    
    //MARK: -- Action Button
    @IBAction func editAddress(_ sender: UIButton) {
        toggleEditAddressView()
    }
    
    @IBAction func confirmOrder(_ sender: UIButton) {
        checkAddressNavigate()
    }
    
    @IBAction func cod(_ sender: UIButton) {
        if orderType != OrderType.pickup {
            self.paymentMode = PaymentMode.cash
            toggleCODandOnline()
        }
    }
    
    @IBAction func kbzpay(_ sender: UIButton) {
        self.paymentMode = PaymentMode.kbz
        toggleCODandOnline()
    }
    
    @IBAction func mpu(_ sender: UIButton) {
        self.paymentMode = PaymentMode.mpu
        toggleCODandOnline()
    }
    
    @IBAction func credit(_ sender: UIButton) {
        self.paymentMode = PaymentMode.credit
        toggleCODandOnline()
    }
    
    @IBAction func cbpay(_ sender: UIButton) {
        self.paymentMode = PaymentMode.cb
        toggleCODandOnline()
    }
    
    @IBAction func visa(_ sender: UIButton) {
        self.paymentMode = PaymentMode.mpgs
        toggleCODandOnline()
    }
    
}



// MARK: - Payment Integration

extension ContinuePaymentViewController {
    
    func goToMPU() {
        paymentWeb(payment: PaymentMode.mpu)
    }
    
    func goToVisa() {
        paymentWeb(payment: PaymentMode.mpgs)
    }
    
    func paymentWeb(payment: PaymentMode) {
        let vc :  MPUViewController = storyboardCart.instantiateViewController(withIdentifier: "MPUViewController") as! MPUViewController
        vc.cartType = cartType
        vc.payment = payment
        if cartType == Cart.restaurant {
            vc.link = "restaurant/" + orderSlug
        }
        else {
            vc.link = "shop/" + orderSlug
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToKBZPay(prepayId: String) {
        kbzPay = PaymentViewController()
        print("goToKBZPay")
        
        #if STAGING
        print("it is staging")
        let MERCHANT_CODE = "200144"
        let APP_ID = "kp8ddaafe77e4b45ba97cff5892ab6b8"
        let APP_KEY = "ef7d003df99dc62c85d2bbd4ff30fbed"
        let urlScheme = "KBZPayAPPPayDemo"
        
        #else
        print("it is production")
        let MERCHANT_CODE = "70025502"
        let APP_ID = "kp10a51ac0acb4439898e781409b9f3a"
        let APP_KEY = "43997935d6e5ac4157b4481c9a184f4e"
        let urlScheme = "KBZPayAPPPay"
        
        #endif
        
        let nonceStr = randomString(length: 32)
        
        let orderString = "appid=\(APP_ID)&merch_code=\(MERCHANT_CODE)&nonce_str=\(nonceStr)&prepay_id=\(prepayId)&timestamp=\(currentTimeInMilliSeconds())"
        
        let signStr = "\(orderString)&key=\(APP_KEY)"
        let sign = signStr.sha256()
        
        print("withOrderInfo == ", orderString)
        print("sign == ", sign)
        print("urlScheme == ", urlScheme)
        
        kbzPay?.startPay(withOrderInfo: orderString, signType: "SHA256", sign: sign, appScheme: urlScheme)
    }
    
    func goToCBPay(reference: String) {
        var url = NSURL(string: "")
        #if STAGING
        url = NSURL(string: "cbuat://pay?keyreference=" + reference)
        #else
        url = NSURL(string: "cb://pay?keyreference=" + reference)
        #endif
        
        if (UIApplication.shared.canOpenURL(url! as URL)) {
            UIApplication.shared.openURL(url! as URL)
        }
    }
   
}

// MARK: - UITextFieldDelegate

extension ContinuePaymentViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        instText = textField.text ?? ""
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        instText = textField.text ?? ""
    }

}
