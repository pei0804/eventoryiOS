//
//  BaseTableViewController.swift
//  Eventory
//
//  Created by jumpei on 2017/01/22.
//  Copyright © 2017年 jumpei. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SafariServices
import SVProgressHUD
import SwiftTask

class BaseTableViewController: UITableViewController {

    @IBOutlet weak var scrollView: UIScrollView?
    
    var viewPageClass: CheckStatus {
        return CheckStatus.None
    }

    var eventSummaries: [EventSummary]? {
        didSet {
            if let eventSummaries = self.eventSummaries where eventSummaries.count == 0 {
                self.tableView.setContentOffset(CGPointZero, animated: false)
            }
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = tableView
        self.addRefreshControl()
        self.refresh()

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        self.edgesForExtendedLayout = UIRectEdge.None

        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0)

        self.tableView.registerNib(UINib(nibName: EventInfoTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: EventInfoTableViewCellIdentifier)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.becomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        self.tableView.delegate = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    var refreshControlY: CGFloat = 3.0

    func addRefreshControl() {
        if let scrollView = self.scrollView {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "更新")
            refreshControl.addTarget(self, action: #selector(BaseViewController.pullRefresh(_:)), forControlEvents: .ValueChanged)
            if let tableView = scrollView as? UITableView {
                tableView.backgroundView = refreshControl
                tableView.alwaysBounceVertical = true
            }
            refreshControl.bounds.origin.y = -self.refreshControlY
            scrollView.alwaysBounceVertical = true
            scrollView.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.size.height-10), animated: true)
            self.refreshControl = refreshControl
        }
    }

    func handleRefresh() {
    }

    func becomeActive(notification: NSNotification) {
    }

    @IBAction func pullRefresh(refreshControl: UIRefreshControl) {
        SVProgressHUD.showWithStatus(ServerConnectionMessage)
        self.handleRefresh()
        self.refresh() {
            SVProgressHUD.dismiss()
            refreshControl.endRefreshing()
        }
    }

    func refresh(completed: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_main_queue()) {
            let task = [EventManager.sharedInstance.fetchNewEvent()]
            Task.all(task).success { _ in
                self.eventSummaries = self.getEventInfo(self.viewPageClass)
                completed?()
                }.failure { _ in
                    let alert: UIAlertController = UIAlertController(title: NetworkErrorTitle,message: NetworkErrorMessage, preferredStyle: .Alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: NetworkErrorButton, style: .Cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.eventSummaries = self.getEventInfo(self.viewPageClass)
                    completed?()
            }
        }
    }

    func getEventInfo(viewPageClass: CheckStatus) -> [EventSummary]? {
        switch viewPageClass {
        case .NoCheck:
            return EventManager.sharedInstance.getSelectNewEventAll()
        case .Keep:
            return EventManager.sharedInstance.getKeepEventAll()
        case .Search:
            return EventManager.sharedInstance.getNewEventAll("")
        case .NoKeep:
            return EventManager.sharedInstance.getNoKeepEventAll()
        case .None:
            return eventSummaries
        }
    }
}

// MARK: - UITableViewDataSource
extension BaseTableViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventSummaries = self.eventSummaries {
            return eventSummaries.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return EventInfoCellHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCellWithIdentifier(EventInfoTableViewCellIdentifier, forIndexPath: indexPath) as? EventInfoTableViewCell {
            if let eventSummaries = self.eventSummaries {
                cell.bind(eventSummaries[indexPath.row], indexPath: indexPath)
                return cell
            }
        }
        return UITableViewCell()
    }
}


// MARK: - UITableViewDelegate
extension BaseTableViewController: SFSafariViewControllerDelegate, UIWebViewDelegate {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {

        guard let eventSummaries = self.eventSummaries else {
            return
        }
        let url: String = eventSummaries[indexPath.row].url
        if !url.lowercaseString.hasPrefix("http://") && !url.lowercaseString.hasPrefix("https://") {
            let alert: UIAlertController = UIAlertController(title: "不正なリンクを検出しました", message: "このイベントに設定されているリンクに問題がありました。", preferredStyle: .Alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if #available(iOS 9.0, *) {
            let brow = SFSafariViewController(URL: NSURL(string: url)!, entersReaderIfAvailable: false)
            brow.delegate = self
            presentViewController(brow, animated: true, completion: nil)
        } else {
            let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewControllerWithIdentifier(EventPageWebViewControllerIdentifier) as! EventPageWebViewController
            vc.targetURL = url
            vc.navigationTitle = eventSummaries[indexPath.row].title
            presentViewController(vc, animated: true, completion: nil)
            // Fallback on earlier versions
        }
    }
}

// MARK: - DZNEmptyDataSetDelegate
extension BaseTableViewController: DZNEmptyDataSetDelegate {

    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "条件に合致する情報がありません"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]

        return NSAttributedString(string: text, attributes: attribs)
    }
}

// MARK: - DZNEmptyDataSetSource
extension BaseTableViewController: DZNEmptyDataSetSource {

    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetWillAppear(scrollView: UIScrollView!) {
        if let tableView = self.scrollView as? UITableView {
            tableView.separatorColor = UIColor.clearColor();
        }
    }

    func emptyDataSetDidDisappear(scrollView: UIScrollView!) {
        if let tableView = self.scrollView as? UITableView {
            tableView.separatorColor = UIColor.grayColor();
        }
    }
}
