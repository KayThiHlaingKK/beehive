//
//  Cell_TV_DeliveryPerson.swift
//  ST Ecommerce
//
//  Created by necixy on 06/08/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_TV_DeliveryPerson: UITableViewCell {

    //MARK: - IBOutlet
    @IBOutlet weak var imageViewDeliveryBoy: UIImageView!
    @IBOutlet weak var labelDeliveryBoyName: UILabel!
    @IBOutlet weak var labelDeliveryBoyContactNumber: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
  
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    
    @IBOutlet weak var vWcancelView: UIView!
    @IBOutlet weak var vwcancelViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCancellation: UILabel!
    @IBOutlet weak var lblCancellationDate: UILabel!
    
    @IBOutlet weak var moreDetailsView: UIView!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var vwDeliveryPerson: UIView!
    @IBOutlet weak var lblDeliveryPerson: UILabel!
    
    
    //MARK: - Variables
    var controller:VC_FoodsMyOrder_Detail!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnHelp(_ sender: Any) {
        
        let vc : HelpViewController = storyboardMyOrders.instantiateViewController(withIdentifier: "HelpViewController") as! HelpViewController
        
        self.controller?.navigationController?.pushViewController(vc, animated: true
        )
        
    }
    
    func setData(restroOrderDetails:RestaurantOrder){
        

    }
}
