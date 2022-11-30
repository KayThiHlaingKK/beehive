//
//  Cell_Foods_Details.swift
//  ST Ecommerce
//
//  Created by necixy on 01/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos


protocol ChangeView {
    func callCustomisation(item: Available_menus)
}
class Cell_Restaurant_Details: UITableViewCell {
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = UIColor().HexToColor(hexString: "#F7F7F7")
        return view
    }()
    
    let imgSelect: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        imageview.image = #imageLiteral(resourceName: "radio_button_un_selected")
        return imageview
    }()
    
    lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lato.Regular, size: 15)
        
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var lblDes: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lato.Regular, size: 13)
        
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var lblPrice: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lato.Regular, size: 13)
        
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var lblActualAmount: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lato.Regular, size: 13)
        
        lbl.sizeToFit()
        return lbl
    }()
    
    let priceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var minusBtn: UIButton = {
        let button = UIButton()
        let origImage = UIImage(named: "minus")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.appDarkYelloColor()
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        //button.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        return button
    }()
    
    lazy var plusBtn: UIButton = {
        let button = UIButton()
        //button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        let origImage = UIImage(named: "plus")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.appDarkYelloColor()
        button.layer.cornerRadius = 4
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        //button.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
        return button
    }()
    
    lazy var lblQty: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.lightGray
        lbl.text = "0"
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lato.Regular, size: 15)
        
        lbl.sizeToFit()
        return lbl
    }()
    
    //MARK: - IBOutlets
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetails: UILabel!
    @IBOutlet weak var labelIsCustomizable: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelActualAmount: UILabel!
    @IBOutlet weak var labelItemNotAvailable: UILabel!
    @IBOutlet weak var imageViewItem: UIImageView!
    @IBOutlet weak var viewItem: UIView!
    @IBOutlet weak var imageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewForAddingItems: GradientView!
    //MARK: - Variables
    var controller: RestaurantDetailViewController!
    
//    var addToCartListener : AddToCartListener?
    var changeView: ChangeView?
    
    var index = 0
    var first = true
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    private func setupUI() {
//        print("setup ui")
//        self.contentView.addSubview(view)
//        view.addSubview(imgSelect)
//        view.addSubview(lblName)
//        view.addSubview(lblDes)
//        view.addSubview(lblPrice)
//        view.addSubview(lblActualAmount)
//        view.addSubview(priceView)
//
//        priceView.addSubview(minusBtn)
//        priceView.addSubview(plusBtn)
//        priceView.addSubview(lblQty)
//        
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        view.snp.makeConstraints { (make) in
//            make.top.bottom.leftMargin.rightMargin.equalToSuperview()
//            make.height.equalTo(160)
//        }
//        imgSelect.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(8)
//            make.height.equalTo(100)
//            make.width.equalTo(100)
//            make.top.equalTo(5)
//        }
//        
//        lblName.snp.makeConstraints { (make) in
//            make.leading.equalTo(imgSelect.snp.trailing).offset(10)
//            make.trailing.equalTo(priceView.snp.leading).offset(5)
//            make.top.equalToSuperview().offset(5)
//        }
//        
//        lblDes.snp.makeConstraints { (make) in
//            make.leading.equalTo(imgSelect.snp.trailing).offset(10)
//            make.trailing.equalTo(priceView.snp.leading).offset(5)
//            make.top.equalTo(lblName.snp.bottom).offset(5)
//        }
//        
//        lblPrice.snp.makeConstraints { (make) in
//            make.leading.equalTo(imgSelect.snp.trailing).offset(10)
//            make.top.equalTo(lblDes.snp.bottom).offset(5)
//        }
//        
//        lblActualAmount.snp.makeConstraints { (make) in
//            make.leading.equalTo(lblPrice.snp.trailing).offset(10)
//            make.trailing.equalTo(priceView.snp.leading).offset(5)
//            make.top.equalTo(lblPrice.snp.top)
//        }
//        
//        priceView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(10)
//            make.trailing.equalToSuperview().offset(10)
//            make.height.equalTo(30)
//            make.width.equalTo(100)
//        }
//
//        minusBtn.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview()
//            make.top.bottom.equalToSuperview()
//            make.width.equalTo(35)
//        }
//
//        plusBtn.snp.makeConstraints { (make) in
//            make.trailing.equalToSuperview()
//            make.top.bottom.equalToSuperview()
//            make.width.equalTo(35)
//        }
//
//        lblQty.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewItem.layer.cornerRadius = 5
        viewItem.layer.borderWidth = 1
        viewItem.layer.borderColor = UIColor().HexToColor(hexString: "F3F3F3").cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Helper Functions
    func setData(item:Available_menus){
        
        if let images = item.images,
            images.count > 0 {
            imageConstraint.constant = 70
            imageViewItem.isHidden = false
            
            //let imagePathItem = "\(images.first?.url ?? "")?size=xsmall"
            //imageViewItem.downloadImage(url: imagePathItem)
            let imagePathItem = "\(images.first?.url ?? "")"
            let imageFileName = "\(images.first?.file_name ?? "")"
            imageViewItem.setIndicatorStyle(.gray)
            imageViewItem.setShowActivityIndicator(true)
            imageViewItem.downloadImage(url: imagePathItem, fileName: imageFileName, size: .small)
        }
        else {
            imageConstraint.constant = 0
            imageViewItem.isHidden = true
        }
        
        labelName.text = item.name ?? ""
        let des = item.description ?? ""
        labelDetails.text = des.trunc(length: 38)
//        labelQty.text = "0"
        
        if let price_ = item.price {
            labelPrice.text = "\(self.controller.priceFormat(pricedouble: price_))\(currencySymbol)"
        }
        
        labelActualAmount.isHidden = true
        
        if (item.discount != 0) {
            let discount = item.discount ?? 0
            let orgPrice = item.price ?? 0
            let actualPrice = orgPrice - discount
            
            labelActualAmount.isHidden = false
            //let originalPrice_ = actualPrice.replacingOccurrences(of: ".00", with: "")
            if let price_ = item.price {
                let attributedString = NSAttributedString(string: "\(self.controller.priceFormat(pricedouble: price_))\(currencySymbol)").withStrikeThrough()
                labelActualAmount.attributedText = attributedString
            }
            
            labelPrice.text = "\(self.controller.priceFormat(pricedouble: actualPrice))\(currencySymbol)"
        }
        

    }
    
    
}
