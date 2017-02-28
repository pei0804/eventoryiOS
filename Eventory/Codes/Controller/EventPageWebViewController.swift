//
//  EventPageWebViewController.swift
//  Eventory
//
//  Created by jumpei on 2017/02/01.
//  Copyright © 2017年 jumpei. All rights reserved.
//

import UIKit
import WebKit

class EventPageWebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var rewindButton: UIBarButtonItem!
    @IBOutlet weak var fastForwardButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var openInSafari: UIBarButtonItem!
    @IBOutlet weak var WebViewCancelButton: UIBarButtonItem!

    var targetURL: String = ""
    var navigationTitle: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        let width: CGFloat! = self.view.bounds.width
        let height: CGFloat! = self.view.bounds.height
        let statusBarHeight: CGFloat! = UIApplication.shared.statusBarFrame.height

        self.navigationBar.topItem?.title = navigationTitle
        self.webView = self.createWebView(CGRect(x: 0, y: statusBarHeight+44, width: width, height: height - statusBarHeight))
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
        self.view.sendSubview(toBack: self.webView)

        let url: URL = URL(string: targetURL)!
        let request: URLRequest = URLRequest(url: url)
        self.webView.load(request)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.rewindButton.isEnabled = self.webView!.canGoBack
        self.fastForwardButton.isEnabled = self.webView!.canGoForward
        self.refreshButton.isEnabled = true
        self.openInSafari.isEnabled = true
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.rewindButton.isEnabled = self.webView!.canGoBack
        self.fastForwardButton.isEnabled = self.webView!.canGoForward
    }

    func createWebView(_ frame: CGRect) -> WKWebView {
        let webView = WKWebView()
        webView.frame = frame
        return webView
    }

    @IBAction func WebViewCancel(_: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func back(_: Any) {
        _ = self.webView?.goBack()
    }

    @IBAction func forward(_: Any) {
        _ = self.webView?.goForward()
    }

    @IBAction func refresh(_: Any) {
        _ = self.webView?.reload()
    }

    @IBAction func safari(_: Any) {
        let url = self.webView.url
        if UIApplication.shared.canOpenURL(url!){
            UIApplication.shared.openURL(url!)
        }
    }
}
