//
//  ConfirmPlaceOrderViewController.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 8/5/22.
//  Copyright © 2022 Shashi. All rights reserved.
//


import Foundation
import UIKit
import KBZPayAPPPay
import MapKit
import CoreLocation
import Alamofire

class ConfirmPlaceOrderViewController: UIViewController {
    
    // MARK: Delegate initialization
    var presenter: ConfirmPlaceOrderViewToPresenterProtocol?
    
    // MARK: Outlets
    @IBOutlet weak var cashOnDeliveryLabel: UILabel!
    @IBOutlet weak var kbzPayLabel: UILabel!
    @IBOutlet weak var cbPayLabel: UILabel!
    @IBOutlet weak var mpuLabel: UILabel!
    @IBOutlet weak var visaMasterLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var availableAmtLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var codBtn: UIButton!
    @IBOutlet weak var kbzPayBtn: UIButton!
    @IBOutlet weak var cbPayBtn: UIButton!
    @IBOutlet weak var mpuBtn: UIButton!
    @IBOutlet weak var visaMasterBtn: UIButton!
    @IBOutlet weak var creditBtn: UIButton!
    @IBOutlet weak var confirmOrderBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var orderSummaryTableView: UITableView!
    @IBOutlet weak var placeOrderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTableView: UITableView!
    
    @IBOutlet weak var scrollView: UIScrollView!
   
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var instructionTextField: UITextField!
    
    // MARK: Custom initializers go here
    var isProductOrder = true
    var changeAddress = false
    var editShow = false
    var paymentMode = PaymentMode.cash
    var orderType = OrderType.instant
    var productCartList: [ProductCart] = []
    var productOrder: ShopCart?
    var restaurantOrder: RestaurantCart?
    var foodOrder: RestaurantCart?
    var cartAddress: Address?
    var address: Address?
    var kbzPay: PaymentViewController?
    var orderSlug = ""
    var currentDate: String = ""
    var orderDate: String = ""
    var addressList: [Address] = []
    var cartType = Cart.restaurant
    var paymentOption = PaymentOption()
    var paymentList = [String]()
    var creditAmount = 0.0
    var instantOrder = true
    let radioController: RadioButtonController = RadioButtonController()
    var updateAddressRequest: AddressRequest {
        return AddressRequest(label: address?.label ?? "", house_number: address?.house_number ?? "", street_name: address?.street_name ?? "", floor: address?.floor ?? 0, township_slug: address?.township?.slug ?? "", latitude: address?.latitude ?? 0.0, longitude: address?.longitude ?? 0.0, addressSlug: address?.slug ?? "")
    }
    var shopUpdateAddressRequest: UpdateAddressRequest {
        return UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: address?.house_number ?? "", floor: address?.floor ?? 0, street_name: address?.street_name ?? "", latitude: address?.latitude ?? 0.0, longitude: address?.longitude ?? 0.0, township_slug: address?.township?.slug ?? "")
    }
    var foodUpdateAddressRequest: UpdateAddressRequest {
        return UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: address?.house_number ?? "", floor: address?.floor ?? 0, street_name: address?.street_name ?? "", latitude: address?.latitude ?? 0.0, longitude: address?.longitude ?? 0.0, township_slug: address?.township?.slug ?? "")
    }
    
    private enum CellTypes: String, CaseIterable {
        case Cell_TV_ShopOrderItem, Cell_TV_ShopOrderBilling,
             SpecialInstructionTableViewCell, Cell_TV_FoodOrderBilling
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.started()
        orderSummaryTableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.placeOrderHeightConstraint.constant = self.orderSummaryTableView.contentSize.height
        }
    }
    
    // MARK: Additional Helpers
    fileprivate func setupUI(){
        setupAddressLabel()
        radioController.buttonsArray = [codBtn,kbzPayBtn,cbPayBtn,mpuBtn,visaMasterBtn,creditBtn]
        tableViewSetup()
        confirmOrderBtn.layer.cornerRadius = 7
        if Singleton.shareInstance.isBack {
            orderSummaryTableView.isHidden = true
        }else{
            orderSummaryTableView.isHidden = false
        }
    }
    
    // MARK: SetUp TableView
    fileprivate func tableViewSetup(){
        orderSummaryTableView.delegate = self
        orderSummaryTableView.dataSource = self
        
        addressTableView.delegate = self
        addressTableView.dataSource = self
        
        CellTypes.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            orderSummaryTableView.register(nib, forCellReuseIdentifier: $0.rawValue)
           
        }
    }
    

    // MARK: AddressView Show&Hide Animated
    fileprivate func hideAddressView(animated: Bool) {
        let duration: CGFloat = animated ? 0.05: 0.0
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] completed in
            self?.addressTableView.isHidden = true
            self?.editShow = false
        }
    }
    
    fileprivate func showAddressView() {
        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.9, options: .curveEaseInOut) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] completed in
            self?.addressTableView.isHidden = false
            self?.editShow = true
        }
    }
    
    
    // MARK: User Interaction - Actions & Targets
    @IBAction func backDismissAction(_ sender: UIButton) {
//        Singleton.shareInstance.addressChange = changeAddress
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCashOnDeliveryAction(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        paymentMode = .cash
    }
    
    @IBAction func btnKBZPayAction(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        paymentMode = .kbz
        
    }
    
    @IBAction func btnCBPayAction(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        paymentMode = .cb
    }
    
    @IBAction func btnMPUAction(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        paymentMode = .mpu
    }
    
    @IBAction func btnVisaMasterAction(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        paymentMode = .mpgs
    }
    
    @IBAction func btnCreditAction(_ sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        paymentMode = .credit
    }
    
    
    @IBAction func btnEditAddressAction(_ sender: UIButton) {
        editShow ? hideAddressView(animated: true): showAddressView()
        addressTableView.reloadData()
        
    }
    
    @IBAction func btnConfrimOrderAction(_ sender: UIButton) {
        confirmPlaceOrder()
//        checkAddressNavigateOption()
    }
    
}

// MARK: - Extension
/**
 - TableView DataSource
 */
extension ConfirmPlaceOrderViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == orderSummaryTableView {
            return 2
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewNumberOfSectionList(tableView, section)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == orderSummaryTableView {
            switch indexPath.section {
            case 0:
                return createItemCell(indexPath)
            default:
                if cartType == .restaurant {
                    return createRestaurantOrderBillingCell(indexPath)
                }else{
                    return createProductOrderBillingCell(indexPath)
                }
            }
        }else {
            if indexPath.section == 0 {
                return createAddressHeaderCell(indexPath)
            }else if indexPath.section == 1 {
                return createAddressListCell(indexPath)
            }else{
                return createAddressFooterCell(indexPath)
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAddressConfigure(indexPath)
    }


    // MARK: CurrentLocation Tap
    @objc func useCurrentLocation(){
        print("Current Lat:",Singleton.shareInstance.currentLat)
        Singleton.shareInstance.addressChange = true
        CustomUserDefaults.shared.removeAll()
        self.presenter?.getAddressFromLatLong(pdblLatitude: "\(Singleton.shareInstance.currentLat)", withLongitude: "\(Singleton.shareInstance.currentLong)", addressTitle: addressTitleLabel, addressLabel: addressLabel, cartType: cartType, cartAddress: cartAddress ?? Address())
        
        addressTableView.reloadData()
        addressTableView.isHidden = true
        changeAddress = true
    }
    
    // MARK: CreateAddress Tap
    @objc func createAddress(){
        changeAddress = true
        self.navigationController?.pushView(AddAddressRouter())
    }
    
}

//MARK: -- TableView Delegate
extension ConfirmPlaceOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == addressTableView {
            return 80
        }else{
            return tableView.estimatedRowHeight
        }
        
    }
    
}

//MARK: - CreateTableView IndexPath
extension ConfirmPlaceOrderViewController {
    
    // MARK: OrderSummarySectionList
    fileprivate func orderSummaryTableSectionList(_ section: Int) -> Int {
        if section == 0 {
            if cartType == .store {
                return productCartList.count
            }else{
                return restaurantOrder?.menus?.count ?? 1
            }
        }
        return 1
    }
    
    // MARK: AddressSectionList
    fileprivate func addressTableSectionList(_ section: Int) -> Int {
        if section == 1 {
            return Singleton.shareInstance.address?.count ?? 0
        }
        return 1
    }
    
    // MARK: TableViewSectionList
    private func tableViewNumberOfSectionList(_ tableView: UITableView, _ section: Int) -> Int {
        if tableView == orderSummaryTableView {
            return orderSummaryTableSectionList(section)
        }else{
            return addressTableSectionList(section)
        }
    }
    
    // MARK: AddressHeaderCell Config
    private func createAddressHeaderCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableHeaderCell") as! AddressTableHeaderCell
        cell.subView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.useCurrentLocation))
        cell.subView.addGestureRecognizer(tap)
        return cell
    }
    
    // MARK: AddressFooterCell Config
    private func createAddressFooterCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableFooterCell") as! AddressTableFooterCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.createAddress))
        cell.addnewView.addGestureRecognizer(tap)
        return cell
    }
    
    // MARK: AddressListCell Config
    private func createAddressListCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        
        let address = Singleton.shareInstance.address?[indexPath.row]
        cell.bindAddressData(address: address ?? Address(),selectedAddress: Singleton.shareInstance.selectedAddress ?? Address())
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: OrderItemCell Config
    private func createItemCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = orderSummaryTableView.dequeueReusableCell(withIdentifier: CellTypes.Cell_TV_ShopOrderItem.rawValue, for: indexPath) as? Cell_TV_ShopOrderItem
        else {
            return UITableViewCell()
        }
        cell.controller = self
        if cartType == .store {
            cell.setShopData(shopItem: productCartList[indexPath.row])
        } else{
            if let item = restaurantOrder?.menus?[indexPath.row] {
                cell.setRestaurantOrderData(orderItem: item)
            }
        }
        return cell
    }
    
    // MARK: ProductOrderBillCell Config
    private func createProductOrderBillingCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = orderSummaryTableView.dequeueReusableCell(withIdentifier: CellTypes.Cell_TV_ShopOrderBilling.rawValue, for: indexPath) as? Cell_TV_ShopOrderBilling
        else {
            return UITableViewCell()
        }
        cell.controller = self
        cell.productQuantity = productCartList
        cell.setShopOrderData(shopCart: productOrder ?? ShopCart())
        return cell
    }
    
    // MARK: RestaurantOrderBillCell Config
    private func createRestaurantOrderBillingCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = orderSummaryTableView.dequeueReusableCell(withIdentifier: CellTypes.Cell_TV_FoodOrderBilling.rawValue, for: indexPath) as? Cell_TV_FoodOrderBilling
        else {
            return UITableViewCell()
        }
        cell.controller = self
        cell.foodOrderQuantity = restaurantOrder?.menus?[indexPath.row].quantity ?? 0
        cell.setFoodOrderData(foodOrder: restaurantOrder ?? RestaurantCart())
        return cell
    }
    
    // MARK: DidSelectAddress Config
    private func didSelectAddressConfigure(_ indexPath: IndexPath){
        if let address = Singleton.shareInstance.address?[indexPath.row] {
            self.address = address
        }
        if cartType == .store {
            self.productOrder = nil
            self.presenter?.fetchUpdateAddressData(request: updateAddressRequest)
            self.presenter?.shopUpdateAddress(request: shopUpdateAddressRequest)
            addressTableView.reloadData()
        }else{
            self.presenter?.foodUpdateAddress(request: foodUpdateAddressRequest)
            self.restaurantOrder = nil
            self.orderSummaryTableView.reloadData()
            addressTableView.reloadData()
        }
        Singleton.shareInstance.selectedAddress = address
        editShow = false
//        CustomUserDefaults.shared.removeAll()
        changeAddress = true
        isAddressChange = true
        CustomUserDefaults.shared.removeAll()
        addressLabel.text = Util.getFormattedAddress(address: Singleton.shareInstance.selectedAddress ?? Address())
        addressTitleLabel.text = Singleton.shareInstance.selectedAddress?.label
        addressTableView.isHidden = true
        
    }
}

// MARK: - Presenter to View
extension ConfirmPlaceOrderViewController: ConfirmPlaceOrderPresenterToViewProtocl {
    
    // MARK: InitialControl Setup
    func initialControlSetup() {
        presenter?.fetchUserSetting()
        presenter?.getUserCredit()
        presenter?.fetchViewCart()
        if Singleton.shareInstance.addressChange {
            productOrder = Singleton.shareInstance.productOrder
            orderSummaryTableView.reloadData()
        }
        addressList = Singleton.shareInstance.address ?? []
        addressTableView.reloadData()
        orderSummaryTableView.reloadData()
        checkAddress()
        setupUI()
    }
    
    // MARK: SetUp Address Label
    private func setupAddressLabel() {
        addressLabel.text = Util.getFormattedAddress(address: Singleton.shareInstance.selectedAddress ?? Address())
        addressTitleLabel.text = Singleton.shareInstance.selectedAddress?.label
        
    }
    
    // MARK: CheckAddress
    private func checkAddress() {
        if let selectedAddress = Singleton.shareInstance.selectedAddress {
            addressLabel.text = Util.getFormattedAddress(address: selectedAddress)
            addressTitleLabel.text = selectedAddress.label
        } else {
            useCurrentLocation()
        }
    }
    
    //MARK: -- Set Data from API
    func setUserCreditData(_ data: CreditCardModel) {
        self.creditAmount = data.data?.remaining_amount ?? 0.0
        if self.creditAmount == 0.0 {
            availableAmtLabel.isHidden = true
            setupPaymentButton(state: PaymentState.disable, button: creditBtn, label: creditLabel, payment: .credit)
        }else{
            availableAmtLabel.isHidden = false
            setupPaymentButton(state: PaymentState.enable, button: creditBtn, label: creditLabel, payment: .credit)
        }
        
        availableAmtLabel.text = "Available amount : \(self.priceFormat(price: Int(self.creditAmount))) MMK"
        
    }
    
    //setCheckOut Data
    func setCheckOutData(data: CheckOutModel) {
        self.orderSlug = data.data?.slug ?? ""
        print(data)
        if data.status == 201 {
            switch paymentMode{
            case .mpu:
                navigateToMPUVisaView(payment: PaymentMode.mpu)
            case .mpgs:
                navigateToMPUVisaView(payment: PaymentMode.mpgs)
            case .kbz:
                print("it is kbz", data)
                if let prepayId = data.data?.prepay_id {
                    presenter?.fetchKBZPay(prepayId: prepayId, randomString: randomString(length: 32), currentTimeMilliSeconds: currentTimeInMilliSeconds())
                }
            case .cb:
                if let refOrder = data.data?.generate_ref_order {
                    presenter?.fetchCBPay(reference: refOrder)
                }
            default:
                goOrderPage(message: orderConfirmText)
            }
        }else{
            presentAlertWithTitle(title: warningAlertText, message: data.message ?? "", options: okayText) { option in
                switch(option) {
                case 0:
                    if data.message != "Success." {
                        Singleton.shareInstance.isBack = self.instantOrder
//                        CustomUserDefaults.shared.removeAll()
//                        CustomUserDefaults.shared.set("", key: .deliDateTime)
                        self.navigationController?.popViewController(animated: true)
                    }
                default:
                    break
                }
            }
        }
        
    }
    
    
    //Set UserSettingData
    func setUserSetting(data: UserSettingModel) {
        guard let data = data.data else { return }
        for i in data{
            if i.key == UserSettingPaymentKey.cbpay {
                paymentOption.cbValue = i.value ?? ""
            }else if i.key == UserSettingPaymentKey.kbzpay {
                paymentOption.kbzValue = i.value ?? ""
               
            }else if i.key == UserSettingPaymentKey.mpu{
                paymentOption.mpuValue = i.value ?? ""
                
            }else if i.key == UserSettingPaymentKey.visa{
                paymentOption.mpgsValue = i.value ?? ""
            }
        }
        paymentList = [paymentOption.kbzValue,paymentOption.cbValue,paymentOption.mpuValue,paymentOption.mpgsValue]
        orderTypePaymentModeOption()
    }
    
    //SetData From UpdateAddress
    func setUpdateAddress(data: AddressModel) {
//        if data.status == 200 {
//            Singleton.shareInstance.selectedAddress = data.data
//        }else{
//            self.addressAlertAction()
//        }
        self.addressTableView.reloadData()
    }
    
    func setShopUpdateAddress(data: ShopUpdateAddressModel) {
        Singleton.shareInstance.selectedAddress?.township_slug = data.data?.address?.township_slug
        Singleton.shareInstance.promoCode = data.data?.promocode ?? ""
        self.presenter?.fetchViewCart()
        self.orderSummaryTableView.reloadData()
    }
    
    func setViewCartData(data: CartData) {
        Singleton.shareInstance.selectedAddress?.township_slug = data.shop?.address?.township_slug
        Singleton.shareInstance.productOrder = data.shop
        self.productOrder = data.shop
        self.restaurantOrder = data.restaurant
        self.orderSummaryTableView.reloadData()
    }
    

    func presentAlertPromo(title: String, message: String){
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okayText, style: .cancel, handler: { action in
            self.presenter?.fetchViewCart()
            Singleton.shareInstance.isPromoUse = false
        }))
        
        self.present(alert, animated: true)
    }
    
    func setFoodUpdateAddress(data: FoodUpdateAddressModel) {
        self.restaurantOrder = data.data
        self.instantOrder = data.data?.restaurant_branch?.instant_order ?? true
        self.orderSummaryTableView.reloadData()
    }
    
    //AddAddress Alert
    func addressAlertAction() {
//        self.presentAlertWithTitle(title: warningText, message: addressWarningText, options: cancelText, yesText) { (option) in
//
//            switch(option) {
//            case 1:
//                if let address = Singleton.shareInstance.selectedAddress {
//                    if address.slug == nil {
//                        self.navigationController?.pushView(AddAddressRouter())
//                    }else{
//                        let clLocation = CLLocationCoordinate2D(latitude: Double(address.latitude ?? 0.0), longitude: Double(address.longitude ?? 0.0))
//                        let vc = AddAddressRouter.init(userCoordinate: clLocation, address: address, profileData: Singleton.shareInstance.userProfile, slug: address.slug ?? "", fromEdit: true)
//                        self.navigationController?.pushView(vc)
//                    }
//                }else{
//                    self.navigationController?.pushView(AddAddressRouter())
//                }
//            default:
//                break
//            }
//        }
    }

    //OrderTypePaymentMode
    func orderTypePaymentModeOption() {
        if orderType == .pickup {
            setupPaymentButton(state: .disable, button: codBtn, label: cashOnDeliveryLabel, payment: .cash)
            checkOnlinePaymentMode()
            
        }else{
            setupPaymentButton(state: .enable, button: codBtn, label: cashOnDeliveryLabel, payment: .cash)
            radioController.defaultButton = codBtn
            paymentMode = .cash
            checkOnlinePaymentMode()
        }
        
    }
    
    //checkKBZPaySelectOption
    fileprivate func checkKbzPayOption(_ paymentOption: PaymentOption) {
        if paymentOption.kbzValue == "false" {
            setupPaymentButton(state: PaymentState.disable, button: kbzPayBtn, label: kbzPayLabel, payment: .kbz)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: kbzPayBtn, label: kbzPayLabel, payment: .kbz)
        }
    }
    
    //checkCBSelectOption
    fileprivate func checkCbPayOption(_ paymentOption: PaymentOption) {
        if paymentOption.cbValue == "false" {
            setupPaymentButton(state: PaymentState.disable, button: cbPayBtn, label: cbPayLabel, payment: .cb)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: cbPayBtn, label: cbPayLabel, payment: .cb)
            
        }
    }
    
    //checkMPUSelectOption
    fileprivate func checkMPUOption(_ paymentOption: PaymentOption) {
        if paymentOption.mpuValue == "false" {
            setupPaymentButton(state: PaymentState.disable, button: mpuBtn, label: mpuLabel, payment: .mpu)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: mpuBtn, label: mpuLabel, payment: .mpu)
        }
    }
    
    //checkVisaSelectOption
    fileprivate func checkVisaOption(_ paymentOption: PaymentOption) {
        if paymentOption.mpgsValue == "false" {
            setupPaymentButton(state: PaymentState.disable, button: visaMasterBtn, label: visaMasterLabel, payment: .mpgs)
        }else{
            setupPaymentButton(state: PaymentState.enable, button: visaMasterBtn, label: visaMasterLabel, payment: .mpgs)
        }
    }
    
    //paymentMode Option
    fileprivate func paymentMethodOption(selectedBtn: UIButton,paymentMode: PaymentMode) {
        radioController.defaultButton = selectedBtn
        self.paymentMode = paymentMode
        checkKbzPayOption(paymentOption)
        checkCbPayOption(paymentOption)
        checkMPUOption(paymentOption)
        checkVisaOption(paymentOption)
    }
    
    //checkOnlinePaymentMode
    func checkOnlinePaymentMode() {
        if orderType == .instant {
            paymentMethodOption(selectedBtn: codBtn, paymentMode: .cash)
        }else if orderType == .schedule {
            paymentMethodOption(selectedBtn: codBtn, paymentMode: .cash)
        }else if paymentList[0] == "true" {
            orderType == .instant ? (paymentMethodOption(selectedBtn: codBtn, paymentMode: .cash)) : (paymentMethodOption(selectedBtn: kbzPayBtn, paymentMode: .kbz))
        }else if paymentList[1] == "true" {
            paymentMethodOption(selectedBtn: cbPayBtn, paymentMode: .cb)
        }else if paymentList[2] == "true" {
            paymentMethodOption(selectedBtn: mpuBtn, paymentMode: .mpu)
        }else if paymentList[3] == "true" {
            paymentMethodOption(selectedBtn: visaMasterBtn, paymentMode: .mpgs)
        }else{
            paymentMethodOption(selectedBtn: creditBtn, paymentMode: .credit)
        }
    }
    
    //navigateToMPUView
    func navigateToMPUVisaView(payment: PaymentMode) {
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
    
    //goToOrderPage
    func goOrderPage(message: String) {
        self.presentAlertWithTitle(title: orderPlacedText, message: message, options: okayText) { (option) in
            switch(option) {
            case 0:
                Singleton.shareInstance.isBack = true
                if self.cartType == .restaurant{
                    CustomUserDefaults.shared.removeAll()
                    self.navigationController?.pushViewController(MyOrderScreenRouter(.paymentOrderList,.restaurant).viewController, animated: true)
                }else{
                    self.navigationController?.pushViewController(MyOrderScreenRouter(.paymentOrderList,.store).viewController, animated: true)
                }
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
       
    }
        
    //Setup PaymentButton & PaymentMode
    func setupPaymentButton(state: PaymentState, button: UIButton, label: UILabel, payment: PaymentMode)  {
        if state == PaymentState.disable {
            button.isUserInteractionEnabled = false
            button.isSelected = false
            button.setImage(UIImage.radioButtonOptionOff(), for: .normal)
            label.textColor = UIColor.appColor(.paymentTextColor)
        }
        else if state == PaymentState.selected {
            label.textColor = .black
            button.isUserInteractionEnabled = true
            button.setImage(UIImage.radioButtonSelected(), for: .normal)
            self.paymentMode = payment
        }
        else {
            button.setImage(UIImage.radioButtonUnSelected(), for: .normal)
        }
    }
    
    //confirmPlaceOrder APICall
    func confirmPlaceOrder() {
        if cartType == .store {
            
            self.orderDate = getCurrentTimeFormat()
            
        }else{
            
            if Singleton.shareInstance.deliTime.contains("ASAP") {
                self.orderDate = getCurrentTimeFormat()
            }else{
                self.orderDate = "\(getDateFormat()) \(getScheduleTimeFormat(deliTime: Singleton.shareInstance.deliTime))"
            }
        }
        
        let address = Singleton.shareInstance.selectedAddress
        let request = ConfirmOrderRequest(order_date: orderDate, payment_mode: paymentMode.caseValue, order_type: orderType.caseValue, special_instruction: instructionTextField.text ?? "", source: "ios", version: "1.0", customer_name: Singleton.shareInstance.userProfile?.name ?? "", phone_number: Singleton.shareInstance.userProfile?.phone_number ?? "", house_number: address?.house_number ?? "", floor: address?.floor ?? 0, street_name: address?.street_name ?? "", latitude: address?.latitude ?? 0.0, longitude: address?.longitude ?? 0.0, township_slug: address?.township_slug ?? "")
        if cartType == .restaurant {
            presenter?.fetchOrderConfirm(cartType: .restaurant,request: request)
        }else{
            presenter?.fetchOrderConfirm(cartType: .store,request: request)
//            if Singleton.shareInstance.selectedAddress == nil {
//                addressAlertAction()
//            }else if Singleton.shareInstance.selectedAddress?.township_slug == nil {
//                addressAlertAction()
//            }else{
//                presenter?.fetchOrderConfirm(cartType: .store,request: request)
//            }
//
        }
        
    }
    
}
