//
//  MainVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/10.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//



import UIKit

class MainVC: UIViewController, UIWebViewDelegate, LoginMenuVCDelegate {
    
    let 动态地图网址:String = "https://mcmap.90g.org"
    let 动态地图登录接口:String = "https://mcmap.90g.org/up/login"
    let 注册页面标题:String = "Minecraft Dynamic Map - Login/Register"
    
    let 等待画面:WaitVC = WaitVC()
    let 登录菜单:LoginMenuVC = LoginMenuVC()
    var 提示框:UIAlertController? = nil
    var 网络模式:网络模式选项 = 网络模式选项.检查是否登录
    
    enum 网络模式选项 {
        case 检查是否登录
        case 提交登录请求
    }
    
    var 后台网页加载器:UIWebView = UIWebView(frame: CGRectMake(0,0,100,200))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(后台网页加载器)
        //self.presentViewController(等待画面, animated: true, completion: nil)
        self.view.addSubview(等待画面.view)
        后台网页加载器.delegate = self
        检查登录网络请求()
    }
    
    func 检查登录网络请求() {
        let 要加载的网页URL:NSURL = NSURL(string: 动态地图网址)!
        let 网络请求:NSURLRequest = NSURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
        后台网页加载器.loadRequest(网络请求)
        等待画面.副标题.text = "正在连接到地图服务器..."
    }
    
    func 打开动态地图登录菜单() {
        等待画面.副标题.text = "请使用动态地图用户登录。"
        登录菜单.代理 = self
        self.view.addSubview(登录菜单.view)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if (网络模式 == 网络模式选项.检查是否登录) {
            let 网页标题:String? = 请求页面源码(true)
            if (网页标题 != nil && 网页标题 == 注册页面标题) {
                打开动态地图登录菜单()
            }
        } else if (网络模式 == 网络模式选项.提交登录请求) {
            let 网页标题:String? = 请求页面源码(true)
            if (网页标题 != nil) {
                NSLog("网页标题=" + 网页标题!)
            } else {
                等待画面.副标题.text = "登录失败"
                提示框 = UIAlertController(title: 等待画面.副标题.text, message: "服务暂时不可用或用户名密码不匹配", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
                    if (self.网络模式 == 网络模式选项.检查是否登录 || self.网络模式 == 网络模式选项.提交登录请求) {
                        self.打开动态地图登录菜单()
                    }
                })
                提示框!.addAction(okAction)
                self.presentViewController(提示框!, animated: true, completion: nil)
            }
        }
    }
    
    func 请求页面源码(只获取标题:Bool) -> String? {
        var 源代码JS请求:String = "document.title"
        if (只获取标题 == false) {
            源代码JS请求 = "document.documentElement.innerHTML"
        }
        return 后台网页加载器.stringByEvaluatingJavaScriptFromString(源代码JS请求)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        等待画面.副标题.text = "网络连接失败"
        提示框 = UIAlertController(title: 等待画面.副标题.text, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
            if (self.网络模式 == 网络模式选项.检查是否登录 || self.网络模式 == 网络模式选项.提交登录请求) {
                self.检查登录网络请求()
            }
        })
        提示框!.addAction(okAction)
        self.presentViewController(提示框!, animated: true, completion: nil)
    }
    
    func 返回登录请求(用户名:String,密码:String) {
        等待画面.副标题.text = "正在登录..."
        登录菜单.代理 = nil
        登录菜单.view.removeFromSuperview()
        网络模式 = 网络模式选项.提交登录请求
        let 网络参数:String = "?j_username=" + 用户名 + "&j_password=" + 密码
        let 要加载的网页URL:NSURL = NSURL(string: 动态地图网址 + 网络参数)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
        网络请求.HTTPMethod = "GET"
        //网络请求.HTTPBody = 网络参数.dataUsingEncoding(NSUTF8StringEncoding)
        后台网页加载器.loadRequest(网络请求)
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
