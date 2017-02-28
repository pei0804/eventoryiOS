//
//  EventSummary.swift
//  Eventory
//
//  Created by jumpei on 2016/08/19.
//  Copyright © 2016年 jumpei. All rights reserved.
//
import Foundation

class EventSummary {
    
    // 管理ID
    var id: Int = 0
    
    // イベントのID　主キー
    var eventId: String = ""
    
    // APIの種別　主キー
    var apiId: Int = 0
    
    // イベントタイトル
    var title: String = ""
    
    // キャッチフレーズ doorkiiperにはない
    var catchphrase: String = ""
    
    // 説明文
    //var desc: String = ""
    
    // URL
    var url: String = ""
    
    // 定員
    var limit: Int = 0
    
    // 現在の参加者数 connpassにはない
    var accepted: Int  = 0
    
    // キャンセル待ち
    //var waitlisted: Int = 0
    
    // 開催住所
    var address: String = ""
    
    //　開催場所
    var place: String = ""
    
    // 開催日時
    var startAt: Date = Date()
    
    // 終了日時
    var endAt: Date = Date()
    
    // 分別ステータス
    var checkStatus: Int = 0
    
    //　開始日
    var eventDate: String = ""
    
    func updateWithEvent(_ event: Event) {
        self.eventId        = event.eventId
        self.title          = event.title
        self.apiId          = event.apiId
        //self.desc           = event.desc
        self.url            = event.url
        self.limit          = event.limit
        self.accepted       = event.accepted
        //self.waitlisted     = event.waitlisted
        self.address        = event.address
        self.place          = event.place
        self.startAt        = event.startAt as Date
        self.endAt          = event.endAt as Date
    }
}

enum Api: Int {
    case atdn = 0
    case connpass = 1
    case doorkeeper = 2
    case none = 5
    
    func getName() -> String {
        switch self {
        case .atdn:         return "ATDN"
        case .connpass:     return "Connpass"
        case .doorkeeper:   return "Doorkeeper"
        case .none:         return ""
        }
    }
}

enum CheckStatus: Int {
    case noCheck = 0
    case keep = 1
    case noKeep = 2
    case none = 5
    
    func getName() -> String {
        switch self {
        case .noCheck:   return ""
        case .keep:      return "キープ"
        case .noKeep:    return "興味なし"
        case .none:      return ""
        }
    }
}

