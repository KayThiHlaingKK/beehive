//
//  ImageViewController.swift
//  ST Ecommerce
//
//  Created by necixy on 21/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Zoomy

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    var imageArray: [Images] = [Images]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        imgView.isUserInteractionEnabled = true
        setData()
        var leftSwipe = UISwipeGestureRecognizer(target:self, action: #selector(handleSwipes(sender:)))
        var rightSwipe = UISwipeGestureRecognizer(target:self, action: #selector(handleSwipes(sender:)))
        var downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleDownSwipe(sender:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        downSwipe.direction = .down
        imgView.addGestureRecognizer(downSwipe)
        imgView.addGestureRecognizer(leftSwipe)
        imgView.addGestureRecognizer(rightSwipe)
        addZoombehavior(for: imgView, settings: Settings.instaZoomSettings.with(actionOnTapOverlay: Action.dismissOverlay))
    }
    
    func setData(){
        imgView.setIndicatorStyle(.gray)
        imgView.setShowActivityIndicator(true)
        if imageArray.isEmpty {
            imgView.image = UIImage(named: "placeholder2")
        } else {
            imgView.downloadImage(url: imageArray[index ?? 1].url, fileName: imageArray[index ?? 1].file_name, size: .large)
        }
       
//        imgView.sd_setImage(with: URL(string: imageArray[index ?? 1]), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
//            self.imgView.setShowActivityIndicator(false)
//        }
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer)
    {
        if index < imageArray.count  && index >= 0{
            if (sender.direction == .left)
            {
                if index < imageArray.count - 1
                {
                    index = index +  1
                }
                setData()
            }
            else
            {
                if index > 0
                {
                    index =  index - 1
                }
                
                setData()
            }
        }
    }
    @objc func handleDownSwipe(sender: UISwipeGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
        
    }
}


    


