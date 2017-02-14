//
//  APISetting.swift
//  Eventory
//
//  Created by jumpei on 2017/01/27.
//  Copyright © 2017年 jumpei. All rights reserved.
//

// PROJECT -> Build Setting -> Other Swift Flags -> -D STAGING
struct APISetting {
    #if LOCALHOST
    static let scheme = "http://"
    static let host = "localhost:8080"
    #elseif STAGING
    static let scheme = "https://"
    static let host = "eventory-staging.appspot.com"
    #else // PRODUCTION
    static let scheme = "https://"
    static let host = "eventory-155000.appspot.com"
    #endif
}
