//
//  DeleteAlertView.swift
//  ST Ecommerce
//
//  Created by Hive Innovation Dev on 9/9/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import UIKit

protocol DeleteAPIDelegate{
    func deleteAPICall()
}

class DeleteAlertView: UIView,MTSlideToOpenDelegate {
    
    static let instance = DeleteAlertView()

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var sliderView: MTSlideToOpenView!
    
    var delegate: DeleteAPIDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("DeleteAlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInit() {
        alertView.dropShadow()
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        confirmBtn.backgroundColor = .darkGray
        confirmBtn.isUserInteractionEnabled = false
        sliderViewInit()
    }
    
    fileprivate func sliderViewInit() {
        sliderView.sliderViewTopDistance = 0
        sliderView.sliderCornerRadius = 25
        sliderView.showSliderText = true
        sliderView.thumbnailColor = UIColor(red:141.0/255, green:19.0/255, blue:65.0/255, alpha:1.0)
        sliderView.slidingColor = UIColor(red:141.0/255, green:19.0/255, blue:65.0/255, alpha:1.0)
        sliderView.textColor = UIColor.orange
        sliderView.sliderBackgroundColor = .appColor(.mainColor) ?? UIColor()
        sliderView.delegate = self
        sliderView.thumnailImageView.image = #imageLiteral(resourceName: "ic_arrow").imageFlippedForRightToLeftLayoutDirection()
    }
    
    func showAlert() {
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        confirmBtn.isUserInteractionEnabled = true
        confirmBtn.backgroundColor = .appColor(.mainColor)
        
    }
    
    @IBAction func onClickConfirm(_ sender: UIButton) {
        parentView.removeFromSuperview()
        confirmBtn.backgroundColor = .darkGray
        delegate.deleteAPICall()
        sliderView.resetStateWithAnimation(true)
    }
    
    @IBAction func onClickCancel(_ sender: UIButton) {
        parentView.removeFromSuperview()
        confirmBtn.backgroundColor = .darkGray
        sliderView.resetStateWithAnimation(true)
    }
    
   
}

