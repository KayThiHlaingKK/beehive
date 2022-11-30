//
//  ProductDetailViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 23/06/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import Down
import Lottie

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionViewProduct: UICollectionView!
    @IBOutlet weak var collectionViewRecommend: UICollectionView!
    @IBOutlet weak var collectionViewExampleImage: UICollectionView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var variantLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var shopView: UIView!
    @IBOutlet weak var variantView: UIView!
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var labelCartCount: UILabel!
    @IBOutlet weak var variantHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var desHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var wholeHeightConstraint: NSLayoutConstraint!

    var slug = ""
    var productDetails : Product?
    private var moreProducts = [Product]()
    var fromCart = false
    var productImages :[Images] = [Images]()
    var productImageNames : [String] = [String]()
    var productList: [Product] = []
    //var chooseVariants: [Variants] = []
    var chooseProductVariant: ProductVariant?
    var cartProduct: CartProduct?
    var roomNote = 0
    var imageVariant: Variants?
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadCartData()
        labelCartCount.isHidden = true
    }
    
    override func viewDidLoad() {
        if readLogin() != 0 {
            self.loadCartData()
        }
        else {
            labelCartCount.isHidden = true
        }
        setupUI()
        loadProductDetailFromServer()
        loadRecommendProducts()
        let gesture1 = UITapGestureRecognizer(target: self, action: #selector(goToShop))
        shopView.addGestureRecognizer(gesture1)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(goToVariant))
        variantView.addGestureRecognizer(gesture2)
    }
    
    @objc final func goToShop() {
        print("go to shop")
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        vc.shop = productDetails?.shop ?? Shop()
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    func setupUI() {
        
        collectionViewSetUP()
        outerView.roundCorners(corners: [.topRight, .topLeft], amount: 20)
        detailView.roundCorners(corners: [.topRight, .topLeft], amount: 20)
        
        if countLbl.text == "0" {
            minusBtnDisable()
        }
    }
    
    
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func loadProductDetailFromServer(){
        
        print("loadProductDetailFromServer")
        
        let param : [String:Any] = [:]
        self.showHud(message: loadingText)
        
        let path = "\(APIEndPoint.product.caseValue)/\(slug)"
        APIUtils.APICall(postName: path, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            print("res = ", response)
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            if status == 200{
                if let productsDetail = data.value(forKeyPath: "data") as? NSDictionary {
                    
                    APIUtils.prepareModalFromData(productsDetail, apiName: APIEndPoint.product.caseValue, modelName:"ProductDetails", onSuccess: { [self] (anyData) in
                        self.productDetails = anyData as? Product ?? nil
                        self.reloadData()
                        self.loadMoreProducts()
                    }) { (error, endPoint) in
                        print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
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
    
    func reloadData() {
        
        if productDetails?.content_name != nil{
            if let contentName = productDetails?.content_name{
                titleLbl.text = "\(productDetails?.name  ?? "") (\(contentName))"
            }

        }else{
            titleLbl.text = productDetails?.name
        }
    
        if productDetails?.brand?.name != nil {
            if let brand = productDetails?.brand?.name {
                brandLbl.text = "Brands : \(brand)"
                brandLbl.isHidden = false
                brandHeightConstraint.constant = 35
            }
        }
        else {
            brandLbl.isHidden = true
            brandHeightConstraint.constant = 0
        }
        
        if productDetails?.rating != nil {
            ratingHeightConstraint.constant = 25
        }
        else {
            ratingHeightConstraint.constant = 0
        }
        
        if productDetails?.discount == 0 {
            discountHeightConstraint.constant = 0
            discountLbl.isHidden = true
            
            
            priceLbl.text = "\(priceFormat(pricedouble: productDetails?.price ?? 0))\(currencySymbol)"
                    
        }
        else {
            discountLbl.isHidden = false
            discountHeightConstraint.constant = 30
                
            let discount = productDetails?.discount ?? 0
            let orgPrice = productDetails?.price ?? 0
            let actualPrice = orgPrice - discount
            let orgPriceInt = Int(orgPrice)
            let actualPriceInt = Int(actualPrice)
            
            let mutableAttributedString = NSMutableAttributedString()
            let attributedString = NSAttributedString(string: "\(priceFormat(price: orgPriceInt))\(currencySymbol)").withStrikeThrough()
//            let yousave = NSAttributedString(string: "You save : ")
//            mutableAttributedString.append(yousave)
            mutableAttributedString.append(attributedString)
            
            discountLbl.attributedText = mutableAttributedString
            
            priceLbl.text = "\(priceFormat(price: actualPriceInt))\(currencySymbol)"
            
        }
        
        detailHeightConstraint.constant = brandHeightConstraint.constant + ratingHeightConstraint.constant + discountHeightConstraint.constant + 100


        let down = Down(markdownString: productDetails?.description ?? "")
        do {
            desTextView.attributedText = try down.toAttributedString().setFont(size: 15, range: nil)
            
//            let  attributes = [NSAttributedString.Key.font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 15.0)]
//            desTextView.attributedText = try NSAttributedString(string: down.toAttributedString().string, attributes: attributes)
        } catch let err {
            desTextView.text = productDetails?.description
        }
//        desTextView.text = productDetails?.description
        
        var imageInclude = false
        if productDetails?.variants != nil {
            let variantcount = productDetails?.variants?.count ?? 0
            var str = ""
            for i in 0..<variantcount {
                if productDetails?.variants?[i].ui == "image"{
                    imageVariant = productDetails?.variants?[i]
                    imageInclude = true
                }
                if let vcount = productDetails?.variants?[i].values_?.count, let name = productDetails?.variants?[i].name {
                    str.append("\(vcount) \(name)")
                }
                
                if i < variantcount - 1 {
                    str.append(",")
                }
            }
            variantLbl.text = str
        }
        
        if ((productDetails?.variants) != nil) {
            if productDetails?.variants?.count ?? 0 == 1 && productDetails?.variants?[0].name == "standard" {
                hideVariant()
            }
            else if productDetails?.variants?.count ?? 0 > 0 {
                if imageInclude {
                    variantHeightConstraint.constant = 150
                    collectionViewExampleImage.reloadData()
                }
                else {
                    variantHeightConstraint.constant = 60
                }
                variantView.isHidden = false
            }
            else {
                hideVariant()
            }
        }
        else {
            hideVariant()
        }
        
        setProductImages(product: productDetails ?? Product())
        collectionViewProduct.reloadData()
        
        adjustUITextViewHeight(arg: desTextView)
        
        desHeightConstraint.constant = self.desTextView.bounds.height + 50
        
        let descriptionHeight: CGFloat = desHeightConstraint.constant < 88 ? desHeightConstraint.constant: (desHeightConstraint.constant + 100)
        wholeHeightConstraint.constant = 1000 + descriptionHeight
        // UIScreen.main.bounds.height + self.desHeightConstraint.constant + variantHeightConstraint.constant - 150
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + self.desHeightConstraint.constant + variantHeightConstraint.constant + 200)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000 + self.desHeightConstraint.constant)
        
    }
    
    func hideVariant() {
        variantView.isHidden = true
        variantHeightConstraint.constant = 0
    }
    
    func loadRecommendProducts(){
        print("loadRecommendProducts")
        let param : [String:Any] = [:]
        APIUtils.APICall(postName: "\(APIEndPoint.recommendProduct.caseValue)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            self.hideHud()
            
            let resp = response as! NSDictionary
            let status = resp.value(forKey: key_status) as? Int
            let data = resp.value(forKey: "data") as! NSArray
            
            if status == 200{
                //Success from our server
                APIUtils.prepareModalFromData(data, apiName: APIEndPoint.recommendProduct.caseValue, modelName:"Product", onSuccess: { (anyData) in
                    
                    let product = anyData as! Product
                    
                    self.productList.append(product)
                    
                    
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlert(title: errorText, message: message)
            }
            
            DispatchQueue.main.async {
                self.collectionViewRecommend.reloadData()
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    @IBAction func goBackClicked(_ sender: UIButton){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goCartClicked(_ sender: UIButton){
        guard let vc = storyboardCart.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController else { return }
        vc.isTappedFromStore = true
        vc.cartType = Cart.store
        vc.cartOption = .navigation
        vc.isFromStore = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //not used
    @IBAction func plusClicked(_ sender: UIButton) {
        chooseForCart()
    }
    
    //not used
    @IBAction func minusClicked(_ sender: UIButton) {
        print("minus click")
        /*
        if UserSessionManager.shared.productOrder.count > 0 {
            let orgCount = UserSessionManager.shared.productOrder[roomNote].orderCount ?? 0
            let newCount = orgCount - 1
            if newCount == 0 {
                UserSessionManager.shared.productOrder.remove(at: roomNote)
                minusBtnDisable()
            }
            else {
                UserSessionManager.shared.productOrder[roomNote].orderCount = newCount
            }
            print(newCount)
            countLbl.text = "\(Int(newCount))"
        }*/
    }
    
    func minusBtnDisable() {
        minusBtn.isUserInteractionEnabled = false
        minusBtn.tintColor = UIColor().HexToColor(hexString: "#000000")
    }
    
    func minusBtnEnable() {
        minusBtn.isUserInteractionEnabled = true
        minusBtn.tintColor = UIColor().HexToColor(hexString: "#FFBB00")
    }
    
    
    func callVariantForm() {
        var chooseArray: [Variants] = []
        let varCount = self.productDetails?.product_variants?[0].variant?.count ?? 0
        for i in 0..<varCount {
            var chooseVariant = Variants()
            chooseVariant.name = self.productDetails?.product_variants?[0].variant?[i].name
            chooseVariant.selectedValue = self.productDetails?.product_variants?[0].variant?[i].value
            chooseArray.append(chooseVariant)
        }
        
        let vc: ProductVariationViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductVariationViewController") as! ProductVariationViewController
        vc.productDetailViewController = self
        vc.chooseVariantArray = chooseArray
        self.present(vc, animated: true, completion: nil)
    }
    
    func chooseForCart() {
        if readLogin() != 0
        {
            if productDetails?.variants != nil {
                if productDetails?.variants?.count == 1 && productDetails?.variants?[0].name == "standard" {
                    self.chooseProductVariant = self.productDetails?.product_variants?[0]
                    self.chooseProductVariant?.qty = 1
                    self.addToCartStore()
                }
                else if productDetails?.variants?.count ?? 0 > 0 {
                    callVariantForm()
                }
                else {
                    self.chooseProductVariant = self.productDetails?.product_variants?[0]
                    self.chooseProductVariant?.qty = 1
                    self.addToCartStore()
                }
            }
            else {
                self.chooseProductVariant = self.productDetails?.product_variants?[0]
                self.chooseProductVariant?.qty = 1
                self.addToCartStore()
            }
        }else{
            self.showNeedToLoginApp()
            
        }
        
    }
    
    //@IBAction func chooseVariantClicked(_ sender: UIButton) {
    @objc final func goToVariant() {
        callVariantForm()
    }
    
    @IBAction func addToCartClicked(_ sender: UIButton) {
        if readLogin() != 0
        {
            chooseForCart()
        }else{
            self.showNeedToLoginApp()
            
        }
    }
    
    
    func addToCartStore(){
        print("read login == ", readLogin())
        if readLogin() != 0 {
            let param : [String:Any] = [
                "customer_slug": Singleton.shareInstance.userProfile?.slug ?? "",
                "quantity": self.chooseProductVariant?.qty ?? 1, "variant_slug": self.chooseProductVariant?.slug ?? "",
                "address": [
                    "house_number": Singleton.shareInstance.selectedAddress?.house_number ?? "",
                    "floor": Singleton.shareInstance.selectedAddress?.floor ?? 0,
                    "street_name": Singleton.shareInstance.selectedAddress?.street_name ?? "",
                    "latitude": Singleton.shareInstance.selectedAddress?.latitude ?? 0.0,
                    "longitude": Singleton.shareInstance.selectedAddress?.longitude ?? 0.0,
                    "township_slug": Singleton.shareInstance.selectedAddress?.township?.slug as Any
            ]
            ]

            print("addtocart = " , param)
            self.showHud(message: loadingText)
            
            let path = "\(APIEndPoint.productCart.caseValue)/\(slug)"
            APIUtils.APICall(postName: path, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
                
                self.hideHud()
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Int
                if status == 200{
                    
                    self.showToast(message: "added to cart", font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))
                    self.loadCartData()
                    
                }else{
                    let message = data[key_message] as? String ?? serverError
                    self.presentAlert(title: errorText, message: message)
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
            }
        }
        else {
            showNeedToLoginApp()
        }
        
      
    }
    
    func loadCartData(){
        print("load cart data")
        let param : [String:Any] = ["customer_slug" : Singleton.shareInstance.userProfile?.slug ?? ""]
        print("Slug: ======>",Singleton.shareInstance.userProfile?.slug ?? "")
        APIUtils.APICall(postName: APIEndPoint.cart.caseValue, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            self.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            
            if status == 200 {
                if let cart = data.value(forKeyPath: "data") as? NSDictionary{
                    APIUtils.prepareModalFromData(cart, apiName: APIEndPoint.cart.caseValue, modelName: "Cart", onSuccess: { (anyData) in
                        let cartData = anyData as? CartData
                        
                        var productCartCount = 0
                        
                        if let shopcount = cartData?.shop?.shops?.count, shopcount > 0 {
                            for i in 0..<shopcount {
                                let product = cartData?.shop?.shops?[i].productCarts
                                for j in 0..<Int(product?.count ?? 0) {
                                    productCartCount += product?[j].quantity ?? 0
                                }
                                
                            }
                            self.labelCartCount.isHidden = false
                            self.labelCartCount.text = "\(productCartCount)"
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
 
    
    
    private func loadMoreProducts() {
        
        print("loadMoreProducts")
        
        guard let slug = productDetails?.shop?.slug else { return }
        let apiStr = "\(APIEndPoint.moreFromThisShop.caseValue)/\(slug)/products"
        
        APIUtils.APICall(postName: apiStr, method: .get, parameters: [String:Any](), controller: self) { (response) in
            
            
            if let data = response as? NSDictionary {
                let status = data.value(forKey: key_status) as? Int ?? 400
                
                if status == 200 {
                    if let favourites = data.value(forKeyPath: "data") as? NSArray {
                        
                        APIUtils.prepareModalFromData(favourites, apiName: apiStr, modelName: "Product", onSuccess: { (anyData) in
                            
                            if let moreProduct = anyData as? [Product] {
                                self.moreProducts = moreProduct
                            }
                            DispatchQueue.main.async {
                                self.collectionViewRecommend.reloadSections(IndexSet(integer: 1))
                            }
                            
                        }) { (errror, reason) in
                            print("error \(String(describing: errror)), reason \(reason)")
                        }
                    }
                } else {
                    let _ = data[key_message] as? String ?? serverError
                }
            }
            
        } onFailure: { (reason, statusCode) in
        }
    }
}

extension ProductDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionViewSetUP(){
        
        collectionViewProduct.dataSource = self
        collectionViewProduct.delegate = self
        collectionViewRecommend.dataSource = self
        collectionViewRecommend.delegate = self
        collectionViewExampleImage.dataSource = self
        collectionViewExampleImage.delegate = self
        
        collectionViewRecommend.register(UINib.init(nibName: "Cell_CV_Row", bundle: nil), forCellWithReuseIdentifier: "Cell_CV_Row")
        
        let nib = UINib(nibName: "SectionHeader", bundle: nil)
        collectionViewRecommend.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        
        collectionViewRecommend.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
        
        collectionViewRecommend.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
        
    }
    
    func setProductImages(product:Product){
        
        productImages.removeAll()
        if let images = product.images{
            for imageUrl in images{
                self.productImages.append(imageUrl)
            }
        }
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == collectionViewRecommend {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        let emptySize = CGSize(width: 0.0, height: 0.0)
        let headerSize = CGSize(width: collectionView.frame.width, height: 54)
        guard collectionView == collectionViewRecommend else { return emptySize }
        
        switch section {
        case 0: return productList.isEmpty ? emptySize: headerSize
        case 1: return moreProducts.isEmpty ? emptySize: headerSize
        default: return emptySize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionViewProduct {
            return productImages.isEmpty ? 1 : productImages.count
        }
        else if collectionView == collectionViewRecommend {
            if section == 0 {
                return productList.count > 0 ? 1: 0
            }
            return moreProducts.count > 0 ? 1: 0
        }
        else if collectionView == collectionViewExampleImage {
            return self.imageVariant?.values_?.count ?? 0
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewProduct {
            let cell : Cell_CV_Product_Image = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Product_Image", for: indexPath) as! Cell_CV_Product_Image
            
            if indexPath.row < productImages.count {
                cell.setData(productImage: productImages[indexPath.row])
            } else {
                cell.imageViewBanner.image = UIImage(named: "placeholder2")
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))

            cell.imageViewBanner.isUserInteractionEnabled = true
            cell.imageViewBanner.tag = indexPath.row
            cell.imageViewBanner.addGestureRecognizer(tapGestureRecognizer)
                        
            return cell
        }
        else if collectionView == collectionViewRecommend {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_CV_Row", for: indexPath) as! Cell_CV_Row
            cell.index = indexPath.item
            cell.controller = self
            if indexPath.section == 1 {
                cell.productType = .weRecommended
                cell.setupData(products: moreProducts)
            } else {
                cell.productType = .other
                cell.setupData(products: productList)
            }
            
            return cell
        }
        else if collectionView == collectionViewExampleImage {
            let cell : Cell_Example_Image = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell_Example_Image", for: indexPath) as! Cell_Example_Image
            cell.setData(productImage: self.imageVariant?.values_?[indexPath.row].image_slug ?? "")
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              collectionView == collectionViewRecommend,
              let brandHeader = collectionViewRecommend.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader
        else {
            let header = collectionViewRecommend.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "EmptyHeader", for: indexPath) as! UICollectionReusableView
            return header
        }
        brandHeader.titleText = indexPath.section == 1 ? "More Products from this shop" : "Recommended for you"
        return brandHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewProduct {
            let width = collectionView.frame.size.width
            return CGSize(width: width, height: width/1.25)
        }
        else if collectionView == collectionViewExampleImage {
            return CGSize(width: 70, height: 70)
        }
        
        else if collectionView == collectionViewRecommend {
            return calculateSizeForProductCell()
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func calculateSizeForProductCell() -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let cellWidth = (screenWidth - (32 + 12 + 4)) / 2
        let width = collectionViewRecommend.frame.size.width
        let cellHeight = (cellWidth*1.6) + 20 + 32
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //self.pageController.currentPage = indexPath.row
    }
    
    
    //MARK: - Supporting functions
    func configurePageView(){
        
//        pageController.numberOfPages = self.productImages.count
//        pageController.currentPage = 0
//        pageController.hidesForSinglePage = true
//        pageController.tintColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
//        pageController.pageIndicatorTintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        pageController.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.4646773338, blue: 0, alpha: 1)
        
    }
    
    func startTimer() {
        
        let timer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = collectionViewProduct {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < self.productImages.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }
    @objc func cellTappedMethod(_ sender:AnyObject){
        guard let vc: ImageViewController = storyboardProductDetails.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else { return }
        vc.imageArray = self.productImages
        vc.index = sender.view.tag
        self.navigationController?.present(vc, animated: true, completion: {
            vc.imageArray = self.productImages
        })
    }
    
    func goToDetailView(product: Product) {
        guard let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController,
              let slug = product.slug
        else { return }
        
        vc.slug = slug
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
