//
//  Cell_TV_Restaurant.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 15/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

protocol Cell_TV_RestaurantDelegate: class {
    func viewAllButtonPressed(indexPath: IndexPath)
}

class Cell_TV_Restaurant: UITableViewCell {
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewAllLabel: UILabel!
    var showViewAllButton = false
    var indexPath: IndexPath!
    
    // MARK: - Properties
    
    weak var controller: UIViewController!
    private let cellId = "Cell_CV_Restaurant"
    private var restaurantBranches = [RestaurantBranch]()
    var serviceAnnouncement: ServiceAnnouncement?
    
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewAllButtonPressed))
        viewAllLabel.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showViewAllButton = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
    }
    
    
    
    // MARK: - Setup Functions
    
    func setData(restaurantBranches: [RestaurantBranch]) {
        self.restaurantBranches = restaurantBranches
        setupCollectionView()
        collectionView.reloadData()
        viewAllLabel.isEnabled = showViewAllButton
        viewAllLabel.isHidden = !showViewAllButton
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        
    }
    
    @objc private func viewAllButtonPressed() {
        if let delegate = controller as? Cell_TV_RestaurantDelegate {
            delegate.viewAllButtonPressed(indexPath: indexPath)
        }
    }
    
}





extension Cell_TV_Restaurant: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? Cell_CV_Restaurant else {
            return UICollectionViewCell() }
        cell.serviceAnnouncement = serviceAnnouncement
        cell.setupData(restaurantBranch: restaurantBranches[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let restroID = self.restaurantBranches[indexPath.row].slug {
            let vc : RestaurantDetailViewController = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
            vc.slug = restroID
            vc.restaurantSlug = self.restaurantBranches[indexPath.row].restaurant?.slug ?? ""
            self.controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        restaurantBranches.count
    }


    
}
