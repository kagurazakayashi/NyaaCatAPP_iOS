//
//  MainTBC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/20.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import WebKit

class MainTBC: UITabBarController, WKNavigationDelegate, WaitVCDelegate {
    
    let 动态地图网址:String = 全局_喵窩API["动态地图域名"]!
    let 动态地图登录接口:String = 全局_喵窩API["动态地图登录接口"]!
    let 注册页面标题:String = 全局_喵窩API["注册页面标题"]!
    let 地图页面标题:String = 全局_喵窩API["地图页面标题"]!
    let 地图页面特征:String = "<div id=\"mcmap\" class=\"dynmap\">"
    
    let 等待画面:WaitVC = WaitVC()
    let 登录菜单:LoginMenuVC = LoginMenuVC()
    var 提示框:UIAlertController? = nil
    var 网络模式:网络模式选项 = 网络模式选项.检查是否登录
    var 新定时器:MSWeakTimer? = nil
    var 菊花定时器:MSWeakTimer? = nil
    var 定时器延迟计时器:TimeInterval = 0
    var 解析延迟定时器:MSWeakTimer? = nil
    var 解析引擎:DynmapAnalysisController = DynmapAnalysisController()
    var 等待提示框:Bool = false
    
    enum 网络模式选项 {
        case 检查是否登录
        case 提交登录请求
        case 监视页面信息
        case 游客模式
    }
    
    //var 后台网页加载器:UIWebView = UIWebView(frame: CGRectMake(0,0,100,200))
    var 后台网页加载器:WKWebView? = nil
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = 全局_导航栏颜色
        //navigationBar.layer.contents = (id)[UIImage imageWithColor:youColor].CGImage;
        tabBar.tintColor = UIColor.white
        全局_设备信息.isBatteryMonitoringEnabled = true
        if (全局_设备信息.batteryState == .charging || 全局_设备信息.batteryState == .full){
            全局_刷新延迟 = 1
        } else {
            全局_刷新延迟 = 3
        }
        初始化WebView()
        
        //self.presentViewController(等待画面, animated: true, completion: nil)
        等待画面.view.frame = self.view.frame
        self.view.addSubview(等待画面.view)
        等待画面.代理 = self
        
        
        检查登录网络请求(false)
        
        //WKWebView内存使用测试
//        for i in 0...100 {
//            let testweb:WKWebView = WKWebView(frame: CGRectMake(0, 0, 100, 100))
//            self.view.addSubview(testweb)
//            testweb.loadRequest(NSURLRequest(URL: NSURL(string: "http://163.com")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30))
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBC.收到重载通知), name: "reloadwebview" as NSNotification.Name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBC.应用定时器延迟设置), name: "timerset" as NSNotification.Name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBC.显示一下网络菊花), name: "netbusyonce" as NSNotification.Name, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainTBC.游客模式), name: "guest" as NSNotification.Name, object: nil)
    }
    
    func 初始化WebView() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        浏览器设置.allowsPictureInPictureMediaPlayback = false
        浏览器设置.allowsInlineMediaPlayback = false
        浏览器设置.allowsAirPlayForMediaPlayback = false
        浏览器设置.requiresUserActionForMediaPlayback = false
        浏览器设置.suppressesIncrementalRendering = false
        浏览器设置.applicationNameForUserAgent = 全局_浏览器标识
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        //浏览器偏好设置.minimumFontSize = 12.0
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
        浏览器偏好设置.javaScriptEnabled = true
        //        let 用户脚本文本:String = "$('div img').remove();"
        //        let 用户脚本:WKUserScript = WKUserScript(source: 用户脚本文本, injectionTime: .AtDocumentEnd, forMainFrameOnly: false)
        //        浏览器设置.userContentController.addUserScript(用户脚本)
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .dynamic
        
        后台网页加载器 = WKWebView(frame: CGRect.zero, configuration: 浏览器设置)
//        后台网页加载器 = WKWebView(frame: CGRectMake(0, 0, 300, 300), configuration: 浏览器设置)
        
        后台网页加载器?.isUserInteractionEnabled = false
        self.view.addSubview(后台网页加载器!)
        后台网页加载器!.navigationDelegate = self
        
        //        后台网页加载器!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        //        后台网页加载器!.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    }
    
    func 游客模式() {
        self.selectedIndex = 3
    }
    func 游客模式阻止(_ message:String?) {
        let 提示:UIAlertController = UIAlertController(title: "游客模式不能浏览此条目", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (动作:UIAlertAction) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
        提示.addAction(取消按钮)
        self.present(提示, animated: true, completion: nil)
    }
    
    func 显示一下网络菊花() {
        if (菊花定时器 == nil && UIApplication.shared.isNetworkActivityIndicatorVisible == false) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            菊花定时器 = MSWeakTimer.scheduledTimer(withTimeInterval: 1.0, target: self, selector: #selector(MainTBC.显示一下网络菊花2), userInfo: nil, repeats: false, dispatchQueue: DispatchQueue.main)
        }
    }
    func 显示一下网络菊花2() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        菊花定时器 = nil
    }
    
    func 收到重载通知() {
        后台网页加载器!.reload()
    }
    
    func 应用定时器延迟设置() {
        定时器延迟计时器 = 0
    }
    
    func 检查登录网络请求(_ 缓存:Bool) {
        let 要加载的网页URL:URL = URL(string: 动态地图网址)!
        var 网络请求:URLRequest? = nil
        if (缓存 == false) {
            网络请求 = URLRequest(url: 要加载的网页URL, cachePolicy: 全局_缓存策略, timeoutInterval: 30)
        } else {
            网络请求 = URLRequest(url: 要加载的网页URL, cachePolicy: 全局_缓存策略, timeoutInterval: 30)
        }
        等待画面.副标题.text = "连接到地图服务器中..."
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        后台网页加载器!.load(网络请求!)
    }
    
    func 打开动态地图登录菜单() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        等待画面.副标题.text = "请使用动态地图用户登录喵"
        等待画面.登录按钮.isHidden = false
//        登录菜单.代理 = self
//        self.view.addSubview(登录菜单.view)
//        登录菜单.进入动画(self.view.frame)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        等待画面.副标题.text = "正在处理返回值..."
//        if (等待提示框 == false) {
            请求页面源码()
//        }
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        等待画面.副标题.text = "错误：\(error.localizedDescription)"
        等待画面.重试按钮模式(true)
        等待画面.登录按钮.isHidden = false
//        if (等待提示框 == false) {
//            等待提示框 = true
//            提示框 = UIAlertController(title: 等待画面.副标题.text, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
//            let okAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
//                self.等待提示框 = false
//                if (self.网络模式 == 网络模式选项.检查是否登录 || self.网络模式 == 网络模式选项.提交登录请求) {
//                    self.检查登录网络请求(false)
//                }
//            })
//            let cancelAction = UIAlertAction(title: "游客登录", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
//                self.等待提示框 = false
//                self.返回登录请求(nil,密码: nil)
//            })
//            提示框!.addAction(okAction)
//            提示框!.addAction(cancelAction)
//            self.presentViewController(提示框!, animated: true, completion: nil)
//        }
    }
//    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
//        NSLog("didCommitNavigation")
//    }
//    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        NSLog("didStartProvisionalNavigation")
//    }
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        if (keyPath != nil) {
//            if (keyPath == "estimatedProgress") {
//                print("网页加载进度：\(后台网页加载器?.estimatedProgress)")
//            } else if (keyPath == "title") {
//                print("网页标题：\(后台网页加载器?.estimatedProgress)")
//            }
//        }
//    }
    
    func 定时器触发() {
        定时器延迟计时器 += 1
        if (定时器延迟计时器 >= 全局_刷新延迟) {
            定时器延迟计时器 = 0
            请求页面源码()
        }
    }
    
    func 处理返回源码(_ 源码:[String]) {
        if (网络模式 == 网络模式选项.检查是否登录) {
            let 网页标题:String? = 源码[0]
            if (网页标题 != nil && 网页标题 == 注册页面标题) {
                打开动态地图登录菜单()
            } else {
                等待画面.副标题.text = "错误：\(网页标题!)"
                用户名或密码不匹配()
            }
        } else if (网络模式 == 网络模式选项.提交登录请求) {
            let 网页标题:String? = 源码[0]
            if (网页标题 == 地图页面标题) {
                let 网页内容:String? = 源码[1]
                if (网页内容 != nil && 网页内容!.range(of: 地图页面特征) != nil) {
                    等待画面.副标题.text = "登录成功~撒花~"
                    等待画面.代理 = nil
                    等待画面.停止 = true
                    等待画面.退出()
                    网络模式 = 网络模式选项.监视页面信息
                    新定时器 = MSWeakTimer.scheduledTimer(withTimeInterval: 1.5, target: self, selector: #selector(MainTBC.定时器触发), userInfo: nil, repeats: true, dispatchQueue: DispatchQueue.main)
                } else {
                    等待画面.副标题.text = "用户名或密码不匹配"
                    用户名或密码不匹配()
                }
            } else if (网页标题 != nil && 网页标题 != 注册页面标题) {
                检查登录网络请求(true)
            } else {
                等待画面.副标题.text = 网页标题
                用户名或密码不匹配()
            }
        } else if (网络模式 == 网络模式选项.监视页面信息) {
            解析引擎.html = 源码[1]
            解析引擎.start()
        } else if (网络模式 == 网络模式选项.游客模式) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "data"), object: nil)
        }
    }
    
    func 用户名或密码不匹配() {
        全局_用户名 = nil
        全局_密码 = nil
        self.网络模式 = 网络模式选项.检查是否登录
        等待画面.重试按钮模式(true)
        等待画面.登录按钮.isHidden = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        if (等待提示框 == false) {
//            等待提示框 = true
//            提示框 = UIAlertController(title: "登录失败", message: 等待画面.副标题.text, preferredStyle: UIAlertControllerStyle.Alert)
//            let okAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
//                self.等待提示框 = false
////                self.打开动态地图登录菜单()
//            })
//            提示框!.addAction(okAction)
//            self.presentViewController(提示框!, animated: true, completion: nil)
//        }
        
    }
    
    func 重试按钮点击() {
        检查登录网络请求(false)
    }
    
    func 请求页面源码() {
        if (解析延迟定时器 == nil) {
            解析延迟定时器 = MSWeakTimer.scheduledTimer(withTimeInterval: 0.9, target: self, selector: #selector(MainTBC.请求页面源码2), userInfo: nil, repeats: false, dispatchQueue: DispatchQueue.main)
        }
    }
    func 请求页面源码2() {
        解析延迟定时器 = nil
        let 获取网页标题JS:String = "document.title"
        let 获取网页源码JS:String = "document.documentElement.innerHTML"
        var 网页源码:[String] = Array<String>()
        后台网页加载器!.evaluateJavaScript(获取网页标题JS) { (对象:AnyObject?, 错误:Error?) -> Void in
            if (对象 == nil) {
                return
            }
            网页源码.append(对象 as! String)
            self.后台网页加载器!.evaluateJavaScript(获取网页源码JS) { (对象:AnyObject?, 错误:Error?) -> Void in
                网页源码.append(对象 as! String)
                self.处理返回源码(网页源码)
            }
        }
    }
    
    func 返回登录请求(_ 用户名:String?,密码:String?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        等待画面.副标题.text = "正在登录喵..."
        //        登录菜单.代理 = nil
        //        登录菜单.退出动画()
        if (用户名 != nil) {
            网络模式 = 网络模式选项.提交登录请求
            let 网络参数:String = "j_username=" + 用户名! + "&j_password=" + 密码!
            let 包含参数的网址:String = 动态地图登录接口 + "?" + 网络参数
            let 要加载的网页URL:URL = URL(string: 包含参数的网址)!
            let 网络请求:NSMutableURLRequest = NSMutableURLRequest(url: 要加载的网页URL, cachePolicy: 全局_缓存策略, timeoutInterval: 30)
            网络请求.httpMethod = "POST"
            全局_用户名 = 用户名
            全局_密码 = 密码
            后台网页加载器!.load(网络请求 as URLRequest)
        } else {
            网络模式 = 网络模式选项.游客模式
            等待画面.退出()
            新定时器 = MSWeakTimer.scheduledTimer(withTimeInterval: 1.0, target: self, selector: #selector(MainTBC.定时器触发), userInfo: nil, repeats: false, dispatchQueue: DispatchQueue.main)
            等待画面.停止 = true
        }
    }
    
    func 弹出代理提示框(_ 提示框:UIAlertController) {
        self.present(提示框, animated: true, completion: nil)
    }
    
//    func 解析完成(综合信息输入:Dictionary<String,NSObject>?,信息数据量 信息数据量输入:Dictionary<String,Int>?) {
//        全局_综合信息 = 综合信息输入
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //后台网页加载器.reload()
    }
}
