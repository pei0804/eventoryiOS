//
//  PushNotificationManager.swift
//  Eventory
//
//  Created by jumpei on 2016/09/11.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit
import Firebase

class PushNotificationManager {
    
    static let sharedInstance = PushNotificationManager()
    
    var enabled: Bool {
        if let currentSettings = UIApplication.shared.currentUserNotificationSettings {
            if currentSettings.types != UIUserNotificationType() {
                return true
            }
        }
        return false
    }
    
    // TODO:　プッシュ通知の実装
    func registerRemote() {
        let application = UIApplication.shared
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        FIRApp.configure()
    }
}
