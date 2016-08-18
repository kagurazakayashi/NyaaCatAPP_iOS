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
    var 缓存策略:NSURLRequest.CachePolicy = 全局_缓存策略
    var 超时时间:TimeInterval = 30
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
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.navigationController == nil || self.navigationController!.tabBarController == nil || 当前Tab == self.navigationController!.tabBarController!.selectedIndex) {
            卸载浏览器()
        }
    }
    
    func 装入网页(_ 网址:String, 标题:String) {
        请求网址 = 网址
        self.title = 标题
        let 要加载的浏览器URL:URL = URL(string: 请求网址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(url: 要加载的浏览器URL, cachePolicy: 缓存策略, timeoutInterval: 超时时间)
        if (浏览器 == nil) {
            创建UI()
            装入浏览器()
        }
        浏览器!.load(网络请求 as URLRequest)
    }
    
    func 装入资料(_ html:String, 标题:String) {
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
        self.view.backgroundColor = UIColor.white
        if (允许刷新按钮 == true) {
            右上按钮 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.右上按钮点击))
            navigationItem.rightBarButtonItem = 右上按钮
        }
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone){
            进度条.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 64, width: self.view.frame.width,height: 2)
        } else {
            进度条.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 69, width: self.view.frame.width,height: 2)
        }
        进度条.backgroundColor = UIColor.white
        self.view.addSubview(进度条)
    }
    
    func 右上按钮点击() {
        let 要加载的浏览器URL:URL = URL(string: 请求网址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(url: 要加载的浏览器URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 超时时间)
        浏览器!.load(网络请求 as URLRequest)
        //防止疯狂刷新
        右上按钮?.isEnabled = false
        刷新限制计时器 = MSWeakTimer.scheduledTimer(withTimeInterval: 1.0, target: self, selector: #selector(self.恢复右上按钮), userInfo: nil, repeats: false, dispatchQueue: DispatchQueue.main)
    }
    func 恢复右上按钮() {
        右上按钮?.isEnabled = true
        刷新限制计时器 = nil
    }
    
    func 卸载浏览器() {
        if (浏览器 != nil) {
            浏览器!.navigationDelegate = nil
            浏览器!.uiDelegate = nil
            浏览器!.removeObserver(self, forKeyPath: "estimatedProgress")
            浏览器!.removeFromSuperview()
            浏览器 = nil
        }
    }
    
    func 装入浏览器() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        if (屏蔽长按菜单 == true) {
            let 禁止长按菜单JS:String = "document.body.style.webkitTouchCallout='none';"
            let 禁止长按菜单:WKUserScript = WKUserScript(source: 禁止长按菜单JS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
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
        浏览器设置.selectionGranularity = .dynamic
        let 浏览器坐标:CGRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height)
        浏览器 = WKWebView(frame: 浏览器坐标, configuration: 浏览器设置)
        浏览器?.backgroundColor = UIColor.white
        浏览器!.navigationDelegate = self
        浏览器!.uiDelegate = self
        self.view.insertSubview(浏览器!, at: 0)
        浏览器!.translatesAutoresizingMaskIntoConstraints = false
        let 左约束 = NSLayoutConstraint(item: 浏览器!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let 右约束 = NSLayoutConstraint(item: 浏览器!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let 上约束 = NSLayoutConstraint(item: 浏览器!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let 下约束 = NSLayoutConstraint(item: 浏览器!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([左约束,右约束,上约束,下约束])
        浏览器!.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
     func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutableRawPointer) {
        if (keyPath == "estimatedProgress"){
            self.进度条.setProgress(Float(浏览器!.estimatedProgress), animated: true)
        }
        if (浏览器!.estimatedProgress == 1 && self.进度条.isHidden == false){
            self.进度条.isHidden = true
        } else if (浏览器!.estimatedProgress < 1 && self.进度条.isHidden == true){
            self.进度条.isHidden = false
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        卸载浏览器()
        let 提示:UIAlertController = UIAlertController(title: "信息载入失败", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (动作:UIAlertAction) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.navigationController?.popViewController(animated: true)
        })
        提示.addAction(取消按钮)
        self.present(提示, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if (在外部浏览器打开网页中的链接 == true) {
            let 即将转到网址:String = navigationAction.request.url!.absoluteString
            let ob:OpenBrowser = OpenBrowser()
            ob.打开浏览器(即将转到网址)
        } else {
            webView.load(navigationAction.request)
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
