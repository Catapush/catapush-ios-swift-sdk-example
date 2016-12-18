//
//  AppDelegate.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Chiarotto Alessandro on 10/12/15.
//  Copyright © 2015 Catapush s.r.l. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CatapushDelegate,MessagesDispatchDelegate,UIAlertViewDelegate {
   
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Catapush.setAppKey("xxxxxxxxxxxxxx")
        
        Catapush.setIdentifier("test", andPassword: "test")
        
        Catapush.registerUserNotification(self, voIPDelegate: nil)
        
        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
        
        do {
            
            try  Catapush.start()
            
        } catch let error as NSError {
            
            print("Error: \(error.localizedDescription)")
            
        }
        
        application.applicationIconBadgeNumber = 0;
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Catapush.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
       
        do {
            try Catapush.applicationWillEnterForeground(application)
        } catch let error as NSError {
            
            print("Error: \(error.localizedDescription)")
            
        }

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Catapush.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Catapush.applicationWillTerminate(application)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        // Custom code (can be empty)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Custom code (can be empty)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Custom code (can be empty)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Custom code (can be empty)
    }
    
    func catapushDidConnectSuccessfully(_ catapush: Catapush!) {
        let connectedAV = UIAlertView( title: "Connected",
                                       message: "Catapush Connected",
                                       delegate: self,
                                       cancelButtonTitle: "Ok")
        connectedAV.show()
    }
    
    public func catapush(_ catapush: Catapush!, didFailOperation operationName: String!, withError error: Error!) {
        let errorMessage = "The operation " + operationName + " is failed with error " + error.localizedDescription
        let flowErrorAlertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
        flowErrorAlertView.show()

    }

    /*
    func catapush(_ catapush: Catapush!, didFailOperation operationName: String!, withError error: NSError!) {
        if error.domain == CATAPUSH_ERROR_DOMAIN {
            print("Error code:\(error.code)")
        }
        let errorMessage = "The operation " + operationName + " is failed with error " + error.localizedDescription
        let flowErrorAlertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
        flowErrorAlertView.show()
    }*/
    
    func libraryDidReceive(_ messageIP: MessageIP!) {
        MessageIP.sendMessageReadNotification(messageIP)
        for message in Catapush.allMessages() {
            print("Message: \((message as AnyObject).body)")
        }
    }
}

