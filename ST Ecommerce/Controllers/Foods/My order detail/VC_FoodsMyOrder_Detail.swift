//
//  VC_FoodsMyOrder_Detail.swift
//  ST Ecommerce
//
//  Created by necixy on 02/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import QuickLook

class VC_FoodsMyOrder_Detail: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewFoodsMyOrdersDetails: UITableView!
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    
    @IBOutlet weak var imgStatus: UIImageView!
    
    @IBOutlet weak var btnReload: UIButton!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgTakeAway: UIImageView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var btnTrackOrder: UIButton!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var deliveredOrders : [MyOrder] = [MyOrder]()
    var invoiceURL: String?
    var invoiceName: String?
    lazy var previewItem = NSURL()
    var isfromNotification: Bool = false
    var userInfo = [AnyHashable: Any]()
    
    var orderId: Int?
    var orderSlug: String?
    var restaurantOrder: RestaurantOrder?
    
    
    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        lblStatus.text = ""
        lblOrderNumber.text = ""
        imgStatus.isHidden = true
        
        
        self.tableViewSetUP()
        self.loadMyOrdersDetailsFromServer()
//        setUpOrderDetails()
//        self.tableViewFoodsMyOrdersDetails.reloadData()
        
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecievedNotification(notification:)), name: .didRecievedNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewWillLayoutSubviews()
        self.tableViewSetUP()
//        setUpOrderDetails()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didRecievedNotification(notification: Notification) {
        if let type = notification.userInfo?["type"] as? String {
            if type == "food_order" {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                self.viewWillLayoutSubviews()
                self.tableViewSetUP()
                setUpOrderDetails()
                
                if let id = self.orderSlug{
                    self.loadMyOrdersDetailsFromServer()
                }
            }
        }
    }
    
    func showAlertOnReorder(title: String, message: String, index: Int? = nil) {
//
//
//        presentAlertWithTitle(title: title, message: message, options: "Yes", "No") { (option) in
//            switch(option) {
//            case 0:
//                guard let vc = storyboardCart.instantiateViewController(withIdentifier: "VC_Cart") as? VC_Cart
//                else { return }
//                guard index != nil else {
//                    return
//                }
//                guard let id = self.restaurantOrder?.slug?.id else { return }
//                let product : [String:Any] = ["id": id, "qty":1]
//                var products :[Any] = [Any]()
//                products.append(product)
//
//                let parameters : [String:Any] = ["products":products]
//                APIUtils.APICall(postName: "\(APIEndPoint.reorder.caseValue)\(id)/reorder", method: .post, parameters: parameters, controller: self, onSuccess: { (response) in
//                    self.hideHud()
//                    let data = response as! NSDictionary
//                    let status = data.value(forKey: key_status) as? Bool ?? false
//
//                    if status == true {
//                        //Success from our server
//                        let cartType = self.restroOrderDetails?.orderType
//                        if cartType == "Restaurant" {
//                            vc.cartType = Cart.restaurant
//                        } else {
//                            vc.cartType = Cart.store
//                        }
//
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    } else {
//                        let message = data[key_message] as? String ?? serverError
//                        self.presentAlert(title: errorText, message: message)
//
//                    }
//                }) { (reason, statusCode) in
//                    self.hideHud()
//                }
//            case 1:
//                self.dismiss(animated: true, completion: nil)
//            default:
//                break
//            }
//        }
    }
    
    @IBAction func btnCancelOrder(_ sender: Any){
        
    }
    
    @IBAction func btnReload(_ sender: Any){
       
        self.view.setNeedsDisplay()
        self.view.setNeedsUpdateConstraints()
        self.viewWillAppear(true)
        self.tableViewFoodsMyOrdersDetails.reloadData()    }
    
    @IBAction func btnReorder(_ sender: Any) {
        let point = (sender as AnyObject).convert(CGPoint.zero, to: self.tableViewFoodsMyOrdersDetails)
        guard let customIndexPath = self.tableViewFoodsMyOrdersDetails.indexPathForRow(at: point) else {
            return
        }
        showAlertOnReorder(title: "Continue", message: "Do you want to repeat this order?",index: customIndexPath.row)
        
    }
    
    @IBAction func btnRateOrder(_ sender: Any) {
//
//        if restroOrderDetails?.selfPickup == false && restroOrderDetails?.driverRating == nil
//        {
//            let vc = (storyboardFoodsMyOrders.instantiateViewController(withIdentifier: "St_RateDriverViewController") as? St_RateDriverViewController)!
//            vc.abc = restroOrderDetails?.driver?.name
//            vc.id = restroOrderDetails?.id ?? 0
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let vc = (storyboardFoodsMyOrders.instantiateViewController(withIdentifier: "FoodRatingViewController") as? FoodRatingViewController)!
//            vc.id = restroOrderDetails?.id ?? 0
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func setUpOrderDetails() {
        
        imgTakeAway.isHidden = true
        lblOrderNumber.text = "Order no:\(restaurantOrder?.invoice_id ?? "")"
        lblStatus.text =  (restaurantOrder?.order_status)
//        if (restroOrderDetails?.selfPickup ?? true)  {
//
//            let imagePath = takeAwayImageUrl
//
//            imgTakeAway.setIndicatorStyle(.gray)
//            imgTakeAway.setShowActivityIndicator(true)
//            imgTakeAway.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "takeAway")) { (image, error, type, url) in
//                self.imgTakeAway.setShowActivityIndicator(false)
//            }
//
//        }
        
//        if restroOrderDetails?.selfPickup == true {
//            imgTakeAway.isHidden = false
//        } else {
//            imgTakeAway.isHidden = true
//        }
        
//        if restroOrderDetails?.canCancel == true || restroOrderDetails?.selfPickup == true {
//            btnTrackOrder.isHidden = false
//            btnTrackOrder.setTitle("CANCEL ORDER", for: .normal)
//            btnTrackOrder.backgroundColor = .white
//            btnTrackOrder.setTitleColor(.red, for: .normal)
//            btnTrackOrder.layer.borderColor = UIColor.red.cgColor
//            btnTrackOrder.layer.borderWidth = 1
//        } else if restroOrderDetails?.trackable == true {
//            btnTrackOrder.isHidden = false
//            btnTrackOrder.setTitle("TRACK ORDER", for: .normal)
//            btnTrackOrder.layer.borderColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1).cgColor
//            btnTrackOrder.setTitleColor(#colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1), for: .normal)
//            btnTrackOrder.layer.borderWidth = 1
//        }
        switch restaurantOrder?.order_status?.lowercased() {
        case "cancelled":
            imgStatus.isHidden = false
            imgStatus.image = #imageLiteral(resourceName: "cancel")
            lblStatus.textColor = #colorLiteral(red: 0.9019607843, green: 0.1607843137, blue: 0.1568627451, alpha: 1)
            lblStatus.text = restaurantOrder?.order_status
            
        case "delivered":
            
            btnTrackOrder.isHidden = true
            imgStatus.isHidden = false
            imgStatus.image = #imageLiteral(resourceName: "tick_circle")
            lblStatus.textColor = #colorLiteral(red: 0.2745098039, green: 0.6666666667, blue: 0.2274509804, alpha: 1)
            lblStatus.text = restaurantOrder?.order_status
            imgStatus.setImageColor(color: #colorLiteral(red: 0.3058251143, green: 0.6672008634, blue: 0.2291442454, alpha: 1))
            
        default:
//            btnTrackOrder.isHidden = true
            imgStatus.isHidden = false
            imgStatus.image = UIImage(named: "Processing")
            imgStatus.setImageColor(color: .yellow)
            lblStatus.text = restaurantOrder?.order_status
            lblStatus.textColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1)
            
            imgStatus.tintColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1)
        }
       
    }
    
    
    //MARK: - Private Functions
    
    private func tableViewSetUP(){
        
        tableViewFoodsMyOrdersDetails.dataSource = self
        tableViewFoodsMyOrdersDetails.delegate = self
    }
    
    
    @IBAction func back(_ sender: UIButton) {
        if isfromNotification == true {
            Util.makeHomeRootController()
        } else {
            isfromNotification = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func home(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func trackOrder(_ sender: Any) {
        
    
//        if let orderId = self.restroOrderDetails?.id, let trackable = self.restroOrderDetails?.trackable, let canCancel = self.restroOrderDetails?.canCancel {
//        if trackable{
//                openTrackOrder(orderId: orderId)
//        } else if canCancel {
                guard  let vc: CancelOrderViewController = storyboardHome.instantiateViewController(withIdentifier: "CancelOrderViewController") as? CancelOrderViewController else { return }
                vc.delegate = self
                add(vc, frame: vc.view.frame)
//            }

//        }
    }
    
    func openTrackOrder(orderId:Int){
        if let vc = storyboardTrackOrder.instantiateViewController(withIdentifier: "VC_TrackOrder") as? VC_TrackOrder{
            vc.orderId = orderId
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func btnDownloadInvoice(_ sender: UIButton) {
        self.downloadfile(completion: {(success, fileLocationURL) in
            self.showHud(message: loadingText)
            if success {
                // Set the preview item to display======
                self.previewItem = fileLocationURL! as NSURL
                // Display file
                DispatchQueue.main.async {
                    let previewController = QLPreviewController()
                    previewController.dataSource = self
                    self.navigationController?.pushViewController(previewController, animated: true)
                }
                self.hideHud()
            }else{
                self.hideHud()
            }
        })
    }
    func downloadfile(completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        let itemUrl = URL(string: invoiceURL ?? "")
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("Invoice-\(invoiceName ?? "").pdf")
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            showSavedPdf(url: invoiceURL ?? "", fileName: "Invoice-\(invoiceName ?? "").pdf")
            completion(true, destinationUrl)
        } else {
            URLSession.shared.downloadTask(with: itemUrl!, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    completion(true, destinationUrl)
                } catch let error as NSError {
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
                    if url.description.contains("\(fileName).pdf") {
                    }
                }
            } catch {
            }
        }
    }
}


//MARK: - API Call Functions STORE
extension VC_FoodsMyOrder_Detail{
    
    func loadMyOrdersDetailsFromServer(){
        
        let param : [String:Any] = [:]
        print("param \(param)")
        self.showHud(message: loadingText)
        
        APIUtils.APICall(postName: "\(APIEndPoint.foodOrder.caseValue)/\(orderSlug ?? "")", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            print("food order = " , response)
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                if let order = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(order, apiName: APIEndPoint.foodOrder.caseValue, modelName:"RestroOrderDetails", onSuccess: { (anyData) in
                        
                        self.restaurantOrder = anyData as? RestaurantOrder ?? nil
                        self.setUpOrderDetails()
                        self.tableViewFoodsMyOrdersDetails.reloadData()
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

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_FoodsMyOrder_Detail : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.restaurantOrder != nil{
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return self.restaurantOrder?.restaurant_order_items?.count ?? 0
        }else if section == 1{
            
            if (self.restaurantOrder?.order_status ?? "").lowercased() == "delivered" || (self.restaurantOrder?.order_status ?? "").lowercased() == "ready to pickup"{
                return 1
            }
            return 1
        }
        
        else if section == 2{
            return 1
        }
        
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_FoodsMyOrder_Detail") as! Cell_FoodsMyOrder_Detail
            cell.selectionStyle = .none
            cell.controller = self
            if let orderItem = self.restaurantOrder?.restaurant_order_items?[indexPath.row]{
                cell.setData(orderItem: orderItem)
            }
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_FoodsMyOrder_Detail_Footer") as! Cell_FoodsMyOrder_Detail_Footer
            cell.selectionStyle = .none
            cell.controller = self
            if let restaurant = self.restaurantOrder{
                //?.restaurant_order_items?[indexPath.row]{
                cell.setData(restaurantOrder: restaurant)
            }
//            self.invoiceURL = restroOrderDetails?.invoiceURL
//            self.invoiceName = restroOrderDetails?.orderSerial
//
            
            // MARK:- logics for review Rating and DriverRating
            
//            if (restroOrderDetails?.driverReview) == nil && (restroOrderDetails?.foodReview) == nil {
//                cell.vwReviewView.isHidden = true
//            } else if (restroOrderDetails?.driverReview) == nil {
//                cell.lblDriverReview.isHidden = true
//                cell.driverReviewText.isHidden = true
//                cell.foodReviewView.layer.cornerRadius = 5
//                cell.foodReviewView.layer.borderWidth = 1
//                cell.foodReviewView.layer.borderColor = UIColor.lightGray.cgColor
//                cell.foodReviewText.text = "\(restroOrderDetails?.foodReview ?? "")"
//            } else if (restroOrderDetails?.foodReview) == nil {
//                cell.foodReviewText.isHidden = true
//                cell.lblFoodReview.isHidden = true
//                cell.driverReviewView.layer.cornerRadius = 5
//                cell.driverReviewView.layer.borderWidth = 1
//                cell.driverReviewView.layer.borderColor = UIColor.lightGray.cgColor
//                cell.driverReviewText.text = "\(restroOrderDetails?.driverReview ?? "")"
//            }else {
//                cell.vwReviewView.isHidden = false
//                cell.vwReviewView.layer.cornerRadius = 5
//                cell.vwReviewView.layer.borderWidth = 1
//                cell.vwReviewView.layer.borderColor = UIColor.lightGray.cgColor
//                cell.driverReviewText.text = "\(restroOrderDetails?.driverReview ?? "")"
//                cell.foodReviewText.text = "\(restroOrderDetails?.foodReview ?? "")"
//            }
//
//            switch restroOrderDetails?.status {
//            case "Delivered":
//                cell.vwRateOrder.isHidden = false
//                cell.btnReorder.isHidden = false
//                cell.vwCancel.isHidden = true
//                cell.btnDownloadInvoice.isHidden = false
//                cell.btnDownloadInvoice.backgroundColor = .white
//                cell.btnDownloadInvoice.layer.borderColor = UIColor.lightGray.cgColor
//                cell.btnDownloadInvoice.layer.borderWidth = 1
//                cell.btnDownloadInvoice.layer.cornerRadius = 5
//                if restroOrderDetails?.selfPickup == true {
//                    cell.lblDriverRating.text = "Not Applicable"
//                    cell.btnRateOrder.titleLabel?.text = "RATE FOOD"
//                    cell.driverReviewView.isHidden = true
//                }else {
//                }
//
//            case "Cancelled":
//                cell.vwRateOrder.isHidden = true
//                cell.btnDownloadInvoice.isHidden  = true
//                if restroOrderDetails?.cancellationReason == "" || restroOrderDetails?.cancellationReason == nil || restroOrderDetails?.cancellationReason == "Enter Cancellation Reason" {
//                    cell.vwCancel.isHidden = true
//                } else {
//                    cell.vwCancel.isHidden = false
//                    cell.vwCancel.layer.cornerRadius = 8
//                    cell.vwCancel.layer.borderWidth = 1
//                    cell.vwCancel.layer.borderColor = UIColor.lightGray.cgColor
//                    cell.lblCancellationTitle.text = "\(restroOrderDetails?.cancellationReason ?? "")"
//                }
//            default:
//                cell.btnDownloadInvoice.isHidden  = true
//                cell.vwRateOrder.isHidden = true
//                cell.vwCancel.isHidden = true
//            }
//
//            switch (restroOrderDetails?.foodRating) {
//            case 5:
//                cell.imgFoodRating.isHidden = false
//                cell.lblSeperator.isHidden = false
//                cell.btnRateOrder.isHidden = true
//                cell.imgFoodRating.image = UIImage(named: "great")
//                cell.lblFoodRating.text = "Great"
//            case 4:
//                cell.imgFoodRating.isHidden = false
//                cell.lblSeperator.isHidden = false
//                cell.btnRateOrder.isHidden = true
//                cell.imgFoodRating.image = UIImage(named: "good")
//                cell.lblFoodRating.text = "Good"
//            case 3:
//                cell.imgFoodRating.isHidden = false
//                cell.lblSeperator.isHidden = false
//                cell.btnRateOrder.isHidden = true
//                cell.imgFoodRating.image = UIImage(named: "okay")
//                cell.lblFoodRating.text = "Okay"
//            case 2:
//                cell.imgFoodRating.isHidden = false
//                cell.lblSeperator.isHidden = false
//                cell.btnRateOrder.isHidden = true
//                cell.imgFoodRating.image = UIImage(named: "bad")
//                cell.lblFoodRating.text = "Bad"
//            case 1:
//                cell.imgFoodRating.isHidden = false
//                cell.lblSeperator.isHidden = false
//                cell.btnRateOrder.isHidden = true
//                cell.imgFoodRating.image = UIImage(named: "terrible")
//                cell.lblFoodRating.text = "Terrible"
//            case 0:
//                cell.imgFoodRating.isHidden = true
//                cell.lblSeperator.isHidden = true
//                cell.btnRateOrder.isHidden = false
//                cell.lblFoodRating.textColor = .lightGray
//                cell.lblFoodRating.text = "Not rated yet"
//            default:
//                if (restroOrderDetails?.foodRating == nil) {
//                    cell.imgFoodRating.isHidden = true
//                    cell.lblSeperator.isHidden = true
//                    cell.btnRateOrder.isHidden = false
//                    cell.lblFoodRating.textColor = .lightGray
//                    cell.lblFoodRating.text = "Not rated yet"
//                }
//            }
//
//
//            if (restroOrderDetails?.driverRating == 0) || (restroOrderDetails?.driverRating == nil) {
//                cell.imgDriverStar.isHidden = true
//                cell.btnRateOrder.isHidden = false
//                cell.lblDriverRating.text = "Not rated yet"
//                cell.lblDriverRating.textColor = .lightGray
//            } else if ((restroOrderDetails?.driverReview?.isEmpty) != nil) && ((restroOrderDetails?.foodReview?.isEmpty ) != nil)  {
//                cell.imgDriverStar.isHidden = false
//                cell.lblDriverRating.text = "\(self.restroOrderDetails?.driverRating ?? 0)"
//
//            }
//            if (restroOrderDetails?.driverRating != nil){
//
//                cell.btnRateOrder.setTitle("RATE FOOD", for: .normal)
//            }
//
//            if restroOrderDetails?.selfPickup == true {
//                cell.btnRateOrder.isHidden = false
//                cell.btnRateOrder.setTitle("RATE FOOD", for: .normal)
//                cell.lblDriverRating.text = "Not Applicable"
//            }
//
//            if restroOrderDetails?.foodRating != nil {
//
//                cell.btnRateOrder.isHidden = true
//            }
            
            return cell
        }
        
        else  if indexPath.section == 2{
            
            
            let cell : Cell_TV_DeliveryPerson = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_DeliveryPerson") as! Cell_TV_DeliveryPerson
            cell.selectionStyle = .none
            cell.controller = self
            
            if let restro = self.restaurantOrder{
                cell.setData(restroOrderDetails: restro)
            }
//            let date = Date(timeIntervalSince1970: Double(restroOrderDetails?.createdAt ?? 0 ))
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
//            let deliveryDate = dateFormatter.string(from: date)
//            cell.lblOrderDate.text = "\(deliveryDate )"
//            cell.lblPaymentMethod.text = "\((restroOrderDetails?.paymentMode)?.uppercased() ?? "")"
//            cell.lblDeliveryAddress.text = "\(restaurantOrder?.shippingAddress?.address1 ?? "")"
            //cell.btnHelp.layer.cornerRadius = 5
            cell.vWcancelView.isHidden = true
            cell.vwDeliveryPerson.isHidden = false
            
//            switch restroOrderDetails?.status {
//
//            case "Delivered":
//                cell.vwcancelViewHeight.constant = -100
//                cell.vWcancelView.layoutSubviews()
//                cell.vWcancelView.layoutIfNeeded()
//                cell.ratingView.isHidden = false
//                if restroOrderDetails?.selfPickup == true {
//                    cell.vwDeliveryPerson.isHidden = true
//                    cell.lblDeliveryAddress.isHidden = true
//                    cell.lblDelivery.isHidden = true
//                }
//                self.view.layoutIfNeeded()
//
//            case "Cancelled":
//                cell.vwcancelViewHeight.constant = 38
//                let date = Date(timeIntervalSince1970: Double(restroOrderDetails?.cancelledAt ?? 0 ))
//                let cancelledDate = dateFormatter.string(from: date)
//                cell.vWcancelView.isHidden = false
//                cell.lblCancellationDate.isHidden = false
//                cell.lblCancellation.isHidden = false
//                cell.lblCancellationDate.text = "\(cancelledDate)"
//
//                if restroOrderDetails?.selfPickup == true
//                {
//                    cell.lblDeliveryAddress.isHidden = true
//                    cell.lblDelivery.isHidden = true
//                    cell.vwDeliveryPerson.isHidden = true
//                }
//
//                if restroOrderDetails?.driver == nil {
//
//                    cell.vwDeliveryPerson.isHidden = true
//                }
//
//            default:
//                cell.vwcancelViewHeight.constant = -10
//                cell.vWcancelView.layoutIfNeeded()
//
//
//                if restroOrderDetails?.status == "Pending"{
//                    cell.vwDeliveryPerson.isHidden = true
//                }
//
//                if restroOrderDetails?.trackable  ?? false == true{
//                    btnTrackOrder.setTitle("TRACK ORDER", for: .normal)
//                }
//
//                if restroOrderDetails?.selfPickup == true {
//                    cell.vwDeliveryPerson.isHidden = true
//                    cell.lblDeliveryAddress.isHidden = true
//                    cell.lblDelivery.isHidden = true
//                }
//            }
//            btnTrackOrder.isHidden = true
//            if restroOrderDetails?.canCancel == true {
//                btnTrackOrder.isHidden = false
//                btnTrackOrder.setTitle("CANCEL ORDER", for: .normal)
//                btnTrackOrder.setTitleColor(.red, for: .normal)
//            } else if restroOrderDetails?.trackable == true {
//                btnTrackOrder.isHidden = false
//                btnTrackOrder.setTitle("TRACK ORDER", for: .normal)
//                btnTrackOrder.setTitleColor(#colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1), for: .normal)
//            }
//            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_FoodsMyOrder_Detail_Header") as! Cell_FoodsMyOrder_Detail_Header
            cell.selectionStyle = .none
            cell.controller = self
            if let restro = self.restaurantOrder{
                cell.setData(restaurantOrderDeatil: restro)
            }
            return cell
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return UITableView.automaticDimension
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        return 137
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

extension VC_FoodsMyOrder_Detail: CancelOrderViewControllerDelegate {
    func callCancelAPI(cancellationReason: String?) {
        let param: [String: Any] = [:]//["cancellation_reason":  cancellationReason]
        self.showHud(message: loadingText)
        //guard let id = restroOrderDetails?.id else { return }
        
        var api = ""
        if let slug = orderSlug {
            api = "\(APIEndPoint.foodOrder.caseValue)/\(slug)"
        }
        APIUtils.APICall(postName: api, method: .delete, parameters: param) { (response) in

            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false

            if status {
//                if self.restroOrderDetails?.canCancel == true {
//                    self.btnTrackOrder.isHidden = true
//                } else {
//                    self.btnTrackOrder.isHidden = false
//                }
                self.view.setNeedsDisplay()
                self.view.setNeedsUpdateConstraints()
                self.viewWillAppear(true)
                self.tableViewFoodsMyOrdersDetails.reloadData()
            } else {
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
        } onFailure: { (reason, IntstatusCode) in
            self.hideHud()
        }

    }
}

extension  VC_FoodsMyOrder_Detail : TrackOrderDelegate{
    
    func orderDelivered(message: String) {
        self.presentAlertWithTitle(title: "Alert", message: message, options: okayText) { (value) in
            
        }
    }
}
extension VC_FoodsMyOrder_Detail: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
}

