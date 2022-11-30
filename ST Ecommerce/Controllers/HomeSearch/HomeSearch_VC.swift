//
//  HomeSearch_VC.swift
//  ST Ecommerce
//
//  Created by Rishabh on 24/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import JGProgressHUD
import AlgoliaSearchClient
import InstantSearch

class HomeSearch_VC: UIViewController , FavoriteListener{
    
    // MARK: - outlets
    @IBOutlet weak var searchBarHome: UISearchBar!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    var searchStr = ""
    var suggestionsProducts : [Product] = [Product]()
    var suggestionsRestaurants : [RestaurantBranch] = [RestaurantBranch]()
     
    
    // MARK: - class functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBarHome.setImage(#imageLiteral(resourceName: "magnifying-glass"), for: .search, state: .normal)
        if #available(iOS 12.0, *) {
            searchBarHome.textField?.contentVerticalAlignment = .center
            searchBarHome.searchTextPositionAdjustment = UIOffset(horizontal: 8.0, vertical: 0.0)
        }
        navigationSetup()
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.register(UINib(nibName: "HomeSearchCell", bundle: nil), forCellReuseIdentifier: "HomeSearchCell")
        
        viewEmpty.isHidden = false
        
    }
    
   
     
    
    func navigationSetup(){
        
        searchBarHome.delegate = self
        searchBarHome.layer.cornerRadius = 8
        //searchBarHome.layer.borderColor = UIColor.clear.cgColor
        //searchBarHome.textField?.borderStyle = .none
        searchBarHome.clipsToBounds = true
        searchBarHome.searchBarStyle = .minimal
        searchBarHome.setTextField(color: .white)
        
        //        searchBarHome.delegate = self
        //               searchBarHome.layer.cornerRadius = 10
        //               searchBarHome.clipsToBounds = true
        searchBarHome.text = searchStr
        if #available(iOS 13.0, *) {
            searchBarHome.searchTextField.backgroundColor = UIColor.white
            searchBarHome.searchTextField.clipsToBounds = true
        } else {
            searchBarHome.backgroundColor = UIColor.white
        }
        addDoneButtonOnKeyboard()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadHomeSearchFromServer(str: searchStr)
    }
    
    //MARK: - API Call Functions
    func loadHomeSearchFromServer(str:String){
        let searchKeyword = str.replacingOccurrences(of: " ", with: "%20")
        let param : [String:Any] = [:]
        
        self.showHud(message: loadingText)
        print("param = " , param)
        
        var lat = 0.0
        var long = 0.0
        if Singleton.shareInstance.selectedAddress?.latitude != nil {
            print("default address")
            lat = Singleton.shareInstance.selectedAddress?.latitude ?? 0.0
            long = Singleton.shareInstance.selectedAddress?.longitude ?? 0.0
        }
        else {
            print("current address")
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
        
        let urlStr = "\(APIEndPoint.homeSearch.caseValue)\(searchKeyword)&lat=\(lat)&lng=\(long)"
        print("search = ", urlStr)
        APIUtils.APICall(postName: urlStr, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            print("response ", response)
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200{
                print(data)
                if let suggestions = data.value(forKeyPath: "data") as? NSDictionary{
                    
                    
                    APIUtils.prepareModalFromData(suggestions, apiName: APIEndPoint.homeSearch.caseValue, modelName: "HomeSearch", onSuccess: { (anyData) in
                        if let suggestionsData = anyData as? HomeData{
                            self.suggestionsProducts = suggestionsData.products ?? []
                            self.suggestionsRestaurants = suggestionsData.restaurant_branches ?? []
                            if self.suggestionsProducts.count == 0 && self.suggestionsRestaurants.count == 0{
                                self.viewEmpty.isHidden = false
                            }else{
                                self.viewEmpty.isHidden = true
                            }
                            self.tblView.reloadData()
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
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
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        self.suggestionsProducts[index!].is_favorite = isFavourite
    }
    
}

extension HomeSearch_VC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if suggestionsProducts.count == 0 && suggestionsRestaurants.count == 0
        {
            return 0
        }
        else if (suggestionsProducts.count != 0 && suggestionsRestaurants.count == 0) || (suggestionsProducts.count == 0 && suggestionsRestaurants.count != 0) {
            return 1
        }
        else if suggestionsProducts.count != 0 && suggestionsRestaurants.count != 0
        {
            return 2
        }
        else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.size.width/homeCellWidthRatio
//        return height/homeCellHeightRatio + 30
        return height/homeCellHeightRatio * 1.3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 || indexPath.row == 1{
            let cell : HomeSearchCell = tableView.dequeueReusableCell(withIdentifier: "HomeSearchCell") as! HomeSearchCell
            cell.favoriteListener = self
            cell.selectionStyle = .none
            cell.controller = self
            cell.parentIndexPath = indexPath
            cell.collectionViewSetUP()
            
            if suggestionsProducts.count > 0 && suggestionsRestaurants.count > 0 {
                if indexPath.row == 0 && self.suggestionsProducts.count > 0{
                    cell.homeItemType = HomeItemType.SuggestionsProductType
                    cell.labelCategory.text = productsText
                }else if indexPath.row == 1 && self.suggestionsRestaurants.count > 0 {
                    cell.homeItemType = HomeItemType.SuggestionsRestaurantType
                    cell.labelCategory.text = restaurantsText
                }
            }
            else if suggestionsProducts.count > 0 {
                cell.homeItemType = HomeItemType.SuggestionsProductType
                cell.labelCategory.text = productsText
            }
            else if suggestionsRestaurants.count > 0 {
                cell.homeItemType = HomeItemType.SuggestionsRestaurantType
                cell.labelCategory.text = restaurantsText
            }
            
            cell.collectionViewHomeSuggestions.reloadData()
            return cell
        }
        return UITableViewCell()
        
    }
}

extension HomeSearch_VC:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchStr = ""
        searchBarHome.text = ""
        suggestionsRestaurants = []
        suggestionsProducts = []
        self.searchBarHome.resignFirstResponder()
        self.tblView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchStr = searchBar.text ?? ""
        let strCheck = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if strCheck != ""{
            suggestionsRestaurants = []
            suggestionsProducts = []
            viewEmpty.isHidden = true
            loadHomeSearchFromServer(str: strCheck)
        }else{
            searchStr = ""
            suggestionsRestaurants = []
            suggestionsProducts = []
            viewEmpty.isHidden = false
            self.tblView.reloadData()
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
        
        searchBarHome.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.searchBarHome.resignFirstResponder()
    }
}

