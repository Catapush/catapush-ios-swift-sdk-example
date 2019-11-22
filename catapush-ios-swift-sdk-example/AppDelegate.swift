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
class AppDelegate: UIResponder, UIApplicationDelegate, CatapushDelegate, MessagesDispatchDelegate, UIAlertViewDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Catapush.setAppKey("xxxxxxxxxxxxxx")
        
        Catapush.setIdentifier("test", andPassword: "test")
        
        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
        
        Catapush.registerUserNotification(self)

        var error: NSError?
        Catapush.start(&error)

        if let error = error {
            // Handle error...
            print("Error: \(error.localizedDescription)")
        }
        
        application.applicationIconBadgeNumber = 0;
        UNUserNotificationCenter.current().delegate = self

        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Catapush.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        var error: NSError?
        Catapush.applicationWillEnterForeground(application, withError: &error)
        
        if let error = error {
            // Handle error...
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Catapush.applicationDidBecomeActive(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Catapush.applicationWillTerminate(application)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Custom code (can be empty)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
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
    
    func libraryDidReceive(_ messageIP: MessageIP!) {
        MessageIP.sendMessageReadNotification(messageIP)
        print("Single message: \(messageIP.body ?? "")")
        print("---All Messages---")
        for message in Catapush.allMessages() {
            print("Message: \((message as! MessageIP).body ?? "")")
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler();
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([]);
    }
    
}
