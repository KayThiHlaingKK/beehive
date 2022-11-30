//
//  VC_FoodCustomisation_Cell.swift
//  ST Ecommerce
//
//  Created by Necixy on 22/12/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class VC_FoodCustomisation_Variation_Cell: UITableViewCell {
    
    var controller: VC_FoodCustomisation?
    var rowIndex : Int = 0
    
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var lblVariationName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lexend.Medium, size: 16)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
   
    lazy var lblAmount: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.textAlignment = .right
        lbl.font = UIFont(name: AppConstants.Font.Lexend.Medium, size: 16)
        
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var lblBoxCharges: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lexend.Regular, size: 14)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var lblBoxChargesTwo: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.font = UIFont(name: AppConstants.Font.Lexend.Regular, size: 14)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
   
    
    lazy var lblBoxAmt: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.textAlignment = .right
        lbl.font = UIFont(name: AppConstants.Font.Lexend.Regular, size: 14)
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    let imgSelect: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        imageview.image = #imageLiteral(resourceName: "radio_button_un_selected")
        return imageview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()

        let tap = UITapGestureRecognizer(target: self, action: #selector(didChoose))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        print("setup ui")
        self.contentView.addSubview(view)
        view.addSubview(imgSelect)
        view.addSubview(lblVariationName)
        view.addSubview(lblAmount)
        view.addSubview(lblBoxCharges)
        view.addSubview(lblBoxAmt)
        view.addSubview(lblBoxChargesTwo)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.snp.makeConstraints { (make) in
            make.top.bottom.leftMargin.rightMargin.equalToSuperview()
            make.height.equalTo(400)
        }
        
        imgSelect.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        lblVariationName.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imgSelect.snp.trailing).offset(10)
            make.trailing.equalTo(lblAmount.snp.leading).offset(10)
        }
        
        lblAmount.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalTo(120)
            make.centerY.equalToSuperview()
        }
        
        lblBoxCharges.snp.makeConstraints { (make) in
            make.top.equalTo(lblVariationName).offset(20)
            make.leading.equalTo(imgSelect.snp.trailing).offset(10)
            make.trailing.equalTo(lblAmount.snp.leading).offset(10)
        }
        
        lblBoxChargesTwo.snp.makeConstraints { (make) in
            make.top.equalTo(lblBoxCharges).offset(20)
            make.leading.equalTo(imgSelect.snp.trailing).offset(10)
            make.trailing.equalTo(lblBoxAmt.snp.leading).offset(10)
        }
        
        lblBoxAmt.snp.makeConstraints { (make) in
            make.top.equalTo(lblAmount).offset(20)
            make.trailing.equalToSuperview().offset(-5)
            make.width.equalTo(120)
            make.centerY.equalTo(lblBoxCharges)
        }

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @objc private func didChoose() {        
        if controller?.menu?.menu_variants?[rowIndex].isSelected == false {
            let count = controller?.menu?.menu_variants?.count ?? 0
            for i in 0..<count {
                if i == rowIndex {
                    controller?.menu?.menu_variants?[i].isSelected = true
                }
                else {
                    controller?.menu?.menu_variants?[i].isSelected = false
                }
            }
            
            self.controller?.chooseVariat = controller?.menu?.menu_variants?[rowIndex]
           
            self.controller?.tableViewVariationCustomisation.reloadData()
        }
    }
    
}
