//
//  define.swift
//  Eventory
//
//  Created by jumpei on 2016/09/06.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import Foundation
import UIKit

// Cell
let EventInfoTableViewCellIdentifier: String = "EventInfoTableViewCell"
let CheckListTableViewCellIdentifier: String = "CheckListTableViewCell"
let SettingTableViewCellIdentifier: String   = "SettingTableViewCell"

// Controller
let RegisterPlaceViewControllerIdentifier: String   = "RegisterPlaceViewController"
let RegisterGenreViewControllerIdentifier: String   = "RegisterGenreViewController"
let SettingViewControllerIdentifier: String         = "SettingViewController"
let EventPageWebViewControllerIdentifier: String    = "EventPageWebViewController"

// Alert
let NetworkErrorTitle: String   = "サーバー接続に失敗しました"
let NetworkErrorMessage: String = "端末がインターネットが使えない。またはサーバーに問題がありました。"
let NetworkErrorButton: String  = "確認"
let ServerConnectionMessage: String = "サーバーと通信中"

// Cell
let EventInfoCellHeight = CGFloat(250)

enum ApiId: Int {
    
    case atdn       = 0
    case connpass   = 1
    case doorkeeper = 2
    case none       = 5
    
    func getName() -> String {
        
        switch self {
        case .atdn:       return "ATDN"
        case .connpass:   return "Connpass"
        case .doorkeeper: return "Doorkeeper"
        case .none:       return ""
        }
    }
}

// UserDefault

enum SettingClass: Int {
    
    case genre      = 0
    case place      = 1
    case status     = 2
    case none       = 5
    
    func getUserSettingKey() -> String {
        
        switch self {
        case .genre:    return "RegisterGenres"
        case .place:    return "RegisterPlaces"
        case .status:   return ""
        case .none:     return ""
        }
    }
    
    func getSettingKey() -> String {
        
        switch self {
        case .genre:    return "SettingGenres"
        case .place:    return "SettingPlaces"
        case .status:   return "SettingStatus"
        case .none:     return ""
        }
    }
}

let userEventInfoUpdatedAt = "UserEventInfoUpdatedAt"
