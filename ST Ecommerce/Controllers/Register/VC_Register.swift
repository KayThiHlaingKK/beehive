//
//  VC_Login.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import SwiftLocation
import CoreLocation
import JGProgressHUD


class VC_Register: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableViewRegister: UITableView!
    @IBOutlet weak var bottomConstraintTableContainerView: NSLayoutConstraint!
   
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK: -
    var userCurrentLocation : CLLocation?
    let notificationCenter = NotificationCenter.default
    let hud = JGProgressHUD(style: .dark)
    var sing = Singleton.shareInstance
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetUp()
        
        addLocationPermissionObserver()
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        self.getUserCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    //MARK: - Private functions
    fileprivate func tableViewSetUp(){
        
        tableViewRegister.delegate = self
        tableViewRegister.dataSource = self
        
        bottomConstraintTableContainerView.constant = 44
        if DeviceUtils.isDeviceIphoneXOrlatter(){
            bottomConstraintTableContainerView.constant = 90
        }
    }
    
    @objc func appMovedToForeground() {
        self.getUserCurrentLocation()
    }
    
    //MARK: - Action Function
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        Util.makeHomeRootController()
    }
    
}

//MARK: - UITableViewDelegate and UITableViewDataSource Functions
extension VC_Register : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Register") as! Cell_Register
        cell.controller = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension VC_Register {
    
    func getUserCurrentLocation(){
        
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .room) { result in
            switch result {
            case .failure(let error):
                debugPrint("Received error: \(error)")
            case .success(let location):
                debugPrint("Location received: \(location)")
                self.userCurrentLocation = location
                if let coordinates = self.userCurrentLocation?.coordinate{
                    Singleton.shareInstance.userCurrentCoordinates = coordinates
                    self.setAddressInSingelton()
                }
            }
        }
    }
    
    func addLocationPermissionObserver(){
        
        LocationManager.shared.onAuthorizationChange.add { newState in
            if newState == LocationManager.State.denied || newState == LocationManager.State.disabled || newState == LocationManager.State.restricted{
                
                self.showPermissionAlert()
            }else{
            }
        }
    }
    
    func setAddressInSingelton()  {
        
        let lat : Double = Double(Singleton.shareInstance.userCurrentCoordinates.latitude)
        let long : Double = Double(Singleton.shareInstance.userCurrentCoordinates.longitude)
        
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: lat , longitude: long)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if placeMark == nil{
                return
            }
            if let country = placeMark.addressDictionary!["Country"] as? String {
                self.sing.country = country
                if let city = placeMark.addressDictionary!["City"] as? String {
                    self.sing.city = city
                    if let state = placeMark.addressDictionary!["State"] as? String{
                        self.sing.state = state
                        if let street = placeMark.addressDictionary!["Street"] as? String{
                            self.sing.street = street
                            let str = street
                            let streetNumber = str.components(
                                separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
                            self.sing.streetNumber = streetNumber
                            if let zip = placeMark.addressDictionary!["ZIP"] as? String{
                                self.sing.zip = zip
                                if let locationName = placeMark?.addressDictionary?["Name"] as? String {
                                    self.sing.locationName = locationName
                                    if let thoroughfare = placeMark?.addressDictionary!["Thoroughfare"] as? NSString {
                                        self.sing.currentAddress = thoroughfare as String
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
}



