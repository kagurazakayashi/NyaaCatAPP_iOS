//
//  BrowserVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/27.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import WebKit

class BrowserVC: UIViewController , WKNavigationDelegate, WKUIDelegate {
    
    //可由外部设置，在加载网页前
    var 缓存策略:NSURLRequestCachePolicy = .UseProtocolCachePolicy
    var 超时时间:NSTimeInterval = 30
    var 屏蔽长按菜单:Bool = true
    var 在外部浏览器打开网页中的链接:Bool = true
    var 允许刷新按钮 = true
    //
    
    var 浏览器:WKWebView? = nil
    var 进度条:UIProgressView = UIProgressView()
    var 右上按钮:UIBarButtonItem? = nil
    var 请求网址:String = "about:blank"
    var 当前Tab:Int = 0
    var 刷新限制计时器:MSWeakTimer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if (self.navigationController == nil || self.navigationController!.tabBarController == nil || 当前Tab == self.navigationController!.tabBarController!.selectedIndex) {
            卸载浏览器()
        }
    }
    
    func 装入网页(网址:String, 标题:String) {
        请求网址 = 网址
        self.title = 标题
        let 要加载的浏览器URL:NSURL = NSURL(string: 请求网址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的浏览器URL, cachePolicy: 缓存策略, timeoutInterval: 超时时间)
        if (浏览器 == nil) {
            创建UI()
            装入浏览器()
        }
        浏览器!.loadRequest(网络请求)
    }
    
    func 装入资料(html:String, 标题:String) {
        self.title = 标题
        if (浏览器 == nil) {
            创建UI()
            装入浏览器()
        }
        浏览器!.loadHTMLString(html, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func 创建UI() {
        当前Tab = self.navigationController!.tabBarController!.selectedIndex
        self.view.backgroundColor = UIColor.whiteColor()
        if (允许刷新按钮 == true) {
            右上按钮 = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(self.右上按钮点击))
            navigationItem.rightBarButtonItem = 右上按钮
        }
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            进度条.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.width,2)
        } else {
            进度条.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 69, self.view.frame.width,2)
        }
        进度条.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(进度条)
    }
    
    func 右上按钮点击() {
        let 要加载的浏览器URL:NSURL = NSURL(string: 请求网址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的浏览器URL, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 超时时间)
        浏览器!.loadRequest(网络请求)
        //防止疯狂刷新
        右上按钮?.enabled = false
        刷新限制计时器 = MSWeakTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.恢复右上按钮), userInfo: nil, repeats: false, dispatchQueue: dispatch_get_main_queue())
    }
    func 恢复右上按钮() {
        右上按钮?.enabled = true
        刷新限制计时器 = nil
    }
    
    func 卸载浏览器() {
        if (浏览器 != nil) {
            浏览器!.navigationDelegate = nil
            浏览器!.UIDelegate = nil
            浏览器!.removeObserver(self, forKeyPath: "estimatedProgress")
            浏览器!.removeFromSuperview()
            浏览器 = nil
        }
    }
    
    func 装入浏览器() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        if (屏蔽长按菜单 == true) {
            let 禁止长按菜单JS:String = "document.body.style.webkitTouchCallout='none';"
            let 禁止长按菜单:WKUserScript = WKUserScript(source: 禁止长按菜单JS, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
            浏览器设置.userContentController.addUserScript(禁止长按菜单)
        }
        浏览器设置.allowsPictureInPictureMediaPlayback = false
        浏览器设置.allowsInlineMediaPlayback = false
        浏览器设置.allowsAirPlayForMediaPlayback = false
        浏览器设置.requiresUserActionForMediaPlayback = false
        浏览器设置.suppressesIncrementalRendering = false
        浏览器设置.applicationNameForUserAgent = 全局_浏览器标识
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
        浏览器偏好设置.javaScriptEnabled = false
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .Dynamic
        let 浏览器坐标:CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.height)
        浏览器 = WKWebView(frame: 浏览器坐标, configuration: 浏览器设置)
        浏览器?.backgroundColor = UIColor.whiteColor()
        浏览器!.navigationDelegate = self
        浏览器!.UIDelegate = self
        self.view.insertSubview(浏览器!, atIndex: 0)
        浏览器!.translatesAutoresizingMaskIntoConstraints = false
        let 左约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0)
        let 右约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0)
        let 上约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        let 下约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([左约束,右约束,上约束,下约束])
        浏览器!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress"){
            self.进度条.setProgress(Float(浏览器!.estimatedProgress), animated: true)
        }
        if (浏览器!.estimatedProgress == 1 && self.进度条.hidden == false){
            self.进度条.hidden = true
        } else if (浏览器!.estimatedProgress < 1 && self.进度条.hidden == true){
            self.进度条.hidden = false
        }
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        卸载浏览器()
        let 提示:UIAlertController = UIAlertController(title: "信息载入失败", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.navigationController?.popViewControllerAnimated(true)
        })
        提示.addAction(取消按钮)
        self.presentViewController(提示, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (在外部浏览器打开网页中的链接 == true) {
            let 即将转到网址:String = navigationAction.request.URL!.absoluteString
            let ob:OpenBrowser = OpenBrowser()
            ob.打开浏览器(即将转到网址)
        } else {
            webView.loadRequest(navigationAction.request)
        }
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
