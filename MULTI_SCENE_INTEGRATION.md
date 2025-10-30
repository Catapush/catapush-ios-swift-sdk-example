# Multi-Scene Integration Guide for Catapush iOS SDK

## Table of Contents

1. [Introduction](#introduction)
2. [Architecture Overview](#architecture-overview)
3. [Implementation Guide](#implementation-guide)
4. [Lifecycle Management](#lifecycle-management)

---

## Introduction

### What is Multi-Scene Support?

Multi-scene support, introduced in iOS 13, enables your app to have multiple active windows simultaneously. This is particularly useful on iPad where users can:
- Open multiple instances of your app side-by-side
- Work with different content in separate windows
- Switch between windows using App Exposé

### When to Use Multi-Scene

**Recommended for:**
- iPad-focused applications
- Messaging apps where users compare multiple conversations
- Document-based apps
- Apps targeting Mac Catalyst

**Not recommended for:**
- iPhone-first applications (limited benefit)
- Simple, single-purpose apps
- Apps with complex shared state that's difficult to synchronize

### Requirements

- **iOS 15.0+**
- **Xcode 13.0+**
- **Swift 5.0+**
- **Catapush iOS SDK 2.2.4+**

> **⚠️ Important**: The Catapush SDK is designed as a singleton service. Special care must be taken when integrating with multi-scene architecture to avoid connection conflicts and delegate management issues.

---

## Architecture Overview

### Single-Scene vs Multi-Scene Architecture

#### Single-Scene (Current Implementation)

```
App Launch → AppDelegate → SceneDelegate (one instance)
                              ↓
                         Catapush.start()
                         Setup delegates
```

**Characteristics:**
- One SceneDelegate instance per app session
- Direct Catapush integration in SceneDelegate
- Simple lifecycle management
- No coordination needed

#### Multi-Scene Architecture

```
App Launch → AppDelegate → Multiple SceneDelegate instances
                              ↓           ↓           ↓
                          Scene 1    Scene 2    Scene 3
                              ↓           ↓           ↓
                              └───────────┴───────────┘
                                         ↓
                                 CatapushManager (singleton)
                                         ↓
                                   Catapush SDK
```

**Characteristics:**
- Multiple SceneDelegate instances (one per window)
- Shared CatapushManager singleton
- Lifecycle state aggregation required
- Delegate broadcasting to all scenes

> **💡 Key Insight**: You cannot call `Catapush.start()` multiple times or register multiple delegates directly. A coordinator pattern is required.

---

## Implementation Guide

### Step 1: Create CatapushManager Singleton

Create a new file `CatapushManager.swift`:

```swift
import Foundation
import UIKit

/// Protocol for scenes to receive Catapush events
protocol CatapushManagerDelegate: AnyObject {
    func catapushManagerDidConnect()
    func catapushManagerDidFailOperation(_ operationName: String?, error: Error?)
    func catapushManagerDidReceiveMessage(_ message: MessageIP)
}

/// Singleton manager coordinating Catapush SDK across multiple scenes
class CatapushManager: NSObject {

    // MARK: - Singleton

    static let shared = CatapushManager()

    // MARK: - Properties

    /// Weak references to scene delegates
    private var delegates = NSHashTable<AnyObject>.weakObjects()

    /// Tracks if Catapush has been started
    private var isStarted = false

    /// Count of scenes currently in foreground state
    private var foregroundSceneCount = 0

    /// Lock for thread-safe access
    private let lock = NSLock()

    // MARK: - Initialization

    private override init() {
        super.init()
        // Configuration is done in AppDelegate
        // Actual start is deferred until first scene connects
    }

    // MARK: - Scene Lifecycle Coordination

    /// Call when a scene connects for the first time
    func sceneDidConnect() {
        lock.lock()
        defer { lock.unlock() }

        // Start Catapush only once, when first scene connects
        if !isStarted {
            var error: NSError?
            Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)
            Catapush.start(&error)

            if let error = error {
                print("⚠️ Catapush start error: \(error.localizedDescription)")
            } else {
                print("✅ Catapush started successfully")
            }

            isStarted = true
        }
    }

    /// Call when a scene transitions to foreground
    func sceneWillEnterForeground() {
        lock.lock()
        defer { lock.unlock() }

        foregroundSceneCount += 1

        // Notify Catapush only when first scene enters foreground
        if foregroundSceneCount == 1 {
            var error: NSError?
            Catapush.applicationWillEnterForeground(UIApplication.shared, withError: &error)

            if let error = error {
                print("⚠️ Catapush foreground error: \(error.localizedDescription)")
            }
        }
    }

    /// Call when a scene becomes active
    func sceneDidBecomeActive() {
        lock.lock()
        defer { lock.unlock() }

        // Notify Catapush only when transitioning from no active scenes to active
        if foregroundSceneCount == 1 {
            Catapush.applicationDidBecomeActive(UIApplication.shared)
        }
    }

    /// Call when a scene enters background
    func sceneDidEnterBackground() {
        lock.lock()
        defer { lock.unlock() }

        foregroundSceneCount -= 1

        // Notify Catapush only when all scenes have entered background
        if foregroundSceneCount == 0 {
            Catapush.applicationDidEnterBackground(UIApplication.shared)
        }
    }

    // MARK: - Delegate Management

    /// Register a scene delegate to receive Catapush events
    /// - Parameter delegate: Scene delegate conforming to CatapushManagerDelegate
    func addDelegate(_ delegate: CatapushManagerDelegate) {
        lock.lock()
        defer { lock.unlock() }

        delegates.add(delegate)
        print("📱 Scene delegate added. Total: \(delegates.allObjects.count)")
    }

    /// Unregister a scene delegate
    /// - Parameter delegate: Scene delegate to remove
    func removeDelegate(_ delegate: CatapushManagerDelegate) {
        lock.lock()
        defer { lock.unlock() }

        delegates.remove(delegate)
        print("📱 Scene delegate removed. Total: \(delegates.allObjects.count)")
    }

    /// Broadcast event to all registered scene delegates
    /// - Parameter block: Closure called for each delegate
    private func notifyDelegates(_ block: @escaping (CatapushManagerDelegate) -> Void) {
        lock.lock()
        let allDelegates = delegates.allObjects.compactMap { $0 as? CatapushManagerDelegate }
        lock.unlock()

        // Notify on main thread to ensure UI updates are safe
        DispatchQueue.main.async {
            for delegate in allDelegates {
                block(delegate)
            }
        }
    }
}

// MARK: - CatapushDelegate

extension CatapushManager: CatapushDelegate {

    func catapushDidConnectSuccessfully(_ catapush: Catapush) {
        print("✅ Catapush connected successfully")

        notifyDelegates { delegate in
            delegate.catapushManagerDidConnect()
        }
    }

    func catapush(_ catapush: Catapush, didFailOperation operationName: String?, withError error: Error?) {
        print("⚠️ Catapush operation failed: \(operationName ?? "unknown") - \(error?.localizedDescription ?? "no error")")

        notifyDelegates { delegate in
            delegate.catapushManagerDidFailOperation(operationName, error: error)
        }
    }
}

// MARK: - MessagesDispatchDelegate

extension CatapushManager: MessagesDispatchDelegate {

    func libraryDidReceive(_ messageIP: MessageIP?) {
        guard let messageIP = messageIP else { return }

        // Send read notification
        MessageIP.sendMessageReadNotification(messageIP)

        print("📨 Message received: \(messageIP.body)")
        print("📋 All messages count: \(Catapush.allMessages().count)")

        // Broadcast to all scenes
        notifyDelegates { delegate in
            delegate.catapushManagerDidReceiveMessage(messageIP)
        }
    }
}
```

### Step 2: Update SceneDelegate

Modify your `SceneDelegate.swift`:

```swift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CatapushManagerDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Scene Lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Setup window
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()

        // Register with CatapushManager instead of calling Catapush directly
        CatapushManager.shared.addDelegate(self)
        CatapushManager.shared.sceneDidConnect()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Notify manager - it will coordinate with other scenes
        CatapushManager.shared.sceneDidEnterBackground()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Notify manager - it will coordinate with other scenes
        CatapushManager.shared.sceneWillEnterForeground()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Notify manager - it will coordinate with other scenes
        CatapushManager.shared.sceneDidBecomeActive()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Handle scene becoming inactive
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Scene disconnected - clean up this scene's registration
        CatapushManager.shared.removeDelegate(self)
    }

    // MARK: - CatapushManagerDelegate

    func catapushManagerDidConnect() {
        // Show connection success in this scene's window
        let alert = UIAlertController(
            title: "Connected",
            message: "Catapush Connected",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        window?.rootViewController?.present(alert, animated: true)
    }

    func catapushManagerDidFailOperation(_ operationName: String?, error: Error?) {
        // Show error in this scene's window
        let errorMessage = "The operation \(operationName ?? "unknown") failed with error: \(error?.localizedDescription ?? "unknown error")"

        let alert = UIAlertController(
            title: "Error",
            message: errorMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        window?.rootViewController?.present(alert, animated: true)
    }

    func catapushManagerDidReceiveMessage(_ message: MessageIP) {
        // Message received - UI updates handled automatically by FetchedResultsController
        // Optionally show notification banner in this scene
        print("📨 Message received in scene: \(message.body)")
    }
}
```

### Step 3: Update AppDelegate (Minimal Changes)

Your `AppDelegate.swift` remains mostly unchanged:

```swift
import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Global Catapush configuration
        Catapush.setAppKey("YOUR_APP_KEY")
        Catapush.setIdentifier("test", andPassword: "test")

        // Register for push notifications - must be on AppDelegate, not SceneDelegate
        Catapush.registerUserNotification(self)

        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self

        return true
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session
        // Use this method to release any resources that were specific to the discarded scenes
    }

    // MARK: - Remote Notifications

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // This method is hooked by Catapush SDK via method swizzling
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("⚠️ Failed to register for remote notifications: \(error.localizedDescription)")
    }

    // MARK: - UNUserNotificationCenterDelegate

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }
}
```

### Step 4: Update Info.plist

In your `Info.plist`, change the multi-scene support flag:

```xml
<key>UIApplicationSceneManifest</key>
<dict>
    <key>UIApplicationSupportsMultipleScenes</key>
    <true/>  <!-- Change from <false/> to <true/> -->

    <key>UISceneConfigurations</key>
    <dict>
        <key>UIWindowSceneSessionRoleApplication</key>
        <array>
            <dict>
                <key>UISceneConfigurationName</key>
                <string>Default Configuration</string>
                <key>UISceneDelegateClassName</key>
                <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
                <key>UISceneStoryboardFile</key>
                <string>Main</string>
            </dict>
        </array>
    </dict>
</dict>
```

---

## Lifecycle Management

### Understanding Scene Lifecycle Aggregation

With multiple scenes, the app's lifecycle state is the aggregate of all scene states:

```
Scene 1: Active      │  App State: Foreground
Scene 2: Active      │

Scene 1: Background  │  App State: Foreground (Scene 2 still active)
Scene 2: Active      │

Scene 1: Background  │  App State: Background (all scenes inactive)
Scene 2: Background  │
```

### Lifecycle Coordination Logic

The `CatapushManager` implements this logic:

```swift
// Track number of foreground scenes
private var foregroundSceneCount = 0

func sceneWillEnterForeground() {
    foregroundSceneCount += 1

    // Call Catapush ONLY when first scene enters foreground
    if foregroundSceneCount == 1 {
        Catapush.applicationWillEnterForeground(...)
    }
}

func sceneDidEnterBackground() {
    foregroundSceneCount -= 1

    // Call Catapush ONLY when last scene enters background
    if foregroundSceneCount == 0 {
        Catapush.applicationDidEnterBackground(...)
    }
}
```

### Thread Safety

All lifecycle methods use a lock to ensure thread-safe access:

```swift
private let lock = NSLock()

func sceneWillEnterForeground() {
    lock.lock()
    defer { lock.unlock() }
    // ... safely modify foregroundSceneCount
}
```

> **⚠️**: Without thread safety, simultaneous scene transitions could lead to incorrect foreground counts and missed Catapush lifecycle calls.
