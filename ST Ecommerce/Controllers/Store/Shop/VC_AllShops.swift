//
//  VC_AllShops.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 28/01/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

enum ShopTypes{
    case search
    case shopAll
}

class VC_AllShops: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var searchShopTF: UITextField!

//    var shops = [Shop]()
    private var loadingView: LoadingReusableView?
    
    private var shops = [Shop]()
    private var currentPage = 1
    private var lastPage = 1
    private let cellId = "Cell_CV_Shop"
    private var type = ShopTypes.shopAll
    var searchStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCartCount()
        setupSearchBar()
        shops.removeAll()
        currentPage = 1
        lastPage = 1
        loadShops(str: searchStr)
        
    }
    
    private func setupSearchBar(){
        if #available(iOS 12.0, *) {
            searchShopTF.contentVerticalAlignment = .center
        }
        searchShopTF.delegate = self
        addDoneButtonOnKeyboard()
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: doneText, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchShopTF.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.searchShopTF.resignFirstResponder()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        collectionView.register(UINib(nibName: "LoadingReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingReusableView")
    }

    private func setupCartCount() {
        if readLogin() != 0 {
            loadCartData()
        } else {
            labelCartCount.isHidden = true
        }
    }

    func loadCartData(){
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]

        APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in

            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int

            if status == 200 {
                if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                    APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cart.caseValue, modelName: "Cart", onSuccess: { (anyData) in
                        let cartData = anyData as? CartData

                        var productOrderCount = 0
                        if let shopcount = cartData?.shop?.shops?.count, shopcount > 0 {
                            for i in 0..<shopcount {
                                let product = cartData?.shop?.shops?[i].productCarts
                                for j in 0..<Int(product?.count ?? 0) {
                                    productOrderCount += product?[j].quantity ?? 0
                                }

                            }
                        }
                        self.labelCartCount.text = "\(productOrderCount)"

                        if productOrderCount > 10 {
                            self.labelCartCount.text = "10+"
                        }
                        self.labelCartCount.isHidden = productOrderCount == 0

                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                    }
                }

            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
    }

    @IBAction func back(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }


}

//MARK: -- UITextFieldDelegate
extension VC_AllShops: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        type = .search
        let searchStr = searchShopTF.text ?? ""
        let strCheck = searchStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if strCheck != ""{
            type = .search
            searchShopTF.text = ""
            shops.removeAll()
            currentPage = 1
            lastPage = 1
            self.searchStr = strCheck
            loadShops(str: strCheck)
            self.searchShopTF.resignFirstResponder()
        }else{
            
            self.searchShopTF.resignFirstResponder()
        }
        return true
    }
}

extension VC_AllShops: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! Cell_CV_Shop
        if indexPath.item == (shops.count - 1) {
            currentPage += 1
            loadShops(str: self.searchStr)
            
        }
        if currentPage >= lastPage {
            loadingView?.activityIndicator.stopAnimating()
        }
        cell.setData(shop: shops[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter
        else { return UICollectionReusableView() }
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath) as! LoadingReusableView
        loadingView = footerView
        loadingView?.backgroundColor = UIColor.clear
        loadingView?.activityIndicator.startAnimating()
        footerView.isHidden = self.currentPage >= 1
        
        loadingView?.activityIndicator.hidesWhenStopped = true
        return footerView
    }
}


extension VC_AllShops: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let shop = shops[indexPath.item]
        goToShopDetail(shop: shop)
    }

    private func goToShopDetail(shop: Shop) {
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        vc.shopSlug = shop.slug
        vc.shop = shop
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VC_AllShops: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width - 32
        let height = width * (130/376) + 12
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: 50)
    }
}


extension VC_AllShops {
    
    private func loadShops(str: String){
        guard currentPage <= lastPage else { return }
        let strCheck = str.trimmingCharacters(in: .whitespacesAndNewlines)
        var apiStr = ""
        
        if type == .search{
            let deviceId =  UIDevice.current.identifierForVendor?.uuidString
            apiStr = "\(APIEndPoint.shops.caseValue)?filter=\(strCheck)&device_id=\(deviceId ?? "")&page=\(currentPage)"
        }else{
            apiStr = "\(APIEndPoint.shops.caseValue)?size=10&page=\(currentPage)"
        }
        
        print(apiStr)
        
        APIUtils.APICall(postName: apiStr, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
            self.hideHud()
            if status == 200 {
                
                if let shops = data.value(forKeyPath: "data") as? NSArray {
                    
                    APIUtils.prepareModalFromData(shops, apiName: APIEndPoint.shopAllSearch.caseValue, modelName: "Shop", onSuccess: { (anyData) in
                        
                        if let shop = anyData as? Shop {
                            self.shops.append(shop)
                            debugPrint(shop)
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.loadingView?.activityIndicator.stopAnimating()
                    }
                }
            } else {
                let message =
                data[key_message] as? String ?? serverError
                self.hideHud()
                self.presentAlert(title: errorText, message: message)
                self.loadingView?.activityIndicator.stopAnimating()
            }
            
        }) { (reason, statusCode) in
        }
    }
    
//    func loadSearchAPI(){
//        guard currentPage <= lastPage else { return }
//        let strCheck = str.trimmingCharacters(in: .whitespacesAndNewlines)
//
//    }
    
}
