//
//  AppDelegate.swift
//  Eventory
//
//  Created by jumpei on 2016/08/19.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit
import Firebase
import SwiftTask
import SVProgressHUD
import iRate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        iRate.sharedInstance().applicationBundleID = "xyz.ganbaruman.Eventory"
        iRate.sharedInstance().onlyPromptIfLatestVersion = false
        iRate.sharedInstance().usesUntilPrompt = 10
        iRate.sharedInstance().eventsUntilPrompt = 0
        iRate.sharedInstance().daysUntilPrompt = 3

        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setBackgroundLayerColor(UIColor.white)

        // TODO: パス確認用（削除必須）
        //        print(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true))
        PushNotificationManager.sharedInstance.registerRemote()

        // TODO ここらへんどうにかしたい
        if !UserRegister.sharedInstance.getSettingStatus() {
            let storyboard = UIStoryboard(name: "Register", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "signUp")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        } else {
            EventManager.sharedInstance.eventInitializer()
            UserRegister.sharedInstance.migrationSettingPlaces()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainMenu")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {

    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""

        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }

        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.unknown)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        DispatchQueue.main.async {
            let task = [EventManager.sharedInstance.fetchNewEvent()]
            Task.all(task).success { _ in
                if EventManager.sharedInstance.getSelectNewEventAll().count > 0 {
                    UIApplication.shared.applicationIconBadgeNumber = 1
                }
                completionHandler(.newData)
                }.failure { _ in
                    completionHandler(.failed)
            }
        }
    }
}

