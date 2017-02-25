//
//  NoKeepButton.swift
//  Eventory
//
//  Created by jumpei on 2016/12/31.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class NoKeepButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4.0
    }
    
    func active() {
        self.layer.borderColor = UIColor.clear.cgColor;
        self.layer.backgroundColor = Colors.noKeep.cgColor
        self.layer.borderWidth = 0;
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.setImage(UIImage(named:"noKeepActive.png"), for: UIControlState())
    }
    
    func noActive() {
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.borderColor = Colors.noKeep.cgColor;
        self.layer.borderWidth = 2;
        self.setTitleColor(Colors.noKeep, for: UIControlState())
        self.setImage(UIImage(named:"noKeepNoActive.png"), for: UIControlState())
    }
}
