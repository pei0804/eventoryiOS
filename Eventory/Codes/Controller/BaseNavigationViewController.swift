//
//  BaseNavigationViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/09/19.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor  = Colors.main
        self.navigationBar.isTranslucent = false
        self.toolbar.isTranslucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
