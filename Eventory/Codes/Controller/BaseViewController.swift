//
//  BaseViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/09/18.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class BaseViewController: UIViewController {
    
    weak var refreshControl: UIRefreshControl?
    @IBOutlet weak var scrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.becomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var refreshControlY: CGFloat = 3.0
    
    func addRefreshControl() {
        if let scrollView = self.scrollView {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "更新")
            refreshControl.addTarget(self, action: #selector(BaseViewController.pullRefresh(_:)), for: .valueChanged)
            if let tableView = scrollView as? UITableView {
                tableView.backgroundView = refreshControl
            }
            refreshControl.bounds.origin.y = -self.refreshControlY
            scrollView.alwaysBounceVertical = true
            scrollView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height-10), animated: true)
            self.refreshControl = refreshControl
        }
    }
    
    
    func handleRefresh() {
    }

    func becomeActive(_ notification: Notification) {
    }

    @IBAction func pullRefresh(_ refreshControl: UIRefreshControl) {
        self.handleRefresh()
        self.refresh() {
            refreshControl.endRefreshing()
        }
    }
    
    func refresh(_ completed: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            completed?()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - DZNEmptyDataSetSource

extension BaseViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "条件に合致する情報がありません"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
}

// MARK: - DZNEmptyDataSetDelegate

extension BaseViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetWillAppear(_ scrollView: UIScrollView!) {
        if let tableView = self.scrollView as? UITableView {
            tableView.separatorColor = UIColor.clear;
        }
    }
    
    func emptyDataSetDidDisappear(_ scrollView: UIScrollView!) {
        if let tableView = self.scrollView as? UITableView {
            tableView.separatorColor = UIColor.gray;
        }
    }
}
