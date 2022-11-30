//
//  Cell_Track_Store.swift
//  ST Ecommerce
//
//  Created by Necixy on 06/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class Cell_Track_Store: UITableViewCell {

    //MARK: - IBOutlets
    
    //Product information
    @IBOutlet weak var lblOrderSerial: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    
    //Status labels static
    @IBOutlet weak var lblOrderPlaced: UILabel!
    @IBOutlet weak var lblOrderConfirmed: UILabel!
    @IBOutlet weak var lblOrderReadyToShip: UILabel!
    @IBOutlet weak var lblOrderShipped: UILabel!
    @IBOutlet weak var lblOrderDelivered: UILabel!
    
    //each status for dates
    @IBOutlet weak var lblOrderPlacedDate: UILabel!
    @IBOutlet weak var lblOrderConfirmedDate: UILabel!
    @IBOutlet weak var lblOrderReadyToShipDate: UILabel!
    @IBOutlet weak var lblOrderShippedDate: UILabel!
    @IBOutlet weak var lblOrderDeliveredDate: UILabel!
    
    //images for each status
    @IBOutlet weak var imgViewOrderPlaced: UIImageView!
    @IBOutlet weak var imgViewOrderConfirmed: UIImageView!
    @IBOutlet weak var imgViewOrderReadyToShip: UIImageView!
    @IBOutlet weak var imgViewOrderShipped: UIImageView!
    @IBOutlet weak var imgViewOrderDelivered: UIImageView!
    
    //line between two ststus
    @IBOutlet weak var viewOrderPlaced: UIView!
    @IBOutlet weak var viewOrderConfirmed: UIView!
    @IBOutlet weak var viewOrderReadyToShip: UIView!
    @IBOutlet weak var viewOrderShipped: UIView!
    
    //MARK: - Variables
    var controller:VC_StoreTrackOrder!
    
    //MARK: - Internal functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        localizedText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: - Functions
    func setData(track:TrackStoreOrderData){
        
        imgViewProduct.setIndicatorStyle(.gray)
        imgViewProduct.setShowActivityIndicator(true)
        imgViewProduct.sd_setImage(with: URL(string: track.product?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
            self.imgViewProduct.setShowActivityIndicator(false)
        }
        
        lblOrderSerial.text = "\(orderNoText) \(track.orderSerial ?? "")"
        lblName.text = track.product?.name ?? ""
        lblDetails.text = track.product?.subtitle ?? ""
        
        self.resetUITrackline()
        
        
        let status = (track.status ?? "").lowercased()
        if status == TrackStoreOrderStatus.pending.caseValue{
            if let dateTimeStamp = track.timeline?.first?.time{
                let date = Util.getDateFrom(timeStampInString: "\(dateTimeStamp)", format: trackStoreTimeFormatString)
                lblOrderPlacedDate.text = date
                imgViewOrderPlaced.image = #imageLiteral(resourceName: "check")
            }
        }
        else if status == TrackStoreOrderStatus.confirmed.caseValue{
            if let dateTimeStampPlaced = track.timeline?[0].time, let dateTimeStampConfirmed = track.timeline?[0].time{
                let datePlaced = Util.getDateFrom(timeStampInString: "\(dateTimeStampPlaced)", format: trackStoreTimeFormatString)
                lblOrderPlacedDate.text = datePlaced
                
                let dateConfirmed = Util.getDateFrom(timeStampInString: "\(dateTimeStampConfirmed)", format: trackStoreTimeFormatString)
                lblOrderConfirmedDate.text = dateConfirmed
                
                imgViewOrderPlaced.image = #imageLiteral(resourceName: "check")
                imgViewOrderConfirmed.image = #imageLiteral(resourceName: "check")
                viewOrderPlaced.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
            }
        }
        else if status == TrackStoreOrderStatus.readyToShip.caseValue{
            if let dateTimeStampPlaced = track.timeline?[0].time, let dateTimeStampConfirmed = track.timeline?[0].time, let dateTimeStampReadyToShipped = track.timeline?[0].time{
                
                let datePlaced = Util.getDateFrom(timeStampInString: "\(dateTimeStampPlaced)", format: trackStoreTimeFormatString)
                lblOrderPlacedDate.text = datePlaced
                
                let dateConfirmed = Util.getDateFrom(timeStampInString: "\(dateTimeStampConfirmed)", format: trackStoreTimeFormatString)
                lblOrderConfirmedDate.text = dateConfirmed
                
                let dateReadyToShipped = Util.getDateFrom(timeStampInString: "\(dateTimeStampReadyToShipped)", format: trackStoreTimeFormatString)
                lblOrderReadyToShipDate.text = dateReadyToShipped
                
                
                imgViewOrderPlaced.image = #imageLiteral(resourceName: "check")
                imgViewOrderConfirmed.image = #imageLiteral(resourceName: "check")
                viewOrderPlaced.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
                imgViewOrderReadyToShip.image = #imageLiteral(resourceName: "check")
                viewOrderConfirmed.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
            }
        }
        else if status == TrackStoreOrderStatus.orderShipped.caseValue{
            if let dateTimeStampPlaced = track.timeline?[0].time, let dateTimeStampConfirmed = track.timeline?[0].time, let dateTimeStampReadyToShipped = track.timeline?[0].time, let dateTimeStampShipped = track.timeline?[0].time{
                
                let datePlaced = Util.getDateFrom(timeStampInString: "\(dateTimeStampPlaced)", format: trackStoreTimeFormatString)
                lblOrderPlacedDate.text = datePlaced
                
                let dateConfirmed = Util.getDateFrom(timeStampInString: "\(dateTimeStampConfirmed)", format: trackStoreTimeFormatString)
                lblOrderConfirmedDate.text = dateConfirmed
                
                let dateReadyToShipped = Util.getDateFrom(timeStampInString: "\(dateTimeStampReadyToShipped)", format: trackStoreTimeFormatString)
                lblOrderReadyToShipDate.text = dateReadyToShipped
                
                let dateShipped = Util.getDateFrom(timeStampInString: "\(dateTimeStampShipped)", format: trackStoreTimeFormatString)
                lblOrderShippedDate.text = dateShipped
                
                
                
                imgViewOrderPlaced.image = #imageLiteral(resourceName: "check")
                imgViewOrderConfirmed.image = #imageLiteral(resourceName: "check")
                viewOrderPlaced.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
                imgViewOrderReadyToShip.image = #imageLiteral(resourceName: "check")
                viewOrderConfirmed.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
                imgViewOrderShipped.image = #imageLiteral(resourceName: "check")
                viewOrderReadyToShip.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
            }
        }
        else if status == TrackStoreOrderStatus.delivered.caseValue{
            if let dateTimeStampPlaced = track.timeline?[0].time, let dateTimeStampConfirmed = track.timeline?[0].time, let dateTimeStampReadyToShipped = track.timeline?[0].time, let dateTimeStampShipped = track.timeline?[0].time, let dateTimeStampDelivered = track.timeline?[0].time{
                
                let datePlaced = Util.getDateFrom(timeStampInString: "\(dateTimeStampPlaced)", format: trackStoreTimeFormatString)
                lblOrderPlacedDate.text = datePlaced
                
                let dateConfirmed = Util.getDateFrom(timeStampInString: "\(dateTimeStampConfirmed)", format: trackStoreTimeFormatString)
                lblOrderConfirmedDate.text = dateConfirmed
                
                let dateReadyToShipped = Util.getDateFrom(timeStampInString: "\(dateTimeStampReadyToShipped)", format: trackStoreTimeFormatString)
                lblOrderReadyToShipDate.text = dateReadyToShipped
                
                let dateShipped = Util.getDateFrom(timeStampInString: "\(dateTimeStampShipped)", format: trackStoreTimeFormatString)
                lblOrderShippedDate.text = dateShipped
                
                let dateDelivered = Util.getDateFrom(timeStampInString: "\(dateTimeStampDelivered)", format: trackStoreTimeFormatString)
                lblOrderDeliveredDate.text = dateDelivered
                
                
                imgViewOrderPlaced.image = #imageLiteral(resourceName: "check")
                imgViewOrderConfirmed.image = #imageLiteral(resourceName: "check")
                viewOrderPlaced.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
                imgViewOrderReadyToShip.image = #imageLiteral(resourceName: "check")
                viewOrderConfirmed.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
                imgViewOrderShipped.image = #imageLiteral(resourceName: "check")
                viewOrderReadyToShip.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
                imgViewOrderDelivered.image = #imageLiteral(resourceName: "check")
                viewOrderShipped.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7098039216, blue: 0.2862745098, alpha: 1)
            }
        }
        
    }
    
    func resetUITrackline(){
        
        imgViewOrderPlaced.image = #imageLiteral(resourceName: "Processing")
        imgViewOrderPlaced.tintColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        viewOrderPlaced.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        
        imgViewOrderConfirmed.image = #imageLiteral(resourceName: "Processing")
        imgViewOrderConfirmed.tintColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        viewOrderConfirmed.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        
        imgViewOrderReadyToShip.image = #imageLiteral(resourceName: "Processing")
        imgViewOrderReadyToShip.tintColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        viewOrderReadyToShip.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        
        imgViewOrderShipped.image = #imageLiteral(resourceName: "Processing")
        imgViewOrderShipped.tintColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        viewOrderShipped.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        
        imgViewOrderDelivered.image = #imageLiteral(resourceName: "Processing")
        imgViewOrderDelivered.tintColor = #colorLiteral(red: 0.9843137255, green: 0.7215686275, blue: 0.2549019608, alpha: 1)
        
    }
    
    func localizedText(){
        
        lblOrderPlaced.text = orderPlaced
        lblOrderConfirmed.text = orderConfirmed
        lblOrderReadyToShip.text = orderReadytoShip
        lblOrderShipped.text = orderShipped
        lblOrderDelivered.text = orderDelivered
        
    }

}
