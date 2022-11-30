//
//  SceneDelegate.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//
////        if DEFAULTS.string(forKey: oneSignalAppId) != nil && connectionOptions.notificationResponse != nil {
//
//          let rootViewController = UINavigationController(rootViewController: VC_Home())
//          window?.rootViewController = rootViewController
//          window?.makeKeyAndVisible()
//
////          DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
////            NotificationCenter.default.post(
////              name: .passApnsDataToDashboardNotification,
////              object: nil,
////              userInfo: connectionOptions.notificationResponse?.notification.request.content.userInfo)
////          }
//
////        }
        
        Util.makeSplashRootController()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
////        print(" window is\(window?.rootViewController?.topViewController)")
//        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//           if let controller = appDelegate?.window?.rootViewController {
//              if let navigationController: UINavigationController = controller as? UINavigationController {
//                 let viewControllers: [UIViewController] = navigationController.viewControllers
//                 for viewController in  viewControllers {
//                     // Check for your view controller here
//                    if viewController == window?.rootViewController?.topMostViewController() {
//                        print("vc found")
//                    }
//                 }
//              } else if let viewController: UIViewController = controller as? UIViewController {
//                  // Check for your view controller here
//              } else if let tabController: UITabBarController = controller as? UITabBarController {
//                 // Narrow the hierarchy and check for your view controller here
//             }
//           }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

