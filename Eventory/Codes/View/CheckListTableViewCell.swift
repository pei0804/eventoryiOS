//
//  CheckListTableViewCell.swift
//  Eventory
//
//  Created by jumpei on 2016/09/06.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class CheckListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = Colors.main
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bind(_ userRegister: Dictionary<String, Any>) {
        self.textLabel?.text = userRegister["name"] as? String
        if userRegister["status"] as! Bool {
            self.check()
        } else {
            self.checkRemove()
        }
    }
    
    func checkAction(_ userRegister: inout [Dictionary<String, Any>]?, indexPath: IndexPath, checkCount: inout Int) {
        if self.accessoryType == .none {
            userRegister![indexPath.row]["status"] = true as Any?
            checkCount += 1
            self.check()
        } else {
            userRegister![indexPath.row]["status"] = false as Any?
            checkCount -= 1
            self.checkRemove()
        }
    }
    
    func check() {
        self.accessoryType = .checkmark
        self.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.textLabel?.textColor = Colors.main
    }
    
    func checkRemove() {
        self.accessoryType = .none
        self.textLabel?.font = UIFont.systemFont(ofSize: 17)
        self.textLabel?.textColor = UIColor.black
    }
}
