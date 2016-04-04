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
    var 缓存策略:NSURLRequestCachePolicy = .UseProtocolCachePolicy
    var 超时时间:NSTimeInterval = 30
    var 屏蔽长按菜单:Bool = true
    //
    
    var 浏览器:WKWebView? = nil
    var 进度条:UIProgressView = UIProgressView()
    var 遮盖:UIView = UIView(frame: CGRectZero)
    var 遮盖文字:UILabel = UILabel()
    var 解析延迟定时器:MSWeakTimer? = nil
    var tryed:Bool = false
    
    override func viewDidAppear(animated: Bool) {
        if (浏览器 == nil) {
            装入浏览器()
        }
    }
    override func viewDidDisappear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        装入浏览器()
        装入UI()
        加载数据()
    }
    func 加载数据() {
        let 要加载的浏览器URL:NSURL = NSURL(string: 全局_喵窩API["论坛地址"]!)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的浏览器URL, cachePolicy: 缓存策略, timeoutInterval: 超时时间)
        浏览器!.loadRequest(网络请求)
    }
    func 装入UI() {
        进度条 = UIProgressView(progressViewStyle: .Bar)
        
        遮盖.backgroundColor = UIColor(red: 1, green: 153/255.0, blue: 203/255.0, alpha: 1)
        遮盖文字.text = "论坛载入中..."
        遮盖文字.textAlignment = .Center
        遮盖文字.textColor = UIColor.whiteColor()
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            遮盖.frame = CGRectMake(0, 0, 1366, 64)
            进度条.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.width,2)
        } else {
            遮盖.frame = CGRectMake(0, 0, 1366, 69)
            进度条.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 69, self.view.frame.width,2)
        }
        进度条.backgroundColor = UIColor.whiteColor()
        遮盖文字.frame = CGRectMake(0, 20, self.view.frame.width, 44)
        
        self.view.addSubview(进度条)
        self.view.addSubview(遮盖)
        遮盖.addSubview(遮盖文字)
    }
    func 装入浏览器() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        if (屏蔽长按菜单 == true) {
            let 禁止长按菜单JS:String = "document.body.style.webkitTouchCallout='none';"
            let 禁止长按菜单:WKUserScript = WKUserScript(source: 禁止长按菜单JS, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
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
        浏览器设置.selectionGranularity = .Dynamic
        let 浏览器坐标:CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.height)
        浏览器 = WKWebView(frame: 浏览器坐标, configuration: 浏览器设置)
        浏览器!.navigationDelegate = self
        浏览器!.UIDelegate = self
        self.view.insertSubview(浏览器!, atIndex: 0)
        浏览器!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        浏览器!.translatesAutoresizingMaskIntoConstraints = false
        let 左约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0)
        let 右约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0)
        let 上约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        let 下约束 = NSLayoutConstraint(item: 浏览器!, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([左约束,右约束,上约束,下约束])
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress"){
            self.进度条.setProgress(Float(浏览器!.estimatedProgress), animated: true)
        }
        if (浏览器!.estimatedProgress == 1){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.遮盖文字.text = ""
                self.进度条.alpha = 0
                self.遮盖.frame = CGRectMake(0, 0, 1366, 20)
                }) { (已完成:Bool) -> Void in
                    self.进度条.removeFromSuperview()
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
                if ((UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight) && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
//                    UIApplication.sharedApplication().statusBarHidden = true
                    self.遮盖.hidden = true
                } else {
//                    UIApplication.sharedApplication().statusBarHidden = false
                    self.遮盖.hidden = false
                }
        }
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        请求页面源码()
    }
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        卸载浏览器()
        let 提示:UIAlertController = UIAlertController(title: "论坛连接失败", message: "\(error.localizedDescription)\n请重新进入本页重试", preferredStyle: UIAlertControllerStyle.Alert)
        let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.navigationController?.popViewControllerAnimated(true)
        })
        提示.addAction(取消按钮)
        self.presentViewController(提示, animated: true, completion: nil)
    }
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let 即将转到网址:String = navigationAction.request.URL!.absoluteString
        let ob:OpenBrowser = OpenBrowser()
        ob.打开浏览器(即将转到网址)
        return nil
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
    
    func 请求页面源码() {
        if (解析延迟定时器 == nil) {
            解析延迟定时器 = MSWeakTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(MainTBC.请求页面源码2), userInfo: nil, repeats: false, dispatchQueue: dispatch_get_main_queue())
        }
    }
    func 请求页面源码2() {
        解析延迟定时器 = nil
        let 获取网页标题JS:String = "document.title"
        let 获取网页源码JS:String = "document.documentElement.innerHTML"
        var 网页源码:[String] = Array<String>()
        浏览器!.evaluateJavaScript(获取网页标题JS) { (对象:AnyObject?, 错误:NSError?) -> Void in
            if (对象 == nil) {
                return
            }
            网页源码.append(对象 as! String)
            self.浏览器!.evaluateJavaScript(获取网页源码JS) { (对象:AnyObject?, 错误:NSError?) -> Void in
                网页源码.append(对象 as! String)
                self.处理返回源码(网页源码)
            }
        }
    }
    func 处理返回源码(源码:[String]) {
        //let 网页标题:String? = 源码[0]
        let 网页内容:String? = 源码[1]
        if (网页内容?.rangeOfString("当前访问的是简约版，使用更先进的浏览器访问效果更佳。") != nil || 网页内容?.rangeOfString("嘗試載入完整版本的論壇時出錯。") != nil || 网页内容?.rangeOfString("Something went wrong while trying to load the full version of this site.") != nil) {
            if (tryed == false) {
                tryed = true
                let 要加载的浏览器URL:NSURL = NSURL(string: 全局_喵窩API["论坛地址"]!)!
                let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的浏览器URL, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 超时时间)
                浏览器!.loadRequest(网络请求)
            } else {
                卸载浏览器()
                let 提示:UIAlertController = UIAlertController(title: "论坛连接失败", message: "尝试载入完整版本论坛时出错，\n请重新进入本页重试", preferredStyle: UIAlertControllerStyle.Alert)
                let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.navigationController?.popViewControllerAnimated(true)
                })
                提示.addAction(取消按钮)
                self.presentViewController(提示, animated: true, completion: nil)
            }
        } else if (网页内容?.rangeOfString("空空如也，何不创作一个？") != nil || 网页内容?.rangeOfString("道生一，一生二，二生三，三生萬物") != nil || 网页内容?.rangeOfString("It looks like there are no discussions here.") != nil) {
            //没有登录 //网页内容?.rangeOfString("关注") == nil
            浏览器!.evaluateJavaScript("getByClass(\"box\").click();", completionHandler: { (obj:AnyObject?, err:NSError?) in
                
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