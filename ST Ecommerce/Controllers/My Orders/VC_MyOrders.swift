//
//  VC_Store_MyOrders.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol DataPass {
    func cancelOrder(title: String?, message: String?, completion: @escaping ((String) -> Void))
    
}

class VC_MyOrders: UIViewController, DataPass {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var buttonCurrent: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var imageViewBack: UIImageView!
    @IBOutlet weak var viewMyOrderContainer: UIView!
    @IBOutlet weak var buttonPast: UIButton!
    @IBOutlet weak var heightMyOrderContainer: NSLayoutConstraint!
    @IBOutlet weak var tableViewStoreMyOrders: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    
    var fromCart = false
    var accountSection: VC_Account?
    var isreload: Bool? = false
    var Orderid: Int? = nil
    var currentOrdersFetched: Bool? = false
    var pastOrderFetched: Bool? = false
    
    
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var currentOrders : [MyOrder] = [MyOrder]()
    var deliveredOrders : [MyOrder] = [MyOrder]()
    var cartType : Cart?
    var fromHome = true
    var myOrderData : MyorderData?
    var apiPage = 1
    private var lastPage: Int!
    var isFromStore = false
    
    let textView = UITextView(frame: CGRect.zero)
    private let emptyParam = [String:Any]()
    var restaurantOrders : [RestaurantOrder] = []
    var productOrders : [ProductOrder] = []
    
    //MARK: - INternal functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewEmpty.isHidden = true
        viewMyOrderContainer.isHidden = true
        heightMyOrderContainer.constant = 0
        buttonBack.isHidden = false
        imageViewBack.isHidden = false
        
        if fromHome{
            viewMyOrderContainer.isHidden = false
            heightMyOrderContainer.constant = 50
            buttonBack.isHidden = fromHome
            imageViewBack.isHidden = fromHome
        }
        
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecievedNotification(notification:)), name: .didRecievedNotification, object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        pastOrderFetched = false
        currentOrdersFetched = false
        
        if cartType == nil{
            cartType = Cart.store
        }
        self.tableViewSetUP()
        
        print("it is login ==  ", readLogin())
        
        if readLogin() == 0{
            
            self.currentOrders = []
           
            self.tableViewStoreMyOrders.reloadData()
            self.showNeedToLoginApp()
            self.viewEmpty.isHidden = false
        }else{
            if let type = self.cartType{
                if type == Cart.restaurant{
                    self.loadMyFoodOrdersFromServer()
                }
                else {
                    self.loadMyProductOrdersFromServer()
                }
            }
        }
    }
    
    @objc func didRecievedNotification(notification: Notification) {
        if let type = notification.userInfo?["type"] as? String {
            if type == "store_order"  || type == "food_order" {
                btnReloadTableView()
            }
        }
    }
    
    func showViewEmpty() {
        
        if currentOrdersFetched == true && pastOrderFetched == true {
            if deliveredOrders.isEmpty  && currentOrders.isEmpty {
                self.viewEmpty.isHidden = false
            } else {
                self.viewEmpty.isHidden = true
            }
        }
    }
    
    func cancelOrder(title: String?, message: String? ,completion: @escaping ((String) -> Void) = { _ in }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction.init(title: "Discard", style: .default) { (action) in
            alertController.view.removeObserver(self, forKeyPath: "bounds")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { action in            alertController.view.removeObserver(self, forKeyPath: "bounds")
            if let result = self.textView.text {
                completion(result)
            }
            else
            { completion("") }
        })
        
        alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        textView.backgroundColor = UIColor.white
        textView.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
        alertController.view.addSubview(self.textView)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin: CGFloat = 15
                let xPos = rect.origin.x + margin
                let yPos = rect.origin.y + 80
                let width = rect.width - 2 * margin
                let height: CGFloat = 90
                
                textView.frame = CGRect.init(x: xPos, y: yPos, width: width, height: height)
            }
        }
    }
    
    func showAlertOnReorder(title: String, message: String, index: Int? = nil) {
        
        
        presentAlertWithTitle(title: title, message: message, options: "Yes", "No") { (option) in
            switch(option) {
            case 0:
                guard let vc = storyboardCart.instantiateViewController(withIdentifier: "VC_Cart") as? VC_Cart
                else { return }
                guard let index = index else {
                    return
                }
                
                guard let id = self.deliveredOrders[index].id else { return }
                let product : [String:Any] = ["id": id, "qty":1]
                var products :[Any] = [Any]()
                products.append(product)
                
                let parameters : [String:Any] = ["products":products]
                APIUtils.APICall(postName: "\(APIEndPoint.reorder.caseValue)\(id)/reorder", method: .post, parameters: parameters, controller: self, onSuccess: { (response) in
                    self.hideHud()
                    let data = response as! NSDictionary
                    let status = data.value(forKey: key_status) as? Bool ?? false
                    
                    if status == true {
                        let cartType = self.deliveredOrders[index].orderType
                        if cartType == "Restaurant" {
                            vc.cartType = Cart.restaurant
                        } else {
                            vc.cartType = Cart.store
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let message = data[key_message] as? String ?? serverError
                        self.presentAlert(title: errorText, message: message)
                        
                    }
                }) { (reason, statusCode) in
                    self.hideHud()
                }
            case 1:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    //MARK: - Private Functions
    
    private func tableViewSetUP(){
        
        tableViewStoreMyOrders.dataSource = self
        tableViewStoreMyOrders.delegate = self
    }
   @objc func btnReloadTableView() {
    pastOrderFetched = false
    currentOrdersFetched = false
        if let type = self.cartType{
            if type == Cart.store{
                isFromStore = true
                apiPage = 1
                self.deliveredOrders.removeAll()
                self.loadMyProductOrdersFromServer()
               // self.loadMyOrdersFromServer(orderStatus: MyOrderStatus.past.caseValue, endPoint: APIEndPoint.myOrdersStore.caseValue)
            }
            else if type == Cart.restaurant{
                isFromStore = false
                apiPage = 1
                self.deliveredOrders.removeAll()
                self.loadMyFoodOrdersFromServer()
                //self.loadMyOrdersFromServer(orderStatus: MyOrderStatus.past.caseValue, endPoint: APIEndPoint.myOrdersRestro.caseValue)
            }
        }
    }
    @IBAction func btnReloadTableView(_ sender: Any) {
        print("isFromStore = ", isFromStore)
        isFromStore ? storeClicked(UIButton()): foodClicked(UIButton())
    }
    
    @IBAction func cart(_ sender: UIButton) {
        if readLogin() != 0
        {
            let vc : VC_Cart = storyboardCart.instantiateViewController(withIdentifier: "VC_Cart") as! VC_Cart
            vc.cartType = Cart.store
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            self.showNeedToLoginApp()
            
        }
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func home(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    
    @IBAction func btnReorder(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.tableViewStoreMyOrders)
        guard let customIndexPath = self.tableViewStoreMyOrders.indexPathForRow(at: point) else {
            return
        }
        if readLogin() != 0 {
            showAlertOnReorder(title: "Continue", message: "Do you want to repeat this order?",index: customIndexPath.row)
        }else{
            self.showNeedToLoginApp()
        }
        
    }
    
    
    
    @IBAction func btnCancelOrder(_ sender: UIButton) {
        
        let point = sender.convert(CGPoint.zero, to: self.tableViewStoreMyOrders)
        guard let customIndexPath = self.tableViewStoreMyOrders.indexPathForRow(at: point) else {
            return
        }
        guard  let vc: CancelOrderViewController = storyboardHome.instantiateViewController(withIdentifier: "CancelOrderViewController") as? CancelOrderViewController else { return }
        guard let id = self.currentOrders[customIndexPath.row].id else { return }
        Orderid = id
        vc.delegate = self
        add(vc, frame: vc.view.frame)
    }
    
    @IBAction func storeClicked(_ sender: UIButton) { //Store
        
        self.restaurantOrders.removeAll()
        self.tableViewStoreMyOrders.reloadData()
        self.apiPage = 1
        self.lastPage = 0
        self.productOrders = []
        isFromStore = true
        if readLogin() == 0 {
            self.showNeedToLoginApp()
        }else{
            buttonCurrent.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
            buttonCurrent.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            buttonPast.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            buttonPast.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
            cartType = Cart.store
            
            if productOrders.count > 0{
                tableViewStoreMyOrders.reloadData()
            }
            else {
                loadMyProductOrdersFromServer()
            }
        }
    }
    
    @IBAction func foodClicked(_ sender: UIButton) { //Food
        isFromStore = false
        self.productOrders.removeAll()
        tableViewStoreMyOrders.reloadData()
        
        self.apiPage = 1
        self.lastPage = 0
        self.restaurantOrders = []
        if readLogin() == 0 {
            self.showNeedToLoginApp()
        }else{
            buttonPast.backgroundColor = #colorLiteral(red: 1, green: 0.7267209888, blue: 0.1742660403, alpha: 1)
            buttonPast.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            
            buttonCurrent.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            buttonCurrent.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            cartType = Cart.restaurant
            if restaurantOrders.count > 0{
                tableViewStoreMyOrders.reloadData()
            }
            else {
                loadMyFoodOrdersFromServer()
            }
        }
    }
    
    func updateCell(path:Int){
        let indexPath = IndexPath(row: path, section: 1)
        
        tableViewStoreMyOrders.beginUpdates()
        tableViewStoreMyOrders.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        tableViewStoreMyOrders.endUpdates()
    }
}

//MARK: - API Call Functions STORE
extension VC_MyOrders{
    
    func loadMyFoodOrdersFromServer(){
        showHud(message: loadingText)
        
        let api = "\(APIEndPoint.foodOrder.caseValue)?size=10&page=\(apiPage)"
        APIUtils.APICall(postName: api, method: .get,  parameters: emptyParam, controller: self, onSuccess: { (response) in
            
            
            self.tableViewStoreMyOrders.tableFooterView?.isHidden = true
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            if status == 200 {
                self.apiPage += 1
                self.lastPage = data["last_page"] as? Int
                
                let orders = response as! NSDictionary
                APIUtils.prepareModalFromData(orders, apiName: APIEndPoint.foodOrder.caseValue, modelName:"MyOrderData", onSuccess: { (orders) in
                    
                    self.hideHud()
                    let orderModel = orders as? RestaurantOrderModel
                    self.restaurantOrders += orderModel?.data ?? []
                    print(orderModel?.data ?? [])
                    self.tableViewStoreMyOrders.reloadData()
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            self.showViewEmpty()
            
        }) { (reason, statusCode) in
            self.hideHud()
            self.showViewEmpty()
        }
    }
    
    func loadMyProductOrdersFromServer(){
        self.showHud(message: loadingText)
        let api = "\(APIEndPoint.shopOrder.caseValue)?size=10&page=\(apiPage)"
        
        APIUtils.APICall(postName: api, method: .get,  parameters: emptyParam, controller: self, onSuccess: { (response) in
            
            self.tableViewStoreMyOrders.tableFooterView?.isHidden = true
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200 {
                
                self.apiPage += 1
                self.lastPage = data["last_page"] as? Int
                let orders = response as! NSDictionary
                
                APIUtils.prepareModalFromData(orders, apiName: APIEndPoint.shopOrder.caseValue, modelName:"MyOrderData", onSuccess: { (orders) in
                    self.hideHud()
                    let orderModel = orders as? ProductOrderModel
                    self.productOrders += orderModel?.data ?? []
                    self.tableViewStoreMyOrders.reloadData()
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            self.showViewEmpty()
            
        }) { (reason, statusCode) in
            self.hideHud()
            self.showViewEmpty()
        }
    }
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_MyOrders : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if cartType == Cart.restaurant {
            return self.restaurantOrders.count
        }
        else {
            print("self.productOrders.count = " , self.productOrders.count)
            return self.productOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cartType == Cart.restaurant {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_MyOrders_Current") as! Cell_MyOrders_Current
            cell.delegate = self as? DataPass
            cell.selectionStyle = .none
            if indexPath.row >= restaurantOrders.count - 1 && self.apiPage <= self.lastPage{
                loadMyFoodOrdersFromServer()
            }
            if self.restaurantOrders.count != 0{
                cell.controller = self
                //cell.setData(order: currentOrders[indexPath.row])
                cell.setData(order: restaurantOrders[indexPath.row])
                let abc = ["Preparing", "Processing", "Pending","Ready to Pickup", "On Route"]
                if abc.contains(restaurantOrders[indexPath.row].order_status ?? ""){
                    cell.imgCancel.image = UIImage(named: "Processing")
                    cell.imgCancel.setImageColor(color: .yellow)
                    cell.labelStatus.sizeToFit()
                    cell.labelStatus.text = (restaurantOrders[indexPath.row].order_status ?? "").capitalized
                    cell.labelStatus.textColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1)
                    cell.imgCancel.tintColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1)
                }
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_MyOrders_Current") as! Cell_MyOrders_Current
            cell.delegate = self as? DataPass
            cell.selectionStyle = .none
            
            if indexPath.row >= productOrders.count - 1 && self.apiPage <= self.lastPage {
                loadMyProductOrdersFromServer()
            }
            
            if self.productOrders.count != 0{
                cell.controller = self
                //cell.setData(order: currentOrders[indexPath.row])
                cell.setData(order: self.productOrders[indexPath.row])
                let abc = ["Preparing", "Processing", "Pending","Ready to Pickup", "On Route"]
                if abc.contains(productOrders[indexPath.row].order_status ?? ""){
                    cell.imgCancel.image = UIImage(named: "Processing")
                    cell.imgCancel.setImageColor(color: .yellow)
                    cell.labelStatus.sizeToFit()
                    cell.labelStatus.text = (productOrders[indexPath.row].order_status ?? "").capitalized
                    cell.labelStatus.textColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1)
                    cell.imgCancel.tintColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1)
                }
                return cell
            }
        }

        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell  : Cell_TV_Order_Header = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_Order_Header") as! Cell_TV_Order_Header
        cell.selectionStyle = .none
        
        cell.labelTitle.text = ""
        if section == 0{
            cell.labelTitle.text = currentOrdersText
        }else if section == 1{
            cell.labelTitle.text = PastOrdersText
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if cartType == Cart.restaurant && self.restaurantOrders.count != 0 && section == 0{
            return 44
        }
        else if (self.productOrders.count != 0) && section == 1{
            return 44
        }
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = self.cartType{
            let isProductOrder = type == Cart.store
            let vc = storyboardMyOrders.instantiateViewController(withIdentifier: "VC_Store_MyOrders_Detail") as! VC_Store_MyOrders_Detail
            
            if isProductOrder {
                vc.productSlug = productOrders[indexPath.row].slug
            } else {
                vc.restaurantSlug = restaurantOrders[indexPath.row].slug
            }
            vc.isProductOrder = isProductOrder
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension VC_MyOrders: CancelOrderViewControllerDelegate {
    func callCancelAPI(cancellationReason: String?)  {
        let param: [String: Any] = ["cancellation_reason":  cancellationReason as Any]
        self.showHud(message: loadingText)
        guard let id = Orderid else { return }
        APIUtils.APICall(postName: "\(APIEndPoint.orderPathRestro.caseValue)\(id)/cancel", method: .patch, parameters: param) { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status {
                self.btnReloadTableView()
                self.hideHud()            } else {
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
        } onFailure: { (reason, IntstatusCode) in
            self.hideHud()
        }
    }
} 
