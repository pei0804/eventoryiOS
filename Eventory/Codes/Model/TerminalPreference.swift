//
//  TerminalPreference.swift
//  Eventory
//
//  Created by jumpei on 2017/02/14.
//  Copyright © 2017年 jumpei. All rights reserved.
//

import RealmSwift

class EventFetchUpdatedAt: Object {

    dynamic var id: Int = 0

    dynamic var updatedAt: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
