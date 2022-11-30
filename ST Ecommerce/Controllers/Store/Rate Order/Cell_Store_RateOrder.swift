//
//  Cell_Store_RateOrder.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Cosmos

class Cell_Store_RateOrder: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageViewProduct: UIImageView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubTitle: UILabel!
    
    @IBOutlet weak var textViewPlaceHolderView: GradientView!
    @IBOutlet weak var textViewReview: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
    
    //MARK: - variables
    var controller:VC_Store_RateOrder!
    
    
    //MARK: - Internal Functions
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Helper Functions
    func setData(product:RateProduct){
        
        let imagePath = product.image ?? ""
        imageViewProduct.setIndicatorStyle(.gray)
        imageViewProduct.setShowActivityIndicator(true)
        imageViewProduct.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
            self.imageViewProduct.setShowActivityIndicator(false)
        }
        
        labelTitle.text = product.name ?? ""
        labelSubTitle.text = product.store?.name ?? ""
        ratingView.rating = Double(product.rating ?? 0)
        
        textViewPlaceHolderView.isHidden = false
        if product.review ?? "" != ""{
            textViewPlaceHolderView.isHidden = true
            textViewReview.text = product.review ?? ""
        }
        
        ratingView.didFinishTouchingCosmos = {rating in

            self.controller.rateOrder?.rateProducts?[self.ratingView.tag].rating = Int(rating)
        }
    }
    
    func configureTextView(){
        
        self.textViewReview.delegate = self

    }
    
}


extension Cell_Store_RateOrder : UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == ""{
            textViewPlaceHolderView.isHidden = false
        }else{
            textViewPlaceHolderView.isHidden = true
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    
        let reviewText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        textView.layer.borderWidth = 0.75
        textView.layer.cornerRadius = 15
        
        if reviewText == ""{
            textViewPlaceHolderView.isHidden = false
            textView.layer.borderColor = UIColor.clear.cgColor
            
        }else{
            textViewPlaceHolderView.isHidden = true
            textView.layer.borderColor = #colorLiteral(red: 0.7131211162, green: 0.7095586061, blue: 0.7061203122, alpha: 1)
            
        }
        
        self.controller.rateOrder?.rateProducts?[textView.tag].review = reviewText
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textViewPlaceHolderView.isHidden = false
        }else{
            textViewPlaceHolderView.isHidden = true
        }
    }
    
    func getCurrentEditingWord() ->String? {
           let selectedRange: UITextRange? = self.textViewReview.selectedTextRange
           var cursorOffset: Int? = nil
           if let aStart = selectedRange?.start {
               cursorOffset = self.textViewReview.offset(from: self.textViewReview.beginningOfDocument, to: aStart)
           }
           let text = self.textViewReview.text
           let substring = (text as NSString?)?.substring(to: cursorOffset!)
           let editedWord = substring?.components(separatedBy: " ").last
           return editedWord
       }
}
