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
class AppDelegate: UIResponder, UIApplicationDelegate, CatapushDelegate, MessagesDispatchDelegate, UIAlertViewDelegate, VoIPNotificationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Catapush.setAppKey("xxxxxxxxxxxxxx")
        
        Catapush.setIdentifier("test", andPassword: "test")
        
        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
        
        // If you set voipDelegate to nil a Local Notification will be fired before the method
        // didReceiveIncomingPush is invoked.
        Catapush.registerUserNotification(self, voIPDelegate: self)

        var error: NSError?
        Catapush.start(&error)

        if let error = error {
            // Handle error...
            print("Error: \(error.localizedDescription)")
        }
        
        application.applicationIconBadgeNumber = 0;
        
        return true
    }
    
    func didReceiveIncomingPush(with payload: PKPushPayload!) {
        print("didReceiveIncomingPush invoked")
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
        print("Single message: \(messageIP.body)")
        print("---All Messages---")
        for message in Catapush.allMessages() {
            print("Message: \((message as AnyObject).body)")
        }
    }
}

extension AppDelegate: PKPushRegistryDelegate {

    @available(iOS 8.0, *)
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        let payloadDict = payload.dictionaryPayload["aps"] as? Dictionary<String, String>
        let message = payloadDict?["alert"]
        
        //present a local notifcation to visually see when we are recieving a VoIP Notification
        if UIApplication.shared.applicationState == UIApplication.State.background {
            
            let localNotification = UILocalNotification();
            localNotification.alertBody = message
            localNotification.applicationIconBadgeNumber = 1;
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            
            UIApplication.shared.presentLocalNotificationNow(localNotification);
        }
            
        else {
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                let alert = UIAlertView(title: "VoIP Notification", message: message, delegate: nil, cancelButtonTitle: "Ok");
                alert.show()
            })
        }
        
        NSLog("incoming voip notfication: \(payload.dictionaryPayload)")
    }

    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        
        //print out the VoIP token. We will use this to test the notification.
        print("voip token: \(pushCredentials.token)")
    }
    
    private func pushRegistry(registry: PKPushRegistry!, didInvalidatePushTokenForType type: String!) {
        
        NSLog("token invalidated")
    }
}

