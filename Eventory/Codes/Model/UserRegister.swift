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
    
    fileprivate init() {}
    
    fileprivate var ud: UserDefaults {
        return UserDefaults.standard
    }
    
    func getSettingStatus() -> Bool {
        guard let isSetting = self.ud.object(forKey: SettingClass.status.getUserSettingKey()) as? Bool else {
            return false
        }
        return isSetting
    }
    
    func setDefaultSettingStatus(_ isSetting: Bool) {
        if isSetting {
            self.ud.set(true, forKey: SettingClass.status.getUserSettingKey())
            self.ud.synchronize()
        }
    }
    
    func getUserSettingGenres() -> [String] {
        guard let userSettingGenres = self.ud.object(forKey: SettingClass.genre.getUserSettingKey()) as? [String] else {
           return [String]()
        }
        return userSettingGenres
    }
    
    func getSettingGenres() -> [Dictionary<String, Any>] {
        return self.ud.object(forKey: SettingClass.genre.getSettingKey()) as! [Dictionary<String, Any>]
    }
    
    func getUserSettingPlaces() -> [String] {
        guard let userSettingPlaces = self.ud.object(forKey: SettingClass.place.getUserSettingKey()) as? [String] else {
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
                if userSettingPlaces.index(of: name) != nil {
                    newUserSettingPlaces.append(String(name))
                    initSettingPlaces[i]["status"] = true as Any?
                }
            }
        }
        let setting :String = SettingClass.place.getSettingKey()
        let userSetting :String = SettingClass.place.getUserSettingKey()

        // 設定の一覧
        self.ud.set(initSettingPlaces, forKey: setting)
        self.ud.synchronize()

        // 実際に検索に使うワード
        self.ud.set(newUserSettingPlaces, forKey: userSetting)
        self.ud.synchronize()

        return
    }
    
    func getSettingPlaces() -> [Dictionary<String, Any>] {
        return self.ud.object(forKey: SettingClass.place.getSettingKey()) as! [Dictionary<String, Any>]
    }
    
    func setUserSettingRegister(_ ragisterSetting: [Dictionary<String, Any>]?, settingClass: SettingClass) {
        var userRegisterSetting: [String] = []
        
        guard let ragisterSetting = ragisterSetting else {
            return
        }
        
        for i in ragisterSetting.indices {
            
            if let name = ragisterSetting[i]["name"], ragisterSetting[i]["status"] as! Bool {
                userRegisterSetting.append(String(describing: name))
            }
        }

        var setting: String = ""
        var userSetting: String = ""
        
        if SettingClass.genre.rawValue == settingClass.rawValue {
            setting = SettingClass.genre.getSettingKey()
            userSetting = SettingClass.genre.getUserSettingKey()
        } else if SettingClass.place.rawValue == settingClass.rawValue {
            setting = SettingClass.place.getSettingKey()
            userSetting = SettingClass.place.getUserSettingKey()
        } else {
            fatalError("UserDefaults設定に間違いがあります。DefineまたはRegister関連を確認してください。")
        }
        
        // 設定の一覧
        self.ud.set(ragisterSetting, forKey: setting)
        self.ud.synchronize()
        
        // 実際に検索に使うワード
        self.ud.set(userRegisterSetting, forKey: userSetting)
        self.ud.synchronize()
    }
    
    func insertNewSetting(_ ragisterSetting: inout [Dictionary<String, Any>]?, newSetting: String) {
        guard (ragisterSetting != nil) else {
            return
        }
        ragisterSetting!.insert(["name":"\(newSetting)" as Any,"status":true as Any], at: 0)
    }
    
    func deleteSetting(_ ragisterSetting: inout [Dictionary<String, Any>]?, index: Int) {
        guard (ragisterSetting != nil) else {
            return
        }
        ragisterSetting!.remove(at: index)
    }
}
