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
```
9. Run the app
10. Back to your [Catapush Dashboard](http://www.catapush.com) and send a test message from "Your APP" -> Send Push.


Note: Catapush DOES register user notification for you, so *DO NOT* register user notification by calling instance method of ```UIApplication```.


# Prerequisites
These are pre-requisites for setting up your application with Catapush.
## Certificate, App Id, Push Entitlements and App Groups
* Make sure your app has an explicit app id and push entitlements in Apple's Developer Portal.
* Create an Apple Push Notification Authentication Key and configure your Catapush applicaton hosted on [Catapush servers](http://www.catapush.com).
* Create a specific App Group for the iOS Application and the Notification Service Extension.

### Create and configure the authentication key
This section describes how to generate an authentication key for an App ID enabled for Push Notifications. If you have an existing key, you can use that key instead of generating a new one.

To create an authentication key:
1) In your [Apple Developer Member Center](https://developer.apple.com/account), go to Certificates, Identifiers & Profiles, and select Keys.
2) Click the Add button (+) in the upper-right corner.
3) Enter a description for the APNs Auth Key.
4) Under Key Services, select the Apple Push Notifications service (APNs) checkbox, and click Continue.
5) Click Confirm and then Download. Save your key in a secure place. This is a one-time download, and the key cannot be retrieved later.

Once you have download it you have to configure your Catapush application.
1) Go to https://www.catapush.com/panel/apps/YOUR_APP_ID/platforms.
2) Click on iOS Token Based to enable it.
3) Fill iOS Team Id, iOS Key Id, iOS AuthKey and iOS Topic.

The iOS Team Id can be found here https://developer.apple.com/account/#/membership in "Membership Information" section.

The iOS Key Id can be retrieved here https://developer.apple.com/account/resources/authkeys/list, click on the key you have created and you can find it under "View Key Details" section.

The iOS AuthKey is the content of the key file.

Example:
```ruby
-----BEGIN PRIVATE KEY-----
...........................
          AUTH_KEY
...........................
-----END PRIVATE KEY-----
```

The iOS Topic is the bundle identifier of your iOS application.

![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/images/catapush_ios_token_based.png)

### Notification Service Extension
In order to process the push notification a Notification Service Extension is required.
An example is already implemented.

### AppGroups
Catapush need that the Notification Service Extension and the main application can share resources.
In order to do that you have to create and enable a specific app group for both the application and the extension.
The app and the extansion must be in the same app group.
![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/images/appgroup_1.png)
![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/images/appgroup_2.png)
![alt tag](https://github.com/Catapush/catapush-ios-sdk-pod/blob/master/images/catapush_ios_token_based.png)

You should also add this information in the App plist and the Extension plist:
```ruby
    <key>Catapush</key>
    <dict>
        <key>AppGroup</key>
        <string>group.catapush.test</string>
    </dict>
```
# UI appearance
You can easily configure the UI appearance by changing TextFont, Background color attributes. You can add this code in the method application of catapush-ios-swift-sdk-example/catapush-ios-swift-sdk-example/AppDelegate.swift 

```ruby
    MessageCollectionViewCell.cornerRadius = 10
    MessageCollectionViewCell.borderColor = UIColor(white:0,alpha:0.2)
    MessageCollectionViewCell.borderWidth = 0.5
    MessageCollectionViewCell.textColor = UIColor.white
    MessageCollectionViewCell.backgroundColor = UIColor.lightGray
    MessageCollectionViewCell.textFont = UIFont(name:"HelveticaNeue",size:18)!
    MessageNavigationBar.barTintColor = UIColor.red
    MessageNavigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor    : UIColor.green,
        NSAttributedString.Key.font        : UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!];
```
The following code shows how to change the appearance of the message bubbles and the navigation bar:
```ruby
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

     // ...

    MessageCollectionViewCell.cornerRadius = 2
    MessageCollectionViewCell.borderColor = UIColor(white:0,alpha:0.2)
    MessageCollectionViewCell.borderWidth = 0.5
    MessageCollectionViewCell.textColor = UIColor.white
    MessageCollectionViewCell.backgroundColor = UIColor.lightGray
        
    let shadow = NSShadow()
    shadow.shadowColor = UIColor(white:0,alpha:0.8)
    shadow.shadowOffset = CGSize(width: 0, height: 1)
    MessageNavigationBar.barTintColor = UIColor.red
    MessageNavigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor(red:245.0/255.0,green:245.0/255.0,blue:255.0/255.0,alpha:1),
        NSAttributedString.Key.font           : UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!,
        NSAttributedString.Key.shadow         : shadow
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
    * catapush-ios-sdk-pod/CatapushKit/Catapush.h
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
#import "Catapush.h"
```

7. Set Build Settings
Go ahead to "Build Settings", select "All" tab
    * Find "Linking" section and fill "Other Linker Flags" with: -ObjC -lxml2
    * Find "Swift Compiler - General" and fill "Objective-C Bridging Header" with: ```<projectname>-Bridging-Header.h```

8. You can copy/paste the AppDelegate from [AppDelegate.swift](https://raw.githubusercontent.com/Catapush/catapush-ios-swift-sdk-example/master/catapush-ios-swift-sdk-example/AppDelegate.swift) to your project
