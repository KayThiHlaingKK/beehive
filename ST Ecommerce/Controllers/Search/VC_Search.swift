//
//  VC_Search.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 02/12/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import AlgoliaSearchClient
import InstantSearch


class VC_Search: UIViewController {
    
    
    private var client: SearchClient!
    private var index: Index!
    
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productMenuTab: UIView!
    @IBOutlet weak var restaurantMenuTab: UIView!
    @IBOutlet weak var productMenuUnderline: RoundedView!
    @IBOutlet weak var restaurantMenuUnderline: RoundedView!
    @IBOutlet weak var searchHistoriesView: UIView!
    @IBOutlet weak var menuBar: UIStackView!
    @IBOutlet weak var menuBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView!
    private var serviceAnnouncement: ServiceAnnouncement?
    
    @IBOutlet weak var searchHistoriesContainerView: UIView!
    
    private var products = [Product]()
    private var restaurants = [RestaurantBranch]()
    private var isHintlist = true
    private var searchHistories = [SearchHistory]()
    private var selectedMenu = MenuType.products_query_suggestions
    private var tagLabels = [UILabel]()
    private var hints = [[String:Any]]()
    private var currentPage = 1
    private var lastPage = 1
    private var loadingView: LoadingReusableView?
    
    private var lat = 0.0
    private var long = 0.0
    var tappedMenuTag: Int?
    var hideMenuBar = false
    var searchKeyword = ""
    
    private var leftSpacingForSearchHistories: CGFloat = 16
    private var topSpacingForSearchHistories: CGFloat = 8
    
    private enum CellType: String, CaseIterable {
        case Cell_CV_SearchHint, Cell_CV_ProductHome, Cell_CV_RestaurantRow
    }
    
    private enum MenuType: String, CaseIterable {
        case products_query_suggestions, restaurant_branches_query_suggestions
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupSegmentedMenu()
        loadServiceAnnouncement()
        if let tag = tappedMenuTag {
            changeMenu(tag: tag)
        } else {
            fetchSearchHistories()
        }
        if hideMenuBar {
            menuBar.isHidden = true
            menuBarHeightConstraint.constant = 0
        }
        setupInstantSearchUI(indexName: MenuType.products_query_suggestions.rawValue)
    }
    
    private func setupCollectionView() {
        navigationController?.navigationBar.backgroundColor = .white
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 16, bottom: 8, right: 16)
        
        CellType.allCases.forEach {
            let nib = UINib(nibName: $0.rawValue, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: $0.rawValue)
        }
        
        ["LoadingReusableView", "Cell_CV_EndResult"].forEach {
            let nib = UINib(nibName: $0, bundle: nil)
            collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let address = Singleton.shareInstance.selectedAddress
        if let address = address {
            lat = address.latitude ?? 0.0
            long = address.longitude ?? 0.0
        } else {
            lat = Singleton.shareInstance.currentLat
            long = Singleton.shareInstance.currentLong
        }
       
        searchHistoriesContainerView.isHidden = false
        searchField.delegate = self
        searchField.becomeFirstResponder()
    }
    
    private func setupSegmentedMenu() {
        [productMenuTab, restaurantMenuTab].forEach { [unowned self] in
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapMenu(sender:)))
            $0!.addGestureRecognizer(gesture)
        }
    }
    
    @objc func onTapMenu(sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag ?? 0
        changeMenu(tag: tag)
    }
    
    func changeMenu(tag: Int) {
        let isProduct = tag == 0
        selectedMenu = tag == 0 ? .products_query_suggestions : .restaurant_branches_query_suggestions
        products = []
        restaurants = []
        currentPage = 1
        lastPage = 1
        textFieldSubmitted()
        
        productMenuUnderline.isHidden = !isProduct
        restaurantMenuUnderline.isHidden = isProduct
    }
   
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearHistory(_ sender: UIButton) {
        guard !searchHistories.isEmpty else { return }
        let alertController = UIAlertController(title: "", message: "Are you sure you want to clear recent search?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned self] action in
            self.clearSearchHistories()
        }
        
        [cancelAction, yesAction].forEach {
            $0.setValue(UIColor.systemYellow, forKey: "titleTextColor")
            alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
    
    private func setupInstantSearchUI(indexName: String) {
        client = SearchClient(appID: ApplicationID(rawValue: "FNOV0X2CZD"), apiKey: APIKey(rawValue: "54d5a09dc9c79273a6b183cb8887b21e"))
        index = client.index(withName: IndexName(rawValue: indexName))
        
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(textFieldSubmitted), for: .editingChanged)
    }
    
    @objc func textFieldSubmitted() {
        searchHistoriesView.isHidden = false
        emptyView.isHidden = true
        collectionView.isHidden = false
        isHintlist = true
        guard let searchText = searchField.text,
              !searchText.isEmpty else {
                  searchHistoriesView.isHidden = false
                  isHintlist = false
                  fetchSearchHistories()
                  return
              }
        
        search(with: searchText)
        searchHistoriesView.isHidden = true
    }
    
  
    private func search(with keyword: String) {
        index = client.index(withName: IndexName(rawValue: selectedMenu.rawValue))
        index.search(query: Query(keyword)) { results in
            switch results {
            case .success(let resp):
                DispatchQueue.main.async { [unowned self] in
                    self.hints = resp.hits.compactMap { $0.object.object() as? [String: Any] }
                    self.collectionView.reloadData()
                }
            case .failure(let err):
                print("Resp Error: \(err)")
                
            }
        }
    }
    
}

extension VC_Search: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        typingEnded()
        return true
    }
    
    @objc private func typingEnded() {
        products = []
        restaurants = []
        currentPage = 1
        lastPage = 1
        isHintlist = true
        if isHintlist {
//            isHintlist = false
            searchKeyword = searchField.text ?? ""
            if selectedMenu == .products_query_suggestions {
                showHud(message: "")
                products = []
                loadProductsFromServer(str: searchKeyword)
            } else {
                showHud(message: "")
                loadRestaurantsFromServer(str: searchKeyword)
            }
            self.searchField.resignFirstResponder()
        }
    }
    
    
}


extension VC_Search: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isHintlist {
            return hints.count// hitsInteractor.numberOfHits()
        }
        return selectedMenu == .products_query_suggestions ? products.count : restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if selectedMenu == .products_query_suggestions && isHintlist == false {
            return 32
        }
        
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isHintlist {
            self.loadingView?.activityIndicator.isHidden = true
            return createHintCell(indexPath: indexPath)
        }
        else {
            if selectedMenu == .products_query_suggestions {
                return createPoductResultCell(indexPath: indexPath)
            } else {
                return createRestaurantResultCell(indexPath: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        
        if isHintlist {
            return CGSize(width: screenWidth, height: 36)
        } else {
            if selectedMenu == .products_query_suggestions {
                let cellWidth = (screenWidth - (32 + 12 + 4)) / 2
                let cellHeight = (cellWidth*1.6) + 20
                
                return CGSize(width: cellWidth, height: cellHeight)
            } else {
                let cellWidth = (screenWidth - 16)
                let cellHeight = (cellWidth * (176/344))
                return CGSize(width: cellWidth, height: cellHeight)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isHintlist == true {
            guard let keyword = hints[indexPath.item]["query"] as? String else { return }
            
            searchField.text = keyword
            products = []
            restaurants = []
            currentPage = 1
            lastPage = 1
            if selectedMenu == .products_query_suggestions {
                showHud(message: "")
                loadProductsFromServer(str: keyword)
            } else {
                showHud(message: "")
                loadRestaurantsFromServer(str: keyword)
            }
        } else {
            
            if selectedMenu == .products_query_suggestions {
                navigateToProducDetail(indexPath: indexPath)
            } else {
                navigateToRestaurantDetail(indexPath: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard selectedMenu == .products_query_suggestions,
              isHintlist == false
        else {
            return CGSize(width: collectionView.frame.size.width, height: 0)
        }
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter
        else { return UICollectionReusableView() }
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath) as! LoadingReusableView
        loadingView = footerView
        loadingView?.backgroundColor = UIColor.clear
        loadingView?.activityIndicator.startAnimating()
        loadingView?.activityIndicator.hidesWhenStopped = true
        return footerView
    }
    
    private func navigateToRestaurantDetail(indexPath: IndexPath) {
        let restaurantBranch = restaurants[indexPath.item]
        let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        if let slug = restaurantBranch.slug {
            vc.slug = slug
        }
        
        vc.restaurantBranch = restaurantBranch
        vc.restaurantSlug = restaurantBranch.slug ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToProducDetail(indexPath: IndexPath) {
        guard let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController
        else { return }
//        vc.fromCart = from
        let product = products[indexPath.item]
        
        if let productId = product.slug {
            vc.slug = productId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func createHintCell(indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.Cell_CV_SearchHint.rawValue, for: indexPath) as! Cell_CV_SearchHint
        cell.label.text = hints[indexPath.item]["query"] as! String
        return cell
    }
    
    private func createPoductResultCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.Cell_CV_ProductHome.rawValue, for: indexPath) as? Cell_CV_ProductHome else {
            return UICollectionViewCell()
        }
        let item = indexPath.item
        if (item + 1) == products.count && currentPage < lastPage {
            currentPage += 1
            loadProductsFromServer(str: searchKeyword)
        }
        if currentPage >= lastPage {
            loadingView?.activityIndicator.stopAnimating()
        }
        cell.favouriteListener = self
        cell.controller = self
        cell.index = indexPath.item
        cell.indexPath = indexPath
        cell.setData(product: products[indexPath.item])
        return cell
    }
    
    private func createRestaurantResultCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.Cell_CV_RestaurantRow.rawValue, for: indexPath) as? Cell_CV_RestaurantRow else {
            return UICollectionViewCell()
        }
//        let item = indexPath.item
//        if (item + 1) == restaurants.count && currentPage <= lastPage {
//            currentPage += 1
//            loadRestaurantsFromServer(str: "")
//        }
//        if currentPage >= lastPage {
//            loadingView?.activityIndicator.stopAnimating()
//        }
        cell.serviceAnnouncement = self.serviceAnnouncement
        cell.favoriteDelegate = self
        cell.controller = self
        cell.indexPath = indexPath
        cell.favoriteDelegate = self
        cell.setData(restaurantBranch: restaurants[indexPath.item])
        return cell
    }
    
    
    func loadProductsFromServer(str:String){
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let param: [String:Any] = [:]
        
        
        let strCheck = str.trimmingCharacters(in: .whitespacesAndNewlines)
        let apiStr = "\(APIEndPoint.product.caseValue)?search=\(strCheck)&device_id=\(deviceId)&page=\(currentPage)&size=30"//&lat=\(lat)&lng=\(long)"
        
        print("api == " , apiStr)
    
        APIUtils.APICall(postName: "\(apiStr)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int
            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
            DispatchQueue.main.async {
                self.hideHud()
            }
            
            if status == 200 {
                APIUtils.prepareModalFromData(data, apiName: APIEndPoint.productSearchStore.caseValue, modelName:"SearchProducts", onSuccess: { [unowned self] (anyData) in
                    
                    if let searchProducts = anyData as? SearchProduct, let controller = self as? VC_Search {
                        self.products.append(contentsOf: searchProducts.data ?? [])
                        DispatchQueue.main.async {
                            self.loadingView?.activityIndicator.stopAnimating()
                            if controller.products.count > 0 {
                                controller.collectionView.reloadData()
                                controller.searchField.resignFirstResponder()
                                controller.isHintlist = false
                                controller.emptyView.isHidden = true
                            } else {
                                controller.isHintlist = true
                                controller.emptyView.isHidden = false
                            }
                        }
                    }
                    
                }) { (error, endPoint) in
                    self.hideHud()
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                self.hideHud()
                let message = data[key_message] as? String ?? serverError
                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
//            self.hideHud()
        }
        
    }
    
    func loadRestaurantsFromServer(str:String){
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let param : [String:Any] = [:]
        
        let strCheck = str.trimmingCharacters(in: .whitespacesAndNewlines)
        let apiStr = "\(APIEndPoint.restaurants.caseValue)?filter=\(str)&device_id=\(deviceId)&lat=\(lat)&lng=\(long)&page=\(currentPage)&size=40"
   
        APIUtils.APICall(postName: "\(apiStr)", method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
            let data = resp.value(forKey: "data") as! NSArray
            let status = resp.value(forKey: key_status) as? Int
//            self.lastPage = data.value(forKey: "last_page") as? Int ?? 1
            DispatchQueue.main.async {
                self.hideHud()
            }
            
            if status == 200 {
                
                APIUtils.prepareModalFromData(data, apiName: APIEndPoint.restaurants.caseValue, modelName:"SearchRestaurant", onSuccess: { [unowned self] (anyData) in
                    
                    if let restaturantBranches = anyData as? RestaurantBranch, let controller = self as? VC_Search {
                        
                        self.restaurants.append(restaturantBranches)
                        DispatchQueue.main.async {
                            self.loadingView?.activityIndicator.stopAnimating()
                            if controller.restaurants.count > 0 {
                                controller.isHintlist = false
                                controller.searchField.resignFirstResponder()
                                controller.collectionView.reloadData()
                                controller.emptyView.isHidden = true
                            } else {
                                controller.isHintlist = true
                                controller.emptyView.isHidden = false
                            }
                            
                            
                        }
                    } else {
                        self.emptyView.isHidden = false
                    }
                    
                }) { (error, endPoint) in
                    self.hideHud()
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
//                self.hideHud()
//                let message = data[key_message] as? String ?? serverError
//                self.presentAlert(title: errorText, message: message)
            }
            
        }) { (reason, statusCode) in
//            self.hideHud()
            self.emptyView.isHidden = false
        }
        
    }
    
    private func fetchSearchHistories() {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let param : [String:Any] = ["device_id": deviceId]
        searchHistories = []
        tagLabels.forEach { $0.removeFromSuperview() }
        tagLabels = []
        
        print("HEERER")
        leftSpacingForSearchHistories = 16
        topSpacingForSearchHistories = 0
        
        showHud(message: "")
        let type = selectedMenu == .products_query_suggestions ? "shop": "restaurant"
        let apiStr = "\(APIEndPoint.searchHistory.caseValue)?device_id=\(deviceId)&page=\(1)&size=5&type=\(type)"
        
        APIUtils.APICall(postName: apiStr, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
            let data = resp.value(forKey: "data") as! NSArray
            let status = resp.value(forKey: key_status) as? Int
            self.hideHud()
            self.searchHistories = []
            
            if status == 200 {
                
                APIUtils.prepareModalFromData(data, apiName: APIEndPoint.searchHistory.caseValue, modelName:"SearchHistory", onSuccess: { [unowned self] (anyData) in
                    
                    if let history = anyData as? SearchHistory {
                        self.searchHistories.append(history)
                    }
                    
                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
            }else{
                self.hideHud()
                //                let message = data[key_message] as? String ?? serverError
                //                self.presentAlert(title: errorText, message: message)
            }
            DispatchQueue.main.async {
                let isNotEmpty = self.searchHistories.count > 0
                if isNotEmpty {
                    self.setupSearchHistoriesTags()
                } else {
                    self.searchHistoriesView.isHidden = !isNotEmpty
                    self.collectionView.isHidden = !isNotEmpty
                }
                
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
    private func clearSearchHistories() {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let param : [String:Any] = ["device_id": deviceId]
        searchHistories = []
        tagLabels.forEach { $0.removeFromSuperview() }
        tagLabels = []
        
        leftSpacingForSearchHistories = 16
        topSpacingForSearchHistories = 0
        
        showHud(message: "")
        let type = selectedMenu == .products_query_suggestions ? "shop": "restaurant"
        let apiStr = "\(APIEndPoint.clearHistory.caseValue)?device_id=\(deviceId)&type=\(type)"
        self.hideHud()
        
        APIUtils.APICall(postName: apiStr, method: .post,  parameters: param, controller: self, onSuccess: { (response) in
            
            let resp = response as! NSDictionary
//            let data = resp.value(forKey: "data") as! NSArray
            let status = resp.value(forKey: key_status) as? Int
            
            DispatchQueue.main.async {
                self.fetchSearchHistories()
            }
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
        
    }
}





//extension HomeSearch_VC: StatsTextController {
//
//    func setItem(_ item: String?) {
//        title = item
//    }
//
//}



struct SearchHint: Codable {
  let name: String
}



extension VC_Search {
    
    private func setupSearchHistoriesTags() {
        searchHistories.forEach {
            layoutTag(with: $0.keyword!)
        }
    }
    
    private func layoutTag(with text: String) {
        let width = text.width(withConstrainedHeight: 22, font: .systemFont(ofSize: 16)) + 20
        
        guard checkIfEnoughWidth(width) else { return }
        
        let label = createLabel(text: text)
        let shadowView = createShadowView()
        setupConstraints(shadowView: shadowView, label: label, width: width)
        leftSpacingForSearchHistories = leftSpacingForSearchHistories + 10 + width
    }
    
    @objc private func searchTag(_ sender: UITapGestureRecognizer) {
//        isHintlist = true
        searchHistoriesView.isHidden = true
        searchField.text = (sender.view as? UILabel)?.text
        typingEnded()
    }
    private func createShadowView() -> UIView {
        let view = UIView()
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 3.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private func createLabel(text: String) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.numberOfLines = 1
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 3
        lbl.clipsToBounds = true
        lbl.isUserInteractionEnabled = true
        lbl.backgroundColor = .systemYellow
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    private func setupConstraints(shadowView: UIView, label: UILabel, width: CGFloat) {
        searchHistoriesContainerView.addSubview(shadowView)
        
        NSLayoutConstraint.activate([
            shadowView.widthAnchor.constraint(equalToConstant: width),
            shadowView.heightAnchor.constraint(equalToConstant: 28),
            shadowView.topAnchor.constraint(equalTo: searchHistoriesContainerView.topAnchor, constant: topSpacingForSearchHistories),
            shadowView.leftAnchor.constraint(equalTo: searchHistoriesContainerView.leftAnchor, constant: leftSpacingForSearchHistories)
        ])
        
        
        shadowView.addSubview(label)
        tagLabels.append(label)
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: shadowView.widthAnchor),
            label.heightAnchor.constraint(equalTo: shadowView.heightAnchor),
            label.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTag))
        label.addGestureRecognizer(tapGesture)
    }

    private func checkIfEnoughWidth(_ width: CGFloat) -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        let containerHeight = searchHistoriesContainerView.frame.size.height
        
        let leftMarginNeeded = leftSpacingForSearchHistories + width + 10
        let topMarginNeeded = topSpacingForSearchHistories + 28 + 12
        
        if screenWidth <= leftMarginNeeded {
//            if containerHeight <= topMarginNeeded {
//                return false
//            }
            topSpacingForSearchHistories = topMarginNeeded
//            heightConstraint.constant = topSpacing + 25 + 8
            
            leftSpacingForSearchHistories = 16
        }
        
        return true
    }
}


extension UILabel {
    func setBoldLetter(for keyword: String, in text: String) {
        let attributedText = NSMutableAttributedString(string: "", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: .regular)])
       
        for char in text {
            let isBold = keyword.contains(char)
            
            attributedText.append(NSAttributedString(string: "\(char)", attributes: [.font : UIFont.systemFont(ofSize: 18, weight: isBold ? .bold: .regular)]))
            if isBold {
                continue
            }
        }
        self.attributedText = attributedText
    }
}

extension VC_Search: FavoriteListener, Cell_CV_RestaurantRowDelegate {
    func isFavorited(index: Int?, productType: ProductType?, isFavourite: Bool) {
        guard let index = index else { return }
        products[index].is_favorite = isFavourite
    }
    
    func isFavorite(indexPath: IndexPath, isFavorite: Bool) {
        restaurants[indexPath.item].restaurant?.is_favorite = isFavorite
    }
    
    
    private func loadServiceAnnouncement() {
        APIUtils.APICall(postName: APIEndPoint.serviceAnnouncement.caseValue, method: .get, parameters: [String:Any](), controller: self, onSuccess: { (response) in
            
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Int ?? 0
            
            if status == 200 {
                if let home_popups = data.value(forKeyPath: "data") as? NSDictionary {
                    
                    APIUtils.prepareModalFromData(home_popups, apiName: APIEndPoint.serviceAnnouncement.caseValue, modelName: "ServiceAnnouncement", onSuccess: { (anyData) in
                        if let serviceAnnouncement = anyData as? ServiceAnnouncement {
                            self.serviceAnnouncement = serviceAnnouncement
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
            }
        }) { (reason, statusCode) in
            
        }
    }

    
}
