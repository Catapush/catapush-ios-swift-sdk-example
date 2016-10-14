# catapush-ios-swift-sdk-example
Catapush sdk iOS App Example written in Swift

![Catapush Logo](https://github.com/Catapush/catapush-ios-swift-sdk-example/blob/master/catapush_logo.png)

# Catapush iOS SDK Example

This project shows how quickly Catapush iOS SDK can be integrated into your current app to receive Catapush messages and display them with a customizable bubble layout. Check out the official website: [Catapush - reliable push notification service](http://www.catapush.com).

![alt tag](https://github.com/Catapush/catapush-ios-swift-sdk-example/blob/master/catapush_screen_shot.jpg)


##Usage


1. git clone https://github.com/Catapush/catapush-ios-swift-sdk-example.git
2. cd catapush-ios-swift-sdk-example
3. pod install
4. open catapush-ios-swift-sdk-example.xcworkspace
5. Get your App Key from [Catapush Dashboard](http://www.catapush.com) and insert it together with a couple of credentials of your choice into your application delegate application:didFinishLaunchingWithOption:
```ruby
 func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Catapush.setAppKey("YOUR_APP_KEY")

        Catapush.registerUserNotification(self, voIPDelegate: nil)

        Catapush.startWithIdentifier("test", andPassword: "test")

        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)

        return true
 }
```
6. Run the app
7. Back to your [Catapush Dashboard](http://www.catapush.com) and send some important message.
This example allows to receive VoIP push notification. A VoIP Push Notification Certificate has to be associated to this app. If you set ```voIPDelegate``` to ```nil``` of the method ```registerUserNotification:self voIPDelegate:```, then Catapush Library will not call ```didReceiveIncomingPushWithPayload/1``` and will display an alert message and will play a default sound when a notification is received.
The method ```registerUserNotification/2``` requests registration for remote notification. If VoIP background mode in an app is enabled in XCode capabilites, then the method requests a registration for VoIP notification.

Note: Catapush DOES register user notification for you, so DO NOT register user notification by calling instance method  ```registerUserNotificationSettings/1``` of ```UIApplication```.




#Prerequisites
##Enabling Voice Over IP Push Notifications
Set the following capabilites in your XCode project:

![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/capabilities_remote_xcode.png)

![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/capabilities_xcode.png)

If VoIP is enabled, Catapush library will display alert message and play default sound when a notification is received
(you don't need to write code for showing alert message).
If you want to use standard notification just select ```Remote Notification``` (and unselect Voip).

The 2nd argument of the method ```registerUserNotification/2``` is a ```VoIPNotificationDelegate``` delegate.
The protocol ```VoIPNotificationDelegate``` has one method ```didReceiveIncomingPushWithPayload:(PKPushPayload *)payload``` called when a notification is received.  You can implement this method, and write your custom code, but  Catapush
library will not display any alert or play a sound when a notification is received.

##Certificate, App Id, and Entitlements
These are pre-requisites for setting up VoIP with Catapush.
* Make sure your app has an explicit app id and push entitlements in Apple's Developer Portal.
* Create a VoIP Push Certificate. This can be re-used for development and production.

![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/voip_cert.png)

* Import the VoIP Push Certificate into Keychain Access and export as a .p12 file.
* Upload the exported .p12 file into your Catapush Application ("Platform" menu item).


##Additional Documentation
Please, read the following documentation to enable push notification: [Catapush - Apple APNs Push Notification setup manual](http://www.catapush.com/docs-ios?__hssc=240266844.6.1447949295248&__hstc=240266844.8906dd1311d28178e3c8bdbb3bf2886a.1447404199228.1447945741012.1447949295248.9&hsCtaTracking=315ccd2b-1bb0-4020-b9f9-8b8dec529f1f|efb89882-78ec-4125-9441-59cdfd6082b2).


# UI appearance
Easily configure the UI appearance by changing TextFont, Background color attributes.

```ruby
	MessageCollectionViewCell.cornerRadius = 10
  	MessageCollectionViewCell.borderColor = UIColor(white:0,alpha:0.2)
    MessageCollectionViewCell.borderWidth = 0.5
    MessageCollectionViewCell.textColor = UIColor.whiteColor()
    MessageCollectionViewCell.backgroundColor = UIColor.lightGrayColor()
    MessageCollectionViewCell.textFont = UIFont(name:"HelveticaNeue",size:18)!
    MessageNavigationBar.barTintColor = UIColor.redColor()
    MessageNavigationBar.titleTextAttributes = [
    		NSForegroundColorAttributeName	: UIColor.greenColor(),
            NSFontAttributeName				: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!];
```
###Example
The following code shows how to change the appearance of the message bubbles and the navigation bar:
```ruby
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

     // ...

    MessageCollectionViewCell.cornerRadius = 2
    MessageCollectionViewCell.borderColor = UIColor(white:0,alpha:0.2)
   	MessageCollectionViewCell.borderWidth = 0.5
   	MessageCollectionViewCell.textColor = UIColor.whiteColor()
    MessageCollectionViewCell.backgroundColor = UIColor.lightGrayColor()

    let shadow = NSShadow()
    shadow.shadowColor = UIColor(white:0,alpha:0.8)
    shadow.shadowOffset = CGSizeMake(0, 1)
    MessageNavigationBar.barTintColor = UIColor.redColor()
    MessageNavigationBar.titleTextAttributes = [

            NSForegroundColorAttributeName: UIColor(red:245.0/255.0,green:245.0/255.0,blue:255.0/255.0,alpha:1),
            NSFontAttributeName           : UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!,
            NSShadowAttributeName         : shadow

        ]

  	return true

}
```
![alt tag](https://github.com/Catapush/catapush-ios-swift-sdk-example/blob/master/catapush_screen_shot_custom_red.jpg)


##Clipboard
Use Long tap to copy a text into clipboard.

![alt tag](https://github.com/Catapush/catapush-ios-swift-sdk-example/blob/master/catapush_screen_shot_clipboard.jpg)
