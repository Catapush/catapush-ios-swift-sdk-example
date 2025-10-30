//
//  SceneDelegate.swift
//  catapush-ios-swift-sdk-example
//
//  Copyright © 2025 Catapush s.r.l. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, CatapushDelegate, MessagesDispatchDelegate, UIAlertViewDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()

        Catapush.setupCatapushStateDelegate(self, andMessagesDispatcherDelegate: self)

        var error: NSError?
        Catapush.start(&error)

        if let error = error {
            // API KEY, USERNAME or PASSWORD not set
            print("Error: \(error.localizedDescription)")
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        Catapush.applicationDidEnterBackground(UIApplication.shared)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        var error: NSError?
        Catapush.applicationWillEnterForeground(UIApplication.shared, withError: &error)

        if let error = error {
            // Handle error...
            print("Error: \(error.localizedDescription)")
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        Catapush.applicationDidBecomeActive(UIApplication.shared)
    }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneDidDisconnect(_ scene: UIScene) { }

    // MARK: - CatapushDelegate

    func catapushDidConnectSuccessfully(_ catapush: Catapush) {
        let alert = UIAlertController(title: "Connected", message: "Catapush Connected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))

        // Use scene window instead of deprecated keyWindow
        window?.rootViewController?.present(alert, animated: true)
    }

    func catapush(_ catapush: Catapush, didFailOperation operationName: String?, withError error: Error?) {
        let errorMessage = "The operation " + (operationName ?? "") + " is failed with error " + (error?.localizedDescription ?? "")
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))

        // Use scene window instead of deprecated keyWindow
        window?.rootViewController?.present(alert, animated: true)
    }

    // MARK: - MessagesDispatchDelegate

    func libraryDidReceive(_ messageIP: MessageIP?) {
        guard let messageIP else { return }
        MessageIP.sendMessageReadNotification(messageIP)
        print("Single message: \(messageIP.body)")
        print("---All Messages---")
        for message in Catapush.allMessages() {
            print("Message: \((message as! MessageIP).body)")
        }
    }
}
