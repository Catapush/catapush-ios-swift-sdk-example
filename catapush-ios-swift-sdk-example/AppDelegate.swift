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

        Catapush.setAppKey("xxxxxxxxxxxxxxxxxxxxxxxxxxx")
      
        Catapush.registerUserNotification(self, voIPDelegate: nil)
        
        Catapush.startWithIdentifier("test", andPassword: "test")
        
        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
        
        application.applicationIconBadgeNumber = 0;
        return true
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
         // Custom code (can be empty)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
         // Custom code (can be empty)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        // Custom code (can be empty)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Custom code (can be empty)
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
}

