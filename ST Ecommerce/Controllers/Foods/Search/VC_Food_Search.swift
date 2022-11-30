//
//  VC_Food_Search.swift
//  ST Ecommerce
//
//  Created by JASWANT SINGH on 11/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD

class VC_Food_Search: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var headerView: GradientView!
    @IBOutlet weak var lblHeaderView: UILabel!
    @IBOutlet weak var searchBarRestro: UISearchBar!
    @IBOutlet weak var heightConstraintHeaderView: NSLayoutConstraint!
    
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var searchRestaurant : SearchRestaurant?
    var restros = [RestaurantBranch]()
    var apiPage = 1
    var searchStr = ""
    let search = UISearchController(searchResultsController: nil)
    
    //for coming from selected category
    var category : Category?
    var isFromSearch = true
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        restros = []
      setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        search.isActive = true
        DispatchQueue.main.async {
            self.searchBarRestro.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Helper Functions
    
    func setupView(){
        searchBarRestro.setImage(#imageLiteral(resourceName: "magnifying-glass"), for: .search, state: .normal)
        if #available(iOS 12.0, *) {
            searchBarRestro.textField?.contentVerticalAlignment = .center
            searchBarRestro.searchTextPositionAdjustment = UIOffset(horizontal: 8.0, vertical: 0.0)
        }
        viewEmpty.isHidden = false
              self.navigationController?.navigationBar.isHidden = true
//              Util.configureTopViewPosition(heightConstraint: heightConstraintHeaderView)
        heightConstraintHeaderView.constant = 85
        if DeviceUtils.isDeviceIphoneXOrlatter() {
            heightConstraintHeaderView.constant = 105
        }
              self.tableViewSetUP()
              self.navigationBarSetUp()
              
              // load products if it is not from search button
//              if !isFromSearch{
                  loadProductsFromServer(str: searchStr)
//              }
        tblView.estimatedRowHeight = 150
        self.tblView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
    
    private func navigationBarSetUp(){
        
        headerView.isHidden = false
        
        searchBarRestro.delegate = self
        //searchBarRestro.layer.cornerRadius = 8
        //searchBarRestro.layer.borderColor = UIColor.clear.cgColor
        //searchBarRestro.textField?.borderStyle = .none
        searchBarRestro.clipsToBounds = true
        //searchBarRestro.searchBarStyle = .minimal
        //searchBarRestro.setTextField(color: .white)
        
//        searchBarRestro.delegate = self
//        searchBarRestro.layer.cornerRadius = 10
//        searchBarRestro.clipsToBounds = true
        
        if isFromSearch{
            //Search bar added to navigation bar
            if #available(iOS 13.0, *) {
                searchBarRestro.searchTextField.backgroundColor = UIColor.white
                searchBarRestro.searchTextField.clipsToBounds = true
            } else {
                // Fallback on earlier versions
                searchBarRestro.backgroundColor = UIColor.white
            }
            searchBarRestro.text = searchStr
            addDoneButtonOnKeyboard()
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: doneText, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBarRestro.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.searchBarRestro.resignFirstResponder()
    }
    
    //MARK: - API Call Functions
    func loadProductsFromServer(str:String){
        let param : [String:Any] = [:]
        print("param \(param)")
        
        if apiPage == 1 {
        self.showHud(message: loadingText)
        }
        
        var lat = 0.0
        var long = 0.0
        
        let address = Singleton.shareInstance.selectedAddress
        if let address = address {
            lat = address.latitude ?? 0.0
            long = address.longitude ?? 0.0
        } else {
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
        
        let api = "\(APIEndPoint.searchRestaurant.caseValue)\(str)&lat=\(lat)&lng=\(long)"
        print("search api == ", api)
        
        
        APIUtils.APICall(postName: api, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
                        
            self.hideHud()
            
             self.tblView.tableFooterView?.isHidden = true
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                //Success from our server
                APIUtils.prepareModalFromData(data, apiName: APIEndPoint.searchRestaurant.caseValue, modelName:"SearchRestro", onSuccess: { (anyData) in
                    
                    self.searchRestaurant = anyData as? SearchRestaurant
                    
                    //showing empty store view when no data
                    if self.searchRestaurant?.data?.count == 0{
                        self.viewEmpty.isHidden = false
                    }else{
                        self.viewEmpty.isHidden = true
                        //adding to product array
                        self.restros += (self.searchRestaurant?.data)!
                    }
                    self.tblView.reloadData()
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    //MARK: - Action Functions
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension VC_Food_Search : UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate{
    //MARK: - Search Bar
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchStr = ""
           searchBarRestro.text = ""
           restros = []
           self.searchBarRestro.resignFirstResponder()
           //showing empty store view when no data
           viewEmpty.isHidden = false
           self.tblView.reloadData()
       }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStr = searchBar.text ?? ""
        let strCheck = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if strCheck != ""{
            apiPage = 1
            restros = []
            viewEmpty.isHidden = true
            loadProductsFromServer(str: strCheck)
        }else{
            searchStr = ""
            restros = []
            //showing empty store view when no data
            viewEmpty.isHidden = false
            self.tblView.reloadData()
        }
    }
 
    
    //for making active search bar
    func didPresentSearchController(searchController: UISearchController) {
        self.search.searchBar.becomeFirstResponder()
    }
}

extension VC_Food_Search:UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- Table view Functions
    
    func tableViewSetUP(){
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib(nibName: "Cell_TV_RestaurantRow", bundle: nil), forCellReuseIdentifier: "Cell_TV_RestaurantRow")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restros.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tblView.dequeueReusableCell(withIdentifier: "Cell_Foods_Search") as! Cell_Foods_Search
//        cell.restaurant = restros[indexPath.row]
//        cell.setData()
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_TV_RestaurantRow") as! Cell_TV_RestaurantRow
        let restaurantBranch = restros[indexPath.row]
        cell.setData(restaurantBranch: restaurantBranch)
        cell.searchController = self
        cell.option = "search"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let restroID = self.restros[indexPath.row].slug{
            
//            let isOpen = self.restros[indexPath.row].isOpen ?? true
//            if !isOpen{
//                return
//            }
            let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
            vc.slug = restroID
            vc.restaurantSlug = self.restros[indexPath.row].restaurant?.slug ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if (indexPath.row == (self.restros.count) - 1 ) {
//            if self.searchProducts?.link?.next == true{
//                self.apiPage += 1
//                              let spinner = UIActivityIndicatorView(style: .gray)
//                              spinner.startAnimating()
//                              spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
//
//                              tblView.tableFooterView = spinner
//                              tblView.tableFooterView?.isHidden = false
//
//                loadProductsFromServer(str: searchStr)
//            }
//        }
//    }
    
}
