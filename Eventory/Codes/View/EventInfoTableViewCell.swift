//
//  EventInfoTableViewCell.swift
//  Eventory
//
//  Created by jumpei on 2016/08/19.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class EventInfoTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.contentView.autoresizingMask = autoresizingMask;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var noKeepButton: NoKeepButton!
    @IBOutlet weak var keepButton: KeepButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var apiNameLbl: UILabel!
    @IBOutlet weak var eventStatusLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var titileLbl: UILabel!
    @IBOutlet weak var titleLblWidth: NSLayoutConstraint!
    
    var id: Int = 0
    var indexPath: IndexPath = IndexPath(index: 0)
    var eventSummary: EventSummary = EventSummary()
    let apiFromMessage = "情報提供元："
    
    fileprivate func keepEvent() {
        self.titileLbl.textColor = Colors.main
        self.keepButton.active()
        self.noKeepButton.noActive()
    }
    
    fileprivate func noKeepEvent() {
        self.titileLbl.textColor = Colors.noKeep
        self.noKeepButton.active()
        self.keepButton.noActive()
    }
    
    fileprivate func noCheckEvent() {
        self.titileLbl.textColor = Colors.noCheck
        self.noKeepButton.noActive()
        self.keepButton.noActive()
    }
    
    @IBAction func keepButton(_ sender: Any) {
        EventManager.sharedInstance.keepAction(id, isKeep: true)
        self.eventSummary.checkStatus = CheckStatus.keep.rawValue
        self.keepEvent()
    }
    
    @IBAction func noKeepButton(_ sender: Any) {
        EventManager.sharedInstance.keepAction(id, isKeep: false)
        self.eventSummary.checkStatus = CheckStatus.noKeep.rawValue
        self.noKeepEvent()
    }
    
    func bind(_ eventSummary: EventSummary, indexPath: IndexPath) {
        self.eventSummary = eventSummary
        
        // イベントの情報
        if self.eventSummary.checkStatus == CheckStatus.noCheck.rawValue {
            self.noCheckEvent()
        } else if self.eventSummary.checkStatus == CheckStatus.keep.rawValue {
            self.keepEvent()
        } else if self.eventSummary.checkStatus == CheckStatus.noKeep.rawValue {
            self.noKeepEvent()
        }
        
        if eventSummary.apiId == ApiId.atdn.rawValue {
            self.apiNameLbl.text = apiFromMessage + ApiId.atdn.getName()
            self.eventStatusLbl.text = "\(eventSummary.accepted) / 定員\(eventSummary.limit)人"
        } else if eventSummary.apiId == ApiId.connpass.rawValue {
            self.apiNameLbl.text = apiFromMessage + ApiId.connpass.getName()
            self.eventStatusLbl.text = "定員\(eventSummary.limit)人"
        } else if eventSummary.apiId == ApiId.doorkeeper.rawValue {
            self.eventStatusLbl.text = "\(eventSummary.accepted) / 定員\(eventSummary.limit)人"
            self.apiNameLbl.text = apiFromMessage + ApiId.doorkeeper.getName()
        }
        
        self.indexPath = indexPath
        
        self.titileLbl.text = eventSummary.title
        self.titileLbl.numberOfLines = 0
        self.titileLbl.lineBreakMode = .byWordWrapping
        
        self.addressLbl.text = eventSummary.address != "" ? eventSummary.address : "開催地未定"
        self.eventSummary.eventDate = ViewFormaatter.sharedInstance.setEventDate(eventSummary)
        self.dateLbl.text = eventSummary.eventDate
        
        self.id = eventSummary.id
    }
    
}
