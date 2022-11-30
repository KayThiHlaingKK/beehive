//
//  AppDelegate.swift
//  ST Ecommerce
//
//  Created by necixy on 30/06/20.
//  Copyright © 2020 Shashi. All rights reserved.
//  test comment by Rishabh

import UIKit
import IQKeyboardManagerSwift
import PGW
import LanguageManager_iOS
import UserNotificationsUI
import Firebase
import DropDown
import Sentry
import SwiftyPlistManager
import FirebaseMessaging
import FirebaseAnalytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var item: Item!
    var labelCartCount: UILabel!
    var window: UIWindow?
    var notificationInfo = [AnyHashable: Any]()
    
    //In app delegate
    let alertWindow: UIWindow = {
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.windowLevel = UIWindow.Level.alert + 1
        return win
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) ->
    Bool {
//        let storyboard = UIStoryboard(name: "Cart", bundle: nil)
//        let vc = storyboard.instantiateViewController(ofType: CartListViewController.self)
//        window?.rootViewController = vc
//        window?.makeKeyAndVisible()
        
        UIApplication.shared.clearLaunchScreenCache()
        
        SwiftyPlistManager.shared.start(plistNames: ["notes"], logging: true)
        
        // Remove this method to stop OneSignal Debugging
//          OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
          
          // OneSignal initialization
//          OneSignal.initWithLaunchOptions(launchOptions)
//
//        #if STAGING
//          OneSignal.setAppId("ef72b03c-34a4-4ddb-acb4-a21702095f8d")
//        #else
//            OneSignal.setAppId("8014c5b4-ac42-4154-a7dd-56a52c608494")
//        #endif
          
          // promptForPushNotifications will show the native iOS notification permission prompt.
          // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
//          OneSignal.promptForPushNotifications(userResponse: { accepted in
//            print("User accepted notifications: \(accepted)")
//          })
          
          // Set your customer userId
          // OneSignal.setExternalUserId("userId")
        
        SentrySDK.start { options in
                options.dsn = "https://3dde55be07374c1c8826c95f5b6ca3d3@o567028.ingest.sentry.io/5798261"
                options.debug = true // Enabled debug when first installing is always helpful
                
                #if STAGING
                options.environment = "staging"
                #else
                options.environment = "production"
                #endif
            
                options.sampleRate = 0.2
            }

        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            //Fallback to scne delegate
        } else {
            Util.makeSplashRootController()
            // Fallback on earlier versions
        }
//        notificationInfo = [:]
        IQKeyboardManager.shared.enable = true
        
        
        #if STAGING
        let firebasePlistFileName = "GoogleService-Info-Staging"
        #else
        let firebasePlistFileName = "GoogleService-Info"
        #endif
        print("=> firebase - \(firebasePlistFileName)")
        let filePath = Bundle.main.path(forResource: firebasePlistFileName, ofType: "plist")
        guard let fileopts = FirebaseOptions(contentsOfFile: filePath!) else {
            assert(false, "Couldn't load config file")
            return true
        }
        FirebaseApp.configure(options: fileopts)
//        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        
        Messaging.messaging().subscribe(toTopic: "marketing") { error in
          print("Subscribed to weather topic")
        }
        
       
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("fetching FCM registration token: \(token)")
          }
        }
       
        application.registerForRemoteNotifications()
       
        
        self.languageSetUp()
        
        PGWSDK.builder()
            .merchantID("JT01")
            .apiEnvironment(APIEnvironment.SANDBOX)
            .initialize()
        
  
        let state = UIApplication.shared.applicationState
        if state == .background || state == .inactive {
            // background
            print("!!background")
            Util.makeHomeRootController()
        } else if state == .active {
            // foreground
            print("!!foreground")
        }

        
        DropDown.startListeningToKeyboard()
        
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
    //MARK: - initial setups
    func languageSetUp(){
        
        if getlanguage() == ""{
        }else{
            DEFAULTS.set("en", forKey: UD_Language)
        }
        
        //LanguageManager.shared.currentLanguage = .en
        LanguageManager.shared.defaultLanguage = .en
        LanguageManager.shared.setLanguage(language: Languages.en)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("errorPushNotification \(error)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("device token = ", deviceToken)
        Messaging.messaging().apnsToken = deviceToken
        
    }
    

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("Recived: \(userInfo)")
    }
   
 
    func applicationDidEnterBackground(_ application: UIApplication) {

    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Util.makeHomeRootController()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        openfromnotification(notificationData: self.notificationInfo)
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
          print("Firebase registration token: \(String(describing: fcmToken))")
          Util.createFirebaseToken(fcmToken: fcmToken ?? "")
          let dataDict: [String: String] = ["token": fcmToken ?? ""]
          NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
          )
      
        
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                  -> Void) {
        
      let userInfo = notification.request.content.userInfo

       Messaging.messaging().appDidReceiveMessage(userInfo)

        if var badgeCount = UserDefaults.standard.value(forKey: BadgeCount) as? Int {

            badgeCount += 1

            UserDefaults.standard.setValue(badgeCount, forKey: BadgeCount)

            UIApplication.shared.applicationIconBadgeNumber = badgeCount
        }
      print(userInfo)

      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
        
        guard let arrAPS = userInfo["data"] as? [String: Any] else { return }
        let target:String = arrAPS["target"] as? String ?? ""
        let orderFlag: String = arrAPS["orderFlag"] as? String ?? ""
        
        if orderFlag == "true"{
            if target == "shop-orders" {
                Util.goShopOrder()
            }
            else if target == "restaurant-orders"{
                Util.goRestaurantOrder()
            }
        }
        
        
        
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            print ("Message Closed")
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print ("App is Open")
        }

        
      let userInfo = response.notification.request.content.userInfo
        print("userinfo == ", userInfo)
        
//        if var badgeCount = UserDefaults.standard.value(forKey: BadgeCount) as? Int {

//            badgeCount -= 1

            UserDefaults.standard.setValue(0, forKey: BadgeCount)

            UIApplication.shared.applicationIconBadgeNumber = 0
//        }
        

      // With swizzling disabled you must let Messaging know about the message, for Analytics
       Messaging.messaging().appDidReceiveMessage(userInfo)
        
        guard let arrAPS = userInfo["data"] as? [String: Any] else { return }

        let target:String = arrAPS["target"] as? String ?? ""
        let slug:String = arrAPS["target_slug"] as? String ?? ""
        
        
        if target == "shop-orders" {
            Util.goShopOrderDetail(slug: slug)
        }
        else if target == "restaurant-orders" {
            Util.goRestaurantOrderDetail(slug: slug)
        }
        else if target == "products" {
            Util.goProductDetail(slug: slug)
        }
        else if target == "restaurant-branches" {
            Util.goRestaurantDetail(slug: slug)
        }
        else if target == "shops" {
            Util.goShopDetail(slug: slug)
        }

      // Print full message.
      print("userInfo ", userInfo)

      completionHandler()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("herer")
        guard let arrAPS = userInfo["data"] as? [String: Any] else { return }
        let target:String = arrAPS["target"] as? String ?? ""
        let orderFlag: String = arrAPS["orderFlag"] as? String ?? ""
        let slug:String = arrAPS["target_slug"] as? String ?? ""
        
        if orderFlag == "true"{
            if target == "shop-orders" {
                Util.goShopOrder()
            }
            else if target == "restaurant-orders" {
                Util.goRestaurantOrder()
            }
        }
        
        let state = application.applicationState
        // user tapped notification while app was in background
        if state == .inactive || state == .background {
            // go to screen relevant to Notification content
            if target == "shop-orders" {
                Util.goShopOrderDetail(slug: slug)
            }
            else if target == "restaurant-orders" {
                Util.goRestaurantOrderDetail(slug: slug)
            }
            else if target == "products" {
                Util.goProductDetail(slug: slug)
            }
            else if target == "restaurant-branches" {
                Util.goRestaurantDetail(slug: slug)
            }
            else if target == "shops" {
                Util.goShopDetail(slug: slug)
            }
        }
        else {
            // App is in UIApplicationStateActive (running in foreground)
            // perhaps show an UIAlertView
        }
    }

}


