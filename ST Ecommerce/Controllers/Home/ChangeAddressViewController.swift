//
//  ChangeAddressViewController.swift
//  ST Ecommerce
//
//  Created by Hive Innovation on 16/09/2021.
//  Copyright © 2021 Shashi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol ChangeAddressDelegate: AnyObject {
    var  addressLabel: UILabel { get }
    func hideChangeAddress()
    func useCurrentLocation()
    func createNewAddress()
    func useSelectedLocation()
    func changeLocation()
    func refetchData()
    func getAddressFromCoordinate(latitude: String, longitude: String)
}

class ChangeAddressViewController: UIViewController {
    
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgWhiteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    
    var addressList: [Address] = []
    let locationManager = CLLocationManager()
    var firstTime = true
    var controller: UIViewController!
    
    // MARK: View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        controller = self.parent
        setupUI()
        loadUserAddressFromServer()
    }
    
    
//    override func viewDidLoad() {
//        NotificationCenter.default.addObserver(self, selector: #selector(disconnectPaxiSocket(_:)), name: Notification.Name(rawValue: "addressNoti"), object: nil)
//    }
    
    // MARK: UISetup
    fileprivate func setupUI() {
        firstTime = true
        setupTableView()
        locationManagerSetup()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(tapGesture)
        self.addressList = Singleton.shareInstance.address ?? []
        if addressList.count > 0 {
            let rowSize = self.addressList.count * 80
            self.tableHeightConstraint.constant = CGFloat(rowSize + 180)
        }
        else {
            self.tableHeightConstraint.constant = 200.0
        }
        self.addressTableView.reloadData()
    }
    
    fileprivate func locationManagerSetup() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.distanceFilter = 5
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    fileprivate func setupTableView() {
        addressTableView.dataSource = self
        addressTableView.delegate = self
        addressTableView.tag = 1
        addressTableView.estimatedRowHeight = 80
        addressTableView.estimatedSectionHeaderHeight = 40
        addressTableView.estimatedRowHeight = 50
    }
    
    @objc func disconnectPaxiSocket(_ notification: Notification) {
        print("discounnectpaxi")
        loadUserAddressFromServer()
    }
    
    @objc func dismissController() {
        if let parent = self.parent as? ChangeAddressDelegate {
            parent.hideChangeAddress()
        }
    }
    
    
    func loadNearestAddress(){
        print(Singleton.shareInstance.currentLat)
        APIClient.fetchNearestAddress(lat: Singleton.shareInstance.currentLat, long: Singleton.shareInstance.currentLong).execute(onSuccess: { data in
            if data.status == 200 {
                self.loadUserAddressFromServer()
                if let data = data.data {
                    Singleton.shareInstance.selectedAddress = data
                    Singleton.shareInstance.selectedAddress?.township_slug = data.township?.slug
                    if let parent = self.parent as? VC_Home {
                        let add = Util.getFormattedAddress(address: data)
                        parent.labelAddress.text = add// add.trunc(length: 100)
                        Singleton.shareInstance.currentAddress = add
                        parent.hideChangeAddress()
                        return
                    } else if
                        let parent = self.parent as? ChangeAddressDelegate {
                        let add = Util.getFormattedAddress(address: data)
                        parent.addressLabel.text = add//.trunc(length:35)
                        Singleton.shareInstance.currentAddress = add
                        parent.hideChangeAddress()
                        return
                    }
                    self.addressTableView.reloadData()
                }else{
                    self.getCurrentAddress()
                    if let parent = self.parent as? ChangeAddressDelegate {
                        parent.hideChangeAddress()
                    }
                }
                
            }else{
                self.getCurrentAddress()
                if let parent = self.parent as? ChangeAddressDelegate {
                    parent.hideChangeAddress()
                }
            }
        }, onFailure: { error in
            print(error.localizedDescription)
            self.getCurrentAddress()
            if let parent = self.parent as? ChangeAddressDelegate {
                parent.hideChangeAddress()
            }
        })
        
    }
    
    
    func getCurrentAddress() {
        if let parent = self.parent as? VC_Home {
            Singleton.shareInstance.addressChange = true
            CustomUserDefaults.shared.removeAll()
            parent.getAddressFromLatLon(pdblLatitude: "\(Singleton.shareInstance.currentLat)", withLongitude: "\(Singleton.shareInstance.currentLong)")
            
            if self.firstTime {
//                parent.loadHomeSuggestionsFromServer()
//                parent.loadNewArrivalFromServer()
                
            }
            parent.checkToRequest()
        }
        
        if let parent = self.parent as? ChangeAddressDelegate{
            parent.changeLocation()
        }
    }

    func loadUserAddressFromServer() {
        APIClient.fetchGetAddress().execute(onSuccess: { data in
            if data.status == 200 {
                Singleton.shareInstance.address = data.data ?? []
                self.addressList = Singleton.shareInstance.address ?? []
                print("address count = " , self.addressList.count)

                if self.addressList.count > 0 {
                    let rowSize = self.addressList.count * 80
                    self.tableHeightConstraint.constant = CGFloat(rowSize + 90)
                }

                if self.addressList.count == 0 {
                    self.tableHeightConstraint.constant = 120.0
                }
                
                self.addressTableView.reloadData()
            }

        }, onFailure: { error in
            print(error)
        })
    }
    
    @objc func useCurrentLocation(){
        Singleton.shareInstance.selectedAddress = nil
        loadNearestAddress()
    }
    
    @objc func createAddress(){
        if readLogin() != 0 {
            if let parent = self.parent as? ChangeAddressDelegate {
                parent.createNewAddress()
            }
        }
        else {
            showNeedToLoginApp()
        }
    }
    
    @objc func closePopup(tapGestureRecognizer: UITapGestureRecognizer){
        if let parent = self.parent as? ChangeAddressDelegate {
            parent.hideChangeAddress()
        }
    }
    
}

extension ChangeAddressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shareInstance.address?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        
        let address = Singleton.shareInstance.address?[indexPath.row]
        
        cell.lableLbl.text = address?.label
        cell.addressLbl.text = Util.getFormattedAddress(address: address ?? Address())
        if Singleton.shareInstance.selectedAddress?.slug == address?.slug {
            cell.optionImage?.image = #imageLiteral(resourceName: "option_on")
            cell.subView.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
            
        }
        else {
            cell.optionImage?.image = #imageLiteral(resourceName: "option_off")
            cell.subView.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("change default" , indexPath.row)
        CustomUserDefaults.shared.removeAll()
        Singleton.shareInstance.address = addressList
        Singleton.shareInstance.selectedAddress = addressList[indexPath.row]
        Singleton.shareInstance.selectedAddress?.township_slug = addressList[indexPath.row].township?.slug
        let address = addressList[indexPath.row]
        addressTableView.reloadData()
        updateAddressAPICall(request: AddressRequest(label: address.label ?? "", house_number: address.house_number ?? "", street_name: address.street_name ?? "", floor: address.floor ?? 0, township_slug: address.township?.slug ?? "", latitude: address.latitude ?? 0.0, longitude: address.longitude ?? 0.0, addressSlug: address.slug ?? ""))
        updateFoodAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: address.house_number ?? "", floor: address.floor ?? 0, street_name: address.street_name ?? "", latitude: address.latitude ?? 0.0, longitude: address.longitude ?? 0.0, township_slug: address.township?.slug ?? ""))
        updateShopAddressAPICall(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: address.house_number ?? "", floor: address.floor ?? 0, street_name: address.street_name ?? "", latitude: address.latitude ?? 0.0, longitude: address.longitude ?? 0.0, township_slug: address.township?.slug ?? ""))
        if let parent = self.parent as? ChangeAddressDelegate{
            parent.changeLocation()
        }
    }
    
    func updateAddressAPICall(request: AddressRequest) {
        APIClient.fetchUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
                Singleton.shareInstance.selectedAddress = data.data
            }
        }, onFailure: { error in
            print("Error")
        })
    }
    
    func updateShopAddressAPICall(request: UpdateAddressRequest) {
        APIClient.fetchShopUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
                Singleton.shareInstance.selectedAddress?.township_slug = data.data?.address?.township_slug
            }
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }

    
    func updateFoodAddressAPICall(request: UpdateAddressRequest) {
        APIClient.fetchFoodUpdateAddress(request: request).execute(onSuccess: { data in
            if data.status == 200 {
//                Singleton.shareInstance.selectedAddress = data.data?.address
            }
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableHeaderCell") as! AddressTableHeaderCell
        cell.subView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.useCurrentLocation))
        cell.subView.addGestureRecognizer(tap)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableFooterCell") as! AddressTableFooterCell
        cell.subView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.createAddress))
        cell.subView.addGestureRecognizer(tap)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}
extension ChangeAddressViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        Singleton.shareInstance.currentLat = locValue.latitude
        Singleton.shareInstance.currentLong = locValue.longitude
        
        if let parent = self.parent as? VC_Home {
            parent.getAddressFromLatLon(pdblLatitude: "\(locValue.latitude)", withLongitude: "\(locValue.longitude)")
        }
        
        
        if readLogin() != 0 {
//            print("load nearest " , Singleton.shareInstance.selectedAddress)
            if Singleton.shareInstance.selectedAddress != nil {
                return
            }
            self.loadNearestAddress()
        }
        else {
            print("get current")
            if Singleton.shareInstance.selectedAddress != nil {
                return
            }
//            self.getCurrentAddress()
            if self.addressList.count == 0 {
                self.tableHeightConstraint.constant = 120.0 * 2
                self.addressTableView.reloadData()
            }
            if let parent = self.parent as? VC_Home {
                parent.getAddressFromLatLon(pdblLatitude: "\(Singleton.shareInstance.currentLat)", withLongitude: "\(Singleton.shareInstance.currentLong)")
                parent.loadHomeSuggestionsFromServer()
                parent.loadNewArrivalFromServer()
                parent.loadStoreCategoriesFromServer()
            }
            self.firstTime = false
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    

}
