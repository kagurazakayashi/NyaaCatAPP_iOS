//
//  MainVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/10.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//



import UIKit

class MainVC: UIViewController, UIWebViewDelegate {
    
    let 动态地图网址:String = "https://mcmap.90g.org"
    let 注册页面标题:String = "Minecraft Dynamic Map - Login/Register"
    let 等待画面:WaitVC = WaitVC()
    let 登录菜单:LoginMenuVC = LoginMenuVC()
    
    var 后台网页加载器:UIWebView = UIWebView(frame: CGRectMake(0,0,100,200))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(后台网页加载器)
        //self.presentViewController(等待画面, animated: true, completion: nil)
        self.view.addSubview(等待画面.view)
        后台网页加载器.delegate = self
        let 要加载的网页URL:NSURL = NSURL(string: "https://mcmap.90g.org")!
        let 网络请求:NSURLRequest = NSURLRequest(URL: 要加载的网页URL)
        后台网页加载器.loadRequest(网络请求)
        等待画面.副标题.text = "正在连接到地图服务器..."
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //延迟定时器 = nil
        let 源代码JS请求:String = "document.title" //document.documentElement.innerHTML
        let 源代码:String? = 后台网页加载器.stringByEvaluatingJavaScriptFromString(源代码JS请求)
        if (源代码 != nil) {
            if (源代码 == 注册页面标题) {
                等待画面.副标题.text = "请使用动态地图用户登录。"
                self.view.addSubview(登录菜单.view)
            }
            
        }
        //延迟定时器 = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "延时分析网页", userInfo: nil, repeats: false)
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
