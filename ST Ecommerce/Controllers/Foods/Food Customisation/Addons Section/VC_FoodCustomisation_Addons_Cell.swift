//
//  VC_FoodCustomisation_Addons_Cell.swift
//  ST Ecommerce
//
//  Created by Necixy on 28/12/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class VC_FoodCustomisation_Addons_Cell: UITableViewCell {

    var controller: VC_FoodCustomisation?
    
    var value: Values?
    var id: Int?
    
    var sectionIndex : Int = 0
    var rowIndex : Int = 0
    
    var qty : Int = 1 
    
//  MARK: - Outlets
    @IBOutlet weak var btnSelectedAddon: UIButton!
    @IBOutlet weak var lblAddonName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var viewQuantity: GradientView!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
//  MARK: - Action Functions
    
    @IBAction func btnSelectedAddon(_ sender: Any) {
        
//        if controller?.men.addons[sectionIndex].type == "radio" {
//            if btnSelectedAddon.isSelected == false {
//
//
//                for index in controller!.item!.addons[sectionIndex].values.indices {
//                    controller?.item?.addons[sectionIndex].values[index].is_Selected =  false
//
//                }
//                let addonValues = [["id": controller!.item!.addons[sectionIndex].values[rowIndex].id ?? 0, "qty": controller?.addonQty ?? 1]]
//                controller?.selectedAddons.remove(at: sectionIndex)
//                controller?.selectedAddons.insert(["id": controller?.item?.addons[sectionIndex].id ?? 0, "values": addonValues], at: sectionIndex)
//                btnSelectedAddon.isSelected = true
//                btnSelectedAddon.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .selected)
//                controller?.item?.addons[sectionIndex].values[rowIndex].is_Selected = true
//                    self.controller?.tableViewAddonsCustomisation.reloadData()
//            }
//                else {
//                btnSelectedAddon.setImage(#imageLiteral(resourceName: "radio_button_un_selected"), for: .normal)
//                self.controller?.tableViewAddonsCustomisation.reloadData()
//            }
//        } else if controller?.item?.addons[sectionIndex].type == "checkbox" {
//
//            if btnSelectedAddon.isSelected == true {
//
//                controller?.selectedAddons.remove(at: sectionIndex)
//                btnSelectedAddon.isSelected = false
//                btnSelectedAddon.setImage(#imageLiteral(resourceName: "blank-check-box"), for: .normal)
//                self.controller?.tableViewAddonsCustomisation.reloadData()
//
//            } else {
//                var addonValue = [[String: Any]]()
//                addonValue = [["id": controller!.item!.addons[sectionIndex].values[rowIndex].id ?? 0, "qty": controller?.addonQty ?? 1]]
//
//                if controller?.selectedAddons.isEmpty == true {
//                    controller?.selectedAddons.append(["id": controller?.item?.addons[sectionIndex].id ?? 0, "values": addonValue])
//                } else {
////                    Do Your Stuff
//                    addonValue.insert(contentsOf: addonValue, at: sectionIndex)
//                    controller?.selectedAddons.append(["id": controller?.item?.addons[sectionIndex].id ?? 0, "values": addonValue])
//                }
//
//                btnSelectedAddon.isSelected = true
//               btnSelectedAddon.setImage(#imageLiteral(resourceName: "check-box-with-check-sign-4"), for: .selected)
//                self.controller?.tableViewAddonsCustomisation.reloadData()
//            }
//
//        } else {
//            print("Invalid State")
//        }
        
    }
    
    @IBAction func btnLessQuantity(_ sender: UIButton) {
        
//        if let cell : VC_FoodCustomisation_Addons_Cell = sender.superview?.superview?.superview as? VC_FoodCustomisation_Addons_Cell {
//
//            if let indexPath = self.controller?.tableViewAddonsCustomisation.indexPath(for: cell) {
//                let addon =  self.controller?.item.addons[indexPath.section].values[indexPath.row]
//
//                if controller?.addonQty == 1 {
//                   print("Do Nothing.")
//                } else if controller!.addonQty >= 2 {
//                    controller?.addonQty = controller!.addonQty - 1
//                }
//                lblQuantity.text = ("\(controller?.addonQty ?? 1)")
//            }
//
//        }
//                    controller?.tableViewAddonsCustomisation.reloadData()
    }
    
    @IBAction func btnMoreQuantity(_ sender: UIButton) {
        
//        if let cell : VC_FoodCustomisation_Addons_Cell = sender.superview?.superview?.superview as? VC_FoodCustomisation_Addons_Cell {
//
//            if let indexPath = self.controller?.tableViewAddonsCustomisation.indexPath(for: cell) {
//                let addon = self.controller?.item.addons[indexPath.section].values[indexPath.row]
//
//                controller?.addonQty = controller!.addonQty + 1
//                lblQuantity.text = ("\(controller?.addonQty ?? 2)")
//            }
////            controller?.tableViewAddonsCustomisation.reloadData()
//
//        }
    }

    
    
}
