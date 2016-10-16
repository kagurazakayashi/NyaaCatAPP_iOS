//
//  BBSVC.swift
//  nyaacatapp
//
//  Created by 神楽坂紫 on 16/2/14.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import WebKit
import UIKit

class BBSVC: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    //可由外部设置，在加载网页前
    var 缓存策略:NSURLRequest.CachePolicy = 全局_缓存策略
    var 超时时间:TimeInterval = 10
    var 屏蔽长按菜单:Bool = true
    //
    
    var 浏览器:WKWebView? = nil
    var 进度条:UIProgressView = UIProgressView()
    var 遮盖:UIView = UIView(frame: CGRect.zero)
    var 遮盖文字:UILabel = UILabel()
    var 解析延迟定时器:MSWeakTimer? = nil
    var 网页超时定时器:MSWeakTimer? = nil
    var tryed:Bool = false
    var 浏览器开关:Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        if (浏览器开关 == false) {
            加载数据()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        装入浏览器()
        装入UI()
        加载数据()
    }
    func 加载数据() {
        遮盖文字.text = "论坛载入中..."
        let 要加载的浏览器URL:URL = URL(string: 全局_喵窩API["论坛地址"]!)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(url: 要加载的浏览器URL, cachePolicy: 缓存策略, timeoutInterval: 超时时间)
        网页超时定时器 = MSWeakTimer.scheduledTimer(withTimeInterval: 10.0, target: self, selector: #selector(self.手工超时), userInfo: nil, repeats: false, dispatchQueue: DispatchQueue.main)
        浏览器!.load(网络请求 as URLRequest)
    }
    func 装入UI() {
        进度条 = UIProgressView(progressViewStyle: .bar)
        
        遮盖.backgroundColor = 全局_导航栏颜色
        遮盖文字.textAlignment = .center
        遮盖文字.textColor = UIColor.white
        
        if(UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone){
            遮盖.frame = CGRect(x: 0, y: 0, width: 1366, height: 64)
            进度条.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 64, width: self.view.frame.width,height: 2)
        } else {
            遮盖.frame = CGRect(x: 0, y: 0, width: 1366, height: 69)
            进度条.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 69, width: self.view.frame.width,height: 2)
        }
        进度条.backgroundColor = UIColor.white
        遮盖文字.frame = CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44)
        
        self.view.addSubview(进度条)
        self.view.addSubview(遮盖)
        遮盖.addSubview(遮盖文字)
    }
    func 装入浏览器() {
        浏览器开关 = true
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        if (屏蔽长按菜单 == true) {
            let 禁止长按菜单JS:String = "document.body.style.webkitTouchCallout='none';"
            let 禁止长按菜单:WKUserScript = WKUserScript(source: 禁止长按菜单JS, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            浏览器设置.userContentController.addUserScript(禁止长按菜单)
        }
        浏览器设置.allowsPictureInPictureMediaPlayback = true
        浏览器设置.allowsInlineMediaPlayback = true
        浏览器设置.allowsAirPlayForMediaPlayback = true
        浏览器设置.requiresUserActionForMediaPlayback = true
        浏览器设置.suppressesIncrementalRendering = true
        //浏览器设置.applicationNameForUserAgent = 全局_浏览器标识
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = true
        浏览器偏好设置.javaScriptEnabled = true
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .dynamic
        let 浏览器坐标:CGRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.height)
        浏览器 = WKWebView(frame: 浏览器坐标, configuration: 浏览器设置)
        浏览器!.navigationDelegate = self
//        浏览器!.uiDelegate = self
        self.view.insertSubview(浏览器!, at: 0)
        浏览器!.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        浏览器!.translatesAutoresizingMaskIntoConstraints = false
        let 左约束 = NSLayoutConstraint(item: 浏览器!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let 右约束 = NSLayoutConstraint(item: 浏览器!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let 上约束 = NSLayoutConstraint(item: 浏览器!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let 下约束 = NSLayoutConstraint(item: 浏览器!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([左约束,右约束,上约束,下约束])
    }
    
    func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutableRawPointer) {
        if (keyPath == "estimatedProgress"){
            self.进度条.setProgress(Float(浏览器!.estimatedProgress), animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
                if ((UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) && UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone){
//                    UIApplication.sharedApplication().statusBarHidden = true
                    self.遮盖.isHidden = true
                } else {
//                    UIApplication.sharedApplication().statusBarHidden = false
                    self.遮盖.isHidden = false
                }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        网页超时定时器 = nil
        请求页面源码()
        if (浏览器!.estimatedProgress == 1){
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.遮盖文字.text = ""
                self.进度条.alpha = 0
                self.遮盖.frame = CGRect(x: 0, y: 0, width: 1366, height: 20)
            }) { (已完成:Bool) -> Void in
                self.进度条.removeFromSuperview()
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        网络失败(error as NSError?)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        NSLog("observeValue=\(keyPath), object=\(object)")
    }
    func 手工超时() {
        网络失败(nil)
    }
    func 网络失败(_ error: NSError?) {
        网页超时定时器 = nil
        卸载浏览器()
        var 错误信息 = ""
        遮盖文字.text = "论坛载入失败"
        进度条.setProgress(0, animated: false)
        if (error != nil) {
            错误信息 = "\(error!.localizedDescription)\n"
            NSLog(error!.localizedDescription)
        }
        let 提示:UIAlertController = UIAlertController(title: "论坛连接失败", message: "\(错误信息)请重新进入本页重试", preferredStyle: UIAlertControllerStyle.alert)
        let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (动作:UIAlertAction) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        提示.addAction(取消按钮)
        self.present(提示, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let 即将转到网址:String = navigationAction.request.url!.absoluteString
        let ob:OpenBrowser = OpenBrowser()
        ob.打开浏览器(即将转到网址)
        return nil
    }
    
    func 卸载浏览器() {
        浏览器开关 = false
        tryed = false
        浏览器!.loadHTMLString("", baseURL: nil)
//        if (浏览器 != nil) {
//            浏览器!.navigationDelegate = nil
//            浏览器!.UIDelegate = nil
//            浏览器!.removeObserver(self, forKeyPath: "estimatedProgress")
//            浏览器!.removeFromSuperview()
//            浏览器 = nil
//        }
    }
    
    func 请求页面源码() {
        if (解析延迟定时器 == nil) {
            解析延迟定时器 = MSWeakTimer.scheduledTimer(withTimeInterval: 0.9, target: self, selector: #selector(self.请求页面源码2), userInfo: nil, repeats: false, dispatchQueue: DispatchQueue.main)
        }
    }
    func 请求页面源码2() {
        解析延迟定时器 = nil
        let 获取网页标题JS:String = "document.title"
        let 获取网页源码JS:String = "document.documentElement.innerHTML"
        var 网页源码:[String] = Array<String>()
        浏览器!.evaluateJavaScript(获取网页标题JS) { (对象:Any?, 错误:Error?) -> Void in
            if (对象 == nil) {
                return
            }
            网页源码.append(对象 as! String)
            self.浏览器!.evaluateJavaScript(获取网页源码JS) { (对象:Any?, 错误:Error?) -> Void in
                网页源码.append(对象 as! String)
                self.处理返回源码(网页源码)
            }
        }
    }
    func 处理返回源码(_ 源码:[String]) {
        //let 网页标题:String? = 源码[0]
        let 网页内容:String? = 源码[1]
        if (网页内容?.range(of: "当前访问的是简约版，使用更先进的浏览器访问效果更佳。") != nil || 网页内容?.range(of: "嘗試載入完整版本的論壇時出錯。") != nil || 网页内容?.range(of: "Something went wrong while trying to load the full version of this site.") != nil) {
//            if (tryed == false) {
//                tryed = true
//                let 要加载的浏览器URL:NSURL = NSURL(string: 全局_喵窩API["论坛地址"]!)!
//                let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的浏览器URL, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 超时时间)
//                浏览器!.loadRequest(网络请求)
//                NSLog("论坛未完整载入，重试")
//            } else {
                卸载浏览器()
                let 提示:UIAlertController = UIAlertController(title: "论坛连接失败", message: "尝试载入完整版本论坛时出错，\n请重新进入本页重试", preferredStyle: UIAlertControllerStyle.alert)
                let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (动作:UIAlertAction) -> Void in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
                提示.addAction(取消按钮)
                self.present(提示, animated: true, completion: nil)
//            }
        } else if (网页内容?.range(of: "空空如也，何不创作一个？") != nil || 网页内容?.range(of: "道生一，一生二，二生三，三生萬物") != nil || 网页内容?.range(of: "It looks like there are no discussions here.") != nil) {
            //没有登录 //网页内容?.rangeOfString("关注") == nil
            //替换「空空如也，何不创作一个？」
            浏览器!.evaluateJavaScript("document.getElementById(\"content\").innerHTML=\"<div class=\\\"Placeholder\\\"><p>尚未登录论坛</p><p>请从菜单登录论坛后继续</p></div>\";", completionHandler: { (obj:Any?, err:Error?) in
                if (err != nil) {
                    NSLog(err!.localizedDescription)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
