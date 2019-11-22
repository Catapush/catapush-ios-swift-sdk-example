//
//  NotificationService.swift
//  Service
//
//  Created by Matteo Corradin on 22/11/2019.
//  Copyright © 2019 Catapush s.r.l. All rights reserved.
//

import UserNotifications

class NotificationService: CatapushNotificationServiceExtension {
    
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler;
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        super.didReceive(request, withContentHandler: contentHandler)
    }
    
    override func handleMessage(_ message: MessageIP!) {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            if (message != nil) {
                bestAttemptContent.body = message.body;
            }else{
                bestAttemptContent.body = "No new message";
            }
            contentHandler(bestAttemptContent);
        }
    }
    
    override func handleError(_ error: Error!) {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
           if (error._code == CatapushCredentialsError) {
               bestAttemptContent.body = "User not logged in";
           }
           if (error._code == CatapushNetworkError) {
               bestAttemptContent.body = "Newtork error";
           }
           if (error._code == CatapushNoMessagesError) {
               bestAttemptContent.body = "No new message";
           }
           contentHandler(bestAttemptContent);
        }
    }

}
