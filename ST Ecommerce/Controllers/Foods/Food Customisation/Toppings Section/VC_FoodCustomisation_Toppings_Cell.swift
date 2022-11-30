//
//  VC_FoodCustomisation_Toppings_Cell.swift
//  ST Ecommerce
//
//  Created by Necixy on 28/12/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Foundation
import MaterialComponents
import SnapKit

class VC_FoodCustomisation_Toppings_Cell: UITableViewCell {
    
    var controller: VC_FoodCustomisation?
    
    var slug : String = ""
    var topping: MenuTopping!
    var option: VariantOption!
    
    var sectionIndex: Int = 0
    var rowIndex: Int = 0
    
    var qty: Int = 0
    
    var shouldHideIncrementView: Bool = false {
        didSet {
            [minusBtn, lblCount, plusBtn].forEach { $0.isHidden = shouldHideIncrementView }
        }
    }
    
    lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var imgSelect: UIImageView = {
        let imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .scaleAspectFit
        imageview.image = #imageLiteral(resourceName: "blank-check-box")
        return imageview
    }()
    
    lazy var lblToppingName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.text = "topping name"
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
        lbl.text = "amount"
        lbl.font = UIFont(name: AppConstants.Font.Lexend.Medium, size: 16)
        lbl.textAlignment = .right
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var priceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var increaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var minusBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minus_black"), for: .normal)
        button.addTarget(self, action: #selector(minus), for: .touchUpInside)
        return button
    }()
    
    lazy var lblCount: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            lbl.textColor = UIColor.label
        } else {
            lbl.textColor = UIColor.darkText
        }
        lbl.text = "1"
        lbl.font = UIFont(name: AppConstants.Font.Lexend.Medium, size: 15)
        lbl.textAlignment = .center
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var plusBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_black"), for: .normal)
        button.addTarget(self, action: #selector(plus), for: .touchUpInside)
        return button
    }()
    
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()

        [lblToppingName, imgSelect].forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didChoose))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tap)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        print("setup ui")
        self.contentView.addSubview(view)
        view.addSubview(imgSelect)
        view.addSubview(lblToppingName)
        view.addSubview(lblAmount)
        view.addSubview(priceView)
        view.addSubview(increaseView)
        increaseView.addSubview(minusBtn)
        increaseView.addSubview(lblCount)
        increaseView.addSubview(plusBtn)
        
        
    }
    
    @objc func plus() {
        if sectionIndex == 0 {
            
            let chooseToppings = controller?.chooseTopping
            let menuToppings = controller?.menu?.menu_toppings
            let count = chooseToppings?.count ?? 0
            
            for i in 0..<count where count > 0 {
                if controller?.chooseTopping?[i] == menuToppings?[rowIndex] {
                    if menuToppings?[rowIndex].max_quantity ?? 1 > chooseToppings?[i].quantity ?? 1 {
                        controller?.chooseTopping?[i].quantity += 1
                        lblCount.text = controller?.chooseTopping?[i].quantity.description
                    } else {
                        if let maxQuantity = menuToppings?[rowIndex].max_quantity {
                            controller?.showToast(message: "At most \(maxQuantity) items", font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))
                        }
                        
                    }
                }
            }
        }
        
    }
    
    @objc func minus() {
        let count = controller?.chooseTopping?.count ?? 0
        
        for i in 0..<count where count > 0 {
            if controller?.chooseTopping?[i] == controller?.menu?.menu_toppings?[rowIndex] {
                if controller?.chooseTopping?[i].quantity ?? 1 > 1 {
                    controller?.chooseTopping?[i].quantity -= 1
                    lblCount.text = controller?.chooseTopping?[i].quantity.description
                }
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        view.snp.makeConstraints { (make) in
            make.top.bottom.leftMargin.rightMargin.equalToSuperview()
            make.height.equalTo(186)
        }
        
        imgSelect.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        
        lblToppingName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(imgSelect.snp.trailing).offset(10)
            make.trailing.equalTo(lblAmount.snp.leading).offset(5)
        }
        
        lblAmount.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
            make.width.equalTo(90)
        }
        
        increaseView.snp.makeConstraints { (make) in
            make.leading.equalTo(lblToppingName.snp.leading)
            make.top.equalTo(lblToppingName.snp.bottom)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        minusBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        lblCount.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        plusBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc private func didChoose() {
        if sectionIndex == 0 && controller?.topping?.count ?? 0 > 0 {
            chooseTopping()
        } else {
            chooseOption()
        }
        
    }
    
    private func chooseTopping() {
        if controller?.menu?.menu_toppings?[rowIndex].isSelected == false {
            if ((controller?.menu?.menu_toppings?[rowIndex].is_incremental) != nil) {
                controller?.willHide[rowIndex] = false
            }
            controller?.menu?.menu_toppings?[rowIndex].isSelected = true
          
            self.controller?.chooseTopping?.append(controller?.menu?.menu_toppings?[rowIndex] ?? MenuTopping())
            let count = self.controller?.chooseTopping?.count ?? 0
            self.controller?.chooseTopping?[count - 1].quantity = 1
        }
        else {
            controller?.willHide[rowIndex] = true
            controller?.menu?.menu_toppings?[rowIndex].isSelected = false
            
            controller?.chooseTopping = controller?.chooseTopping?.filter {
                $0.slug != controller?.menu?.menu_toppings?[rowIndex].slug
            }
        }
        self.controller?.tableViewToppingsCustomisation.reloadData()
    }
    
    private func chooseOption() {
        
        guard let controller = controller
        else { return }
        
        var room = 0
        if controller.topping?.count ?? 0 > 0 {
            room = sectionIndex - 1
        }
        else {
            room = sectionIndex
        }
        guard let option = controller.menu?.menu_options?[room].options?[rowIndex]
        else { return }
        
        if option.selected == true {
            controller.menu?.menu_options?[room].options?[rowIndex].selected = false
            controller.chooseOptions = controller.chooseOptions.filter {
                $0.slug != controller.menu?.menu_options?[room].options?[rowIndex].slug
            }
        } else if (option.selected == false || option.selected == nil) && isLessThanMaxChoice() {
            controller.menu?.menu_options?[room].options?[rowIndex].selected = true
            controller.chooseOptions.append(option)
        }
        
        controller.tableViewToppingsCustomisation.reloadData()
        
    }
    
    private func isLessThanMaxChoice() -> Bool {
        var room = 0
        if controller?.topping?.count ?? 0 > 0 {
            room = sectionIndex - 1
        }
        else {
            room = sectionIndex
        }
        guard let menuOptions = controller?.menu?.menu_options?[room],
              let chooseOptions = controller?.chooseOptions,
              let maxChoice = menuOptions.max_choice
        else { return true }
        var choicesOfCurrentMenu = [VariantOption]()
        chooseOptions.forEach { option in
            menuOptions.options?.forEach {
                if option.slug == $0.slug {
                    choicesOfCurrentMenu.append(option)
                }
            }
        }
        if choicesOfCurrentMenu.count >= maxChoice {
            controller?.showToast(message: "At most \(maxChoice) items", font: UIFont(name: AppConstants.Font.Lexend.Medium, size: 14) ?? UIFont.systemFont(ofSize: 14))
        }
        return choicesOfCurrentMenu.count < maxChoice
    }
}
