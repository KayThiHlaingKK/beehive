//
//  VC_Reward.swift
//  ST Ecommerce
//
//  Created by Necixy on 04/12/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

class VC_Reward: UIViewController {
    
//  MARK: - Outlets
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReload: UIButton!
    
    @IBOutlet weak var rewardScrollView: UIScrollView!
    
    @IBOutlet weak var viewCheckinDetails: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var imgDay1: UIImageView!
    @IBOutlet weak var imgDay2: UIImageView!
    @IBOutlet weak var imgDay3: UIImageView!
    @IBOutlet weak var imgDay4: UIImageView!
    @IBOutlet weak var imgDay5: UIImageView!
    @IBOutlet weak var imgDay6: UIImageView!
    @IBOutlet weak var imgDay7: UIImageView!
    
    @IBOutlet weak var rewardsTableView: UITableView!
    
    
    
//  MARK: - Variables
    
    var dailyCheckIn : DailyCheckIn?
    var rewards : Rewards?
    var checkinImageArray: Array = [UIImageView]()
    var rewardsCode : [RewardCode] = [RewardCode]()
    var apiPage = 1
    
    
//  MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        rewardsTableView.separatorStyle = .none
        rewardsTableView.tableFooterView?.backgroundColor = .yellow
        apiPage = 1
        self.rewards?.data?.removeAll()
        loadCheckindDataFromServer()
        loadRewardDataFromServer()
        UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        rewardScrollView.isScrollEnabled = false
        
        viewCheckinDetails.layer.cornerRadius = 10
        userImage.layer.cornerRadius = userImage.frame.width / 2
        
        checkinImageArray = [imgDay1, imgDay2, imgDay3, imgDay4, imgDay5, imgDay6, imgDay7]
        
        for image in checkinImageArray {
            image.setImageColor(color: UIColor.gray)
        }
        
    }
    
//  MARK: - Action Functions
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReload(_ sender: Any) {
  
        
        viewDidLoad()
    }
    
    
    @IBAction func btnPromoCode(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: self.rewardsTableView)
        guard let customIndexPath = self.rewardsTableView.indexPathForRow(at: point) else {
            return
        }
        guard let cell = rewardsTableView.cellForRow(at: customIndexPath) as? VC_Reward_cell else { return }
        UIPasteboard.general.string = cell.btnPromoCode.title(for: .normal)
        let uialert = UIAlertController(title: "", message: "Promo code copied to pasteboard!", preferredStyle: .alert)
        uialert.addAction(UIAlertAction(title: okayText, style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(uialert, animated: true, completion:{
            uialert.view.superview?.isUserInteractionEnabled = true
            uialert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    @objc func dismissOnTapOutside(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentAlerts(title: String, message: String){
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okayText, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
// MARK: - API Functions
    
    func loadCheckindDataFromServer () {
            
            let param : [String:Any] = [:]
            print("param \(param)")
            self.showHud(message: loadingText)

        let path = APIEndPoint.check_in.caseValue

            APIUtils.APICall(postName: path, method: .get,  parameters: param, controller: self, onSuccess: { (response) in

                self.hideHud()
                let data = response as! NSDictionary
                let status = data.value(forKey: key_status) as? Bool ?? true

                if status {
                    
                    if let checkIn = data.value(forKeyPath: "data") as? NSDictionary {
                        APIUtils.prepareModalFromData(checkIn, apiName: APIEndPoint.check_in.caseValue, modelName: "DailyCheckIn", onSuccess: { (anyData) in
                            self.dailyCheckIn = anyData as? DailyCheckIn
                            self.setCheckInData()
                            
                        }) { (error, endPoint) in
                            print("Error")
                            print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                        }
                    } else {
                       print("There is an error")
                    }
                } else {
                    let message = data[key_message] as? String ?? serverError
                    self.presentAlert(title: errorText, message: message)
             
                }

            }) { (reason, statusCode) in
                self.hideHud()
            }
    }
    
    func setCheckInData() {
        
        var array:[CheckIn] = (self.dailyCheckIn?.checkIns)!
            
        userName.text = self.dailyCheckIn?.user?.name
        
        let imagePath = self.dailyCheckIn?.user?.profilePic ?? ""
        userImage.setIndicatorStyle(.gray)
        userImage.setShowActivityIndicator(true)
        userImage.sd_setImage(with: URL(string: imagePath), placeholderImage: #imageLiteral(resourceName: "Path 23")) { (image, error, type, url) in
            self.userImage.setShowActivityIndicator(false)
        }
        
        self.userImage.layer.cornerRadius = userImage.frame.size.width/2
        self.userImage.clipsToBounds = true
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.borderColor = UIColor.orange.cgColor
        
        
        //Changes by KARISHMA
        for(index,object) in array.enumerated(){
            let img = checkinImageArray[index]
            if object.checkedIn!{
                img.setImageColor(color: UIColor.orange)
            }
        }
      
        
        //Changes by KARISHMA
        
    }
  
    
    func loadRewardDataFromServer() {
        let param : [String:Any] = [:]
        print("param \(param)")
        
        if self.apiPage == 1{
            self.showHud(message: loadingText)
        }
        
    let path = "\(APIEndPoint.rewards.caseValue)?page=\(apiPage)"
        APIUtils.APICall(postName: path, method: .get,  parameters: param, controller: self, onSuccess: { (response) in
            if self.apiPage == 1{
                self.hideHud()
            }
            
            self.rewardsTableView.tableFooterView?.isHidden = true
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? true
            
            if path == APIEndPoint.rewards.caseValue {
                self.rewards?.data?.removeAll()
            }
            self.rewardsTableView.reloadData()

            if status {
                
                APIUtils.prepareModalFromData(data, apiName: APIEndPoint.rewards.caseValue, modelName: "Rewards", onSuccess: { (anyData) in
                    self.rewards = anyData as? Rewards
                    self.rewardsCode += self.rewards?.data ?? []
                    self.rewardsTableView.reloadData()
                    
                    if self.rewards?.data?.count == 0{
                        self.rewardsTableView.isHidden = true
                    }

                }) { (error, endPoint) in
                    print("error \(String(describing: error?.localizedDescription)), reason \(endPoint)")
                }
                
            } else {

                    let message = data[key_message] as? String ?? serverError
                    self.presentAlert(title: errorText, message: message)
            }

        }) { (reason, statusCode) in
            self.hideHud()
        }
    }
    
}

//  MARK: - Table View Setup

extension VC_Reward : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewards?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VC_Reward_cell") as? VC_Reward_cell else { return  UITableViewCell()}
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        rewardsTableView.allowsSelection = false
        
        cell.btnPromoCode.semanticContentAttribute = .forceRightToLeft
        if let reward = self.rewards?.data?[indexPath.row]{
            cell.lblCellTitle.text = reward.displayName ?? ""
            let date = Date(timeIntervalSince1970:TimeInterval(reward.validDate ?? 0))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let localDate = dateFormatter.string(from: date)
            cell.lblValidityDate.text = "Valid Till : \(localDate)"
            cell.btnPromoCode.setTitle(reward.promoCode, for: .normal)
            if reward.expired == true {
                cell.lblExpired.isHidden = false
            } else {
                cell.lblExpired.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension 
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == ((self.rewards?.data?.count)!) - 1 ) {
            if self.rewards?.link?.next == true{
                self.apiPage += 1
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                rewardsTableView.tableFooterView = spinner
                rewardsTableView.tableFooterView?.isHidden = false
                self.loadRewardDataFromServer()
            }
            
        }
    }
    
    
    
    
}
