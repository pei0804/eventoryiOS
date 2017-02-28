//
//  NoKeepEventViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/08/22.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftTask

class NoKeepEventViewController: BaseTableViewController {

    override var viewPageClass: CheckStatus {
        return CheckStatus.noKeep
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.show(withStatus: ServerConnectionMessage)
        self.handleRefresh()
        self.refresh() {
            SVProgressHUD.dismiss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func refresh(_ completed: (() -> Void)? = nil) {
        self.eventSummaries = EventManager.sharedInstance.getNoKeepEventAll()
        completed?()
    }
}
