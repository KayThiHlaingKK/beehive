//
//  VC_Add_Address.swift
//  ST Ecommerce
//
//  Created by necixy on 27/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Mapbox
import SwiftLocation
import CoreLocation
import JGProgressHUD
import MapKit

import DropDown

protocol MapDragEndDelegate : NSObjectProtocol {
    func mapDragEnd()
}

class VC_Add_Address: UIViewController,UIGestureRecognizerDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var textFieldNote: UITextField!
    @IBOutlet weak var textFieldFloor: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldTownShip: UITextField!
    @IBOutlet weak var textFieldHouseNo: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    
//    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var mapView: MKMapView!
   
    @IBOutlet weak var buttonFloor: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var workView: UIView!
    @IBOutlet weak var schoolView: UIView!
    @IBOutlet weak var partnerView: UIView!
    @IBOutlet weak var gymView: UIView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var pullUpView: UIView!
    
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    //    var sing = Singleton.shareInstance
    let hud = JGProgressHUD(style: .dark)
    var profileData : Profile? = nil
    var address: Address? = nil
    var address_: Address_? = nil
    var userCoordinates : CLLocationCoordinate2D?
    var fromEdit = false
    var addressId = 0
    var slug = ""
    var townShips : [Township] = [Township]()
    var cities : [City] = [City]()
    var floors : [Floor] = [Floor]()
    var city: [CityTownShipData] = [CityTownShipData]()
    let floorDropDown = DropDown()
    let cityDropDown = DropDown()
    var selectedFloor : Floor?
    var shown = false
    var labelName = ["Home", "Work", "School", "Partner", "Gym"]
    var labelRoom = 0
    var panGesture = UIPanGestureRecognizer()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 500
    var previousLocation: CLLocation?
   
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.floors = Singleton.shareInstance.floors
        checkLocationServices()
        setupUI()
        setData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupUI()
    }
    
    
    //MARK: -- SetupUI
    fileprivate func setupUI() {
        dropDownSetup()
        self.localization()
        setupShadowView()
        setupCollectoinView()
        checkUserCoordinates()
        buttonAdd.backgroundColor = .gray
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(_:)))
        self.pullUpView.addGestureRecognizer(panGesture)
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        
        buttonAdd.isEnabled = false
        buttonAdd.backgroundColor = UIColor(displayP3Red: 227/255, green: 224/255, blue: 224/255, alpha: 1)
        homeView.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
        self.pullUpViewHeightConstraint.constant = 380
    }
    
    fileprivate func checkUserCoordinates() {
        if self.userCoordinates == nil{
            getUserCurrentLocation()
            self.addLocationPermissionObserver()
        }else{
            setAddressInUI()
        }
    }
    
    fileprivate func setupShadowView() {
        homeView.addShadow()
        workView.addShadow()
        schoolView.addShadow()
        partnerView.addShadow()
        gymView.addShadow()
    }
    
    //MARK: -- Set Data
    fileprivate func setData() {
        if fromEdit{
            let selectedFloor = floors.filter { (Floor) -> Bool in
                return Floor.value == address?.floor
            }
            print("select floor = " , selectedFloor)
            
            self.selectedFloor = selectedFloor[0]
            self.textFieldFloor.text = selectedFloor[0].name
            self.textFieldHouseNo.text = address?.house_number
            self.textFieldAddress.text = address?.street_name
            for i in 0..<labelName.count {
                if labelName[i] == address?.label {
                    labelRoom = i
                    collection.reloadData()
                }
            }
        
        }
    }
    
    //SetupCollectionView
    func setupCollectoinView() {
        collection.delegate = self
        collection.dataSource = self
    }
    
    
    //PanGestureAction
    @objc func panGestureAction(_ gestureRecognizer : UIPanGestureRecognizer) {

        guard gestureRecognizer.view != nil else {return}

        let directionVelocity = gestureRecognizer.velocity(in: pullUpView)
        switch gestureRecognizer.state {

        case .began :
            break
        case .changed:
            if directionVelocity.y > 0 {
                print("swipe down")
                pullUpViewHeightConstraint.constant = 350
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }

            }

            if directionVelocity.y < 0 {
                pullUpViewHeightConstraint.constant = 550
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }

            }
            break
        case .ended :
            print("end")
        default:
            break
        }

    }
    
    
    
    
    func dropDownSetup() {
        flowDropDownSetup()
        cityDropDownSetup()
    }
    
    fileprivate func flowDropDownSetup() {
        floorDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.floorDropDown.hide()
            self.selectedFloor = self.floors[index]
            self.textFieldFloor.text = item
        }
        floorDropDown.anchorView = textFieldFloor
        
        self.floorDropDown.dataSource = self.floors.map({($0.name )})
        self.textFieldFloor.text = self.floors[0].name
        self.selectedFloor = self.floors[0]
    }
    
    fileprivate func cityDropDownSetup(){
        cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cityDropDown.hide()
            self.textFieldCity.text = item
        }
        cityDropDown.anchorView = textFieldCity
        
        self.cityDropDown.dataSource = self.city.map({($0.name ?? "")})
//        self.textFieldCity.text = self.city[0].name
    }
    
    func setAddressInUI(){

        if let coordinate = self.userCoordinates {

            Util.getAddressFromLatLng(lat: coordinate.latitude, long: coordinate.longitude) { (address) in

                let formattedAddress = " \(address.title ?? ""),\(address.address1 ?? "")\(address.address2 ?? "")\(address.city ?? ""), \(address.state ?? "")"
                print("formattedAddress = " , formattedAddress)

                DispatchQueue.main.async {
                    self.textFieldAddress.text = formattedAddress
                }
            }
        }
    }
    
    func localization(){
        buttonAdd.setTitle(saveText, for: .normal)
        if fromEdit{
            buttonAdd.setTitle(UpdateText, for: .normal)
        }
    }

    
    //MARK: - Helping Functions LocationManager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            startTackingUserLocation()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            startTackingUserLocation()
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    //MARK: - Action Functions
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func checkAddAction() {
        if fromEdit{
            self.updateAddress(addressSlug: slug)
            
        }else{
            self.addAddress()
        }
    }
    
    @IBAction func add(_ sender: UIButton) {
        checkAddAction()
    }
    
    @IBAction func floor(_ sender: UIButton) {
        self.floorDropDown.show()
    }
    
    @IBAction func cityBtnAction(_ sender: UIButton) {
        self.cityDropDown.show()
    }
    
}

//MARK: - API callings
extension VC_Add_Address {
   
    func addAddress(){
        print("add Address")
        
        if let selectedFloor = self.selectedFloor{
            
            let param : [String:Any] = [
                "label": labelName[labelRoom],
                "house_number": textFieldHouseNo.text ?? "",
                "street_name": textFieldAddress.text ?? "",
                "floor": selectedFloor.value,
                "latitude": userCoordinates?.latitude ?? 0.0,
                "longitude": userCoordinates?.longitude ?? 0.0
            ]
            print("param \(param)")
            self.showHud(message: loadingText)
            
            APIUtils.APICall(postName: APIEndPoint.Address.caseValue, method: .post, parameters: param, controller: self, onSuccess: { (response) in
                
                self.hideHud()
                let data = response as! NSDictionary
                let status = data[key_status] as? Int
                
                if status == 201 {
                    print("success === " , data)
                    
                    let address = data.value(forKeyPath: "data") as? NSDictionary ?? [:]
                    print("address === " , address)
                    
                    APIUtils.prepareModalFromData(address, apiName: APIEndPoint.Address.caseValue, modelName: "Address", onSuccess: { (addressModel) in
                        print("address modal = " , addressModel)
                        let addressModal  = addressModel as? Address ?? nil
                        if let userAddressId = addressModal?.slug {
                            
                            DEFAULTS.set(userAddressId, forKey: UD_Address_Id)
                            
                            _ = data.value(forKey: key_message) as? String ?? ""
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "addressNoti"), object: nil)
                            Singleton.shareInstance.selectedAddress = addressModal
                            Singleton.shareInstance.address?.append(addressModal!)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }) { (error, reason) in
                        print("error \(String(describing: error)), reason \(reason)")
                    }
                    
                }
                
                else{
                    self.showNeedToLoginApp()
                   
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
                
            }
        }else{
            self.hideHud()
            self.presentAlert(title: app_name, message: selectFloorText)
        }
        
    }
    
    func updateAddress(addressSlug: String){
        
        print("update address")
        
        
        if let selectedFloor = self.selectedFloor{
            
            let lat = userCoordinates?.latitude
            let long = userCoordinates?.longitude
            
            let param : [String:Any] = ["label": labelName[labelRoom],
                                        "house_number": textFieldHouseNo.text ?? "",
                                        "street_name": textFieldAddress.text ?? "",
                                        "floor": selectedFloor.value,
                                        "latitude": lat ?? 0.0,
                                        "longitude": long ?? 0.0]
            print("param ===  \(param)")
            self.showHud(message: loadingText)
            
            APIUtils.APICall(postName: "\(APIEndPoint.Address.caseValue)/\(addressSlug)", method: .put, parameters: param, controller: self, onSuccess: { (response) in
                
                self.hideHud()
                let data = response as! NSDictionary
                let status = data[key_status] as? Int
                
                if status == 200{
                    
                    let address = data.value(forKeyPath: "data") as? NSDictionary ?? [:]
                    
                    APIUtils.prepareModalFromData(address, apiName: APIEndPoint.Address.caseValue, modelName: "Address", onSuccess: { (addressModel) in
                        let addressModal  = addressModel as? Address ?? nil
                        
                        if let userAddressId = addressModal?.slug {
                            
                            DEFAULTS.set(userAddressId, forKey: UD_Address_Id)
                            
                            let message = data.value(forKey: key_message) as? String ?? ""
                            
                            let editedIndex = Singleton.shareInstance.address?.firstIndex { $0.slug == userAddressId }
                            if let editedIndex = editedIndex,
                               let editedAddress = addressModal {
                                Singleton.shareInstance.address?[editedIndex] = editedAddress
                            }
                            
                            self.presentAlertWithTitle(title: successText, message: message, options: okayText) { (option) in
                                
                                switch(option) {
                                case 0:
                                    self.navigationController?.popViewController(animated: true)
                                default:
                                    break
                                }
                            }
                            
                        }
                        
                    }) { (error, reason) in
                        print("error \(String(describing: error)), reason \(reason)")
                    }
                }else{
                    
                    let message = data[key_message] as? String ?? serverError
                    self.presentAlert(title: errorText, message: message)
                }
                
            }) { (reason, statusCode) in
                self.hideHud()
            }
        }
        else{
            self.hideHud()
            self.presentAlert(title: app_name, message: selectFloorText)
        }
    }
    
}



//MARK: -- CLLocationManagerDelegate
extension VC_Add_Address: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        userCoordinates?.longitude = userLocation.coordinate.longitude
        userCoordinates?.latitude = userLocation.coordinate.latitude
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
}


//MARK: -- MKMapViewDelegate
extension VC_Add_Address: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }

            if let _ = error {
                //TODO: Show alert informing the user
                return
            }

            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }

            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let state = placemark.postalAddress?.state ?? ""
            let city = placemark.postalAddress?.city ?? ""
//            let country = placemark.postalAddress?.country ?? ""

            DispatchQueue.main.async {
                self.self.textFieldAddress.text = "\(streetName),\(city),\(state)"
            }
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        buttonAdd.isEnabled = true
        buttonAdd.backgroundColor = UIColor(displayP3Red: 255/255, green: 187/255, blue: 0/255, alpha: 1)
    }
}


//MARK: -- GetUserCurrentLocation
extension VC_Add_Address {
    
    func getUserCurrentLocation(){
        
        LocationManager.shared.locateFromGPS(.oneShot, accuracy: .room) { result in
            switch result {
            case .failure(let error):
                debugPrint("Received error: \(error)")
                switch error {
                case . requiredLocationNotFound( _, let lastLocation):
                    if let location = lastLocation{
                        Singleton.shareInstance.userCurrentCoordinates = location.coordinate
                        self.userCoordinates = location.coordinate
                        self.setAddressInUI()
                    }
                    
                default:
                    break
                }
            case .success(let location):
                debugPrint("Location received: \(location)")
                
                Singleton.shareInstance.userCurrentCoordinates = location.coordinate
                self.userCoordinates = location.coordinate
                self.setAddressInUI()
                
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
    
}

//MARK: -- UICollectionView DataSource & Delegate
extension VC_Add_Address: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        labelName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LabelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCollectionViewCell", for: indexPath) as! LabelCollectionViewCell
        cell.nameLbl.text = labelName[indexPath.row]
        cell.imgView.image = UIImage(named: labelName[indexPath.row])
        
        cell.bgView.addShadow()
        
        if labelRoom == indexPath.row {
            cell.bgView.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
        }
        else {
            cell.bgView.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.allowsSelection = true
        let cell : LabelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCollectionViewCell", for: indexPath) as! LabelCollectionViewCell
        cell.bgView.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
        labelRoom = indexPath.row
        collection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell : LabelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCollectionViewCell", for: indexPath) as! LabelCollectionViewCell
        cell.bgView.backgroundColor = UIColor.white
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collection?.collectionViewLayout.invalidateLayout()

    }

}












