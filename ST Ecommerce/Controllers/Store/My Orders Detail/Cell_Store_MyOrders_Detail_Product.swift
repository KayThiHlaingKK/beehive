//
//  Cell_Store_MyOrders_Detail_Product.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_Store_MyOrders_Detail_Product: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageViewProduct: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelColor: UILabel!
    @IBOutlet weak var labelBrandName: UILabel!
    @IBOutlet weak var labelQty: UILabel!
    @IBOutlet weak var labelAmount: UILabel!
    @IBOutlet weak var labelSubTotal: UILabel!
    @IBOutlet weak var labelDeliveryCharge: UILabel!
    @IBOutlet weak var labelDeliveryStatus: UILabel!
    @IBOutlet weak var labelDeliveryInfo: UILabel!
    
    @IBOutlet weak var lblTaxPercentage: UILabel!
    @IBOutlet weak var cancelStackView: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var vwBuyNow: UIStackView!
    @IBOutlet weak var btnRateOrder: UIButton!
    @IBOutlet weak var btnBuyNow: UIButton!
    
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblReviewText: UILabel!
    
//    @IBOutlet weak var vwBuyNow: UIStackView!
    @IBOutlet weak var lblCancellationTitle: UILabel!
    @IBOutlet weak var vWcancel: UIView!
    
    @IBOutlet weak var lblCancellationText: UILabel!
    
    //Cancel Track order view start
    @IBOutlet weak var btnTrack: UIButton!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var heightConstraintCancelTrackOrder: NSLayoutConstraint!
    @IBOutlet weak var viewContainerCancelTrackOrder: UIView!
    //Cancel Track order view end
    
    //Promocode discount start ----->
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var topConstraintPromocodeLbl: NSLayoutConstraint!
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var topConstraintLblDiscount: NSLayoutConstraint!
    //Promocode discount start ------>
    
    @IBOutlet weak var lblSoldBy: UILabel!
    @IBOutlet weak var btnDownloadInvoice: UIButton!
    
    @IBOutlet weak var heightConstraintVWCancel: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintDwnldInvoice: NSLayoutConstraint!
    
    //MARK: - Variable
    var controller : VC_Store_MyOrders_Detail!
    var orderProductID = Int()
    
    //MARK: - INternal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
    //MARK: -  Helper Functions
    func setData(orderProduct: Shop_Order_Item){
        
        
        if let images = orderProduct.images,
           images.count > 0 {
            let imagePath = "\(images.first?.url ?? "")?size=xsmall"
            imageViewProduct.setIndicatorStyle(.gray)
            imageViewProduct.setShowActivityIndicator(true)
            imageViewProduct.downloadImage(url: imagePath, fileName: images.first?.file_name, size: .xsmall)
        }
        
        
        labelName.text = orderProduct.product_name ?? ""
        
        labelQty.text = ""
        if let qty = orderProduct.quantity{
            labelQty.text = "\(qty)"
        }
        
        if let discount = orderProduct.discount , discount > 0{
            let org = orderProduct.amount ?? 0
            let price = org - discount
            labelAmount.text = "\(self.controller.priceFormat(pricedouble: price))\(currencySymbol)"
        }
        else {
            labelAmount.text = "\(self.controller.priceFormat(pricedouble: orderProduct.amount ?? 0))\(currencySymbol)"
        }
        
        
        labelSubTotal.text = "\(self.controller.priceFormat(pricedouble: orderProduct.total_amount ?? 0))\(currencySymbol)"
        

        //Option showing in store name if its available work adding START
        lblSoldBy.text = "Sold By"
        labelBrandName.text = orderProduct.shop?.name ?? ""
        
        if let options = orderProduct.variations{
        
            if options.count != 0{
                var text = ""//"\(orderProduct.variations?.store?.name ?? "")\n"
                var soldBy = "Sold By\n"
                if options.count != 0{
                    
                    for option in options{
                        
                        //soldBy.append("\(options.option ?? "")\n")
                        //text.append("\(option.product_variation_values ?? "")\n")
                    }
                    
                }

                lblSoldBy.attributedText = Util.getAttributedStringApplyVerticalLineSpacing(spacing: 2, string: String(soldBy.dropLast()))
                
                labelBrandName.attributedText = Util.getAttributedStringApplyVerticalLineSpacing(spacing: 2, string: String(text.dropLast()))
                
                labelBrandName.textAlignment = .right
            }
            
        }
        //lblTaxPercentage.text = "Tax ( \(orderProduct.tax ?? "") %)"
        
        btnDownloadInvoice.layer.cornerRadius = 4
    }
    

    
   
 
    
    @IBAction func cancelOrder(_ sender: UIButton) {
        
        guard  let vc: CancelOrderViewController = storyboardHome.instantiateViewController(withIdentifier: "CancelOrderViewController") as? CancelOrderViewController else { return }
        vc.delegate = self
        self.controller.add(vc, frame: vc.view.frame)
    }
}

extension Cell_Store_MyOrders_Detail_Product: CancelOrderViewControllerDelegate {
    func callCancelAPI(cancellationReason: String?) {
        let param: [String: Any] = ["cancellation_reason":  cancellationReason]
        self.controller.showHud(message: loadingText)
        APIUtils.APICall(postName: "\(APIEndPoint.storeOrders.caseValue)\(orderProductID)/cancel", method: .delete, parameters: param) { (response) in
            
            self.controller.hideHud()
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status {
//                self.controller.tableViewStoreMyOrdersDetails.reloadData()
                self.controller.viewDidLoad()
                self.vWcancel.isHidden = false
            } else {
                let message = data[key_message] as? String ?? serverError
                self.controller.presentAlert(title: errorText, message: message)
            }
        } onFailure: { (reason, IntstatusCode) in
            self.controller.hideHud()
        }
    }
}
