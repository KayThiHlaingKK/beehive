//
//  VC_AllBrands.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 27/04/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VC_AllBrands: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelCartCount: UILabel!
    
    var brands = [Brand]()
    private let cellId = "Cell_CV_Brand"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadBrands()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCartCount()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
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
    
    @IBAction func goToCartView(_ sender: UIButton) {
        if readLogin() != 0 {
            let vc : CartViewController = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            
            vc.cartType = Cart.store
            vc.cartOption = .navigation
            vc.isFromStore = true
            vc.fromHome = true
            vc.isTappedFromStore = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.showNeedToLoginApp()
        }
    }
    
}


extension VC_AllBrands: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! Cell_CV_Brand
        cell.setData(brand: brands[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        brands.count
    }
}


extension VC_AllBrands: UICollectionViewDelegate {
    
    private func loadBrands() {
        let api = "\(APIEndPoint.brands.caseValue)?size=160&page=1"
        self.showHud(message: "")
        APIUtils.APICall(postName: api, method: .get,  parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            self.brands = []
            
            self.hideHud()
            if status == 200 {
                if let brands = data.value(forKeyPath: "data") as? NSArray {
                    
                    APIUtils.prepareModalFromData(brands, apiName: api, modelName: "Brands", onSuccess: { (anyData) in
                        
                        if let brand = anyData as? Brand {
                            self.brands.append(brand)
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            } else {
                let message =
                data[key_message] as? String ?? serverError
                
                self.hideHud()
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brand = brands[indexPath.item]
        goToBrand(brand: brand)
    }
    
    private func goToBrand(brand: Brand) {
        guard let slug = brand.slug,
              let vc = storyboardBrandDetail.instantiateViewController(withIdentifier: "VC_BrandDetail") as? VC_BrandDetail
        else { return }
        vc.brandId = slug
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension VC_AllBrands: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 48) / 2
        let height = width * (25 / 43) + 32
        return CGSize(width: width, height: height)
    }
}
