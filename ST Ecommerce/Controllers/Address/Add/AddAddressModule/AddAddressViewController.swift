//
//  AddAddressViewController.swift
//  ST Ecommerce
//
//  Created Hive Innovation Dev on 7/27/22.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import MapKit
import CoreLocation
import SwiftLocation

class AddAddressViewController: UIViewController,UIGestureRecognizerDelegate {
    
    // MARK: Delegate initialization
    var presenter: AddAddressViewToPresenterProtocol?
    
    // MARK: Outlets
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
    
    @IBOutlet weak var dropDownImage: UIImageView!
    
    @IBOutlet weak var heightConstraintTopView: NSLayoutConstraint!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
   
    
    // MARK: Custom initializers go here
    var profileData : Profile? = nil
    var address: Address? = nil
    var address_: Address_? = nil
    
    var fromEdit = false
    var addressId = 0
    var slug = ""
    var index = 0
    var townShipSlug = String()
    var shown = false
    var labelName = ["Home", "Work", "School", "Partner", "Gym"]
    var labelRoom = 0
    
    var townShips : [Township] = [Township]()
    var cities : [City] = [City]()
    var floors : [Floor] = [Floor]()
    var city: [CityTownShipData] = [CityTownShipData]()
    let floorDropDown = DropDown()
    let cityDropDown = DropDown()
    let townShipDropDown = DropDown()
    var selectedFloor : Floor?
    
    var panGesture = UIPanGestureRecognizer()
    var userCoordinates : CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 500
    var previousLocation: CLLocation?
    var long = Double()
    var lat = Double()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.started()
        
    }
    
    
    // MARK: Additional Helpers
    fileprivate func setupUI() {
        floorDropDownSetup()
        self.localization()
        setupShadowView()
        setupCollectoinView()
        buttonAdd.backgroundColor = .gray
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureAction(_:)))
        self.pullUpView.addGestureRecognizer(panGesture)
        Util.configureTopViewPosition(heightConstraint: heightConstraintTopView)
        
        buttonAdd.isEnabled = false
        buttonAdd.backgroundColor = UIColor(displayP3Red: 227/255, green: 224/255, blue: 224/255, alpha: 1)
        homeView.backgroundColor = UIColor().HexToColor(hexString: "#FFBB00")
        self.pullUpViewHeightConstraint.constant = 200
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
                pullUpViewHeightConstraint.constant = 200
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }

            }

            if directionVelocity.y < 0 {
                pullUpViewHeightConstraint.constant = 400
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
    
    
    
    //MARK: -- DropDownSetup
    fileprivate func floorDropDownSetup() {
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
    
    fileprivate func cityDropDownSetup(cityList: [CityTownShipData]){
        cityDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.cityDropDown.hide()
            self.textFieldCity.text = item
            self.textFieldTownShip.text = ""
            presenter?.getTownShip(citySlug: cityList[index].slug ?? "")
        }
        cityDropDown.anchorView = textFieldCity
        
        self.cityDropDown.dataSource = cityList.map({($0.name ?? "")})
        
        
    }
    
    fileprivate func townShipDropDownSetup(townShipList: [CityTownShipData]){
        townShipDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.townShipDropDown.hide()
            self.textFieldTownShip.text = item
            self.townShipSlug = townShipList[index].slug ?? ""
            Singleton.shareInstance.selectedAddress?.township_slug = self.townShipSlug
        }
        townShipDropDown.anchorView = textFieldTownShip
        
        self.townShipDropDown.dataSource = townShipList.map({($0.name ?? "")})
        if townShipList.isEmpty {
            self.dropDownImage.tintColor = .lightGray
        }else{
            self.dropDownImage.tintColor = .black
        }
        
    }
    
    //setAddressUI
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
            var region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            if fromEdit {
                region.center.latitude = Singleton.shareInstance.selectedAddress?.latitude ?? 0.0
                region.center.longitude = Singleton.shareInstance.selectedAddress?.longitude ?? 0.0
            }
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
        self.lat = mapView.centerCoordinate.latitude
        self.long = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
    //ActionButton APICall
    fileprivate func checkAddAction() {
        if fromEdit{
            self.updateAddress()
        }else{
            self.createAddress()
        }
    }
    
    fileprivate func createAddress() {
        if let selectedFloor = selectedFloor {
            presenter?.createAddress(request: AddressRequest(label: labelName[labelRoom], house_number: textFieldHouseNo.text ?? "", street_name: textFieldAddress.text ?? "", floor: selectedFloor.value, township_slug: self.townShipSlug, latitude: self.lat, longitude: self.long))
        }
       
    }
    
    fileprivate func updateAddress() {
        if let selectedFloor = selectedFloor {
            presenter?.updateAddress(request: AddressRequest(label: labelName[labelRoom], house_number: textFieldHouseNo.text ?? "", street_name: textFieldAddress.text ?? "", floor: selectedFloor.value, township_slug: self.townShipSlug, latitude: self.lat, longitude: self.long,addressSlug: slug))
        }
    }
    
    
    // MARK: User Interaction - Actions & Targets
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func townShipBtnAction(_ sender: UIButton) {
        self.townShipDropDown.show()
    }
}

// MARK: - Extension
/**
 - Documentation for purpose of extension
 */
//MARK: -- CLLocationManagerDelegate
extension AddAddressViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
//        self.lat = userLocation.coordinate.latitude
//        self.long = userLocation.coordinate.longitude
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
}


//MARK: -- MKMapViewDelegate
extension AddAddressViewController: MKMapViewDelegate {
    
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

//            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let state = placemark.postalAddress?.state ?? ""
            let city = placemark.postalAddress?.city ?? ""


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
extension AddAddressViewController {
    
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
extension AddAddressViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

// MARK: - Presenter to View
extension AddAddressViewController: AddAddressPresenterToViewProtocl {
    
    func initialControlSetup() {
        if fromEdit {
            presenter?.getOneAddress(slug: slug)
        }
        presenter?.getCity()
        self.floors = Singleton.shareInstance.floors
        checkLocationServices()
        setupUI()
    }
    
    func failAddressAlert(title: String, message: String) {
        presentAlert(title: title, message: message)
    }
    
    func setCreateAddressData(data: AddressModel) {
        if let userAddressId = data.data?.slug {
            DEFAULTS.set(userAddressId, forKey: UD_Address_Id)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addressNoti"), object: nil)
        Singleton.shareInstance.address?.append(data.data ?? Address())
        Singleton.shareInstance.addressChange = true
        Singleton.shareInstance.selectedAddress = data.data
        Singleton.shareInstance.selectedAddress?.township_slug = data.data?.township?.slug
        presenter?.updateShopAddress(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: textFieldHouseNo.text ?? "", floor: selectedFloor?.value ?? 0, street_name: textFieldAddress.text ?? "", latitude: self.lat, longitude: self.long, township_slug: self.townShipSlug))
    }
    
    func setUpdateAddressData(data: AddressModel) {
        if let userAddressId = data.data?.slug {
            Singleton.shareInstance.selectedAddress = data.data ?? Address()
            
            DEFAULTS.set(userAddressId, forKey: UD_Address_Id)
            
            let message = data.message ?? ""
            presenter?.updateShopAddress(request: UpdateAddressRequest(customer_slug: Singleton.shareInstance.userProfile?.slug ?? "", house_number: textFieldHouseNo.text ?? "", floor: selectedFloor?.value ?? 0, street_name: textFieldAddress.text ?? "", latitude: self.lat, longitude: self.long, township_slug: self.townShipSlug))
            
            let editedIndex = Singleton.shareInstance.address?.firstIndex { $0.slug == userAddressId }
            if let editedIndex = editedIndex,
               let editedAddress = data.data {
                Singleton.shareInstance.address?[editedIndex] = editedAddress
                Singleton.shareInstance.selectedAddress = editedAddress
                Singleton.shareInstance.selectedAddress?.township_slug = editedAddress.township?.slug
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
    }
    

    func setUpdateShopAddressData(data: ShopUpdateAddressModel) {
        Singleton.shareInstance.productOrder = data.data
        Singleton.shareInstance.selectedAddress?.township_slug = data.data?.address?.township_slug
        self.navigationController?.popViewController(animated: true)
    }
    
    func setGetOneAddressData(data: AddressModel) {
        setData(data: data.data ?? Address())
    }
    
    //MARK: -- Set Data
    fileprivate func setData(data: Address) {
        if fromEdit{
            let selectedFloor = floors.filter { (Floor) -> Bool in
                return Floor.value == data.floor
            }
            if data.township?.slug != nil {
                self.townShipSlug = data.township?.slug ?? ""
            }
            self.selectedFloor = selectedFloor[0]
            self.textFieldFloor.text = selectedFloor[0].name
            self.textFieldCity.text = data.township?.city?.name
            self.textFieldHouseNo.text = data.house_number
            self.textFieldAddress.text = data.street_name
            self.textFieldTownShip.text = data.township?.name
            for i in 0..<labelName.count {
                if labelName[i] == data.label {
                    labelRoom = i
                    collection.reloadData()
                }
            }
        
        }else{
            checkUserCoordinates()
        }
    }
    
    
    func setCity(data: CityTownShipModel) {
        self.city = data.data ?? [CityTownShipData]()
        cityDropDownSetup(cityList: self.city)
        
    }
    
    func setTownShip(data: CityTownShipModel) {
        let townShipData = data.data ?? [CityTownShipData]()
        townShipDropDownSetup(townShipList: townShipData)
    }
    
    
}
