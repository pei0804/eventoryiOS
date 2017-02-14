//
//  EventInfoViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/08/19.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftTask

class EventInfoViewController: BaseTableViewController {

    override var viewPageClass: CheckStatus {
        return CheckStatus.NoCheck
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated:Bool) {
        SVProgressHUD.showWithStatus(ServerConnectionMessage)
        self.refresh() {
            SVProgressHUD.dismiss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillEnterForeground(notification: NSNotification?) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = -1
        if (self.isViewLoaded() && (self.view.window != nil)) {
            SVProgressHUD.showWithStatus(ServerConnectionMessage)
            self.refresh() {
                SVProgressHUD.dismiss()
            }
        }
    }
}
