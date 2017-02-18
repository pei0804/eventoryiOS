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
import Instructions

class EventInfoViewController: BaseTableViewController {

    override var viewPageClass: CheckStatus {
        return CheckStatus.NoCheck
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.coachMarksController.dataSource = self
    }

    let coachMarksController = CoachMarksController()

    override func viewWillAppear(animated:Bool) {
        if sawWebView {
            sawWebView = false
        } else {
            SVProgressHUD.showWithStatus(ServerConnectionMessage)
            self.refresh() {
                SVProgressHUD.dismiss()
                self.tableView.setContentOffset(CGPointMake(0, -20), animated: true)

                let updatedAt = TerminalPreferenceManager.sharedInstance.getUserEventInfoUpdateTime(TerminalPreferenceClass.Tutorial)
                guard let eventSummaries = self.eventSummaries else {
                    return
                }
                if updatedAt == "" && eventSummaries.count > 0 {
                    let skipView = CoachMarkSkipDefaultView()
                    skipView.setTitle("スキップ", forState: .Normal)
                    self.coachMarksController.skipView = skipView
                    if #available(iOS 9.0, *) {
                        self.coachMarksController.overlay.blurEffectStyle = UIBlurEffectStyle.Dark
                    }
                    self.coachMarksController.overlay.allowTap = true
                    self.coachMarksController.startOn(self)
                    TerminalPreferenceManager.sharedInstance.setUserEventInfoUpdateTime(TerminalPreferenceClass.Tutorial)
                }
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EventInfoViewController: CoachMarksControllerDataSource {

    // ヒントを出す数
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    // ヒントのマーク配置方法
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkForIndex index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.helper.coachMarkForView(self.tableView) { (frame: CGRect) -> UIBezierPath in
                var cellRect =  self.tableView.rectForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                cellRect = CGRectOffset(cellRect, -self.tableView.contentOffset.x, -self.tableView.contentOffset.y)

                return UIBezierPath(rect: cellRect)
            }
        case 1:
            return coachMarksController.helper.coachMarkForView(self.tableView) { (frame: CGRect) -> UIBezierPath in
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! EventInfoTableViewCell
                let cellRect = CGRectOffset(cell.noKeepButton.layer.bounds, cell.noKeepButton.frame.origin.x, cell.noKeepButton.layer.position.y)
                return UIBezierPath(rect: cellRect.insetBy(dx: -5, dy: -5))
            }

        case 2:
            return coachMarksController.helper.coachMarkForView(self.tableView) { (frame: CGRect) -> UIBezierPath in
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! EventInfoTableViewCell
                let cellRect = CGRectOffset(cell.keepButton.layer.bounds, cell.keepButton.frame.origin.x, cell.keepButton.layer.position.y)
                return UIBezierPath(rect: cellRect.insetBy(dx: -5, dy: -5))
            }

        case 3:
            return coachMarksController.helper.coachMarkForView(self.tabBarController?.tabBar) { (frame: CGRect) -> UIBezierPath in
                let view = self.tabBarController?.tabBar.items![0].valueForKey("view") as! UIView
                let cellRect = CGRectOffset(view.layer.bounds,view.frame.origin.x, self.tableView.frame.maxY)
                return UIBezierPath(rect: cellRect)
            }
        case 4:
            return coachMarksController.helper.coachMarkForView(self.tabBarController?.tabBar) { (frame: CGRect) -> UIBezierPath in
                let view = self.tabBarController?.tabBar.items![3].valueForKey("view") as! UIView
                let cellRect = CGRectOffset(view.layer.bounds,view.frame.origin.x, self.tableView.frame.maxY)
                return UIBezierPath(rect: cellRect)
            }
        default:
            return coachMarksController.helper.coachMarkForView()
        }
    }

    // ヒントに出す内容
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

        var hintText = ""

        switch(index) {
        case 0:
            hintText = "イベント情報が表示されます。\nタップするとイベントページを閲覧できます。"
        case 1:
            hintText = "不必要な情報なら、興味なしをタップ。"
        case 2:
            hintText = "必要な情報の場合はキープをタップ。"
        case 3:
            hintText = "ここではあなたへの新着情報が表示されます。\n情報は興味設定を元に選定されています。"
        case 4:
            hintText = "興味設定はこちらから変更できます。"
        default: break
        }

        let coachViews = coachMarksController.helper.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
}
