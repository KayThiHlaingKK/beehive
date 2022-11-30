//
//  MyOrderScreenViewController.swift
//  ST Ecommerce
//
//  Created MacBook Pro on 17/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//
//

import Foundation
import UIKit
import SwiftLocation

enum isFromHome{
    case orderTab
    case orderMenu
    case paymentOrderList
}

class MyOrderScreenViewController: UIViewController {
    
    // MARK: Delegate initialization
    var presenter: MyOrderScreenViewToPresenterProtocol?
    
    // MARK: Outlets
    @IBOutlet weak var navTitleLabel: UILabel!
    
    @IBOutlet weak var btnFood: UIButton!
    @IBOutlet weak var btnShop: UIButton!
    
    @IBOutlet weak var foodBgView: UIView!
    @IBOutlet weak var shopBgView: UIView!
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var tableViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var orderTypeStackView: UIStackView!
    
    @IBOutlet weak var orderListTableView: UITableView!
    
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: Custom initializers go here
    var isFromHome: isFromHome?
    var orderShopLists : [OrderData] = [OrderData]()
    var orderFoodLists: [OrderData] = [OrderData]()
    var cartType: Cart = .store
    var currentPage = 1
    var totalPage = 1
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
   
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.started()
        checkLogin()
    }
    
  
    // MARK: User Interaction - Actions & Targets
    
    
    // MARK: Additional Helpers
    fileprivate func checkLogin(){
        if readLogin() != 0{
            if cartType == .restaurant{
                orderFoodLists.removeAll()
                self.currentPage = 1
                presenter?.getOrderFoodLists(.init(size: "10", page: "\(currentPage)"))
            }else{
                orderShopLists.removeAll()
                self.currentPage = 1
                presenter?.getOrderShopLists(.init(size: "10", page: "\(currentPage)"))
            }
           
        }else{
            self.orderListTableView.reloadData()
            self.showNeedToLoginApp()
            self.noDataView.isHidden = false
        }
    }
    
    //MARK: -- UISetup
    fileprivate func defaultSetup(){
        activityIndicator = LoadMoreActivityIndicator(scrollView: orderListTableView, spacingFromLastCell: 20, spacingFromLastCellWhenLoadMoreActionStart: 60)
        cartType == .store ? (navTitleLabel.text = "Shops  Orders") : (navTitleLabel.text = "Foods  Orders")
        tableViewSetup()
        buttonSetup()
        noDataView.dropShadow()
       checkNavigateUI()
    }
    
    fileprivate func checkNavigateUI(){
        switch isFromHome {
        case .orderTab:
            backBtn.isHidden = true
        case .paymentOrderList:
            orderTypeStackView.isHidden = true
            tableViewTopContraint.constant = 10
            backBtn.isHidden = false
            backBtn.addTarget(self, action: #selector(backDismiss(_:)), for: .touchUpInside)
        default:
            backBtn.isHidden = false
            backBtn.addTarget(self, action: #selector(backDismiss(_:)), for: .touchUpInside)
        }
        
    }
    
    //MARK: -- dismiss objc function
    @objc func backDismiss(_ sender: UIButton){
        Singleton.shareInstance.isBack = true
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: -- tableviwe Setup
    private func tableViewSetup(){
        orderListTableView.registerCell(type: MyOrderListTableViewCell.self)
        orderListTableView.dataSource = self
        orderListTableView.delegate = self
    }
    
    //MARK: -- button Setup
    private func buttonSetup(){
        btnFood.addTarget(self, action: #selector(tapFoodButtonAction(_:)), for: .touchUpInside)
        btnShop.addTarget(self, action: #selector(tapShopButtonAction(_:)), for: .touchUpInside)
    }
    
    //MARK: -- button action objc func
    @objc func tapFoodButtonAction(_ sender: UIButton){
        isShopOrFood(navTitle: "Food Orders", type: .restaurant, isFood: false, isShop: true)
        orderFoodLists.removeAll()
        self.currentPage = 1
        presenter?.getOrderFoodLists(.init(size: "10", page: "\(currentPage)"))
    }
    
    @objc func tapShopButtonAction(_ sender: UIButton){
        isShopOrFood(navTitle: "Shop Orders", type: .store, isFood: true, isShop: false)
        orderShopLists.removeAll()
        self.currentPage = 1
        presenter?.getOrderShopLists(.init(size: "10", page: "\(currentPage)"))
        
    }
    
    //MARK: -- check isShopOrFoodOption
    fileprivate func isShopOrFood(navTitle: String,type: Cart,isFood: Bool,isShop:Bool){
        navTitleLabel.text = navTitle
        cartType = type
        foodBgView.isHidden = isFood
        shopBgView.isHidden = isShop
    }
    
}

// MARK: - Extension
/**
 - Documentation for purpose of extension
 */
// MARK: - UITableViewDataSource
extension MyOrderScreenViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cartType == .restaurant{
            return orderFoodLists.count
        }else{
            return orderShopLists.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderListTableViewCell.identifier, for: indexPath) as? MyOrderListTableViewCell else {
            return UITableViewCell()
            
        }
        cell.controller = self
        if cartType == .restaurant{
            let foodData = orderFoodLists[indexPath.row]
            cell.setFoodData(data: foodData)
        }else{
            let shopData = orderShopLists[indexPath.row]
            cell.setShopData(data: shopData)
        }
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension MyOrderScreenViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isProductOrder = cartType == Cart.store
        let vc = storyboardMyOrders.instantiateViewController(withIdentifier: "VC_Store_MyOrders_Detail") as! VC_Store_MyOrders_Detail
        
        if isProductOrder {
            vc.productSlug = orderShopLists[indexPath.row].slug
        } else {
            vc.restaurantSlug = orderFoodLists[indexPath.row].slug
            vc.resNameTownShip = orderFoodLists[indexPath.row].restaurant_branch_info?.name ?? ""
        }
        vc.isProductOrder = isProductOrder
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: -- pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.start {
            DispatchQueue.global(qos: .utility).async {
                for i in 0..<1 {
                    print("!!!!!!!!! \(i)")
                    if self.currentPage > self.totalPage  {
                        debugPrint("Page--------------------------------->", self.currentPage)
                    } else {
                        debugPrint("Page--------------------------------->", self.currentPage)
                        self.currentPage += 1
                    }
                    DispatchQueue.main.async {
                        if self.cartType == .restaurant{
                            self.presenter?.getOrderFoodLists(.init(size: "10", page: "\(self.currentPage)"))
                        }else{
                            self.presenter?.getOrderShopLists(.init(size: "10", page: "\(self.currentPage)"))
                        }
                    }
                    
                    sleep(1)
                }
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stop()
                }
            }
        }
    }
}

// MARK: - Presenter to View
extension MyOrderScreenViewController: MyOrderScreenPresenterToViewProtocl {
   
    func initialControlSetup() {
        defaultSetup()
    }
    
    //MARK: -- SetData
    func setShopData(_ data: ShopOrderModel) {
        self.totalPage = data.last_page ?? 0
        if let shopData = data.data {
            self.orderShopLists.append(contentsOf: shopData)
        }
        orderListTableView.reloadData()
    }
    
    func setFoodData(_ data: FoodOrderModel) {
        self.totalPage = data.last_page ?? 0
        if let foodData = data.data {
            self.orderFoodLists.append(contentsOf: foodData)
        }
        orderListTableView.reloadData()
    }
    
    func fialAuthenticateStatus(_ message: String) {
        self.unAuthenticatedOptoin(toastMessage: message)
    }
    
    func failStatus(_ message: String) {
        self.presentAlert(title: "Warning!", message: message)
    }
    
}
