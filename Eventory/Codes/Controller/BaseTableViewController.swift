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

internal class BaseTableViewController: UITableViewController {

    @IBOutlet weak var scrollView: UIScrollView?
    
    var viewPageClass: CheckStatus {
        return CheckStatus.none
    }

    // TODO いつか変える
    var sawWebView: Bool = false

    var eventSummaries: [EventSummary]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView = tableView
        self.addRefreshControl()

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self

        self.edgesForExtendedLayout = UIRectEdge()

        self.tableView.tableFooterView = UIView()
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 0, 0)

        self.tableView.register(UINib(nibName: EventInfoTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: EventInfoTableViewCellIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        self.tableView.delegate = nil
        NotificationCenter.default.removeObserver(self)
    }

    var refreshControlY: CGFloat = 3.0

    func addRefreshControl() {
        if let scrollView = self.scrollView {
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "更新")
            refreshControl.addTarget(self, action: #selector(BaseViewController.pullRefresh(_:)), for: .valueChanged)
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
        self.goTop()
    }

    func viewWillEnterForeground(_ notification: Notification?) {
        UIApplication.shared.applicationIconBadgeNumber = -1
    }

    func viewDidEnterBackground(_ notification: Notification?) {
    }

    func goTop() {
        self.tableView.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
    }

    @IBAction func pullRefresh(_ refreshControl: UIRefreshControl) {
        SVProgressHUD.show(withStatus: ServerConnectionMessage)
        self.refresh() {
            SVProgressHUD.dismiss()
            refreshControl.endRefreshing()
        }
    }

    func refresh(_ completed: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let task = [EventManager.sharedInstance.fetchNewEvent()]
            Task.all(task).success { _ in
                self.eventSummaries = self.getEventInfo(self.viewPageClass)
                completed?()
                }.failure { _ in
                    let alert: UIAlertController = UIAlertController(title: NetworkErrorTitle,message: NetworkErrorMessage, preferredStyle: .alert)
                    let cancelAction: UIAlertAction = UIAlertAction(title: NetworkErrorButton, style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    self.eventSummaries = self.getEventInfo(self.viewPageClass)
                    completed?()
            }
        }
    }

    func getEventInfo(_ viewPageClass: CheckStatus) -> [EventSummary]? {
        switch viewPageClass {
        case .noCheck:
            return EventManager.sharedInstance.getSelectNewEventAll()
        case .keep:
            return EventManager.sharedInstance.getKeepEventAll()
        case .noKeep:
            return EventManager.sharedInstance.getNoKeepEventAll()
        case .none:
            return eventSummaries
        }
    }
}

// MARK: - UITableViewDataSource
extension BaseTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let eventSummaries = self.eventSummaries {
            return eventSummaries.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return EventInfoCellHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: EventInfoTableViewCellIdentifier, for: indexPath) as? EventInfoTableViewCell {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {

        guard let eventSummaries = self.eventSummaries else {
            return
        }
        let url: String = eventSummaries[indexPath.row].url
        if !url.lowercased().hasPrefix("http://") && !url.lowercased().hasPrefix("https://") {
            let alert: UIAlertController = UIAlertController(title: "不正なリンクを検出しました", message: "このイベントに設定されているリンクに問題がありました。", preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if #available(iOS 9.0, *) {
            let brow = SFSafariViewController(url: URL(string: url)!, entersReaderIfAvailable: false)
            brow.delegate = self
            self.sawWebView = true
            present(brow, animated: true, completion: nil)
        } else {
            let vc = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: EventPageWebViewControllerIdentifier) as! EventPageWebViewController
            vc.targetURL = url
            vc.navigationTitle = eventSummaries[indexPath.row].title
            // TODO いつか変える
            self.sawWebView = true
            present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - DZNEmptyDataSetDelegate
extension BaseTableViewController: DZNEmptyDataSetDelegate {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "条件に合致する情報がありません"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]

        return NSAttributedString(string: text, attributes: attribs)
    }
}

// MARK: - DZNEmptyDataSetSource
extension BaseTableViewController: DZNEmptyDataSetSource {

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
