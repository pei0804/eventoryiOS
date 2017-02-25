//
//  ViewFormatter.swift
//  Eventory
//
//  Created by jumpei on 2016/08/21.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import Foundation

class ViewFormaatter {
    static let sharedInstance = ViewFormaatter()
    
    fileprivate init() {}
    
    func setEventDate(_ eventSummary: EventSummary) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        let startDate: String = dateFormatter.string(from: eventSummary.startAt as Date)
        dateFormatter.dateFormat = "MM月dd日 HH:mm"
        let endDate: String = dateFormatter.string(from: eventSummary.endAt as Date)
        return "\(startDate)〜\(endDate)"
    }
}
