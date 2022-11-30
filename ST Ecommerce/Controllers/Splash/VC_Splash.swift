//
//  VC_Splash.swift
//  ST Ecommerce
//
//  Created by necixy on 07/07/20.
//  Copyright © 2020 Shashi. All rights reserved.
// 

import UIKit
import Lottie
import AVFoundation

class VC_Splash: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            Util.makeHomeRootController()

        }
    }
    
//    var avPlayer: AVPlayer!
//        var avPlayerLayer: AVPlayerLayer!
//        var paused: Bool = false
//
//        override func viewDidLoad() {
//
//            let theURL = Bundle.main.url(forResource:"splash", withExtension: "mp4")
//
//            avPlayer = AVPlayer(url: theURL!)
//            avPlayerLayer = AVPlayerLayer(player: avPlayer)
//            avPlayerLayer.videoGravity = .resizeAspectFill
//            avPlayer.volume = 0
//            avPlayer.actionAtItemEnd = .none
//
//            avPlayerLayer.frame = view.layer.bounds
//            view.backgroundColor = .clear
//            view.layer.insertSublayer(avPlayerLayer, at: 0)
//
//            NotificationCenter.default.addObserver(self,
//                                               selector: #selector(playerItemDidReachEnd(notification:)),
//                                               name: .AVPlayerItemDidPlayToEndTime,
//                                               object: avPlayer.currentItem)
//        }
//
//        @objc func playerItemDidReachEnd(notification: Notification) {
//            let p: AVPlayerItem = notification.object as! AVPlayerItem
//            p.seek(to: .zero)
//        }
//
//        override func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(animated)
//            avPlayer.play()
//            paused = false
//        }
//
//        override func viewDidDisappear(_ animated: Bool) {
//            super.viewDidDisappear(animated)
//            avPlayer.pause()
//            paused = true
//        }

}
