//
//  Cell_TV_Announcement.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 06/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class Cell_TV_Announcement: UITableViewCell {
    
    // MARK: - IBOutlets
    
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    // MARK: - Properties
    var controller: UIViewController!
    private let cellId = "Cell_CV_Announcement"
    private var announcements = [Announcement]()
    
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setData(announcments: [Announcement]) {
        self.announcements = announcments
        print(announcments)
        setupCollectionView()
        collectionView.reloadData()
    }
    
    func setupCollectionView() {
        backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    
}


extension Cell_TV_Announcement: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? Cell_CV_Announcement else {
            return UICollectionViewCell()
        }
        cell.setupData(announcement: announcements[indexPath.item])
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return announcements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = announcementDetailStoryboard.instantiateViewController(withIdentifier: "VC_Announcement") as! VC_Announcement
        vc.controller = self.controller
        let selectedAnnouncement = self.announcements[indexPath.item]
        let otherAnnouncements = self.announcements.filter { $0.value != selectedAnnouncement.value }
        vc.setData(announcment: self.announcements[indexPath.item], otherAnnouncements: otherAnnouncements)
        
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
}
