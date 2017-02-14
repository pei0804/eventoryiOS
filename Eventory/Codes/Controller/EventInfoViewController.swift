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
import SafariServices

class EventInfoViewController: BaseTableViewController {

    override var viewPageClass: CheckStatus {
        return CheckStatus.NoCheck
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated:Bool) {
        if sawWebView {
            sawWebView = false
        } else {
            SVProgressHUD.showWithStatus(ServerConnectionMessage)
            self.refresh() {
                SVProgressHUD.dismiss()
                self.tableView.setContentOffset(CGPointMake(0, -20), animated: true)
            }
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
                self.tableView.setContentOffset(CGPointMake(0, -20), animated: true)
            }
        }
    }
}
