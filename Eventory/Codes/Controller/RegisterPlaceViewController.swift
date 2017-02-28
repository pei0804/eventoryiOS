//
//  RegisterPlaceViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/09/05.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit
import SwiftTask
import SVProgressHUD

class RegisterPlaceViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var checkCount: Int = 0
    var places: [Dictionary<String, Any>]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    // 設定画面からのアクセスの場合trueになる
    var leftBarButton: UIBarButtonItem = UIBarButtonItem()
    var rightBarButton: UIBarButtonItem = UIBarButtonItem()
    var settingStatus: Bool = false

    //    @IBOutlet weak var searchBar: BaseSearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        //        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.register(UINib(nibName: CheckListTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: CheckListTableViewCellIdentifier)
    }

    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        if self.settingStatus {
            self.leftBarButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.goBack(_:)))
            self.rightBarButton = UIBarButtonItem(title: "適用", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pushSubmitBtn(_:)))
            self.places = UserRegister.sharedInstance.getSettingPlaces()
            self.checkCount = UserRegister.sharedInstance.getUserSettingPlaces().count
            TerminalPreferenceManager.sharedInstance.resetUpdateTime()
        } else {
            //            self.leftBarButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.goBack(_:)))
            self.rightBarButton = UIBarButtonItem(title: "次へ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pushSubmitBtn(_:)))
            self.places = EventManager.sharedInstance.placesInitializer()
            UserRegister.sharedInstance.setUserSettingRegister(EventManager.sharedInstance.genreInitializer(), settingClass: SettingClass.genre)
        }
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        self.navigationItem.rightBarButtonItem = self.rightBarButton
    }

    override func viewWillDisappear(_ animated:Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func goBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated:true)
    }

    //    @IBAction func pushEditModeBtn(sender: Any) {
    //        if self.tableView.editing == false {
    //            self.tableView.editing = true
    //        } else {
    //            self.tableView.editing = false
    //        }
    //    }

    @IBAction func pushSubmitBtn(_ sender: Any) {
        UserRegister.sharedInstance.setUserSettingRegister(self.places, settingClass: SettingClass.place)
        UserRegister.sharedInstance.setDefaultSettingStatus(true)
        if self.settingStatus {
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: ServerConnectionMessage)
                let task = [EventManager.sharedInstance.fetchNewEvent()]
                Task.all(task).success { _ in
                    SVProgressHUD.dismiss()
                    _ = self.navigationController?.popViewController(animated:true)
                    }.failure { _ in
                        SVProgressHUD.dismiss()
                        _ = self.navigationController?.popViewController(animated:true)
                }
            }
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.show(withStatus: "サービス利用準備中\n初回通信は時間がかかります。")
                let task = [EventManager.sharedInstance.fetchNewEvent()]
                Task.all(task).success { _ in
                    SVProgressHUD.dismiss()
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UITabBarController = storyBoard.instantiateViewController(withIdentifier: "MainMenu") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                    }.failure { _ in
                        SVProgressHUD.dismiss()
                        let alert: UIAlertController = UIAlertController(title: NetworkErrorTitle,message: NetworkErrorMessage, preferredStyle: .alert)
                        let cancelAction: UIAlertAction = UIAlertAction(title: NetworkErrorButton, style: .cancel, handler: nil)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension RegisterPlaceViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let places = self.places {
            return places.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: CheckListTableViewCellIdentifier, for: indexPath) as? CheckListTableViewCell {
            if let places = self.places {
                cell.bind(places[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }

    //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == UITableViewCellEditingStyle.Delete {
    //            UserRegister.sharedInstance.deleteSetting(&self.places, index: indexPath.row)
    //        }
    //    }
}

// MARK: - UITableViewDelegate

extension RegisterPlaceViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? CheckListTableViewCell {
            cell.checkAction(&self.places, indexPath: indexPath, checkCount: &self.checkCount)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }


    //    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    //        return true
    //    }
    //
    //    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
    //        return "削除"
    //    }
}


// MARK: - UISearchBarDelegate

//extension RegisterPlaceViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        let text = self.searchBar.text ?? ""
//        if !text.isEmpty {
//            UserRegister.sharedInstance.insertNewSetting(&self.places, newSetting: text)
//            self.searchBar.text = ""
//            self.searchBar.resignFirstResponder()
//        }
//    }
//
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        self.searchBar.text = ""
//        self.searchBar.resignFirstResponder()
//    }
//}
