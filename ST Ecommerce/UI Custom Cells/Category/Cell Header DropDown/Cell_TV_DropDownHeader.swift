//
//  Cell_TV_DropDownHeader.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 23/12/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit

protocol DropDownCellDelegate: class {
    func toggleDropDown(indexPath: IndexPath, isShowing: Bool)
    func goToProductList(indexPath: IndexPath)
    func select(shopSubcategory: ShopSubCategory, indexPath: IndexPath)
}

class Cell_TV_DropDownHeader: UITableViewCell {

    
    // MARK: - Outlets
    
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownArrow: UIImageView!
    @IBOutlet weak var subcategoryContainer: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropDownButton: UIButton!
    
    
    
    // MARK: - Data
    
    private var subcategoryViews = [UIView]()
    private var subcategory: CategorizedProduct!
    private var shopSubcategories = [ShopSubCategory]()
    
    
    // MARK: - States
    
    var isShowing = false
    var indexPath: IndexPath?
    private var topSpacing: CGFloat = 16
    private var leftSpacing: CGFloat = 10
    weak var delegate: DropDownCellDelegate?
    
    
    
    // MARK: - LifeCycle Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    // MARK: - IBActions
    
    @IBAction func dropDownButtonPressed(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        removeSubcategoryViews()
        
        if shopSubcategories.count > 0 {
            delegate?.toggleDropDown(indexPath: indexPath, isShowing: self.isShowing)
        } else {
            delegate?.goToProductList(indexPath: indexPath)
        }
        
    }
    
    
    
    // MARK: - DropDown Functions
    
    func showDropDown(shouldDrop: Bool) {
        shopSubcategories = self.subcategory.shop_sub_categories ?? []
        dropDownView.isHidden = shopSubcategories.count < 1
//        dropDownButton.isEnabled = !(shopSubcategories.count < 1)
        
        animateDropDownArrow(shouldDrop: shouldDrop)
    }
    
    private func animateDropDownArrow(shouldDrop: Bool) {
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            let angle = !shouldDrop ? CGFloat.pi : 0
            self.dropDownArrow.transform = CGAffineTransform(rotationAngle: angle)
        }, completion: { [unowned self] complete in
            if shouldDrop {
                self.setupSubcategories()
            }
        })
        self.isShowing = shouldDrop
    }
    
    func setData(subcategory: CategorizedProduct) {
        self.subcategory = subcategory
        subcategoryLabel.text = subcategory.name
        shopSubcategories = self.subcategory.shop_sub_categories ?? []
        removeSubcategoryViews()
    }
}


extension Cell_TV_DropDownHeader {
    
    
    private func setupSubcategories() { 
        leftSpacing = 10
        topSpacing = 16
        
        for (index, item) in shopSubcategories.enumerated() {
            layoutSubcategory(index: index)
        }
    }
    
    private func layoutSubcategory(index: Int) {
        let noColumns = 3
        let totalPadding = CGFloat((noColumns * 10) + 10)
        let itemWidth: CGFloat = (frame.size.width - totalPadding) / CGFloat(noColumns)
        let itemHeight: CGFloat = itemWidth + 30
        
        calculateSpacing(itemWidth, height: itemHeight)
        
        setupContainer(index: index, width: itemWidth, height: itemHeight)
        leftSpacing = leftSpacing + 10 + itemWidth
    }
    
    private func createSubcategoryImageView() -> UIImageView {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }
    
    private func createSubcategoryLabel() -> UILabel {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textColor = .black
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
    
    private func createContainerView() -> UIView {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }
    
    private func setupTapGesture(_ containerView: UIView, _ index: Int) {
        containerView.tag = index
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSubcategory(sender:)))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    private func setupContainer(index: Int, width: CGFloat, height: CGFloat) {
        let shopSubcategory = shopSubcategories[index]
        let containerView = createContainerView()
        setupTapGesture(containerView, index)
        
        let subcategoryImage = createSubcategoryImageView()
        if let images = shopSubcategory.images,
           let firstImage = images.first {
            let url = "\(firstImage.url ?? "")?size=xsmall"
            subcategoryImage.downloadImage(url: url, fileName: firstImage.fileName, size: .small)
        }
        else {
            subcategoryImage.downloadImage()
        }

        let subcategoryNameLabel = createSubcategoryLabel()
        subcategoryNameLabel.text = shopSubcategory.name

        containerView.addSubview(subcategoryImage)
        NSLayoutConstraint.activate([
            subcategoryImage.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            subcategoryImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subcategoryImage.heightAnchor.constraint(equalTo: subcategoryImage.widthAnchor),
            subcategoryImage.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])

        containerView.addSubview(subcategoryNameLabel)
        NSLayoutConstraint.activate([
            subcategoryNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            subcategoryNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subcategoryNameLabel.heightAnchor.constraint(equalToConstant: 30),
            subcategoryNameLabel.topAnchor.constraint(equalTo: subcategoryImage.bottomAnchor)
        ])
        
        subcategoryContainer.addSubview(containerView)
        subcategoryViews.append(containerView)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: width),
            containerView.heightAnchor.constraint(equalToConstant: height),
            containerView.topAnchor.constraint(equalTo: subcategoryContainer.topAnchor, constant: topSpacing),
            containerView.leftAnchor.constraint(equalTo: subcategoryContainer.leftAnchor, constant: leftSpacing)
        ])
    }
    
    private func removeSubcategoryViews() {
        subcategoryViews.forEach { $0.removeFromSuperview() }
        subcategoryViews.removeAll()
    }
    
    private func calculateSpacing(_ width: CGFloat, height: CGFloat) {
        let screenWidth = frame.size.width
        let leftMarginNeeded = leftSpacing + width
        
        if screenWidth <= leftMarginNeeded {
            topSpacing = topSpacing + height + 16
            leftSpacing = 10
        }
    }
    
    @objc private func tapSubcategory(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        let indexPath = IndexPath(row: tag, section: 0)
        let shopSubcategory = shopSubcategories[tag]
        delegate?.select(shopSubcategory: shopSubcategory, indexPath: indexPath)
    }
}
