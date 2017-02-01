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
        let statusBarHeight: CGFloat! = UIApplication.sharedApplication().statusBarFrame.height

        self.navigationBar.topItem?.title = navigationTitle
        self.webView = self.createWebView(CGRectMake(0, statusBarHeight+44, width, height - statusBarHeight))
        self.webView.navigationDelegate = self
        self.view.addSubview(self.webView)
        self.view.sendSubviewToBack(self.webView)

        let url: NSURL = NSURL(string: targetURL)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.rewindButton.enabled = self.webView!.canGoBack
        self.fastForwardButton.enabled = self.webView!.canGoForward
        self.refreshButton.enabled = true
        self.openInSafari.enabled = true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.rewindButton.enabled = self.webView!.canGoBack
        self.fastForwardButton.enabled = self.webView!.canGoForward
    }

    func createWebView(frame: CGRect) -> WKWebView {
        let webView = WKWebView()
        webView.frame = frame
        return webView
    }

    @IBAction func WebViewCancel(_: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func back(_: AnyObject) {
        self.webView?.goBack()
    }

    @IBAction func forward(_: AnyObject) {
        self.webView?.goForward()
    }

    @IBAction func refresh(_: AnyObject) {
        self.webView?.reload()
    }

    @IBAction func safari(_: AnyObject) {
        let url = self.webView.URL
        if UIApplication.sharedApplication().canOpenURL(url!){
            UIApplication.sharedApplication().openURL(url!)
        }
    }
}
