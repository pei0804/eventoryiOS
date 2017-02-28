//
//  RegisterGenreViewController.swift
//  Eventory
//
//  Created by jumpei on 2016/09/05.
//  Copyright © 2016年 jumpei. All rights reserved.
//

import UIKit

class RegisterGenreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var checkCount: Int = 0
    var genres: [Dictionary<String, Any>]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // 設定画面からのアクセスの場合trueになる
    var leftBarButton: UIBarButtonItem = UIBarButtonItem()
    var rightBarButton: UIBarButtonItem = UIBarButtonItem()
    var settingStatus: Bool = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var submitBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: CheckListTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: CheckListTableViewCellIdentifier)
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        if self.settingStatus {
            self.leftBarButton = UIBarButtonItem(title: "戻る", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.goBack(_:)))
            self.rightBarButton = UIBarButtonItem(title: "適用", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pushSubmitBtn(_:)))
            self.genres = UserRegister.sharedInstance.getSettingGenres()
            self.checkCount = UserRegister.sharedInstance.getUserSettingGenres().count
        } else {
            self.rightBarButton = UIBarButtonItem(title: "次へ", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pushSubmitBtn(_:)))
            self.genres = EventManager.sharedInstance.genreInitializer()
        }
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        self.navigationItem.rightBarButtonItem = self.rightBarButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushEditModeBtn(_ sender: Any) {
        if self.tableView.isEditing == false {
            self.tableView.isEditing = true
        } else {
            self.tableView.isEditing = false
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated:true)
        
    }
    
    @IBAction func pushSubmitBtn(_ sender: Any) {
        UserRegister.sharedInstance.setUserSettingRegister(self.genres, settingClass: SettingClass.genre)
        if self.settingStatus {
            _ = self.navigationController?.popViewController(animated:true)
        } else {
            let vc = UIStoryboard(name:"Register", bundle: nil).instantiateViewController(withIdentifier: RegisterPlaceViewControllerIdentifier)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource

extension RegisterGenreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let genres = self.genres {
            return genres.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: CheckListTableViewCellIdentifier, for: indexPath) as? CheckListTableViewCell {
            if let genres = self.genres {
                cell.bind(genres[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            UserRegister.sharedInstance.deleteSetting(&self.genres, index: indexPath.row)
        }
    }
}

// MARK: - UITableViewDelegate

extension RegisterGenreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? CheckListTableViewCell {
            cell.checkAction(&self.genres, indexPath: indexPath, checkCount: &self.checkCount)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
}

// MARK: - UISearchBarDelegate

extension RegisterGenreViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = self.searchBar.text ?? ""
        if !text.isEmpty {
            UserRegister.sharedInstance.insertNewSetting(&self.genres, newSetting: text)
            self.searchBar.text = ""
            self.searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
}
