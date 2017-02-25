//
//  EventoryModel.swift
//  Eventory
//
//  Created by jumpei on 2016/07/10.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import RealmSwift
import ObjectMapper

class Event: Object {
    
    // 管理ID
    dynamic var id: Int = 0
    
    // イベントのID　主キー
    dynamic var eventId: String = ""
    
    // API識別ID
    dynamic var apiId: Int = 0
    
    // イベントタイトル
    dynamic var title: String = ""
    
    // 説明文
    //dynamic var desc: String = ""
    
    // URL
    dynamic var url: String = ""
    
    // 定員
    dynamic var limit: Int = 0
    
    // 現在の参加者数 connpassにはない
    dynamic var accepted: Int  = 0
    
    // キャンセル待ち
    //dynamic var waitlisted: Int = 0
    
    // 開催住所
    dynamic var address: String = ""
    
    //　開催場所
    dynamic var place: String = ""
    
    // 開催日時
    dynamic var startAt: Date = Date()
    
    // 終了日時
    dynamic var endAt: Date = Date()
    
    // 分別ステータス
    dynamic var checkStatus: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
}

extension Event: Mappable {
    func mapping(map: Map) {
        id              <- map["id"]
        eventId         <- map["event_id"]
        apiId           <- map["api_id"]
        title           <- map["title"]
        //desc            <- map["desc"]
        url             <- map["url"]
        limit           <- map["limit"]
        accepted        <- map["accepted"]
        //        waitlisted      <- map["waitlisted"]
        address         <- map["address"]
        place           <- map["place"]
        startAt         <- (map["start_at"], EntryDateTransform())
        endAt           <- (map["end_at"], EntryDateTransform())
    }
}

class EntryDateTransform : DateTransform {
    override func transformFromJSON(_ value: Any?) -> Date? {
        if let dateStr = value as? String {
            return Date.dateWithString(
                dateStr,
                format: "yyyy-MM-dd'T'HH:mm:ss'Z" ,
                locale : Locale(identifier: "ja_JP"))
        }
        return nil
    }
}
