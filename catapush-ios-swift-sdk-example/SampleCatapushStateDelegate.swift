//
//  SampleCatapushStateDelegate.swift
//  catapush-ios-swift-sdk-example
//
//  Created by Matteo Corradin on 03/11/2020.
//  Copyright © 2020 Catapush s.r.l. All rights reserved.
//

import Foundation

class SampleCatapushStateDelegate : NSObject, CatapushDelegate{
    let LONG_DELAY =  300
    let SHORT_DELAY = 30
    
    func catapushDidConnectSuccessfully(_ catapush: Catapush!) {
        let connectedAV = UIAlertView( title: "Connected",
                                       message: "Catapush Connected",
                                       delegate: self,
                                       cancelButtonTitle: "Ok")
        connectedAV.show()
    }
    
    func catapush(_ catapush: Catapush!, didFailOperation operationName: String!, withError error: Error!) {
        let test = CatapushErrorCode.INVALID_APP_KEY;
        let domain = (error as NSError).domain
        let code = (error as NSError).code
        if domain == CATAPUSH_ERROR_DOMAIN {
            switch code {
            case CatapushErrorCode.INVALID_APP_KEY.rawValue:
                /*
                 Check the app id and retry.
                 [Catapush setAppKey:@"YOUR_APP_KEY"];
                 */
                break;
            case CatapushErrorCode.USER_NOT_FOUND.rawValue:
                /*
                 Please check if you have provided a valid username and password to Catapush via this method:
                 [Catapush setIdentifier:username andPassword:password];
                 */
                break;
            case CatapushErrorCode.WRONG_AUTHENTICATION.rawValue:
                /*
                 Please verify your identifier and password validity. The user might have been deleted from the Catapush app (via API or from the dashboard) or the password has changed.

                 You should not keep retrying, delete the stored credentials.
                 Provide a new identifier to this installation to solve the issue.
                 */
                break;
            case CatapushErrorCode.GENERIC.rawValue:
                /*
                 An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.XMPP_MULTIPLE_LOGIN.rawValue:
                /*
                 The same user identifier has been logged on another device, the messaging service will be stopped on this device
                 Please check that you are using a unique identifier for each device, even on devices owned by the same user.
                 */
                break;
            case CatapushErrorCode.API_UNAUTHORIZED.rawValue:
                /*
                 The credentials has been rejected    Please verify your identifier and password validity. The user might have been deleted from the Catapush app (via API or from the dashboard) or the password has changed.

                 You should not keep retrying, delete the stored credentials.
                 Provide a new identifier to this installation to solve the issue.
                 */
                break;
            case CatapushErrorCode.API_INTERNAL_ERROR.rawValue:
                /*
                 Internal error of the remote messaging service
                 
                 An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.REGISTRATION_BAD_REQUEST.rawValue:
                /*
                 Internal error of the remote messaging service    An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.REGISTRATION_FORBIDDEN_WRONG_AUTH.rawValue:
                /*
                 Wrong auth    Please verify your identifier and password validity. The user might have been deleted from the Catapush app (via API or from the dashboard) or the password has changed.

                 You should not keep retrying, delete the stored credentials.
                 Provide a new identifier to this installation to solve the issue.
                 */
                break;
            case CatapushErrorCode.REGISTRATION_NOT_FOUND_APPLICATION.rawValue:
                /*
                 Application not found
                 
                 You appplication is not found or not active.
                 You should not keep retrying.
                 */
                break;
            case CatapushErrorCode.REGISTRATION_NOT_FOUND_USER.rawValue:
                /*
                 User not found
                 The user has been probably deleted from the Catapush app (via API or from the dashboard).

                 You should not keep retrying.
                 Provide a new identifier to this installation to solve the issue.
                 */
                break;
            case CatapushErrorCode.REGISTRATION_INTERNAL_ERROR.rawValue:
                /*
                 Internal error of the remote messaging service    An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.OAUTH_BAD_REQUEST.rawValue:
                /*
                 Internal error of the remote messaging service    An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.OAUTH_BAD_REQUEST_INVALID_CLIENT.rawValue:
                /*
                 Internal error of the remote messaging service    An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.OAUTH_BAD_REQUEST_INVALID_GRANT.rawValue:
                /*
                 Internal error of the remote messaging service    An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.OAUTH_INTERNAL_ERROR.rawValue:
                /*
                 Internal error of the remote messaging service    An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 Please try again in a few minutes.
                 */
                self.retry(delayInSeconds: LONG_DELAY);
                break;
            case CatapushErrorCode.UPDATE_PUSH_TOKEN_FORBIDDEN_WRONG_AUTH.rawValue:
                /*
                 Credentials error
                 
                 Please verify your identifier and password validity. The user might have been deleted from the Catapush app (via API or from the dashboard) or the password has changed.

                 You should not keep retrying, delete the stored credentials.
                 Provide a new identifier to this installation to solve the issue.
                 */
                break;
            case CatapushErrorCode.UPDATE_PUSH_TOKEN_FORBIDDEN_NOT_PERMITTED.rawValue:
                /*
                 Credentials error
                 
                 Please verify your identifier and password validity. The user might have been deleted from the Catapush app (via API or from the dashboard) or the password has changed.

                 You should not keep retrying, delete the stored credentials.
                 Provide a new identifier to this installation to solve the issue.
                 */
                break;
            case CatapushErrorCode.UPDATE_PUSH_TOKEN_NOT_FOUND_CUSTOMER.rawValue:
                /*
                 Application error
                 
                 You appplication is not found or not active.
                 You should not keep retrying.
                 */
                break;
            case CatapushErrorCode.UPDATE_PUSH_TOKEN_NOT_FOUND_APPLICATION.rawValue:
                /*
                 Application not found
                 
                 You appplication is not found or not active.
                 You should not keep retrying.
                 */
                break;
            case CatapushErrorCode.UPDATE_PUSH_TOKEN_NOT_FOUND_USER.rawValue:
                /*
                 User not found
                 
                 Please verify your identifier and password validity. The user might have been deleted from the Catapush app (via API or from the dashboard) or the password has changed.

                 You should not keep retrying, delete the stored credentials.
                 Provide a new identifier to this installation to solve the issue.
                 */
                break;
            case CatapushErrorCode.UPDATE_PUSH_TOKEN_INTERNAL_ERROR.rawValue:
                /*
                 Internal error of the remote messaging service when updating the push token.
                 
                 Nothing, it's handled automatically by the sdk.
                 An unexpected internal error on the remote messaging service has occurred.
                 This is probably due to a temporary service disruption.
                 */
                break;
            case CatapushErrorCode.NETWORK_ERROR.rawValue:
                /*
                 The SDK couldn’t establish a connection to the Catapush remote messaging service.
                 
                 The device is not connected to the internet or it might be blocked by a firewall or the remote messaging service might be temporarily disrupted.    Please check your internet connection and try to reconnect again.
                 */
                self.retry(delayInSeconds: SHORT_DELAY);
                break;
            case CatapushErrorCode.PUSH_TOKEN_UNAVAILABLE.rawValue:
                /*
                 Push token is not available.
                 
                 Nothing, it's handled automatically by the sdk.
                 */
                break;
            default:
                break;
            }
        }
    }
    
    func retry(delayInSeconds:Int) {
        let deadlineTime = DispatchTime.now() + .seconds(delayInSeconds)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            var error: NSError?
            Catapush.start(&error)
            if let error = error {
                // API KEY, USERNAME or PASSWORD not set
            }
        }
    }
    
    
}
