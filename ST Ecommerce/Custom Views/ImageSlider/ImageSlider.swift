//
//  ImageSlider.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 13/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

class ImageSlider: UIView {
    
    private var superView: UIView!
    var imageNames = [String]()
    private let cellId = "cellId"
    var popupView: PopupView!
    var popupBox: PopupBox!
   
    let imageSlider: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.layer.cornerRadius = 5
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.isUserInteractionEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
   
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.hidesForSinglePage = true
        pc.backgroundColor = .clear
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    
    init(superView: UIView) {
        self.superView = superView
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupCollectionView()
    }
    
    func setupData(imageNames: [String]) {
        self.imageNames = imageNames
        self.pageControl.numberOfPages = imageNames.count
        self.imageSlider.reloadData()
    }
    
    private func setupCollectionView() {
        imageSlider.delegate = self
        imageSlider.dataSource = self
        imageSlider.decelerationRate = .fast
        imageSlider.register(SliderCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(imageSlider)
        NSLayoutConstraint.activate([
            imageSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageSlider.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageSlider.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            imageSlider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26)
        ])
        
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.leftAnchor.constraint(equalTo: leftAnchor),
            pageControl.rightAnchor.constraint(equalTo: rightAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    func scrollAutomatically() {
        for cell in imageSlider.visibleCells {
            let indexPath: IndexPath? = imageSlider.indexPath(for: cell)
            if ((indexPath?.row)! < self.imageNames.count - 1){
                let indexPath1: IndexPath?
                indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                
                imageSlider.scrollToItem(at: indexPath1!, at: .right, animated: true)
            }
            else{
                let indexPath1: IndexPath?
                indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                imageSlider.scrollToItem(at: indexPath1!, at: .left, animated: true)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension ImageSlider: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
        self.popupBox.changeData(currentIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageSlider.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SliderCell else { return UICollectionViewCell() }
        if imageNames[indexPath.item] == "placeholder2" {
            cell.imageView.image = UIImage(named: "placeholder2")
        } else {
            cell.imageView.downloadImage(fileName: imageNames[indexPath.item], size: .medium)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.size.width - 32
        return CGSize(width: width, height: width)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        popupView.stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        animateCurrentPage(scrollView: scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        animateCurrentPage(scrollView: scrollView)
    }
    
    private func animateCurrentPage(scrollView: UIScrollView) {
        let cellWidth = frame.width - 32
        let x = scrollView.contentOffset.x
        var currentIndex = Int((x / cellWidth) + 0.5)
        currentIndex = min(currentIndex, imageNames.count - 1)
        popupView.currentIndex = currentIndex
        pageControl.currentPage = currentIndex
        imageSlider.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        popupView.startTimer()
        popupBox.changeData(currentIndex: currentIndex)
    }
}
