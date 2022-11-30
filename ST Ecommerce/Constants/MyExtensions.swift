//
//  MyExtensions.swift
//  ST Ecommerce
//
//  Created by necixy on 03/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation
import Comets
import JGProgressHUD
import Contacts
import UIKit
import CommonCrypto
import SwiftyPlistManager

private var window: UIWindow!

extension UIAlertController {
    func present(animated: Bool, completion: (() -> Void)?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.windowLevel = .alert + 1
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: animated, completion: completion)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        window = nil
    }
}

let hud = JGProgressHUD(style: .dark)
//MARK: - UISegmentedControl Extensions
extension UISegmentedControl {
    
    
    func setTitleColor(_ color: UIColor, state: UIControl.State) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
    
    func setTitleFont(_ font: UIFont, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.font] = font
        self.setTitleTextAttributes(attributes, for: state)
    }
}

public extension UIAlertController {
    func show() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
//        vc.view.tintColor = Theme.mainAccentColor
        appDelegate.alertWindow.rootViewController = vc
        appDelegate.alertWindow.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}


//MARK: - UIViewController Extensions
extension UIViewController {
    
    
    func convertDateToString(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter.string(from: date)
    }
    
    func convertStringToDate(_ string: String, from format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        return dateFormatter.date(from: string)
    }
    
    func changeOrderDate(_ orderDate: String) -> String{
        let date = Date.getDateFormat(formatStyle: "yyyy-MM-dd HH:mm:ss", formatDate: orderDate)
        let orderDate =  Date.getDateToStringFormat(formatStyle: "dd/MM/yyyy h:mm a", formatDate: date)
        return orderDate
    }
    
    
    func getDateTime(_ time: String) -> Date{
        let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: Date())
        var dateComponents = DateComponents()
        let splitTime = time.split(separator: ":")
        let hour = Int(splitTime[0])
        let minute = Int(splitTime[1])
        let second = Int(splitTime[2])
        dateComponents.year = calendarDate.year
        dateComponents.month = calendarDate.month
        dateComponents.day = calendarDate.day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        let date = Calendar.current.date(from: dateComponents) ?? Date()
        return date
    }
    
    
    func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        
        var hour = String(calendar.component(.hour, from: date))
        var minutes = String(calendar.component(.minute, from: date))
        var seconds = String(calendar.component(.second, from: date))
        var timeString = "9:15:00"
            
        if hour.count <= 1 {
            hour = "0\(hour)"
        }
        if minutes.count <= 1 {
            minutes = "0\(minutes)"
        }
        if seconds.count <= 1 {
            seconds = "0\(seconds)"
        }
        timeString = "\(hour):\(minutes):\(seconds)"
        return timeString
    }
    
    func removeColmn(string: String) -> String {
        string.replacingOccurrences(of: ":", with: "")
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } 
    
    func showPermissionAlert(){
        let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getGoogleFormatedAddress(coordinates:CLLocationCoordinate2D, completion: @escaping (_ result: String) -> Void){
        
        var formattedAddress = ""
        let options = GeocoderRequest.GoogleOptions(APIKey: GOOGLE_API_KEY)
        
        LocationManager.shared.locateFromCoordinates(coordinates, service: .google(options)) { result in
            switch result {
            case .failure(let error):
                debugPrint("An error has occurred: \(error)")
            case .success(let places):
                formattedAddress = places.first?.formattedAddress ?? ""
                completion(formattedAddress)
            }
        }
    }
    
    //MARK: - Comet UX
    func makeCommetAndAnimate(){
        
        // Customize your comet
        let width = view.bounds.width
        let height = view.bounds.height
        let comets = [Comet(startPoint: CGPoint(x: 100, y: 0),
                            endPoint: CGPoint(x: 0, y: 100),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0.4 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.8 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0.8 * width, y: 0),
                            endPoint: CGPoint(x: width, y: 0.2 * width),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: width, y: 0.2 * height),
                            endPoint: CGPoint(x: 0, y: 0.25 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0, y: height - 0.8 * width),
                            endPoint: CGPoint(x: 0.6 * width, y: height),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: width - 100, y: height),
                            endPoint: CGPoint(x: width, y: height - 100),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white),
                      Comet(startPoint: CGPoint(x: 0, y: 0.8 * height),
                            endPoint: CGPoint(x: width, y: 0.75 * height),
                            lineColor: UIColor.white.withAlphaComponent(0.2),
                            cometColor: UIColor.white)]
        
        // draw line track and animate
        for comet in comets {
            view.layer.addSublayer(comet.drawLine())
            view.layer.addSublayer(comet.animate())
        }
    }
    
    //MARK: - Showing Login alert
    func showNeedToLoginApp(){
        
//        self.changeLoginState(newState: 0)
        
        let message = loginMessageText
        
        self.presentAlertWithTitle(title: "Hi! ", message: message, options: goBackText, needToLoginText) { (option) in
            switch(option) {
            case 0:
                self.dismiss(animated: true, completion: nil)
                Util.makeHomeRootController()
                
            case 1:
                Util.makeSignInRootController()
                
            default:
                break
            }
        }
        
    }
    
    func priceFormat(price: Int) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:price))
        
        return formattedNumber ?? ""
    }
    
    func priceFormat(pricedouble: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:pricedouble))
        
        return formattedNumber ?? ""
    }
    
   
    
    func readLogin() -> Int {
        var isLogin = 0
        SwiftyPlistManager.shared.getValue(for: UD_isUserLogin, fromPlistWithName: "notes") { (result, err) in
          if err == nil {
            print("The Value is: '\(result ?? "No Value Fetched")'")
              guard let login = result as? Int else {
                  return
              }
              isLogin = login
          }
        else {
            SwiftyPlistManager.shared.addNew(false, key: UD_isUserLogin, toPlistWithName: "notes") { (err) in
              if err == nil {
                print("Value successfully added into plist.")
              }
            }
        }
            
        }
        
        return isLogin
    }
    
    func changeLoginState(newState: Int) {
        print("login value == " , newState)
        SwiftyPlistManager.shared.save(newState, forKey: UD_isUserLogin, toPlistWithName: "notes") { (err) in
          if err == nil {
            print("Value successfully saved into plist.")
          }
            else {
                SwiftyPlistManager.shared.addNew(newState, key: UD_isUserLogin, toPlistWithName: "notes") { (err) in
                  if err == nil {
                    print("Value successfully added into plist.")
                  }
                }
            }
        }
    }
    
    func unAuthenticatedOptoin(toastMessage: String) {
        changeLoginState(newState: 0)
        writeToken(token: "")
        Util.navigateToHomeRootController(toastMessage: toastMessage)
    }
    
    func readToken() -> Any {
        
        var token: Any?
        SwiftyPlistManager.shared.getValue(for: UD_APITOKEN, fromPlistWithName: "notes") { (result, err) in
          if err == nil {
            print("The token Value is: '\(result ?? "No Value Fetched")'")
              token = result
          }
            else {
                print("token value = ", err)
                writeToken(token: "temp")
                changeLoginState(newState: 0)
            }
        }
        
        return token
    }
    
    func writeToken(token: Any) {
        print("tokkkkkk = " , token)
        SwiftyPlistManager.shared.addNew(token, key: UD_APITOKEN, toPlistWithName: "notes") { (err) in
          if err == nil {
            print("Value successfully added into plist.2")
          }
            else  {
                SwiftyPlistManager.shared.save(token, forKey: UD_APITOKEN, toPlistWithName: "notes") { (err) in
                  if err == nil {
                    print("token Value successfully saved into plist.1")
                  }
                }
            }

        }
    }
    
    
}


//MARK: - UIColor Extensions
extension UIColor {
    
    class func appDarkGrayColor() -> UIColor{
        return #colorLiteral(red: 0.4078431373, green: 0.4117647059, blue: 0.4196078431, alpha: 1)
    }
    
    class func appLightGrayColor() -> UIColor{
        return #colorLiteral(red: 0.6549019608, green: 0.6509803922, blue: 0.6470588235, alpha: 1)
    }
    
    class func appPurpleColor() -> UIColor{
        return #colorLiteral(red: 0.6352941176, green: 0.3294117647, blue: 0.4745098039, alpha: 1)
    }
    
    class func appLightYelloColor() -> UIColor{
        return #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1)
    }
    
    class func appDarkYelloColor() -> UIColor{
        return #colorLiteral(red: 1, green: 0.6745098039, blue: 0.137254902, alpha: 1)
    }
    
    class func appRedColor() -> UIColor{
        return #colorLiteral(red: 0.9764705882, green: 0.3019607843, blue: 0, alpha: 1)
    }
    
    class func appGreenColor() -> UIColor{
        return #colorLiteral(red: 0.1019607843, green: 0.6823529412, blue: 0.4823529412, alpha: 1)
    }
    
    class func appBackGroundColor() -> UIColor{
        return #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
    }
    
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}


//MARK: - UIFonnt Extensions
extension UIFont {
    
    class func latoRegular(size:CGFloat) -> UIFont{
        return UIFont.init(name: "LATO-REGULAR", size: size)!
    }
}

//MARK: - String Extensions


//MARK: - String Extensions
extension String {
    
    func localized(loc:String) ->String {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var isValidContact: Bool {
            let phoneNumberRegex = "^[6-9]\\d{7}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
            let isValidPhone = phoneTest.evaluate(with: self)
            return isValidPhone
        }
    
    
}


@IBDesignable extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue
              layer.masksToBounds = (newValue > 0)
        }
    }
    
}



extension UIView {
    enum Corner:Int {
        case bottomRight = 0,
             topRight,
             bottomLeft,
             topLeft
    }
    
    private func parseCorner(corner: Corner) -> CACornerMask.Element {
        let corners: [CACornerMask.Element] = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return corners[corner.rawValue]
    }
    
    private func createMask(corners: [Corner]) -> UInt {
        return corners.reduce(0, { (a, b) -> UInt in
            return a + parseCorner(corner: b).rawValue
        })
    }
    
    func roundCorners(corners: [Corner], amount: CGFloat = 5) {
        layer.cornerRadius = amount
        let maskedCorners: CACornerMask = CACornerMask(rawValue: createMask(corners: corners))
        layer.maskedCorners = maskedCorners
    }
    
    func dropShadow(scale: Bool = true) {
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize.init(width: 0, height: 3)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
    }
}

extension NSAttributedString {
    func withStrikeThrough(_ style: Int = 1) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.strikethroughStyle,
                                      value: style,
                                      range: NSRange(location: 0, length: string.count))
        return NSAttributedString(attributedString: attributedString)
    }
    
    func setFont(_ font: UIFont, range: NSRange? = nil)-> NSAttributedString {
        let mas = NSMutableAttributedString(attributedString: self)
        let range = range ?? NSMakeRange(0, self.length)
        mas.addAttributes([.font: font], range: range)
        return NSAttributedString(attributedString: mas)
    }


    // keeping foot, but changing size:
    func setFont(size: CGFloat, range: NSRange? = nil)-> NSAttributedString {
        let mas = NSMutableAttributedString(attributedString: self)
        let range = range ?? NSMakeRange(0, self.length)


        mas.enumerateAttribute(.font, in: range) { value, range, stop in
            if let font = value as? UIFont {
                let name = font.fontName
                let newFont = UIFont(name: name, size: size)
                mas.addAttributes([.font: newFont!], range: range)
            }
        }
        return NSAttributedString(attributedString: mas)

    }
}

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

extension UIImage {
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func upOrientationImage() -> UIImage? {
        switch imageOrientation {
        case .up:
            return self
        default:
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(in: CGRect(origin: .zero, size: size))
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return result
        }
    }
    
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
}

//MARK:- NavigationBar

extension UINavigationBar {
    func setGradientBackground(colors: [UIColor],
                               startPoint: UINavigationBarGradientView.Point = .topLeft,
                               endPoint: UINavigationBarGradientView.Point = .bottomLeft,
                               locations: [NSNumber] = [0, 1]) {
        guard let backgroundView = value(forKey: "backgroundView") as? UIView else { return }
        guard let gradientView = backgroundView.subviews.first(where: { $0 is UINavigationBarGradientView }) as? UINavigationBarGradientView else {
            let gradientView = UINavigationBarGradientView(colors: colors, startPoint: startPoint,
                                                           endPoint: endPoint, locations: locations)
            backgroundView.addSubview(gradientView)
            gradientView.setupConstraints()
            return
        }
        gradientView.set(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }
}


public enum ImageSize: String {
    case large, medium, small, xsmall, thumbnail
}



extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func downloadImage(url: String? = nil, fileName: String? = nil, size: ImageSize = ImageSize.xsmall) {
        guard let url = fileName != nil ? "\(IMAGE_DOWNLOAD_URL)/\(size.rawValue)/\(fileName!)" : url
        else {
            self.image = UIImage(named: "placeholder2")
            return
        }
//        print("IMAGEURL==\(url)")
        self.sd_setImage(with: URL(string: url), placeholderImage: #imageLiteral(resourceName: "placeholder2")) { (image, error, type, url) in
            self.setShowActivityIndicator(false)
        }
        
    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

extension UISegmentedControl{
    func selectedSegmentTintColor(Textcolor: UIColor, backgroundColor: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: Textcolor], for: .selected)
        self.backgroundColor = backgroundColor
    }
    func unselectedSegmentTintColor(Textcolor: UIColor, backgroundColor: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: Textcolor], for: .normal)
        self.backgroundColor = backgroundColor
    }
}



extension Notification.Name {
    static let didRecievedNotification = Notification.Name("didRecievedNotification")
    static let didOpenedNotification = Notification.Name("didOpenedNotification")
}



extension UIViewController {
    
    func createNewAddress() {
//        let vc : VC_Add_Address = storyboardAddress.instantiateViewController(withIdentifier: "VC_Add_Address") as! VC_Add_Address
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.pushView(AddAddressRouter())
    }
    
    func saveToUserDefault(deliTime: String, deliDateTime: String, deliMode: DeliveryMode, deliDate: DeliveryDate){
        CustomUserDefaults.shared.set(deliTime, key: .deliTime)
        CustomUserDefaults.shared.set(deliDateTime, key: .deliDateTime)
        deliMode == .delivery ? (CustomUserDefaults.shared.set("delivery", key: .deliMode)) : (CustomUserDefaults.shared.set("pickup", key: .deliMode))
        switch deliDate {
        case .today:
            CustomUserDefaults.shared.set("today", key: .deliDate)
        case .tomorrow:
            CustomUserDefaults.shared.set("tomorrow", key: .deliDate)
        case .thedayaftertomorrow:
            CustomUserDefaults.shared.set("thedayaftertomorrow", key: .deliDate)
        }
    }
    
    //GetHourString Function
    func getHourString(_ openingHourString: String) -> String{
        let dateTime = Date.getDateFormat(formatStyle: "HH:mm:ss", formatDate: openingHourString)
        let timeString = Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: dateTime)
        return timeString
    }
    
    func getClosingHourString(_ closingHourString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "HH:mm:ss"
        let temp = formatter.date(from:  closingHourString) ?? Date()
        formatter.dateFormat =  "hh:mm a"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: temp)
    }
    
    func currentTimeInMilliSeconds()-> Int
    {
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? UIViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        if let frame = frame {
            child.view.frame = frame
        }
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    var topViewController: UIViewController? {
        return self.topViewController(currentViewController: self)
    }
    
    private func topViewController(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return self.topViewController(currentViewController: selectedViewController)
        } else if let navigationController = currentViewController as? UINavigationController,
                  let visibleViewController = navigationController.visibleViewController {
            return self.topViewController(currentViewController: visibleViewController)
        } else if let presentedViewController = currentViewController.presentedViewController {
            return self.topViewController(currentViewController: presentedViewController)
        } else {
            return currentViewController
        }
    }
    
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func presentAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okayText, style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    
    func addBagde(btn:UIButton,count:Int){
        
        let badgeCount = UILabel(frame: CGRect(x: 28, y: -5, width: 20, height: 20))
        badgeCount.isHidden = true
        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = UIColor.appDarkYelloColor()
        badgeCount.text = "\(count)"
        
        btn.addSubview(badgeCount)
    }
    
    
    //MARK: - Hud
    func showHud(message:String){
        hud.textLabel.text = message
        DispatchQueue.main.async {
            hud.show(in: self.view)
        }
        
    }
    
    func hideHud(){
        hud.dismiss(animated: true)
    }
    
    func getCurrentTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: Date())
    }
    
    func getCurrentDateTimeFormat() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getScheduleTimeFormat(deliTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "hh:mm a"
        let temp = formatter.date(from:  deliTime) ?? Date()
        formatter.dateFormat =  "HH:mm:ss"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: temp)
    }
    
    func getDateOption(value: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: Calendar.current.date(byAdding: .day, value: value, to: Date()) ?? Date())
    }
    
    func getDateFormat() -> String {
        var date = ""
        switch Singleton.shareInstance.deliDate {
        case .today:
            date = getDateOption(value: 0)
        case .tomorrow:
            date = getDateOption(value: 1)
        case .thedayaftertomorrow:
            date = getDateOption(value: 2)
            
        }
        return date
    }
    
    func getTimeFormat(deliTime: String) -> String {
        var time = ""
        if Singleton.shareInstance.deliTime == "ASAP" {
            time = getCurrentTimeFormat()
        }else{
            time = getScheduleTimeFormat(deliTime: Singleton.shareInstance.deliTime)
        }
        
        return time
        
    }
    
}

extension UIView {
    func showHud(message:String){
        hud.textLabel.text = message
        DispatchQueue.main.async {
            hud.show(in: self)
        }
        
    }
    
    func hideHud(){
        hud.dismiss(animated: true)
    }
    
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UISearchBar {
    public var textField: UITextField? {
        if #available(iOS 13, *) {
            return searchTextField
        }
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    func clearBackgroundColor() {
        guard let UISearchBarBackground: AnyClass = NSClassFromString("UISearchBarBackground") else { return }
        
        for view in subviews {
            for subview in view.subviews where subview.isKind(of: UISearchBarBackground) {
                subview.alpha = 0
            }
        }
    }
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
       func setTextField(color: UIColor) {
           guard let textField = getTextField() else { return }
           switch searchBarStyle {
           case .minimal:
               textField.layer.backgroundColor = color.cgColor
               textField.layer.cornerRadius = 6
           case .prominent, .default: textField.backgroundColor = color
           @unknown default: break
           }
       }
}

extension UINavigationController
{
    /// Given the kind of a (UIViewController subclass),
    /// removes any matching instances from self's
    /// viewControllers array.

    func removeAnyViewControllers(ofKind kind: AnyClass)
    {
        self.viewControllers = self.viewControllers.filter { !$0.isKind(of: kind)}
    }

    /// Given the kind of a (UIViewController subclass),
    /// returns true if self's viewControllers array contains at
    /// least one matching instance.

    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
}


extension UIWindow {

    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }

    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom(vc: navigationController.visibleViewController!)
            
        } else if vc.isKind(of: UITabBarController.self) {
            
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            
        } else {
            
            if let presentedViewController = vc.presentedViewController {
                
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController.presentedViewController!)
                
            } else {
                
                return vc;
            }
        }
    }

}

extension UIApplication {

    func clearLaunchScreenCache() {
            do {
                let launchScreenPath = "\(NSHomeDirectory())/Library/SplashBoard"
                try FileManager.default.removeItem(atPath: launchScreenPath)
            } catch {
                print("Failed to delete launch screen cache - \(error)")
            }
        }
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }

    class func topNavigation(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {

        if let nav = viewController as? UINavigationController {
            return nav
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return selected.navigationController
            }
        }
        return viewController?.navigationController
    }
}

extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

public extension String {
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return stringData.sha256()
        }
        return ""
    }
    
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    func convertStringToDate(format: String? = "d MMM yyyy") -> String {
        let dateString = self
        let strArray = dateString.split(separator: ".")
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        if let date = dateFormatter.date(from: String(strArray[0])) {
            dateFormatter.dateFormat = format
            dateFormatter.locale = tempLocale
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            return dateFormatter.string(from: date)
        }
        return "Invalid Date Format"
    }
    
    func convertDateStringFormat(from format1: String? = "yyyy-MM-dd'T'HH:mm:ss", to format2: String? = "d MMM yyyy") -> String {
        let dateString = self
        let strArray = dateString.split(separator: ".")
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format1 //"yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        if let date = dateFormatter.date(from: String(strArray[0])) {
            dateFormatter.dateFormat = format2
            dateFormatter.locale = tempLocale
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            return dateFormatter.string(from: date)
        }
        return "Invalid Date Format"
    }
}


