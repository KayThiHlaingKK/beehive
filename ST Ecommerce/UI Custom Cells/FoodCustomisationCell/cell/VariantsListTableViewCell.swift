//
//  VariantsListTableViewCell.swift
//  ST Ecommerce
//
//  Created by Ku Ku Zan on 7/10/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

class VariantsListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblVariationName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var imgSelect: UIImageView!
    
    @IBOutlet weak var extraChargeTableView: SelfSizingTableView!
    
    
    var controller: VC_FoodCustomisation?
    var extraVariants: [ExtraCharges] = [ExtraCharges]()
    var menuVariants: [Menu_variants] = [Menu_variants]()
    var rowIndex : Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        extraChargeTableView.reloadData()
    }
    
  
    func setDataConfigure(variants: [Variant]){
        let count = variants.count
        if count > 0 {
            var name = ""
            for i in 0..<count {
                if let value = variants[i].value {
                    if i == 0{
                        name = value
                    }
                    else {
                        name.append("/\(value)")
                    }
                }
            }
            lblVariationName.text = name
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    fileprivate func setupUI(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didChoose))
        addGestureRecognizer(tap)
        extraChargeTableView.delegate = self
        extraChargeTableView.dataSource = self
        extraChargeTableView.registerCell(type: ExtraChargeListTableViewCell.self)
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

extension VariantsListTableViewCell: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extraVariants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExtraChargeListTableViewCell.identifier, for: indexPath)as? ExtraChargeListTableViewCell else {
            return UITableViewCell()
        }
        cell.extraChargeNameLbl.text = extraVariants[indexPath.row].name
        let price = "\(priceFormat(pricedouble: Double(extraVariants[indexPath.row].value ?? "") ?? 0.0))\(currencySymbol)"
        cell.extraChargePriceLbl.text = price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
}
