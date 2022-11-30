//
//  PopupView.swift
//  ST Ecommerce
//
//  Created by Min Thet Maung on 12/10/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import Down

class PopupView: UIView {
    
    private var popupBox: PopupBox!
    var popupsData = [PopupModel]()
    weak var superVC: UIViewController!
    var currentIndex = 0
    private var timer: Timer?
    
    private var blurView: UIView = {
        let bv = UIView()
        bv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        bv.alpha = 0.0
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    
    final func constraintTo(superView view: UIView, popupsData: [PopupModel]) {
        guard !popupsData.isEmpty else { return }
        self.popupsData = popupsData
        setupBlurView(view)
        createPopupBox(view: view)
        
        showPopup()
        
        startTimer()
    }
    
    private func setupBlurView(_ view: UIView) {
        view.addSubview(blurView)
        blurView.frame = view.frame
        blurView.center = view.center
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hidePopup))
        blurView.addGestureRecognizer(gesture)
    }
    
    private func createPopupBox(view: UIView) {
        popupBox = nil
        popupBox = PopupBox(backgroundView: view)
        popupBox.closeButton.addTarget(self, action: #selector(self.hidePopup), for: .touchUpInside)
        popupBox.buyNowButton.addTarget(self, action: #selector(buyNowButtonPressed), for: .touchUpInside)
        popupBox.imageSlider.popupView = self
        popupBox.setupData(data: popupsData)
    }
    
    @objc private func buyNowButtonPressed() {
        let currentData = popupsData[currentIndex]
        
        switch currentData.targetType {
        case .product: goToProductDetail(item: currentData)
        case .shop: goToShopDetail(item: currentData)
        case .restaurantBranch: goToRestaurantBranch(item: currentData)
        case .brand: goToBrandDetail(item: currentData)
        default: break
        }
    }
    
    
    func startTimer() {
        stopTimer()
        timer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(changeData), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    @objc func changeData() {
        if currentIndex < popupsData.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
        popupBox.changeData()
    }
    
    final func showPopup() {
        popupBox.showDialogue()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.blurView.alpha = 1.0
        })
    }
    
    
    @objc final func hidePopup() {
        popupBox.fadeOut()
        stopTimer()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [unowned self] in
            self.blurView.alpha = 0.0
        }) { [unowned self] (success) in
            self.popupBox = nil
            self.popupsData = []
            self.blurView.removeFromSuperview()
            superVC = nil
        }
    }
    
    
}


// MARK: - Navigation Functions

extension PopupView {
    
    private func goToProductDetail(item: PopupModel) {
        guard let value = item.value else { return }
        let vc = storyboardProductDetails.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
        vc.slug = value
        self.superVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func goToShopDetail(item: PopupModel) {
        guard let vc = storyboardStore.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        var shop = Shop()
        shop.slug = item.value
        vc.shopSlug = item.value
        vc.shop = shop
        self.superVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToRestaurantBranch(item: PopupModel) {
        guard let value = item.value else { return }
        let vc = storyboardRestaurantDetails.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.slug = value
        self.superVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToBrandDetail(item: PopupModel) {
        guard let slug = item.value else { return }
        let vc = storyboardBrandDetail.instantiateViewController(withIdentifier: "VC_BrandDetail") as! VC_BrandDetail
        vc.brandId = slug
        self.superVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension PopupBox {
    
    func showDialogue() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            dialogueBox.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            dialogueBox.alpha = 1.0
        })
    }
    
    func closeDialogue() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            dialogueBox.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            dialogueBox.alpha = 0.0
        }) { (success) in
            dialogueBox.transform = .identity
            dialogueBox.alpha = 1.0
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            dialogueBox.alpha = 0.0
        }) {(success) in
            dialogueBox.removeFromSuperview()
        }
    }
    
}

struct PopupBox {
    
    private var backgroundView: UIView!
    private var centerYAnchor: NSLayoutConstraint!
    private var imageWidth: CGFloat = 0
    private var popupsData = [PopupModel]()
    private var titleHeightAnchor: NSLayoutConstraint!

    private let dialogueBox: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        v.backgroundColor = .white
        v.alpha = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let popupImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray
        iv.layer.cornerRadius = 5
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let imageSlider: ImageSlider!
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.backgroundColor = .clear
        lbl.font = .preferredFont(forTextStyle: .title3)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let subTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.backgroundColor = .clear
        lbl.font = .preferredFont(forTextStyle: .body)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    let buyNowButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Buy Now", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 4
        btn.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let closeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        let img = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private func setupDialogueRectangleView() {
        let dialogueBoxWidth = backgroundView.frame.size.width * 0.8
        let popupHeight: CGFloat = dialogueBoxWidth + 10 + 8 + 40 + 8 + 40 + 16 + 44 + 16
        
        backgroundView.addSubview(dialogueBox)
        
        NSLayoutConstraint.activate([
            dialogueBox.widthAnchor.constraint(equalToConstant: dialogueBoxWidth),
            dialogueBox.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dialogueBox.heightAnchor.constraint(equalToConstant: popupHeight),
           centerYAnchor
        ])
    }
    
    private func setupImageSlider() {
        let dialogueBoxHeight = backgroundView.frame.size.width * 0.8
        
        dialogueBox.addSubview(imageSlider)
        NSLayoutConstraint.activate([
            imageSlider.heightAnchor.constraint(equalToConstant: dialogueBoxHeight + 10),
            imageSlider.centerXAnchor.constraint(equalTo: dialogueBox.centerXAnchor),
            imageSlider.widthAnchor.constraint(equalTo: dialogueBox.widthAnchor),
            imageSlider.topAnchor.constraint(equalTo: dialogueBox.topAnchor),
        ])
    }
    
    
    mutating private func setupTitleLabel() {
        dialogueBox.addSubview(titleLabel)
        self.titleHeightAnchor = titleLabel.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageSlider.bottomAnchor, constant: 8),
            titleLabel.widthAnchor.constraint(equalTo: dialogueBox.widthAnchor, constant: -16),
            titleHeightAnchor,
            titleLabel.centerXAnchor.constraint(equalTo: dialogueBox.centerXAnchor)
        ])
    }
    
    private func setupSubTitleLabel() {
        dialogueBox.addSubview(subTitleLabel)
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subTitleLabel.widthAnchor.constraint(equalTo: dialogueBox.widthAnchor, constant: -16),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 40),
            subTitleLabel.centerXAnchor.constraint(equalTo: dialogueBox.centerXAnchor)
        ])
    }
    
    
    
    private func setupBuyNowButton() {
        dialogueBox.addSubview(buyNowButton)
        
        NSLayoutConstraint.activate([
            buyNowButton.heightAnchor.constraint(equalToConstant: 44),
            buyNowButton.widthAnchor.constraint(equalTo: dialogueBox.widthAnchor, multiplier: 0.5),
            buyNowButton.centerXAnchor.constraint(equalTo: dialogueBox.centerXAnchor, constant: 0),
//            buyNowButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
            buyNowButton.bottomAnchor.constraint(equalTo: dialogueBox.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupCloseButton() {
        dialogueBox.addSubview(closeButton)
            
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 25),
            closeButton.widthAnchor.constraint(equalToConstant: 25),
            closeButton.trailingAnchor.constraint(equalTo: dialogueBox.trailingAnchor, constant: -32),
            closeButton.topAnchor.constraint(equalTo: dialogueBox.topAnchor, constant: 32),
        ])
    }
    
    mutating private func setupDialogueBox() {
        setupDialogueRectangleView()
        setupImageSlider()
        setupTitleLabel()
        setupSubTitleLabel()
        setupBuyNowButton()
        setupCloseButton()
        
        dialogueBox.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    init(backgroundView: UIView) {
        self.backgroundView = backgroundView
        self.imageSlider = ImageSlider(superView: backgroundView)
        centerYAnchor =  dialogueBox.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        
        setupDialogueBox()
    }
    
    mutating func setupData(data: [PopupModel]) {
        guard let _ = data.first else { return }
        self.popupsData = data
        self.imageSlider.popupBox = self
        
        changeData(currentIndex: 0)
        var imageNames = [String]()
        
        data.filter { $0.images?.isEmpty == false }.compactMap { $0.images?.first?.fileName }
        data.forEach {
            let fileName = $0.images?.first?.fileName ?? "placeholder2"
            imageNames.append(fileName)
        }
        
//        data.compactMap {
//            $0.images?[0].fileName }.filter { $0 != nil }
        imageSlider.setupData(imageNames: imageNames)
        
    }
    
    func changeData() {
        self.imageSlider.scrollAutomatically()
    }
    
    func changeData(currentIndex: Int) {
        let currentData = self.popupsData[currentIndex]
        self.titleLabel.text = currentData.label ?? ""
        self.subTitleLabel.text = "" // currentData.note ?? ""
        self.subTitleLabel.isHidden = true
        calculateTitleLabelHeight()
        guard let targetType = currentData.targetType else { return }
        
        if targetType == .product || targetType == .restaurantBranch || targetType == .shop || targetType == .brand {
            buyNowButton.isHidden = false
        } else {
            buyNowButton.isHidden = true
        }
    }
    
    private func calculateTitleLabelHeight() {
        
        guard self.subTitleLabel.text == "" else { return }
        self.subTitleLabel.sendSubviewToBack(titleLabel)
        
        titleLabel.numberOfLines = 3
        self.titleHeightAnchor.constant = 96
    }
}
