//
//  UserRegister.swift
//  Eventory
//
//  Created by jumpei on 2016/09/10.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import Foundation

class UserRegister {
    static let sharedInstance = UserRegister()
    
    private init() {}
    
    private var ud: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    func getSettingStatus() -> Bool {
        guard let isSetting = self.ud.objectForKey(SettingClass.Status.getUserSettingKey()) as? Bool else {
            return false
        }
        return isSetting
    }
    
    func setDefaultSettingStatus(isSetting: Bool) {
        if isSetting {
            self.ud.setObject(true, forKey: SettingClass.Status.getUserSettingKey())
            self.ud.synchronize()
        }
    }
    
    func getUserEventInfoUpdateTime() -> String {
        guard let updatedAt = self.ud.objectForKey(userEventInfoUpdatedAt) as? String else {
            return String()
        }
        return updatedAt
    }
    
    func setUserEventInfoUpdateTime() -> Void {

        dispatch_async(dispatch_get_main_queue(), {
            let now = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let updatedAt = formatter.stringFromDate(now)

            self.ud.setObject(updatedAt, forKey: userEventInfoUpdatedAt)
            self.ud.synchronize()
        })
    }
    
    func getUserSettingGenres() -> [String] {
        guard let userSettingGenres = self.ud.objectForKey(SettingClass.Genre.getUserSettingKey()) as? [String] else {
           return [String]()
        }
        return userSettingGenres
    }
    
    func getSettingGenres() -> [Dictionary<String, AnyObject>] {
        return self.ud.objectForKey(SettingClass.Genre.getSettingKey()) as! [Dictionary<String, AnyObject>]
    }
    
    func getUserSettingPlaces() -> [String] {
        guard let userSettingPlaces = self.ud.objectForKey(SettingClass.Place.getUserSettingKey()) as? [String] else {
            return [String]()
        }
        return userSettingPlaces
    }

    // 開催地を自由に設定出来ないように変更したので、その対応
    func migrationSettingPlaces() {

        var newUserSettingPlaces: [String] = []
        let userSettingPlaces = self.getUserSettingPlaces()
        var initSettingPlaces = EventManager.sharedInstance.placesInitializer()

        for i in initSettingPlaces.indices {

            if let name = initSettingPlaces[i]["name"] as! String? {
                if userSettingPlaces.indexOf(name) != nil {
                    newUserSettingPlaces.append(String(name))
                    initSettingPlaces[i]["status"] = true
                }
            }
        }
        let setting :String = SettingClass.Place.getSettingKey()
        let userSetting :String = SettingClass.Place.getUserSettingKey()

        // 設定の一覧
        self.ud.setObject(initSettingPlaces, forKey: setting)
        self.ud.synchronize()

        // 実際に検索に使うワード
        self.ud.setObject(newUserSettingPlaces, forKey: userSetting)
        self.ud.synchronize()

        return
    }
    
    func getSettingPlaces() -> [Dictionary<String, AnyObject>] {
        return self.ud.objectForKey(SettingClass.Place.getSettingKey()) as! [Dictionary<String, AnyObject>]
    }
    
    func setUserSettingRegister(ragisterSetting: [Dictionary<String, AnyObject>]?, settingClass: SettingClass) {
        var userRegisterSetting: [String] = []
        
        guard let ragisterSetting = ragisterSetting else {
            return
        }
        
        for i in ragisterSetting.indices {
            
            if let name = ragisterSetting[i]["name"] where ragisterSetting[i]["status"] as! Bool {
                userRegisterSetting.append(String(name))
            }
        }

        var setting: String = ""
        var userSetting: String = ""
        
        if SettingClass.Genre.rawValue == settingClass.rawValue {
            setting = SettingClass.Genre.getSettingKey()
            userSetting = SettingClass.Genre.getUserSettingKey()
        } else if SettingClass.Place.rawValue == settingClass.rawValue {
            setting = SettingClass.Place.getSettingKey()
            userSetting = SettingClass.Place.getUserSettingKey()
        } else {
            fatalError("UserDefaults設定に間違いがあります。DefineまたはRegister関連を確認してください。")
        }
        
        // 設定の一覧
        self.ud.setObject(ragisterSetting, forKey: setting)
        self.ud.synchronize()
        
        // 実際に検索に使うワード
        self.ud.setObject(userRegisterSetting, forKey: userSetting)
        self.ud.synchronize()
    }
    
    func insertNewSetting(inout ragisterSetting: [Dictionary<String, AnyObject>]?, newSetting: String) {
        guard (ragisterSetting != nil) else {
            return
        }
        ragisterSetting!.insert(["name":"\(newSetting)","status":true], atIndex: 0)
    }
    
    func deleteSetting(inout ragisterSetting: [Dictionary<String, AnyObject>]?, index: Int) {
        guard (ragisterSetting != nil) else {
            return
        }
        ragisterSetting!.removeAtIndex(index)
    }
}
