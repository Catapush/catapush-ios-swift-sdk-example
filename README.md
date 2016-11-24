# catapush-ios-swift-sdk-example
Catapush sdk iOS App Example written in Swift

![Catapush Logo](https://github.com/Catapush/catapush-ios-swift-sdk-example/blob/master/catapush_logo.png)

# Catapush iOS SDK Example

This project shows how quickly Catapush iOS SDK can be integrated into your current app to receive Catapush messages and display them with a customizable bubble layout. For more information about Catapush platform check out the official website: [Catapush - reliable push notification service](http://www.catapush.com).

![alt tag](https://github.com/Catapush/catapush-ios-swift-sdk-example/blob/master/catapush_screen_shot.jpg)


##Usage
*ATTENTION*: this procedure works only if you are NOT using the "use_frameworks!" flag, if you need it look at the dedicated section [Manual library integration when using use_frameworks!](#manual-library-integration-when-using-use_frameworks)

1. sudo gem install cocoapods (IMPORTANT: run it also if you have already installed cocoapods)
2. git clone https://github.com/Catapush/catapush-ios-swift-sdk-example.git
3. cd catapush-ios-swift-sdk-example
4. pod install 
5. open catapush-ios-swift-sdk-example.xcworkspace
6. Get your App Key from [Catapush Dashboard](http://www.catapush.com) from the left menu in "Your APP" -> App details 
7. Create the first user from "Your APP" -> User
8. Insert the App Key and the user credentials into your application delegate (catapush-ios-swift-sdk-example/catapush-ios-swift-sdk-example/AppDelegate.swift) :
```ruby
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Catapush.setAppKey("INSERT_YOU_APPKEY_HERE")
        
        Catapush.registerUserNotification(self, voIPDelegate: nil)
        
        Catapush.start(withIdentifier: "INSERT_THE_USER_USERNAME_HERE", andPassword: "INSERT_THE_USER_PASSWORD_HERE")
        
        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
        
        application.applicationIconBadgeNumber = 0;
        return true
    }

```
9. Run the app
10. Back to your [Catapush Dashboard](http://www.catapush.com) and send a test message from "Your APP" -> Send Push.


This example allows to receive VoIP push notification (PushKit framework). A VoIP Push Notification Certificate has to be associated to this app in the section "Your APP" -> Platforms. 
You can choose if you want read and show directly the push notifications or let the library to handle them, if you set ```voIPDelegate``` to ```nil``` in the method ```didFinishLaunchingWithOptions``` (```registerUserNotification:self voIPDelegate:nil```), then Catapush Library will display an alert message and will play a default sound when a notification is received. Instead if you want to completly handle them you have to implement ```didReceiveIncomingPushWithPayload/1```.

The method ```registerUserNotification/2``` requests registration for standard or Voip push notification. The library choose the right type using the capabilites settings enabled in XCode as described below.

Note: Catapush DOES register user notification for you, so *DO NOT* register user notification by calling instance method  ```registerUserNotificationSettings/1``` of ```UIApplication```.


#Prerequisites
You must enable the right capabilites in your Xcode project and create a certificate for your VoIP app. Each VoIP app requires its own individual VoIP Services certificate, mapped to a unique App ID. This certificate allows your notification server to connect to the VoIP service. Visit the [Apple Developer Member Center](https://developer.apple.com/) and create a new VoIP Services Certificate.

##Enabling Voice Over IP Push Notifications
Set the following capabilites in your XCode project:

![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/capabilities_remote_xcode.png)

![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/capabilities_xcode.png)


##Certificate, App Id, and Entitlements
These are pre-requisites for setting up VoIP with Catapush.
* Make sure your app has an explicit app id and push entitlements in Apple's Developer Portal.
* Create a VoIP Push Certificate. This can be re-used for development and production.

Follow this [step by step tutorial](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/CREATING_APN_CERTIFICATE.md) to generate VoIP certificate and configure your Catapush applicaton hosted on [Catapush servers](http://www.catapush.com).


# UI appearance
You can easily configure the UI appearance by changing TextFont, Background color attributes. You can add this code in the method application of catapush-ios-swift-sdk-example/catapush-ios-swift-sdk-example/AppDelegate.swift 

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
                NSFontAttributeName		: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!];
```
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

## Manual library integration when using use_frameworks!
Since our library isn't a framework you cannot ```use use_frameworks!``` in your Podfile, if you have to use this flag you have to include the library manually following this steps:

*ATTENTION*: this steps doesn't works in our example project, you have to create a new empty project or include it in your project

1. cd ~
2. git clone git@github.com:Catapush/catapush-ios-sdk-pod.git
3. open your project in XCode
4. From Finder drag this files in your project root, when asked select "Copy items if needed"
    * catapush-ios-sdk-pod/CatapushKit/libCatapushLib.a
    * catapush-ios-sdk-pod/CatapushKit/CatapushHeaders.h
    * catapush-ios-sdk-pod/CatapushKit/CatapushLibBundle.bundle

5. Add Dependencies
From Project settings, select your target, and go to the "Build Phases" tab. Under "Link Binary With Libraries" use the + button to add the following Frameworks to your project:
    * Security.framework
    * CFNetwork.framework
    * SystemConfiguration.framework
    * CoreData.framework
    * libresolv

6. From XCode create a new File -> header, call it ```<projectname>-Bridging-Header.h``` and add this instruction like in this [Bridging-Header.h example](https://raw.githubusercontent.com/Catapush/catapush-ios-swift-sdk-example/master/catapush-ios-swift-sdk-example-Bridging-Header.h)
```ruby
#import "CatapushHeaders.h"
```

7. Set Build Settings
Go ahead to "Build Settings", select "All" tab
    * Find "Linking" section and fill "Other Linker Flags" with: -ObjC -lxml2
    * Find "Swift Compiler - General" and fill "Objective-C Bridging Header" with: ```<projectname>-Bridging-Header.h```

8. You can copy/paste the AppDelegate from [AppDelegate.swift](https://raw.githubusercontent.com/Catapush/catapush-ios-swift-sdk-example/master/catapush-ios-swift-sdk-example/AppDelegate.swift) to your project
