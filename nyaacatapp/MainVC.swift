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
    let 地图页面标题:String = "Minecraft Dynamic Map"
    let 地图页面特征:String = "<!-- These 2 lines make us fullscreen on apple mobile products - remove if you don't like that -->"
    
    let 等待画面:WaitVC = WaitVC()
    let 登录菜单:LoginMenuVC = LoginMenuVC()
    var 提示框:UIAlertController? = nil
    var 网络模式:网络模式选项 = 网络模式选项.检查是否登录
    var 定时器:NSTimer? = nil
    
    enum 网络模式选项 {
        case 检查是否登录
        case 提交登录请求
    }
    
    var 后台网页加载器:UIWebView = UIWebView(frame: CGRectMake(0,0,100,200))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(后台网页加载器)
        //self.presentViewController(等待画面, animated: true, completion: nil)
        等待画面.view.frame = self.view.frame
        登录菜单.view.frame = self.view.frame
        self.view.addSubview(等待画面.view)
        后台网页加载器.delegate = self
        检查登录网络请求(false)
    }
    
    func 检查登录网络请求(缓存:Bool) {
        let 要加载的网页URL:NSURL = NSURL(string: 动态地图网址)!
        var 网络请求:NSURLRequest? = nil
        if (缓存 == false) {
            网络请求 = NSURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
        } else {
            网络请求 = NSURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30)
        }
        后台网页加载器.loadRequest(网络请求!)
        等待画面.副标题.text = "连接到地图服务器中喵"
    }
    
    func 打开动态地图登录菜单() {
        等待画面.副标题.text = "请使用动态地图用户登录喵"
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
            if (网页标题 == 地图页面标题) {
                let 网页内容:String? = 请求页面源码(false)
                if (网页内容?.rangeOfString(地图页面特征) != nil) {
                    等待画面.副标题.text = "登录成功~撒花~"
                    定时器 = NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "定时器触发", userInfo: nil, repeats: true)
                }
            } else if (网页标题 != nil) {
                检查登录网络请求(true)
                NSLog("网页标题=" + 网页标题!)
            } else {
                等待画面.副标题.text = "登录失败喵"
                提示框 = UIAlertController(title: 等待画面.副标题.text, message: "服务暂时不可用或用户名密码不匹配喵QAQ", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "重试喵", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
                    if (self.网络模式 == 网络模式选项.检查是否登录 || self.网络模式 == 网络模式选项.提交登录请求) {
                        self.打开动态地图登录菜单()
                    }
                })
                提示框!.addAction(okAction)
                self.presentViewController(提示框!, animated: true, completion: nil)
            }
        }
    }
    
    func 定时器触发() {
        let 网页内容:String? = 请求页面源码(false)
        NSLog("网页内容="+网页内容!)
    }
    
    func 请求页面源码(只获取标题:Bool) -> String? {
        var 源代码JS请求:String = "document.title"
        if (只获取标题 == false) {
            源代码JS请求 = "document.documentElement.innerHTML"
        }
        return 后台网页加载器.stringByEvaluatingJavaScriptFromString(源代码JS请求)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        等待画面.副标题.text = "网络连接失败喵"
        提示框 = UIAlertController(title: 等待画面.副标题.text, message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "重试", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
            if (self.网络模式 == 网络模式选项.检查是否登录 || self.网络模式 == 网络模式选项.提交登录请求) {
                self.检查登录网络请求(false)
            }
        })
        提示框!.addAction(okAction)
        self.presentViewController(提示框!, animated: true, completion: nil)
    }
    
    func 返回登录请求(用户名:String,密码:String) {
        等待画面.副标题.text = "正在登录喵..."
        登录菜单.代理 = nil
        登录菜单.view.removeFromSuperview()
        网络模式 = 网络模式选项.提交登录请求
        let 网络参数:String = "j_username=" + 用户名 + "&j_password=" + 密码
        let 包含参数的网址:String = 动态地图登录接口 + "?" + 网络参数
        let 要加载的网页URL:NSURL = NSURL(string: 包含参数的网址)!
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
