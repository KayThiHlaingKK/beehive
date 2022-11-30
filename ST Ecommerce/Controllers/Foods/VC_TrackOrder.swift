//
//  VC_TrackOrder.swift
//  ST Ecommerce
//
//  Created by Necixy on 30/10/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections
import CoreLocation
import Cosmos
import JGProgressHUD

protocol TrackOrderDelegate : NSObjectProtocol {
    func orderDelivered(message:String)
}

class VC_TrackOrder: UIViewController {
    
    //MARK: - IBoutlets
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblRestroName: UILabel!
    @IBOutlet weak var lblRestroInfo: UILabel!
    @IBOutlet weak var imgViewRestro: UIImageView!
    
    @IBOutlet weak var imgViewDeliveryPerson: UIImageView!
    @IBOutlet weak var lblDeliveryPersonName: UILabel!
    @IBOutlet weak var lblDeliveryPersonInfo: UILabel!
    
    @IBOutlet weak var ratingViewDeliveryPerson: CosmosView!
    @IBOutlet weak var btnCall: UIButton!
    
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var viewETA: GradientView!
    
    //MARK: - variables
    var orderId = Int()
    let directions = Directions.shared
    var trackOrder : TrackOrder?
    var restroCoordinate = CLLocationCoordinate2D()
    var userCoordinate = CLLocationCoordinate2D()
    var driverCoordinate = CLLocationCoordinate2D()
    let hud = JGProgressHUD(style: .dark)
    var trackerTimer: Timer?
    var isFirstLoad = true
    var routeLine = MGLPolyline()
    var delegate : TrackOrderDelegate?
    
    
    //MARK: - Internal Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        dataSource()
        
        self.mapView.delegate = self
        
        self.trackerTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.getTrackingData(orderNo: self.orderId)
        }
        
        self.getTrackingData(orderNo: orderId)
     
        self.viewETA.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        trackerTimer?.invalidate()
    }
    
    //MARK: - Functions
    
    func setData(){
        
        //Restro
        imgViewRestro.setIndicatorStyle(.gray)
        imgViewRestro.setShowActivityIndicator(true)
        imgViewRestro.sd_setImage(with: URL(string: self.trackOrder?.restaurant?.logo ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
            self.imgViewRestro.setShowActivityIndicator(false)
        }
        lblOrderNumber.text = "Order no: \(self.self.trackOrder?.orderSerial ?? "")"
        lblRestroName.text = self.trackOrder?.restaurant?.name ?? ""
        imgViewDeliveryPerson.setIndicatorStyle(.gray)
        imgViewDeliveryPerson.setShowActivityIndicator(true)
        imgViewDeliveryPerson.sd_setImage(with: URL(string: self.trackOrder?.driver?.profilePic ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
            self.imgViewDeliveryPerson.setShowActivityIndicator(false)
        }
        
        lblDeliveryPersonName.text = self.trackOrder?.driver?.name ?? ""
        ratingViewDeliveryPerson.rating = Double(self.trackOrder?.driver?.rating ?? 0)
    }
    
    func addUserMarker(){
        let user = MGLPointAnnotation()
        user.coordinate = userCoordinate
        user.title = self.trackOrder?.user?.name ?? ""
        mapView.addAnnotation(user)
    }
    
    func addDriverMarker(){
        let driver = MGLPointAnnotation()
        driver.coordinate = driverCoordinate
        driver.title = self.trackOrder?.driver?.name ?? ""
        mapView.addAnnotation(driver)
    }
    
    func addRestroMarker(){
        let restro = MGLPointAnnotation()
        restro.coordinate = restroCoordinate
        restro.title = self.trackOrder?.restaurant?.name ?? ""
        mapView.addAnnotation(restro)
    }
    
    func makeRouteOption(firstCoordinate:CLLocationCoordinate2D, secondCoordinate:CLLocationCoordinate2D){
        
        let waypoints = [
            Waypoint(coordinate: firstCoordinate, name: self.trackOrder?.user?.name ?? ""),
            Waypoint(coordinate: secondCoordinate, name: self.trackOrder?.driver?.name ?? ""),
        ]
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
        options.includesSteps = true
        
        /*let task = */directions.calculate(options) { (session, result) in
            switch result {
            case .failure(let error):
                print("Error calculating directions: \(error)")
            case .success(let response):
                guard let route = response.routes?.first, let leg = route.legs.first else {
                    return
                }
                
                print("response.routes?.count \(response.routes?.count ?? 0)")
                
                print("response.waypoints?.count \(response.waypoints?.count ?? 0)")
                print("Route via \(leg):")
                
                self.drawRoute(route: route)
                
                let distanceFormatter = LengthFormatter()
                let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
                
                let travelTimeFormatter = DateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .short
                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
                
                print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                
                self.lblETA.text = formattedTravelTime
                
                for step in leg.steps {
                    print("\(step.instructions)")
                    let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
                    print("— \(formattedDistance) —")
                }
            }
        }
    }
    
    func drawRoute(route:Route){
        
        if var routeCoordinates = route.shape?.coordinates, routeCoordinates.count > 0 {
            // Convert the route’s coordinates into a polyline.
            self.routeLine = MGLPolyline(coordinates: &routeCoordinates, count: UInt(routeCoordinates.count))
            
            // Add the polyline to the map.
            mapView.addAnnotation(routeLine)
            
            // Fit the viewport to the polyline.
            let camera = mapView.cameraThatFitsShape(routeLine, direction: 0, edgePadding: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40))
            mapView.setCamera(camera, animated: true)
        }
    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func addMarkers(){
        
        self.mapView.removeAnnotation(self.routeLine)
        if let allmarkers = self.mapView.annotations { if !allmarkers.isEmpty { self.mapView.removeAnnotations(allmarkers)
        }}
        
        self.addDriverMarker()
        self.addRestroMarker()
        self.addUserMarker()
        
    }
    
    func showPathBetweenDriverAndRestro(){
        self.makeRouteOption(firstCoordinate: self.driverCoordinate, secondCoordinate: self.restroCoordinate)
        self.setData()
    }
    
    func showPathBetweenDriverAndUser(){

        self.makeRouteOption(firstCoordinate: self.driverCoordinate, secondCoordinate: self.userCoordinate)
        self.setData()
    }
    
    
    //MARK: - Action function
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reload(_ sender: UIButton) {
        
        self.getTrackingData(orderNo: self.orderId)
    }
    
    @IBAction func callDeliveryPerson(_ sender: UIButton) {
        
        if let deliveryPersonNumber = self.trackOrder?.driver?.phone{
            dialNumber(number: deliveryPersonNumber)
        }else{
            self.presentAlertWithTitle(title: "Alert", message: "Phone number not available", options: "Ok") { (value) in
                
            }
        }
    }
    
    //MARK; - API calling
    func getTrackingData(orderNo:Int){
        
        if isFirstLoad{
            self.showHud(message: loadingText)
        }
        APIUtils.APICall(postName: "\(APIEndPoint.orderPathRestro.caseValue)\(orderNo)\(APIEndPoint.trackOrder.caseValue)", method: .get,  parameters: [:], controller: self, onSuccess: { (response) in
            
            if self.isFirstLoad{
                self.hideHud()
            }
            
            self.isFirstLoad = false
            let data = response as! NSDictionary
            let status = data.value(forKey: key_status) as? Bool ?? false
            
            if status{
                if let data = data.value(forKeyPath: "data.order") as? NSDictionary{
                    
                    APIUtils.prepareModalFromData(data, apiName: APIEndPoint.trackOrder.caseValue, modelName: "TrackOrder", onSuccess: { (anyData) in
                        
                        self.viewETA.isHidden = true
                        if let trackO = anyData as? TrackOrder{
                            self.trackOrder = trackO
                            
                            self.restroCoordinate = CLLocationCoordinate2D(latitude: Double(self.trackOrder?.restaurant?.latitude ?? "") ?? 0, longitude: Double(self.trackOrder?.restaurant?.longitude ?? "") ?? 0)
                            
                            self.userCoordinate =  CLLocationCoordinate2D(latitude: Double(self.trackOrder?.user?.latitude ?? "") ?? 0, longitude: Double(self.trackOrder?.user?.longitude ?? "") ?? 0)
                            
                            self.driverCoordinate =  CLLocationCoordinate2D(latitude: Double(self.trackOrder?.driver?.latitude ?? "") ?? 0, longitude: Double(self.trackOrder?.driver?.longitude ?? "") ?? 0)
                            
                            
                            self.addMarkers()
                            
                            if let status = self.trackOrder?.status{
                                print("tracking status \(status)")
                                if status.lowercased() == "pending"{
                                    self.lblRestroInfo.text = "Your Order is pending."
                                    self.lblDeliveryPersonInfo.text = ""
                                    
                                    self.showPathBetweenDriverAndRestro()
                                }
                                else if status.lowercased() == "preparing"{
                                    self.lblRestroInfo.text = "Your Order is being prepared."
                                    self.lblDeliveryPersonInfo.text = "Driver is on the way to restaurant."
                                    self.showPathBetweenDriverAndRestro()
                                }
                                else if status.lowercased() == "ready to pickup"{
                                    self.lblRestroInfo.text = "Your Order is ready to pickup."
                                    self.lblDeliveryPersonInfo.text = "Driver is on the way to restaurant."
                                    self.showPathBetweenDriverAndRestro()
                                }
                                else if status.lowercased() == "on route"{
                                    self.lblRestroInfo.text = "Order is picked by delivery partner."
                                    self.lblDeliveryPersonInfo.text = "On the way to you."
                                    self.showPathBetweenDriverAndUser()
                                    self.viewETA.isHidden = false
                                }
                                else {
                                    self.trackerTimer?.invalidate()
                                    self.lblRestroInfo.text = ""
                                    self.lblDeliveryPersonInfo.text = "Your order has been delivered."
                                }
                                
                            }
                            
                            
                        }
                        
                    }) { (errror, reason) in
                        print("error \(String(describing: errror)), reason \(reason)")
                    }
                }
                
            }
            else{
                let message = data[key_message] as? String ?? serverError
                self.trackerTimer?.invalidate()
                self.navigationController?.popViewController(animated: true)
                self.delegate?.orderDelivered(message: message)
                
                self.presentAlert(title: "Alert", message: message)
            }
            
        }) { (reason, statusCode) in
            self.hideHud()
        }
        
    }
    
}


extension VC_TrackOrder : MGLMapViewDelegate{
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // get the custom reuse identifier for this annotation
        let reuseIdentifier = reuseIdentifierForAnnotation(annotation: annotation)
        // try to reuse an existing annotation image, if it exists
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier)
        
        // if the annotation image hasn‘t been used yet, initialize it here with the reuse identifier
        if annotationImage == nil {
            // lookup the image for this annotation
            let image = imageForAnnotation(annotation: annotation)
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        }
        
        return annotationImage
    }
    
    // create a reuse identifier string by concatenating the annotation coordinate, title, subtitle
    func reuseIdentifierForAnnotation(annotation: MGLAnnotation) -> String {
        var reuseIdentifier = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        if let title = annotation.title, title != nil {
            reuseIdentifier += title!
        }
        if let subtitle = annotation.subtitle, subtitle != nil {
            reuseIdentifier += subtitle!
        }
        return reuseIdentifier
    }
    
    // lookup the image to load by switching on the annotation's title string
    func imageForAnnotation(annotation: MGLAnnotation) -> UIImage {
        var imageName = ""
        if let title = annotation.title, title != nil {
            switch title! {
            case self.trackOrder?.user?.name ?? "":
                imageName = "user_marker"
            case self.trackOrder?.driver?.name ?? "":
                imageName = "driver_marker"
            case self.trackOrder?.restaurant?.name ?? "":
                imageName = "restro_marker"
            default:
                imageName = "user_marker"
            }
        }
        // ... etc.
        return UIImage(named: imageName)!
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always allow callouts to popup when annotations are tapped.
        return true
    }
}
