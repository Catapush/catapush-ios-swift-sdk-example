//
//  NotificationService.swift
//  Service
//
//  Created by Matteo Corradin on 22/11/2019.
//  Copyright © 2019 Catapush s.r.l. All rights reserved.
//

import UserNotifications

class NotificationService: CatapushNotificationServiceExtension {
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        super.didReceive(request, withContentHandler: contentHandler)
    }

    override func handleMessage(_ message: MessageIP?, withContentHandler contentHandler: ((UNNotificationContent?) -> Void)?, withBestAttempt bestAttemptContent: UNMutableNotificationContent?) {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            if (message != nil) {
                bestAttemptContent.body = message!.body;
            }else{
                bestAttemptContent.body = "No new message";
            }
            contentHandler(bestAttemptContent);
        }
    }

    override func handleError(_ error: Error, withContentHandler contentHandler: ((UNNotificationContent?) -> Void)?, withBestAttempt bestAttemptContent: UNMutableNotificationContent?) {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent{
            let errorCode = (error as NSError).code
            if (errorCode == CatapushCredentialsError) {
                bestAttemptContent.body = "User not logged in";
            }
            if (errorCode == CatapushNetworkError) {
                bestAttemptContent.body = "Network error";
            }
            if (errorCode == CatapushNoMessagesError) {
                bestAttemptContent.body = "No new message";
            }
            if (errorCode == CatapushFileProtectionError) {
                bestAttemptContent.body = "Unlock the device at least once to receive the message";
            }
            if (errorCode == CatapushConflictErrorCode) {
                bestAttemptContent.body = "Connected from another resource";
            }
            if (errorCode == CatapushAppIsActive) {
                bestAttemptContent.body = "Please open the app to read the message";
            }
            contentHandler(bestAttemptContent);
        }
    }
    
}
