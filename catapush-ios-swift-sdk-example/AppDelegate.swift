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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Catapush.setAppKey("bce7c80f45ace7dbe07888a4198c2ac6")
        Catapush.startWithIdentifier("test-ios", andPassword: "test-ios")
        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
        
        if let loptions = launchOptions { 
             let remoteNotification = loptions[UIApplicationLaunchOptionsRemoteNotificationKey]
            if case let sender as String = remoteNotification!["sender"] {
                if sender == "catapush" {
                    // Wake up, it's Catapush!
                }
            }
        }
        
        if NSProcessInfo().operatingSystemVersion.majorVersion > 8 {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Sound,.Alert,.Badge], categories: [])
            application.registerUserNotificationSettings(notificationSettings)
        } else {
            application.registerForRemoteNotificationTypes([.Sound,.Alert,.Badge])
        }
        
        application.applicationIconBadgeNumber = 0;
        return true
    }

    
    
    
    func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(application: UIApplication) {
        Catapush.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        Catapush.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        Catapush.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(application: UIApplication) {
        Catapush.applicationWillTerminate(application)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Catapush.registerForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Did Fail Register Notification",error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        CatapushRemoteNotifications.application(application,
            didReceiveRemoteNotification: userInfo,
            fetchCompletionHandler: completionHandler)
    }
    
    func catapushDidConnectSuccessfully(catapush: Catapush!) {
         let connectedAV = UIAlertView( title: "Connected",
                                        message: "Catapush Connected",
                                        delegate: self,
                                        cancelButtonTitle: "Ok")
        connectedAV.show()
    }
    
    
    func catapush(catapush: Catapush!, didFailOperation operationName: String!, withError error: NSError!) {
        if error.domain == CATAPUSH_ERROR_DOMAIN {
            print("Error code:\(error.code)")
        }
        let errorMessage = "The operation " + operationName + " is failed with error " + error.localizedDescription
        let flowErrorAlertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
        flowErrorAlertView.show()
    }

    func libraryDidReceiveMessageIP(messageIP: MessageIP!) {
        MessageIP.sendMessageReadNotification(messageIP)
        for message in Catapush.allMessages() {
            print("Message: \(message.body)")
        }
    }
    
    
    /**
    
        Customize appearance of message bubbles

    */
    

    
    

  
}

