//
//  KeepButton.swift
//  Eventory
//
//  Created by jumpei on 2016/12/30.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class KeepButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4.0
    }
    
    func active() {
        self.layer.backgroundColor = Colors.main.cgColor
        self.layer.borderColor = UIColor.clear.cgColor;
        self.layer.borderWidth = 0;
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.setImage(UIImage(named:"keepActive.png"), for: UIControlState())
        
    }
    
    func noActive() {
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.borderColor = Colors.main.cgColor;
        self.layer.borderWidth = 2;
        self.setTitleColor(Colors.main, for: UIControlState())
        self.setImage(UIImage(named:"keepNoActive.png"), for: UIControlState())
    }
}
