//
//  DateFormatter.swift
//  Eventory
//
//  Created by jumpei on 2017/02/25.
//  Copyright © 2017年 jumpei. All rights reserved.
//

import Foundation

extension Date {
    public static func dateWithString(_ dateStr : String? , format : String, locale : Locale) ->Date? {
        if let uwDateStr = dateStr {
            let df : DateFormatter = DateFormatter()
            df.locale = Locale(identifier: "ja_JP")
            df.timeZone = TimeZone.current
            df.dateFormat = format
            return df.date(from: uwDateStr)
        }

        return nil
    }
}
