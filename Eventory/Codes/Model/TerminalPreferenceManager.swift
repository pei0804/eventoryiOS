//
//  TerminalPreferenceManager.swift
//  Eventory
//
//  Created by jumpei on 2017/02/14.
//  Copyright © 2017年 jumpei. All rights reserved.
//

import Alamofire
import ObjectMapper
import RealmSwift
import SwiftTask

class TerminalPreferenceManager {

    static let sharedInstance = TerminalPreferenceManager()

    private init() {}

    private var realm: Realm {

        guard let realm = try? Realm() else {
            fatalError("Realm error")
        }
        return realm
    }


    func getUserEventInfoUpdateTime(terminalPreferenceClass: TerminalPreferenceClass) -> String {
        let terminalPreference: Results<TerminalPreference> = self.realm.objects(TerminalPreference)
        guard let eventFetch = terminalPreference.filter("id == \(terminalPreferenceClass.rawValue)").first else {
            self.setUserEventInfoUpdateTime(terminalPreferenceClass)
            return ""
        }
        return eventFetch.updatedAt
    }

    func setUserEventInfoUpdateTime(terminalPreferenceClass: TerminalPreferenceClass) -> Void {
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let updatedAt = formatter.stringFromDate(now)

        do{
            try self.realm.write {
                self.realm.create(TerminalPreference.self, value: ["id": terminalPreferenceClass.rawValue, "updatedAt": updatedAt], update: true)
            }
        } catch {}
    }

    func resetUpdateTime() -> Void {
        do{
            try self.realm.write {
                self.realm.create(TerminalPreference.self, value: ["id": TerminalPreferenceClass.EventFetch.rawValue, "updatedAt": "2015-10-10 10:10:10"], update: true)
            }
        } catch {}
    }
}
