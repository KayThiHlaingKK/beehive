//
//  VC_Store_MyOrders_Detail.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import Cosmos
import QuickLook

class VC_Store_MyOrders_Detail: UIViewController {
    
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressStackView: UIStackView!
    
    @IBOutlet weak var fromAddressIcon: UIImageView!
    @IBOutlet weak var reorderButton: UIButton!
    
    @IBOutlet weak var bannerImageHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryFeeDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryFeeDescriptionLabel: UILabel!
    
   
    @IBOutlet weak var orderStateContainerView: UIView!
    @IBOutlet weak var deliverytimeLabel: UILabel!
    @IBOutlet weak var orderStateStackView: UIStackView!
    @IBOutlet weak var orderStateImageView: UIImageView!
    @IBOutlet weak var orderStateLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
  
    
    @IBOutlet weak var overlayLayer: UIView!
    
    @IBOutlet weak var ratingModalBox: RoundedView!
    @IBOutlet weak var submitButtom: UIButton!
    
    @IBOutlet weak var productQualityRatingView: UIView!
    @IBOutlet weak var productQualityRatingStars: CosmosView!
    
    @IBOutlet weak var restaurantServiceRatingView: UIView!
    @IBOutlet weak var restaurantServiceRatingStars: CosmosView!
    
    @IBOutlet weak var deliveryServiceRatingView: UIView!
    @IBOutlet weak var deliveryServiceRatingStars: CosmosView!
    @IBOutlet weak var feedBackTextView: UITextView!
    @IBOutlet weak var feedBackTextViewBackground: RoundedView!
    @IBOutlet weak var rateOurServiceBottomButtonView: UIView!
    @IBOutlet weak var rateOurServiceButton: UIButton!
    
    @IBOutlet weak var addressStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shopNameStackView: UIStackView!
    
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var driverPhLabel: UILabel!
    
    var isProductOrder = true
    private var isProductItemRating = false
    var selectedProductItemSlug: String?
    
    private enum CellTypes: String, CaseIterable {
        case Cell_TV_ShopOrderItem, Cell_TV_ShopOrderBilling,
             Cell_TV_SpecialInstruction, Cell_TV_FoodOrderBilling
    }
    
    private enum OrderState: String, CaseIterable {
        case pending, preparing, pickUp, onRoute, delivered, cancelled, none
    }
    
    private var currentOrderState: OrderState!
    
    private var contentViewHeight: CGFloat = 409 // total view - (image view height - table view height)
    var productSlug: String?
    var resNameTownShip: String?
    var restaurantSlug: String?
    var isfromNotification: Bool = false
    var productOrder: ProductOrder?
    var restaurantOrder: RestaurantOrder?
    private var isRatingModalShowing = false
    private var feedback = ""
    
    private var productQualityRating: Double = 0 {
        didSet {
            checkSubmitButton()
        }
    }
    
    private var restaurantServiceRating: Double = 0 {
        didSet {
            checkSubmitButton()
        }
    }
    
    private var deliveryServiceRating: Double = 0 {
        didSet {
            checkSubmitButton()
        }
    }
    
    private var shouldEnableSubmitButton = false {
        didSet {
            let enabledColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 0, alpha: 1)
            let disabledColor = UIColor(displayP3Red: 227/255, green: 224/255, blue: 223/255, alpha: 1)
            submitButtom.isEnabled = shouldEnableSubmitButton
            submitButtom.backgroundColor = shouldEnableSubmitButton ? enabledColor: disabledColor
        }
    }
    
    private var bannerHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isProductOrder ? fetchProductOrder(): fetchResturantOrder()
        setDataWithRestaurantOrder()
        let imageName = isProductOrder ? "shop_order_icon": "restaurant_order_icon"
        fromAddressIcon.image = UIImage(named: imageName)
        if isProductOrder != true {
            deliveryFeeDescriptionHeight.constant = 0
            deliveryFeeDescriptionLabel.isHidden = true
        }
        setupTableView()
        prepareRatingModal()
        calculateHeights()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
        
        driverPhLabel.isUserInteractionEnabled = true;
        let tap = UITapGestureRecognizer(target: self, action: #selector(phoneNumberLabelTap))

        driverPhLabel.addGestureRecognizer(tap)

    }
    
    @objc final  func phoneNumberLabelTap()
    {
        print("phone num == " , driverPhLabel.text)
        if let phoneCallURL = URL(string: "telprompt://\(driverPhLabel.text ?? "")") {

                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                         application.openURL(phoneCallURL as URL)

                    }
                }
            }
    }
    
    private func calculateHeights() {
        let screenWidth = UIScreen.main.bounds.width
        bannerHeight = screenWidth * (213 / 408)
        bannerImageHeight.constant = bannerHeight
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        
        CellTypes.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: $0.rawValue)
        }
        
    }
    
    
    private func setDataWithProductOrder() {
        guard let productOrder = productOrder else {
            return
        }
        
        if let invoiceId = productOrder.invoice_id {
            orderIdLabel.text = "#\(invoiceId)"
        }
//        let date: String = productOrder.order_date ?? ""
        let orderDate = changeOrderDate(productOrder.order_date ?? "")
        
        orderDateLabel.text = orderDate
        paymentTypeLabel.text = "\((productOrder.payment_mode)?.uppercased() ?? "")"
        var addressString = ""
        
//        if let floor = productOrder.contact?.floor {
//            addressString += "\(floor), "
//        }
        if let streetName = productOrder.contact?.street_name {
            addressString += streetName
        }
        
        toAddressLabel.text = addressString
        let shops = productOrder.items?.reduce("") {
            "\($0!)\($0!.isEmpty ? "": ", ")\($1.shop?.name ?? "")"
        }
        
        driverNameLabel.text = productOrder.driver?.name
        driverPhLabel.text = productOrder.driver?.phone_number
        
//        fromAddressLabel.text = shops
        shopNameStackView.isHidden = true
        addressStackViewHeightConstraint.constant = 45
        
        if productOrder.order_status == "delivered"{
            deliveryStatusLabel.text = "success"
        }
        
        if productOrder.order_status == "cancelled" {
            deliveryStatusLabel.text = "fail"
        }
        
        if productOrder.payment_status == "success"{
            deliveryStatusLabel.text = productOrder.payment_status
        }
        
        if productOrder.payment_status == "pending"{
            deliveryStatusLabel.text = productOrder.payment_status
        }
        
        checkWhichRatingViewToShow()
    }
    
    
    private func setDataWithRestaurantOrder() {
        guard let restaurantOrder = restaurantOrder else {
            return
        }
        shopNameStackView.isHidden = false
        if let invoiceId = restaurantOrder.invoice_id {
            orderIdLabel.text = "#\(invoiceId)"
        }
        orderDateLabel.text = changeOrderDate(restaurantOrder.order_date ?? "")
        paymentTypeLabel.text = "\((restaurantOrder.payment_mode)?.uppercased() ?? "")"
        
        let orderDate = changeOrderDate(restaurantOrder.order_date ?? "")
        print(restaurantOrder.order_date ?? "")
        deliverytimeLabel.text = ""
        deliverytimeLabel.text = orderDate

        if restaurantOrder.order_type == "pickup" {
            deliverytimeLabel.text = "\(orderDate) (Pickup)"
        }else if restaurantOrder.order_type == "schedule"{
            deliverytimeLabel.text = orderDate
        }else{
            deliverytimeLabel.text = restaurantOrder.delivery_time
        }
    
//        if let floor = restaurantOrder.restaurant_order_contact?.floor {
//            addressString += "\(floor), "
//        }
        if let streetName = restaurantOrder.restaurant_order_contact?.street_name {
            toAddressLabel.text = streetName
        }
        
        if let resName = restaurantOrder.restaurant_branch_info?.restaurant?.name,let branchName = restaurantOrder.restaurant_branch_info?.name{
            fromAddressLabel.text = resName + "(\(branchName))"
        }
        
        driverNameLabel.text = restaurantOrder.driver?.name
        driverPhLabel.text = restaurantOrder.driver?.phone_number
    
        if restaurantOrder.order_status == "delivered"{
            deliveryStatusLabel.text = "success"
        }
        
        if restaurantOrder.order_status == "cancelled" {
            deliveryStatusLabel.text = "fail"
        }
        
        if restaurantOrder.payment_status == "success"{
            deliveryStatusLabel.text = restaurantOrder.payment_status
        }
        checkWhichRatingViewToShow()
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
         if isfromNotification == true {
             Util.makeHomeRootController()
         } else {
             isfromNotification = false
             self.navigationController?.popViewController(animated: true)
         }
    }
    
    @IBAction func reorderButtonPressed(_ sender: UIButton) {
        showAlertOnReorder(title: "Continue", message: "Do you want to repeat this order?")
    }
    
    
    @IBAction func rateOurServiceButtonPressed(_ sender: UIButton) {
        checkWhichRatingViewToShow()
        showRatingModal()
    }
    
    @IBAction func ratingModalBoxCloseButtonPressed(_ sender: UIButton) {
        hideRatingModal()
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
       giveFeedback()
    }
    
    
    func fetchProductOrder() {
        guard let slug = productSlug else { return }
        self.showHud(message: loadingText)
        let api = "\(APIEndPoint.shopOrder.caseValue)/\(slug)"
        
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
            let status = resp.value(forKey: key_status) as? Int
            
            if status == 200 {
                
                do {
                    let data = resp.value(forKey: "data")
                    
                    let dict = data as! NSDictionary
                    let JSONData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let productOrder = try JSONDecoder().decode(ProductOrder.self, from: JSONData)
                    DispatchQueue.main.async {
                        self.productOrder = productOrder
                        self.setDataWithProductOrder()
                        self.updateUIWithProductOrder()
                        self.tableView.reloadData()
                    }
                    
                } catch let err {
                    fatalError("Error in decoding Product Model: \(err.localizedDescription)")
                }
                
            }else{
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
    
    func fetchResturantOrder(){
        guard let slug = restaurantSlug else { return }
        self.showHud(message: loadingText)
        let param : [String:Any] = [:]
        
        APIUtils.APICall(postName: "\(APIEndPoint.foodOrder.caseValue)/\(slug ?? "")", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let order = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(order, apiName: APIEndPoint.foodOrder.caseValue, modelName:"RestroOrderDetails", onSuccess: { (anyData) in
                        
                        self.restaurantOrder = anyData as? RestaurantOrder ?? nil
                        DispatchQueue.main.async {
                            self.setDataWithRestaurantOrder()
                            self.updateUIWithRestaurantOrder()
                            self.tableView.reloadData()
                        }
                        
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                    
                }
            }
            
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    
    
}


extension VC_Store_MyOrders_Detail: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if isProductOrder {
//            if indexPath.row == productOrder?.items?.count ?? 0 {
//                return 190
//            } else if indexPath.row == (productOrder?.items?.count ?? 0) + 1 {
//                return calculateSpecialInstructionHeight() + 16 + 52 + 16
//            }
//        } else {
//            if indexPath.row == restaurantOrder?.restaurant_order_items?.count ?? 0 {
//                if let extraCharges = restaurantOrder?.extra_charges {
//                    return 186 + CGFloat(Double(extraCharges.count) * 17.5)
//                }
//                return 186
//            } else if indexPath.row == (restaurantOrder?.restaurant_order_items?.count ?? 0) + 1 {
//                return calculateSpecialInstructionHeight() + 16 + 52 + 16
//            }
//        }
        return tableView.estimatedRowHeight
    }
}


extension VC_Store_MyOrders_Detail: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isProductOrder {
            if indexPath.row == (productOrder?.items?.count ?? 0) + 1 {
                return createSpecialInstructionCell(indexPath)
            }
            return indexPath.row < self.productOrder?.items?.count ?? 0 ? createItemCell(indexPath): createProductOrderBillingCell(indexPath)
        } else {
            if indexPath.row == (restaurantOrder?.restaurant_order_items?.count ?? 0) + 1 {
                return createSpecialInstructionCell(indexPath)
            }
            return indexPath.row < self.restaurantOrder?.restaurant_order_items?.count ?? 0 ? createItemCell(indexPath): createRestaurantOrderBillingCell(indexPath)
        }
        
        
    }
    
    private func createItemCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.Cell_TV_ShopOrderItem.rawValue, for: indexPath) as? Cell_TV_ShopOrderItem
        else {
            return UITableViewCell()
        }
        cell.controller = self
        cell.productItemRatingDelegate = self
        if isProductOrder, let item = productOrder?.items?[indexPath.row] {
            cell.setupData(productItem: item)
        } else if isProductOrder == false,
        let item = restaurantOrder?.restaurant_order_items?[indexPath.row]  {
            cell.setupData(restaurantItem: item)
        }
        return cell
    }
    
    private func createProductOrderBillingCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.Cell_TV_ShopOrderBilling.rawValue, for: indexPath) as? Cell_TV_ShopOrderBilling
        else {
            return UITableViewCell()
        }
        cell.controller = self
        cell.setData(productOrder: self.productOrder)
        return cell
    }
    
    
    private func createRestaurantOrderBillingCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.Cell_TV_FoodOrderBilling.rawValue, for: indexPath) as? Cell_TV_FoodOrderBilling
        else {
            return UITableViewCell()
        }
        cell.controller = self
        cell.setData(restaurantOrder: self.restaurantOrder)
//        cell.backgroundColor = .systemBlue
        return cell
    }
    
    private func createSpecialInstructionCell(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellTypes.Cell_TV_SpecialInstruction.rawValue, for: indexPath) as? Cell_TV_SpecialInstruction
        else {
            return UITableViewCell()
        }
        let instruction = isProductOrder ? productOrder?.special_instruction: restaurantOrder?.special_instruction
        cell.setData(specialInstruction: instruction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProductOrder {
            var totalCells = productOrder?.special_instruction != nil ? 1: 0
            totalCells += (productOrder?.items?.count ?? 0) + 1
            return totalCells
        } else {
            var totalCells = restaurantOrder?.special_instruction != nil ? 1: 0
            totalCells += (restaurantOrder?.restaurant_order_items?.count ?? 0) + 1
            return totalCells
        }
    }
    
    private func updateUIWithProductOrder() {
        let screenWidth = UIScreen.main.bounds.width
        var itemCellsTotalHeight: CGFloat = 0
        let sideSpacing: CGFloat = 32 + 110 + 8 + 36 + 32
        let productNameLabelWidth = screenWidth - sideSpacing
        
        self.productOrder?.items?.forEach {
            if let productName = $0.product_name {
                itemCellsTotalHeight += 16 + 18 + 8 + 1 + 13
                let labelHeight = productName.height(withConstrainedWidth: productNameLabelWidth, font: UIFont(name: "Lexend-Regular", size: 16)!)
                itemCellsTotalHeight += labelHeight
            }
        }
        if productOrder?.special_instruction != nil {
            itemCellsTotalHeight += calculateSpecialInstructionHeight() + 52 + 16
        }
        var reviews = productOrder?.items?.filter{ $0.review == nil }
        if productOrder?.order_status != "delivered" {
            reviews = []
        }
        let reviewsCount = reviews?.count ?? 0
        itemCellsTotalHeight += CGFloat(reviewsCount * 40)
        tableViewHeight.constant = itemCellsTotalHeight + 200
        tableView.contentInset = .zero
        setOrderState()
    }
    
    private func setOrderState() {
        orderStateContainerView.isHidden = false
        var index = 0
//        deliverytimeLabel.text = restaurantOrder?.delivery_time
        
        var state: OrderState!
        if isProductOrder {
            state = OrderState(rawValue: productOrder?.order_status ?? "none")
            deliverytimeLabel.isHidden = true
        } else {
            state = OrderState(rawValue: restaurantOrder?.order_status ?? "none")
            deliverytimeLabel.isHidden = false
        }
        guard let state = state else { return }
        
        orderStateLabel.text = state.rawValue.uppercased()
        switch state {
        case .pending:
            index = 0
        case .preparing:
            index = 1
        case .pickUp:
            index = 2
        case .onRoute:
            index = 3
        case .delivered, .cancelled:
            bannerImageView.contentMode = .scaleAspectFit
            orderStateContainerView.isHidden = true
            
            bannerImageView.image = UIImage(named: "thank_you")
            
            if let firstImage = restaurantOrder?.restaurant_branch_info?.restaurant?.images?.first {
                bannerImageView.downloadImage(url: firstImage.url, fileName: firstImage.file_name, size: .medium)
            }
        default: break
        }
        
        updateUIWithOrderState(state: state, index: index)
    }
    
    private func updateUIWithOrderState(state: OrderState, index: Int) {
        switch state {
        case .cancelled, .delivered, .none: return
        default: break
        }
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "\(state.rawValue)_state", withExtension: "GIF")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        orderStateImageView.image = advTimeGif
        orderStateStackView.arrangedSubviews.forEach {
            orderStateStackView.removeArrangedSubview($0)
        }
        for i in 0...4 {
            let isChecked = i <= index
            setupCheckedTickView(isChecked: isChecked)
        }
    }
    
    private func setupCheckedTickView(isChecked checked: Bool) {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        orderStateStackView.addArrangedSubview(v)
        
        NSLayoutConstraint.activate([
            v.widthAnchor.constraint(equalToConstant: 20),
            v.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        v.layer.borderColor = UIColor(displayP3Red: 112/255, green: 112/255, blue: 112/255, alpha: 1).cgColor
        v.layer.borderWidth = 1.0
        v.backgroundColor = .white
        
        guard checked else { return }
        
        v.backgroundColor = .black
        v.layer.borderWidth = 0.0
        
        let img = UIImageView()
        img.image = UIImage(named: "tick_circle")
        img.tintColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 0/255, alpha: 1)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        v.addSubview(img)
        img.frame = v.frame
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalTo: v.widthAnchor),
            img.heightAnchor.constraint(equalTo: v.heightAnchor)
        ])
        
        
    }
    
    private func updateUIWithRestaurantOrder() {
        let screenWidth = UIScreen.main.bounds.width
        var itemCellsTotalHeight: CGFloat = 0
        let sideSpacing: CGFloat = 32 + 110 + 8 + 36 + 32
        let menuLabelWidth = screenWidth - sideSpacing
        
        self.restaurantOrder?.restaurant_order_items?.forEach {
            if let menu = $0.menu_name {
                itemCellsTotalHeight += 16 + 18 + 8 + 1 + 13
                let labelHeight = menu.height(withConstrainedWidth: menuLabelWidth, font: UIFont(name: "Lexend-Regular", size: 16)!)
                itemCellsTotalHeight += labelHeight
            }
            let toppingsString = $0.concatToppingsAndVariations()
            itemCellsTotalHeight += toppingsString.height(withConstrainedWidth: (menuLabelWidth + 110.0), font: UIFont(name: "Lexend-Regular", size: 14)!)
            itemCellsTotalHeight -= toppingsString.isEmpty ? 18: 0
        }
        if restaurantOrder?.special_instruction != nil {
            itemCellsTotalHeight += calculateSpecialInstructionHeight() + 52 + 16
        }
        if let extraCharges = restaurantOrder?.extra_charges {
            itemCellsTotalHeight += CGFloat(Double(extraCharges.count) * 17.5)
        }
        tableViewHeight.constant = (itemCellsTotalHeight + 186)
        
        tableView.contentInset = .zero
        setOrderState()
    }
    
    private func calculateSpecialInstructionHeight() -> CGFloat {
        let instruction = isProductOrder ? productOrder?.special_instruction: restaurantOrder?.special_instruction
        guard let specialInstruction = instruction else {
            return 0.0
        }
        return specialInstruction.height(withConstrainedWidth: UIScreen.main.bounds.width - 80, font: UIFont(name: "Lexend-Regular", size: 16)!)
    }
    
    private func showAlertOnReorder(title: String, message: String, index: Int? = nil) {
        
        self.presentAlertWithTitle(title: title, message: message, options: "Yes", "No") { (option) in
            switch(option) {
            case 0:
                guard let vc = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
                else { return }
                
                /////////vc.storeData = self.orderDetails
                vc.index = index
                vc.isFromBuyNow =  true
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 1:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
}


extension VC_Store_MyOrders_Detail {
    
    
    func downloadfile(invoiceUrl: String, invoiceName: String,completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        let itemUrl = URL(string: invoiceUrl)
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("Invoice-\(invoiceName).pdf")
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            showSavedPdf(url: invoiceUrl ?? "", fileName: "Invoice-\(invoiceName).pdf")
            completion(true, destinationUrl)
            
        } else {
            URLSession.shared.downloadTask(with: itemUrl!, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        }
    }
    
    func showSavedPdf(url:String, fileName:String) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName).pdf") {                    }
                }
            } catch {
            }
        }
    }

}

protocol ProductItemRating: AnyObject {
    func didReviewProductItem(_ slug: String)
}


    // MARK: - Rating Modal Related Functions

extension VC_Store_MyOrders_Detail: ProductItemRating {
    func didReviewProductItem(_ slug: String) {
        selectedProductItemSlug = slug
        isProductItemRating = true
        checkWhichRatingViewToShow()
        showRatingModal()
    }
}

extension VC_Store_MyOrders_Detail: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        feedback = textView.text
        checkSubmitButton()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share Your Feedback..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    private func toggleModalBox() {
        isRatingModalShowing ? hideRatingModal(): showRatingModal()
    }
    
    private func showRatingModal() {
        overlayLayer.isHidden = false
        ratingModalBox.isHidden = false
        feedBackTextViewBackground.layer.borderColor = UIColor(displayP3Red: 186/255, green: 186/255, blue: 186/255, alpha: 1).cgColor
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) { [unowned self] in
            overlayLayer.alpha = 1
            ratingModalBox.alpha = 1
        } completion: { [unowned self] success in
            self.isRatingModalShowing = true
        }
    }
    
    @objc private func hideRatingModal() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) { [unowned self] in
            self.overlayLayer.alpha = 0
            self.ratingModalBox.alpha = 0
        } completion: { [unowned self] success in
            self.overlayLayer.isHidden = true
            self.ratingModalBox.isHidden = true
            
            
            self.resetRatingForm()
        }
    }
    
    private func resetRatingForm() {
        isRatingModalShowing = false
        isProductItemRating = false
        
        feedBackTextView.text = ""
        deliveryServiceRatingStars.rating = 0.0
        restaurantServiceRatingStars.rating = 0.0
        productQualityRatingStars.rating = 0.0
        
        deliveryServiceRating = 0.0
        restaurantServiceRating = 0.0
        productQualityRating = 0.0
        feedback = ""
        
        feedBackTextView.text = "Share Your Feedback..."
        feedBackTextView.textColor = UIColor.lightGray
    }
    
    private func prepareRatingModal() {
        feedBackTextView.delegate = self
        
        feedBackTextView.text = "Share Your Feedback..."
        feedBackTextView.textColor = UIColor.lightGray
        
        rateOurServiceBottomButtonView.isHidden = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideRatingModal))
        overlayLayer.addGestureRecognizer(gesture)
        setupRatingObservers()
        checkSubmitButton()
    }
    
    private func checkWhichRatingViewToShow() {
        checkProductRatingView()
        checkRestaurantRatingViews()
    }
    
    private func checkProductRatingView() {
        guard isProductOrder else { return }
        rateOurServiceButton.setTitle("Rate Delivery Service", for: .normal)
        
        restaurantServiceRatingView.isHidden = true
        productQualityRatingView.isHidden = !isProductItemRating
        deliveryServiceRatingView.isHidden = isProductItemRating
        
        guard let productOrder = productOrder else { return }
        let isNoDriver = productOrder.driver == nil
        let isNotDelivered = productOrder.order_status != "delivered"
        let isDriverRated = productOrder.review?.contains { $0.target_type == "driver" } ?? false
        
        rateOurServiceBottomButtonView.isHidden = (isNoDriver || isDriverRated || isNotDelivered)
        if !(isNoDriver || isDriverRated || isNotDelivered) {
            showRatingModal()
        }
    }
    
    private func checkRestaurantRatingViews() {
        guard isProductOrder == false,
              let restaurantOrder = self.restaurantOrder
        else { return }
        
        productQualityRatingView.isHidden = true
        restaurantServiceRatingView.isHidden = false
        deliveryServiceRatingView.isHidden = restaurantOrder.driver == nil
        
        guard let reviews = restaurantOrder.review
        else { return }
        
        let isDriverAlreadyRated = reviews.contains { $0.target_type == "driver" }
        let isRestaurantAlreadyRated = reviews.contains { $0.target_type == "restaurant" }
        
        if isDriverAlreadyRated || restaurantOrder.driver
         == nil {
            deliveryServiceRatingView.isHidden = true
            rateOurServiceButton.setTitle("Rate Restaurant Service", for: .normal)
        }
        if isRestaurantAlreadyRated {
            restaurantServiceRatingView.isHidden = true
            rateOurServiceButton.setTitle("Rate Delivery Service", for: .normal)
        }
        
        let isNotDelivered = restaurantOrder.order_status != "delivered"
        let isNoDriver = restaurantOrder.driver
        == nil
        if isNotDelivered {
            rateOurServiceBottomButtonView.isHidden = true
        } else {
            rateOurServiceBottomButtonView.isHidden = (isDriverAlreadyRated || isNoDriver) && isRestaurantAlreadyRated
            if !((isDriverAlreadyRated || isNoDriver) && isRestaurantAlreadyRated) {
                showRatingModal()
            }
        }
    }
    
    private func setupRatingObservers() {
        [productQualityRatingStars, restaurantServiceRatingStars, deliveryServiceRatingStars].forEach {
            $0?.settings.minTouchRating = 0.0
        }
        productQualityRatingStars.didFinishTouchingCosmos = { [unowned self] rating in
            self.productQualityRating = rating
        }
        restaurantServiceRatingStars.didFinishTouchingCosmos = { [unowned self] rating in
            self.restaurantServiceRating = rating
        }
        deliveryServiceRatingStars.didFinishTouchingCosmos = { [unowned self] rating in
            self.deliveryServiceRating = rating
        }
        
        
    }
    
    @objc private func checkSubmitButton() {
        let feedbackWritten = (feedback.count > 0 && feedBackTextView.textColor == UIColor.black)
        
        if isProductOrder {
            let rating = isProductItemRating ? productQualityRating: deliveryServiceRating
            let isGreaterThan0 = rating > 0.0
            let isGreaterThan1 = rating > 1
            shouldEnableSubmitButton = isGreaterThan1 || (isGreaterThan0 && feedbackWritten)
            
        } else {
            let isDeliveryShow = !deliveryServiceRatingView.isHidden
            let isRestaurantShow = !restaurantServiceRatingView.isHidden
            let isRestaurantGreaterThan0 = restaurantServiceRating > 0.0
            let isDeliveryGreaterThan0 = deliveryServiceRating > 0.0
            let isRestaurantGreaterThan1 = restaurantServiceRating > 1
            let isDeliveryGreaterThan1 = deliveryServiceRating > 1
            
            if isDeliveryShow && isRestaurantShow {
                shouldEnableSubmitButton = (isRestaurantGreaterThan1 || isDeliveryGreaterThan1) || ((isDeliveryGreaterThan0 || isRestaurantGreaterThan0) && feedbackWritten)
            } else if isDeliveryShow {
                shouldEnableSubmitButton = isDeliveryGreaterThan1 || (isDeliveryGreaterThan0 && feedbackWritten)
            } else if isRestaurantShow {
                shouldEnableSubmitButton = isRestaurantGreaterThan1 || (isRestaurantGreaterThan0 && feedbackWritten)
            }
        }
        if isRatingModalShowing {
            checkFeedbackTextView()
        }
    }
    
    private func checkFeedbackTextView() {
        let defaultBorderColor = UIColor(displayP3Red: 186/255, green: 186/255, blue: 186/255, alpha: 1).cgColor
        let errorColor = UIColor.red.cgColor
        let feedbackWritten = (feedback.count > 0 && feedBackTextView.textColor == UIColor.black)
        
        if isProductOrder {
            if isProductItemRating {
                feedBackTextViewBackground.layer.borderColor = (productQualityRating > 1 || feedbackWritten) ? defaultBorderColor: errorColor
            } else {
                feedBackTextViewBackground.layer.borderColor = (deliveryServiceRating > 1 || feedbackWritten) ? defaultBorderColor: errorColor
            }
        } else {
            let isDeliveryRatingAvailable = !deliveryServiceRatingView.isHidden
            let isRestaurantRatingAvailable = !restaurantServiceRatingView.isHidden
            var isDeliveryRated = deliveryServiceRating > 0.5
            var isRestaurantRated = restaurantServiceRating > 0.5
            var shouldDefaultBordered = false
            
            if isDeliveryRatingAvailable && isRestaurantRatingAvailable {
                shouldDefaultBordered = feedbackWritten || (isDeliveryRated && isRestaurantRated)
            } else if isDeliveryRatingAvailable {
                shouldDefaultBordered = feedbackWritten || isDeliveryRated
            } else if isRestaurantRatingAvailable {
                shouldDefaultBordered = feedbackWritten || isRestaurantRated
            }
            
            feedBackTextViewBackground.layer.borderColor = shouldDefaultBordered ? defaultBorderColor: errorColor
        }
    }
}



extension VC_Store_MyOrders_Detail {
    
    private func createParametersForRestaurantRating() -> [String: Any] {
        guard let orderSlug = restaurantOrder?.slug,
              let restaurantSlug = restaurantOrder?.restaurant_branch_info?.restaurant?.slug
        else { return [String: Any]() }
        var param = [String:Any]()
        
        param["order_slug"] = orderSlug
        
        var ratings = [[String : Any]]()
        
        if restaurantServiceRating > 0 {
            let restaurantRating: [String: Any] = [
                "target_type": "restaurant",
                "target_slug": restaurantSlug,
                "rating": restaurantServiceRating,
                "review": feedback
            ]
            ratings.append(restaurantRating)
        }
        
        if deliveryServiceRating > 0,
           let driverSlug = restaurantOrder?.driver?.slug {
            let driverRating: [String: Any] = [
                "target_type": "driver",
                "target_slug": driverSlug,
                "rating": deliveryServiceRating,
                "review": feedback
            ]
            ratings.append(driverRating)
        }
        param["ratings"] = ratings
        
        return param
    }
    
    private func createParametersForProductRating() -> [String: Any] {
        guard let productOrder = productOrder,
              let orderSlug = productOrder.slug
        else { return [String: Any]() }
        var param = [String:Any]()
        
        param["order_slug"] = orderSlug
        
        var ratings = [[String : Any]]()
        
        if productQualityRating > 0,
           isProductItemRating,
           let itemSlug = selectedProductItemSlug {
            let restaurantRating: [String: Any] = [
                "target_type": "product",
                "target_slug": itemSlug,
                "rating": productQualityRating,
                "review": feedback
            ]
            ratings.append(restaurantRating)
        }
        
        if deliveryServiceRating > 0,
           let driverSlug = productOrder.driver?.slug {
            let driverRating: [String: Any] = [
                "target_type": "driver",
                "target_slug": driverSlug,
                "rating": deliveryServiceRating,
                "review": feedback
            ]
            ratings.append(driverRating)
        }
        param["ratings"] = ratings
        
        return param
    }
    
    private func giveFeedback() {
        let parameters = isProductOrder ? createParametersForProductRating(): createParametersForRestaurantRating()
        
        let apiStr = isProductOrder ? APIEndPoint.productRating.caseValue: APIEndPoint.restaurantRating.caseValue
        
        showHud(message: "")
        APIUtils.APICall(postName: apiStr, method: .post, parameters: parameters, controller: nil) { (response) in
            DispatchQueue.main.async {
                self.hideHud()
                self.hideRatingModal()
                
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                _ = data.value(forKey: key_message) as? String ?? ""
                
                if status == 200 {
                    self.isProductOrder ? self.fetchProductOrder(): self.fetchResturantOrder()
                    self.showToast(message: "Feedback Sent Successfully!", font: UIFont(name: "Lexend-Regular", size: 10)!)
                }
            }
        } onFailure: { (reason, statusCode) in
            
        }
    }
    
    
}

