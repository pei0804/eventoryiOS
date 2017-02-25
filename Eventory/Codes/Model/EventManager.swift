//
//  EventManager.swift
//  Eventory
//
//  Created by jumpei on 2016/08/19.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import Alamofire
import ObjectMapper
import RealmSwift
import SwiftTask
import SwiftyJSON

class EventManager {

    static let sharedInstance = EventManager()

    private init() {}

    private var realm: Realm {
        guard let realm = try? Realm() else {
            fatalError("Realm error")
        }
        return realm
    }

    func getSelectNewEventAll() -> [EventSummary] {
        let genres: [String]! = UserRegister.sharedInstance.getUserSettingGenres()
        let places: [String]! = UserRegister.sharedInstance.getUserSettingPlaces()
        var selectGenre: String = ""

        // クエリ文字の結合が1回目かチェックする
        var firstFlg: Bool = false
        for genre in genres {
            if !firstFlg {
                selectGenre += "AND (title CONTAINS[c] '\(genre)' "
                firstFlg = true
            }
            selectGenre += "OR title CONTAINS[c] '\(genre)' "
        }
        // 0は許容していないがバグ回避のためチェック
        if genres.count != 0 {
            selectGenre += ")"
        }

        firstFlg = false
        for place in places {
            if !firstFlg {
                selectGenre += "AND (address CONTAINS[c] '\(place)' OR  place CONTAINS[c] '\(place)'"
                firstFlg = true
            }
            selectGenre += "OR address CONTAINS[c] '\(place)' OR place CONTAINS[c] '\(place)' "
        }
        // 0は許容していないがバグ回避のためチェック
        if places.count != 0 {
            selectGenre += ")"
        }

        let events: Results<Event> = self.realm.objects(Event.self).filter("checkStatus == \(CheckStatus.noCheck.rawValue) \(selectGenre)").sorted(byProperty: "startAt")
        return setEventInfo(events)
    }

    func getKeepEventAll() -> [EventSummary] {
        let events: Results<Event> = self.realm.objects(Event.self).filter("checkStatus == \(CheckStatus.keep.rawValue)").sorted(byProperty: "startAt")
        return setEventInfo(events)
    }

    func getNoKeepEventAll() -> [EventSummary] {
        let events: Results<Event> = self.realm.objects(Event.self).filter("checkStatus == \(CheckStatus.noKeep.rawValue)").sorted(byProperty: "startAt")
        return setEventInfo(events)
    }

    func setEventInfo(_ searchEvents: Results<Event>) -> [EventSummary] {
        var eventSummaries: [EventSummary] = [EventSummary]()
        for event in searchEvents {
            let eventSummary: EventSummary = EventSummary()
            eventSummary.id         = event.id
            eventSummary.apiId      = event.apiId
            eventSummary.eventId    = event.eventId
            eventSummary.title      = event.title
            //eventSummary.desc = event.desc
            eventSummary.url        = event.url
            eventSummary.limit      = event.limit
            eventSummary.accepted   = event.accepted
            //eventSummary.waitlisted = event.waitlisted
            eventSummary.address    = event.address
            eventSummary.place      = event.place
            eventSummary.startAt    = event.startAt as Date
            eventSummary.endAt      = event.endAt as Date
            eventSummary.checkStatus = event.checkStatus
            eventSummaries.append(eventSummary)
        }
        return eventSummaries
    }

    func eventInitializer() {
        self.realm.beginWrite()
        let oldLocations = self.realm.objects(Event.self).filter(NSPredicate(format:"startAt < %@", NSDate().addingTimeInterval(0)))
        self.realm.delete(oldLocations)
        do {
            try realm.commitWrite()
        }
        catch {
            fatalError("Realm can not delete")
        }
    }

    func keepAction(_ id: Int, isKeep: Bool) {
        if let thisEvent = self.realm.objects(Event.self).filter("id == \(id)").first {
            if isKeep {

                do {
                    try self.realm.write {
                        thisEvent.checkStatus = CheckStatus.keep.rawValue
                    }
                }
                catch {
                    fatalError("Realm can not wirte")
                }

            } else {

                do {
                    try self.realm.write {
                        thisEvent.checkStatus = CheckStatus.noKeep.rawValue
                    }
                }
                catch {
                    fatalError("Realm can not wirte")
                }
            }
        }
    }

    func fetchNewEvent() -> Task<Float, String, NSError?> {
        var updatedAt = TerminalPreferenceManager.sharedInstance.getUserEventInfoUpdateTime(TerminalPreferenceClass.eventFetch)
        let places = UserRegister.sharedInstance.getUserSettingPlaces()
        let result = self.realm.objects(Event.self)

        // 初回ダウンロードは更新時間は関係なしに取ってくるが、
        // サーバーとの通信エラーが発生するとそのまま更新時間がセットされてしまうので、
        // それの対策のために便宜的にupdatedAtを空にしている。
        if(result.count == 0) {
            updatedAt = ""
        }

        let API = APISetting.scheme + APISetting.host


        return Task<Float, String, NSError?> { progress, fulfill, reject, configure in
            Alamofire.request("\(API)/api/smt/events", parameters: ["updated_at": updatedAt, "places": places.joined(separator: ",")]).responseJSON { (response) in

                if let statusCode = response.response?.statusCode {
                    if statusCode == 304 {
                        fulfill("SUCCESS")
                        return
                    }
                }

                guard response.result.isSuccess, let value = response.result.value else {
                    reject(nil)
                    return
                }

                // write request result to realm database
                let json = JSON(value)
                self.realm.beginWrite()
                for (_, subJson) : (String, JSON) in json {
                    let event: Event = Mapper<Event>().map(JSONObject: subJson.dictionaryObject!)!
                    self.realm.add(event, update: true)
                }

                do {
                    try self.realm.commitWrite()
                } catch {

                }
                fulfill("SUCCESS")
                TerminalPreferenceManager.sharedInstance.setUserEventInfoUpdateTime(TerminalPreferenceClass.eventFetch)
            }
        }
    }

    func genreInitializer() ->  [Dictionary<String, Any>] {
        let genreArray: [Dictionary<String, Any>] = [
            [
                "name": "Javascript",
                "status": false
            ],
            [
                "name": "PHP",
                "status": false
            ],
            [
                "name": "Java",
                "status": false
            ],
            [
                "name": "Swift",
                "status": false
            ],
            [
                "name": "Ruby",
                "status": false
            ],
            [
                "name": "Python",
                "status": false
            ],
            [
                "name": "Perl",
                "status": false
            ],
            [
                "name": "Scala",
                "status": false
            ],
            [
                "name": "Haskell",
                "status": false
            ],
            [
                "name": "Go",
                "status": false
            ],
            [
                "name": "LT",
                "status": false
            ],
            [
                "name": "HTML",
                "status": false
            ],
            [
                "name": "CSS",
                "status": false
            ],
            [
                "name": "jQuery",
                "status": false
            ]
        ]
        return genreArray
    }


    func placesInitializer() ->  [Dictionary<String, Any>] {
        let place: [Dictionary<String, Any>] = [
            [
                "name": "北海道",
                "status": false
            ],
            [
                "name": "青森県",
                "status": false
            ],
            [
                "name": "岩手県",
                "status": false
            ],
            [
                "name": "宮城県",
                "status": false
            ],
            [
                "name": "秋田県",
                "status": false
            ],
            [
                "name": "山形県",
                "status": false
            ],
            [
                "name": "福島県",
                "status": false
            ],
            [
                "name": "茨城県",
                "status": false
            ],
            [
                "name": "栃木県",
                "status": false
            ],
            [
                "name": "群馬県",
                "status": false
            ],
            [
                "name": "埼玉県",
                "status": false
            ],
            [
                "name": "千葉県",
                "status": false
            ],
            [
                "name": "東京都",
                "status": false
            ],
            [
                "name": "神奈川県",
                "status": false
            ],
            [
                "name": "新潟県",
                "status": false
            ],
            [
                "name": "富山県",
                "status": false
            ],
            [
                "name": "石川県",
                "status": false
            ],
            [
                "name": "福井県",
                "status": false
            ],
            [
                "name": "山梨県",
                "status": false
            ],
            [
                "name": "岐阜県",
                "status": false
            ],
            [
                "name": "静岡県",
                "status": false
            ],
            [
                "name": "愛知県",
                "status": false
            ],
            [
                "name": "三重県",
                "status": false
            ],
            [
                "name": "滋賀県",
                "status": false
            ],
            [
                "name": "京都府",
                "status": false
            ],
            [
                "name": "大阪府",
                "status": false
            ],
            [
                "name": "兵庫県",
                "status": false
            ],
            [
                "name": "奈良県",
                "status": false
            ],
            [
                "name": "和歌山県",
                "status": false
            ],
            [
                "name": "鳥取県",
                "status": false
            ],
            [
                "name": "島根県",
                "status": false
            ],
            [
                "name": "岡山県",
                "status": false
            ],
            [
                "name": "広島県",
                "status": false
            ],
            [
                "name": "山口県",
                "status": false
            ],
            [
                "name": "徳島県",
                "status": false
            ],
            [
                "name": "香川県",
                "status": false
            ],
            [
                "name": "愛媛県",
                "status": false
            ],
            [
                "name": "高知県",
                "status": false
            ],
            [
                "name": "福岡県",
                "status": false
            ],
            [
                "name": "佐賀県",
                "status": false
            ],
            [
                "name": "長崎県",
                "status": false
            ],
            [
                "name": "熊本県",
                "status": false
            ],
            [
                "name": "大分県",
                "status": false
            ],
            [
                "name": "宮崎県",
                "status": false
            ],
            [
                "name": "鹿児島県",
                "status": false
            ],
            [
                "name": "沖縄県",
                "status": false
            ]
        ]
        return place
    }
}
