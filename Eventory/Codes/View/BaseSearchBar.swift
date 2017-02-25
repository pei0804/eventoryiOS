//
//  BaseSearchBar.swift
//  Eventory
//
//  Created by jumpei on 2017/01/24.
//  Copyright © 2017年 jumpei. All rights reserved.
//

import UIKit

class BaseSearchBar: UISearchBar {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4.0
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 40)
        self.tintColor = Colors.main
    }
}



