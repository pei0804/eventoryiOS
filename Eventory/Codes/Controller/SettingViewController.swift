//
//  SettingViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/09/10.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

        var newEventCount: Int = 0 {
            didSet {
                tableView.reloadData()
            }
        }

    let settingClasses: [Dictionary<String, String>] = [
        [
            "name": "興味のあるジャンル",
            "controller": RegisterGenreViewControllerIdentifier
        ],
        [
            "name": "開催地",
            "controller": RegisterPlaceViewControllerIdentifier
        ],
        [
            "name": "",
            "controller":""
        ]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)

        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(indexPathForSelectedRow, animated: true)
        }
        self.newEventCount = EventManager.sharedInstance.getSelectNewEventAll().count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingClasses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(SettingTableViewCellIdentifier, forIndexPath: indexPath)

        if indexPath.row <= 1 {
            cell.textLabel?.text = self.settingClasses[indexPath.row]["name"]
            cell.accessoryType = .DisclosureIndicator
            return cell
        } else {
            if newEventCount > 0 {
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.backgroundColor = Colors.main2
                cell.textLabel?.text = "新着情報：\(newEventCount)件"
                return cell
            }
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.text = "新着情報：なし"
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let nextVc = settingClasses[indexPath.row]["controller"] {
           
            // どのコントローラに遷移するか判定している
            // 既存にあるRegister系は少し煩雑になっているが、初期登録アクセスかを判定しているだけ
            if nextVc == RegisterPlaceViewControllerIdentifier {
                let vc = UIStoryboard(name:"Register", bundle: nil).instantiateViewControllerWithIdentifier(nextVc) as! RegisterPlaceViewController
                vc.settingStatus = true
                self.navigationController?.pushViewController(vc, animated: true)
            } else if nextVc == RegisterGenreViewControllerIdentifier {
                let vc = UIStoryboard(name:"Register", bundle: nil).instantiateViewControllerWithIdentifier(nextVc) as! RegisterGenreViewController
                vc.settingStatus = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

