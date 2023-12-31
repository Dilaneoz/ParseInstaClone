//
//  AppDelegate.swift
//  Parse Insta Clone
//
//  Created by Atil Samancioglu on 25.09.2018.
//  Copyright © 2018 Atil Samancioglu. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let configuration = ParseClientConfiguration { (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "YnDqooINiwOgXJqTFDpSBdyqdeOxBANkpT62Rqor"
            ParseMutableClientConfiguration.clientKey = "TEy1Bmln0oiuN3Ph1L0phnxArt5oNuE2x6moBNeZ"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
        }
        
        Parse.initialize(with: configuration)
        
        let defaultACL = PFACL()
        defaultACL.getPublicReadAccess = true
        defaultACL.getPublicWriteAccess = true
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        rememberUser()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func rememberUser() {
        
        let user : String? = UserDefaults.standard.string(forKey: "username") // kullanıcı var mı kontrol ediyoruz. string değeri username olan bir değer kaydedildiyse, kullanıcı oluşturulmuş demektir. eğer kullanıcı daha önce oluşturulmuşsa onu signInVC den değil tabBarVC dan başlatıcaz
        
        if user != nil { // kullanıcı boş değilse
            
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // önce UIStoryboard u tanımlıyoruz
            
            let tabBar = board.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController // sonra UITabBarController ı tanımlıyoruz
            
            window?.rootViewController = tabBar // UITabBarController dan başlat
            
        }
    }


}

