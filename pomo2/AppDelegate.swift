//
//  AppDelegate.swift
//  pomo2
//
//  Created by Tanaka Kenta on 2020/01/14.
//  Copyright © 2020 PrestSQuare. All rights reserved.
//

import UIKit
//import Firebase
//import GoogleMobileAds
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //firebase
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //FirebaseApp.configure()
       // GADMobileAds.sharedInstance().start(completionHandler: nil)
        
         do {
                   try AVAudioSession.sharedInstance().setCategory(
                    AVAudioSession.Category.ambient, mode: .default)
                   try AVAudioSession.sharedInstance().setActive(true)
               } catch {
                   print(error)
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    /*
    func applicationDidEnterBackground(_ application: UIApplication){
        print("backGround")
    }
    */


   
    

}

