//
//  TerminalPreference.swift
//  Eventory
//
//  Created by jumpei on 2017/02/14.
//  Copyright © 2017年 jumpei. All rights reserved.
//

import RealmSwift

class TerminalPreference: Object {

    dynamic var id: Int = 0

    dynamic var updatedAt: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

enum TerminalPreferenceClass: Int {
    case EventFetch = 0
    case Tutorial = 1
    case None = 100
}
