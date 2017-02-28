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
        return CheckStatus.noCheck
    }

    let coachMarksController = CoachMarksController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coachMarksController.dataSource = self
    }


    override func viewWillAppear(_ animated:Bool) {
        if sawWebView {
            sawWebView = false
        } else {
            SVProgressHUD.show(withStatus: ServerConnectionMessage)
            self.refresh() {
                SVProgressHUD.dismiss()
                if EventManager.sharedInstance.getSelectNewEventAll().count > 0 {
                    self.tableView.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
                }
                let updatedAt = TerminalPreferenceManager.sharedInstance.getUserEventInfoUpdateTime(TerminalPreferenceClass.tutorial)
                guard let eventSummaries = self.eventSummaries else {
                    return
                }
                if updatedAt == "" && eventSummaries.count > 0 {
                    let skipView = CoachMarkSkipDefaultView()
                    skipView.setTitle("スキップ", for: .normal)
                    self.coachMarksController.skipView = skipView
                    if #available(iOS 10.0, *) {
                        self.coachMarksController.overlay.blurEffectStyle = UIBlurEffectStyle.dark
                    }
                    self.coachMarksController.overlay.allowTap = true
                    self.coachMarksController.startOn(self)
                    TerminalPreferenceManager.sharedInstance.setUserEventInfoUpdateTime(TerminalPreferenceClass.tutorial)
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }

    override func viewWillEnterForeground(_ notification: Notification?) {
        UIApplication.shared.applicationIconBadgeNumber = -1
        if (self.isViewLoaded && (self.view.window != nil)) {
            SVProgressHUD.show(withStatus: ServerConnectionMessage)
            self.refresh() {
                SVProgressHUD.dismiss()
                self.tableView.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EventInfoViewController: CoachMarksControllerDataSource {

    // ヒントを出す数
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }

    // ヒントのマーク配置方法
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch(index) {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.tableView) { (frame: CGRect) -> UIBezierPath in
                var cellRect = self.tableView.rectForRow(at: IndexPath(row: 0, section: 0))
                cellRect = cellRect.offsetBy(dx: -self.tableView.contentOffset.x, dy: -self.tableView.contentOffset.y)
                return UIBezierPath(rect: cellRect)
            }
        case 1:
            return coachMarksController.helper.makeCoachMark(for: self.tableView) { (frame: CGRect) -> UIBezierPath in
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EventInfoTableViewCell
                let cellRect = cell.noKeepButton.layer.bounds.offsetBy(dx: cell.noKeepButton.frame.origin.x, dy: cell.noKeepButton.layer.position.y)
                return UIBezierPath(rect: cellRect.insetBy(dx: -5, dy: -5))
            }

        case 2:
            return coachMarksController.helper.makeCoachMark(for: self.tableView) { (frame: CGRect) -> UIBezierPath in
                let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! EventInfoTableViewCell
                let cellRect = cell.keepButton.layer.bounds.offsetBy(dx: cell.keepButton.frame.origin.x, dy: cell.keepButton.layer.position.y)
                return UIBezierPath(rect: cellRect.insetBy(dx: -5, dy: -5))
            }

        case 3:
            return coachMarksController.helper.makeCoachMark(for: self.tabBarController?.tabBar) { (frame: CGRect) -> UIBezierPath in
                let view = self.tabBarController?.tabBar.items![0].value(forKey: "view") as! UIView
                let cellRect = view.layer.bounds.offsetBy(dx: view.frame.origin.x, dy: self.tableView.frame.maxY)
                return UIBezierPath(rect: cellRect)
            }
        case 4:
            return coachMarksController.helper.makeCoachMark(for: self.tabBarController?.tabBar) { (frame: CGRect) -> UIBezierPath in
                let view = self.tabBarController?.tabBar.items![3].value(forKey: "view") as! UIView
                let cellRect = view.layer.bounds.offsetBy(dx: view.frame.origin.x, dy: self.tableView.frame.maxY)
                return UIBezierPath(rect: cellRect)
            }
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }

    // ヒントに出す内容
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {

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
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation, hintText: hintText, nextText: nil)
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
}
