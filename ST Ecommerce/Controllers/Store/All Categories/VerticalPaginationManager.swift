//
//  VerticalPaginationManager.swift
//  ST Ecommerce
//
//  Created by necixy on 12/11/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

protocol VerticalPaginationManagerDelegate: class {
    func refreshAll(completion: @escaping (Bool) -> Void)
    func loadMore(completion: @escaping (Bool) -> Void)
}

class VerticalPaginationManager: NSObject {
    private var isLoading = false
    private var isObservingKeyPath: Bool = false
    private var scrollView: UIScrollView!
    private var leftMostLoader: UIView?
    private var rightMostLoader: UIView?
    var refreshViewColor: UIColor = .white
    var loaderColor: UIColor = .white
    
    weak var delegate: VerticalPaginationManagerDelegate?
    
    init(scrollView: UIScrollView) {
        super.init()
        self.scrollView = scrollView
        self.addScrollViewOffsetObserver()
    }
    
    deinit {
        self.removeScrollViewOffsetObserver()
    }
    
    func initialLoad() {
        self.delegate?.refreshAll(completion: { _ in })
    }
}


extension VerticalPaginationManager {
    
    private func addLeftMostControl() {
        let view = UIView()
        view.backgroundColor = self.refreshViewColor
        view.frame.origin = CGPoint(x: -60, y: 0)
        view.frame.size = CGSize(width: 60,
                                 height: self.scrollView.bounds.height)
        let activity = UIActivityIndicatorView(style: .gray)
        activity.color = self.loaderColor
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        self.scrollView.contentInset.left = view.frame.width
        self.leftMostLoader = view
        self.scrollView.addSubview(view)
    }
    
    func removeLeftLoader() {
        self.leftMostLoader?.removeFromSuperview()
        self.leftMostLoader = nil
        self.scrollView.contentInset.left = 0
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
}
extension VerticalPaginationManager {
    
    private func addRightMostControl() {
        let view = UIView()
        view.backgroundColor = self.refreshViewColor
        view.frame.origin = CGPoint(x: self.scrollView.contentSize.width,
                                    y: 0)
        view.frame.size = CGSize(width: 60,
                                 height: self.scrollView.bounds.height)
        let activity = UIActivityIndicatorView(style: .gray)
        activity.color = self.loaderColor
        activity.frame = view.bounds
        activity.startAnimating()
        view.addSubview(activity)
        self.scrollView.contentInset.right = view.frame.width
        self.rightMostLoader = view
        self.scrollView.addSubview(view)
    }
    
    func removeRightLoader() {
        self.rightMostLoader?.removeFromSuperview()
        self.rightMostLoader = nil
    }
    
}
extension VerticalPaginationManager {
    
    private func addScrollViewOffsetObserver() {
        if self.isObservingKeyPath { return }
        self.scrollView.addObserver(
            self,
            forKeyPath: "contentOffset",
            options: [.new],
            context: nil
        )
        self.isObservingKeyPath = true
    }
    
    private func removeScrollViewOffsetObserver() {
        if self.isObservingKeyPath {
            self.scrollView.removeObserver(self,
                                           forKeyPath: "contentOffset")
        }
        self.isObservingKeyPath = false
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard let object = object as? UIScrollView,
            let keyPath = keyPath,
            let newValue = change?[.newKey] as? CGPoint,
            object == self.scrollView, keyPath == "contentOffset" else { return }
        self.setContentOffSet(newValue)
    }
    
    private func setContentOffSet(_ offset: CGPoint) {
        let offsetX = offset.x
        if offsetX < -100 && !self.isLoading {
            self.isLoading = true
            self.addLeftMostControl()
            self.delegate?.refreshAll { success in
                self.isLoading = false
                self.removeLeftLoader()
            }
            return
        }
        
        let contentWidth = self.scrollView.contentSize.width
        let frameWidth = self.scrollView.bounds.size.width
        let diffX = contentWidth - frameWidth
        if contentWidth > frameWidth,
        offsetX > (diffX + 130) && !self.isLoading {
            self.isLoading = true
            self.addRightMostControl()
            self.delegate?.loadMore { success in
                self.isLoading = false
                self.removeRightLoader()
            }
        }
    }
    
}

