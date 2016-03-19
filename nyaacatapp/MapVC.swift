//
//  MapVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/12.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import WebKit

class MapVC: UIViewController , WKNavigationDelegate {
    
    var 动态地图网页:WKWebView? = nil
    let 动态地图URL:String = 全局_喵窩API["静态地图接口"]!
    let 动态地图登录接口:String = 全局_喵窩API["动态地图登录接口"]!
    
    var 登录步骤:Int = 0
    var 左上按钮:UIBarButtonItem? = nil
    var 右上按钮:UIBarButtonItem? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        创建UI()
        创建地图浏览器()
    }
    
    func 创建UI() {
//        左上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "左上按钮点击")
//        navigationItem.leftBarButtonItem = 左上按钮
        右上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "右上按钮点击")
        navigationItem.rightBarButtonItem = 右上按钮
    }
    
    func 右上按钮点击() {
        //TODO: 预留地图切换接口
        NSLog("地图切换")
    }
    
    func 创建地图浏览器() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        浏览器设置.allowsPictureInPictureMediaPlayback = false
        浏览器设置.allowsInlineMediaPlayback = false
        浏览器设置.allowsAirPlayForMediaPlayback = false
        浏览器设置.requiresUserActionForMediaPlayback = false
        浏览器设置.suppressesIncrementalRendering = false
        浏览器设置.applicationNameForUserAgent = "Mozilla/5.0 (kagurazaka-browser)"
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
        浏览器偏好设置.javaScriptEnabled = true
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .Dynamic
        let 浏览器坐标:CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.height)
        动态地图网页 = WKWebView(frame: 浏览器坐标, configuration: 浏览器设置)
        self.view.addSubview(动态地图网页!)
        自动登录动态地图()
    }
    
    func 自动登录动态地图() {
        if (全局_用户名 != nil && 全局_密码 != nil) {
            let 网络参数:String = "j_username=" + 全局_用户名! + "&j_password=" + 全局_密码!
            let 包含参数的网址:String = 动态地图登录接口 + "?" + 网络参数
            let 要加载的网页URL:NSURL = NSURL(string: 包含参数的网址)!
            let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
            网络请求.HTTPMethod = "POST"
            动态地图网页?.navigationDelegate = self
            动态地图网页!.loadRequest(网络请求)
        } else {
            动态地图网页?.loadHTMLString("你正在处于游客模式，没有权限访问地图。", baseURL: nil)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        NSLog("page ok")
        if (登录步骤 == 0) {
            登录步骤++
            let 要加载的网页URL:NSURL = NSURL(string: 动态地图URL)!
            let 加载地图网络请求:NSURLRequest =  NSURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30)
            动态地图网页!.loadRequest(加载地图网络请求)
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
