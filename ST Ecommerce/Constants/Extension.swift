//
//  Extension.swift
//  ST Ecommerce
//
//  Created by MacBook Pro on 16/05/2022.
//  Copyright © 2022 Shashi. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    static func getDateToStringFormat(formatStyle: String,formatDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStyle
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.string(from: formatDate)
    }
    
    static func getDateFormat(formatStyle: String,formatDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStyle
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter.date(from: formatDate) ?? Date()
    }
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        return dateFormatter.string(from: Date())
    }
    
    static func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        
        return dateFormatter.string(from: Date())
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    public func addMinute(_ minute: Int) -> Date? {
        var comps = DateComponents()
        comps.minute = minute
        let calendar = Calendar.current
        let result = calendar.date(byAdding: comps, to: self)
        return result ?? nil
    }
    
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension UIColor {
    
    static let mainColor = UIColor(named: "")
    
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
    
    
    
}

extension UIImage {
    
    static func radioButtonOptionOff() -> UIImage? {
        return UIImage(named: "option_off")
    }
    
    static func radioButtonSelected() -> UIImage? {
        return UIImage(named: "radio_button_selected")
    }
    
    static func radioButtonUnSelected() -> UIImage? {
        return UIImage(named: "radio_button_un_selected")
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func changeOrderDate(_ orderDate: String) -> String{
        let date = Date.getDateFormat(formatStyle: "yyyy-MM-dd HH:mm:ss", formatDate: orderDate)
        let orderDate =  Date.getDateToStringFormat(formatStyle: "dd/MM/yyyy h:mm a", formatDate: date)
        return orderDate
    }
    
    func priceFormat(pricedouble: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:pricedouble))
        
        return formattedNumber ?? ""
    }
    
}

extension UITableView {
    
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier, for: indexPath) as? T
    }
    
}

extension UICollectionReusableView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

//MARK:-- UICollectionCell
extension UICollectionView {
    
    func registerCell(type: UICollectionViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(UINib(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeueCell<T: UICollectionViewCell>(withType type: UICollectionViewCell.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T
    }
    
}

extension UICollectionViewCell {
    func getHourString(_ openingHourString: String) -> String{
        let dateTime = Date.getDateFormat(formatStyle: "HH:mm:ss", formatDate: openingHourString)
        let timeString = Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: dateTime)
        return timeString
    }
}

extension UITableViewCell {
    func getHourString(_ openingHourString: String) -> String{
        let dateTime = Date.getDateFormat(formatStyle: "HH:mm:ss", formatDate: openingHourString)
        let timeString = Date.getDateToStringFormat(formatStyle: "hh:mm a", formatDate: dateTime)
        return timeString
    }
}

extension UILabel{
    @IBInspectable
        var rotation: Int {
            get {
                return 0
            } set {
                let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
                self.transform = CGAffineTransform(rotationAngle: radians)
            }
        }
}

extension UIView {
    
    func addShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3
    }
    
    func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.close()
        
        UIColor.red.withAlphaComponent(0.5).setFill()
        path.fill()
    }
    
    func dropShadow() {
        self.layer.masksToBounds =  false
        self.layer.borderWidth = 0.5
        if #available(iOS 13.0, *) {
            self.layer.borderColor = UIColor.systemGray4.cgColor
        } else {
            // Fallback on earlier versions
        }
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 5
    }
    
    
    func borderColor(for edges:[UIRectEdge], width:CGFloat = 0.5){
        if edges.contains(.all) {
            layer.borderWidth = width
            if #available(iOS 13.0, *) {
                layer.borderColor = UIColor.systemGray4.cgColor
            } else {
                // Fallback on earlier versions
            }
        } else {
            
        }
    }
    
    func addBorder(toEdges edges: UIRectEdge, color: UIColor, thickness: CGFloat) {

            func addBorder(toEdge edges: UIRectEdge, color: UIColor, thickness: CGFloat) {
                let border = CALayer()
                border.backgroundColor = color.cgColor

                switch edges {
                case .top:
                    border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
                case .bottom:
                    border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
                case .left:
                    border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
                case .right:
                    border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
                default:
                    break
                }

                layer.addSublayer(border)
            }

            if edges.contains(.top) || edges.contains(.all) {
                addBorder(toEdge: .top, color: color, thickness: thickness)
            }

            if edges.contains(.bottom) || edges.contains(.all) {
                addBorder(toEdge: .bottom, color: UIColor.white, thickness: thickness)
            }

            if edges.contains(.left) || edges.contains(.all) {
                addBorder(toEdge: .left, color: color, thickness: thickness)
            }

            if edges.contains(.right) || edges.contains(.all) {
                addBorder(toEdge: .right, color: color, thickness: thickness)
            }
        }
    
}


