//
//  DraggableAnnotationView.swift
//  ST Ecommerce
//
//  Created by Shashi Kumar Gupta on 28/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import Mapbox

class DraggableAnnotationView: MGLAnnotationView {
    
    var delegate : MapDragEndDelegate?
    init(reuseIdentifier: String, size: CGFloat) {
        super.init(reuseIdentifier: reuseIdentifier)
        isDraggable = true
        scalesWithViewingDistance = false
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        backgroundColor = .clear
        
        layer.cornerRadius = size / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        
        let markerImage = UIImage(named: "marker")!
        let imageView = UIImageView(image: markerImage)
        imageView.tintColor = #colorLiteral(red: 1, green: 0.7851476073, blue: 0.4851175547, alpha: 1)
        imageView.frame = CGRect(x: 2, y: 2, width: self.frame.size.width-4, height: self.frame.size.height-4)
        self.addSubview(imageView)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)
        
        switch dragState {
        case .starting:
            startDragging()
        case .dragging:
            print(".", terminator: "")
        case .ending, .canceling:
            endDragging()
            self.delegate?.mapDragEnd()
        case .none:
            break
        @unknown default:
            fatalError("Unknown drag state")
        }
    }
    
    // When the user interacts with an annotation, animate opacity and scale changes.
    func startDragging() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 0.8
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        }, completion: nil)
        
        // Initialize haptic feedback generator and give the user a light thud.
        if #available(iOS 10.0, *) {
            let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
            hapticFeedback.impactOccurred()
        }
    }
    
    func endDragging() {
        transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 1
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }, completion: nil)
        
        // Give the user more haptic feedback when they drop the annotation.
        if #available(iOS 10.0, *) {
            let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
            hapticFeedback.impactOccurred()
        }
        
    }
}
