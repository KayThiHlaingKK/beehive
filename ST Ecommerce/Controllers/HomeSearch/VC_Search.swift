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

class VC_Search: UIViewController, HitsController {
    
    private var results = ["Cocacola", "French Fries", "Oreo", "Shark", "Kyay Oh"]
    let searcher = HitsSearcher(appID: "UPYQSA1ACD", apiKey: "f854c1a5a93a1f82e40d199ba2f05d8e", indexName: "products")
    var searchController: UISearchController!
    var textFieldController: TextFieldController!
    var searchConnector: SearchConnector<BestBuyItem>!
    let hitsViewController: BestBuyHitsViewController = .init()
    let hitsInteractor: HitsInteractor<BestBuyItem> = .init()
    let statsInteractor: StatsInteractor = .init()
    var hitsSource: HitsInteractor<BestBuyItem>?
    var keyword = ""
    
    var queryInputConnector: QueryInputConnector!
    
    private let searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextField()
        setupCollectionView()
        setupInstantSearchUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchField.text = keyword
        searchField.endEditing(true)
        textFieldSubmitted()
    }
   
    private func setupInstantSearchUI() {
        searchController = .init(searchResultsController: hitsViewController)
        textFieldController = TextFieldController(textField: searchField)
        
        queryInputConnector = QueryInputConnector(searcher: searcher, controller: textFieldController)
        queryInputConnector = .init(searcher: searcher, controller: textFieldController)
        searchField.delegate = self
        hitsInteractor.connectSearcher(searcher)
        hitsInteractor.connectController(self)
        statsInteractor.connectController(self)
        searchField.addTarget(self, action: #selector(textFieldSubmitted), for: .editingDidEndOnExit)
//        searchField.addTarget(self, action: #selector(textFieldSubmitted), for: .editingChanged)
        searcher.search()
    }
    
    @objc func textFieldSubmitted() {
        searcher.search()
        collectionView.reloadData()
    }
    
}

extension VC_Search: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        textFieldSubmitted()
//        return true
//    }
}


extension VC_Search: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hitsInteractor.numberOfHits()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SearchResultCell
        if let bestBuy = hitsInteractor.hit(atIndex: indexPath.row) {
            cell.label.text = bestBuy.name
        }
        return cell
    }
}










extension VC_Search {
    
    private func setupTextField() {
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 50),
            searchField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
    
    private func setupCollectionView() {
        setupCollectionViewConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: "cellId")
    }
    
    private func setupCollectionViewConstraints() {
        navigationController?.navigationBar.backgroundColor = .white
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 44)
    }
}





class SearchResultCell: UICollectionViewCell {
    let searchIcon: UIImageView = {
        let iv = UIImageView()
        let img = UIImage(named: "magnifying-glass")
        iv.image = img
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemBlue
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(searchIcon)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            searchIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            searchIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            searchIcon.widthAnchor.constraint(equalToConstant: 15),
            searchIcon.heightAnchor.constraint(equalToConstant: 15),
            
            label.leftAnchor.constraint(equalTo: searchIcon.rightAnchor, constant: 8),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            label.heightAnchor.constraint(equalTo: heightAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





extension HomeSearch_VC: StatsTextController {
    
    func setItem(_ item: String?) {
        title = item
    }
    
}


