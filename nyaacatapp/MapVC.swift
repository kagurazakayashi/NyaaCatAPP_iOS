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
    
    var 浏览器:WKWebView? = nil
    let 动态地图登录接口:String = 全局_喵窩API["动态地图登录接口"]!
    
    var 登录步骤:Int = 0
    var 左上按钮:UIBarButtonItem? = nil
    var 右上按钮:UIBarButtonItem? = nil
    var 等待提示:UIAlertController? = nil
    var 解析延迟定时器:MSWeakTimer? = nil
    
    @IBOutlet weak var 动态地图工具栏: UIView!
    @IBOutlet weak var 动态: UISwitch!
    @IBOutlet weak var 三维: UISwitch!
    @IBOutlet weak var 转到: UIButton!
    
    var 地图名:String = "world"

    override func viewDidLoad() {
        super.viewDidLoad()
        创建UI()
        动态地图工具栏可用(false)
        创建地图浏览器()
    }
    
    func 创建UI() {
        左上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: #selector(MapVC.左上按钮点击))
        navigationItem.leftBarButtonItem = 左上按钮
        右上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: #selector(MapVC.右上按钮点击))
        navigationItem.rightBarButtonItem = 右上按钮
    }
    
    func 左上按钮点击() {
        动态地图工具栏.hidden = !动态地图工具栏.hidden
        转到.hidden = 动态地图工具栏.hidden
    }
    func 右上按钮点击() {
        //TODO: 预留地图切换接口
        let 选择地图 = UIAlertController(title: "选择地图", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let 地图按钮 = UIAlertAction(title: "主世界地图", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
            self.地图名 = "world"
            self.装入地图(nil, y: nil, z: nil)
        })
        选择地图.addAction(地图按钮)
        let 地图S = UIAlertAction(title: "S 世界", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
            self.地图名 = "S"
            self.装入地图(nil, y: nil, z: nil)
        })
        选择地图.addAction(地图S)
        let 地图M = UIAlertAction(title: "M 世界", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
            self.地图名 = "M"
            self.装入地图(nil, y: nil, z: nil)
        })
        选择地图.addAction(地图M)
//        let 导航地图按钮 = UIAlertAction(title: "导航地图(by Miz)", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
//            self.装入网页(全局_喵窩API["Ilse地图"]!)
//        })
//        选择地图.addAction(导航地图按钮)
        let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
            
        })
        选择地图.addAction(取消按钮)
        self.presentViewController(选择地图, animated: true, completion: nil)
    }
    
    func 装入地图(x:String?, y:String?, z:String?) {
        var 参数串:String = "\(全局_喵窩API["动态地图域名"]!)/?worldname="
        参数串 = "\(参数串)\(地图名)"
        if (三维.on == true) {
            参数串 = "\(参数串)&mapname=surface"
        } else {
            参数串 = "\(参数串)&mapname=flat"
        }
        if (动态.on == true) {
            参数串 = "\(参数串)&nogui=false"
        } else {
            参数串 = "\(参数串)&nogui=true"
        }
        if (x != nil) {
            参数串 = "\(参数串)&x=\(x!)"
        }
        if (y != nil) {
            参数串 = "\(参数串)&y=\(y!)"
        }
        if (z != nil) {
            参数串 = "\(参数串)&zoom=\(z!)"
        }
        self.装入网页(参数串)
    }
    
    func 动态地图工具栏可用(是否可用:Bool) {
        左上按钮?.enabled = 是否可用
        转到.hidden = !是否可用
        动态地图工具栏.hidden = !是否可用
    }
    
    func 创建地图浏览器() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        浏览器设置.allowsPictureInPictureMediaPlayback = false
        浏览器设置.allowsInlineMediaPlayback = false
        浏览器设置.allowsAirPlayForMediaPlayback = false
        浏览器设置.requiresUserActionForMediaPlayback = false
        浏览器设置.suppressesIncrementalRendering = false
        浏览器设置.applicationNameForUserAgent = 全局_浏览器标识
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
        浏览器偏好设置.javaScriptEnabled = true
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .Dynamic
        let 浏览器坐标:CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.height)
        浏览器 = WKWebView(frame: 浏览器坐标, configuration: 浏览器设置)
        浏览器?.backgroundColor = UIColor.blackColor()
        self.view.insertSubview(浏览器!, atIndex: 0)
        自动登录动态地图()
    }
    
    func 自动登录动态地图() {
        if (全局_用户名 != nil && 全局_密码 != nil) {
            let 网络参数:String = "j_username=" + 全局_用户名! + "&j_password=" + 全局_密码!
            let 包含参数的网址:String = 动态地图登录接口 + "?" + 网络参数
            let 要加载的网页URL:NSURL = NSURL(string: 包含参数的网址)!
            let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的网页URL, cachePolicy: 全局_缓存策略, timeoutInterval: 30)
            网络请求.HTTPMethod = "POST"
            浏览器?.navigationDelegate = self
            浏览器!.loadRequest(网络请求)
        } else {
            浏览器?.loadHTMLString("你正在处于游客模式，没有权限访问地图。", baseURL: nil)
        }
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if (登录步骤 == 0) {
            登录步骤 += 1
            装入网页(全局_喵窩API["静态地图接口"]!)
        }
        if (等待提示 != nil) {
            等待提示?.dismissViewControllerAnimated(false, completion: nil)
            等待提示 = nil
        }
        let 当前网址:NSString = (webView.URL?.absoluteString)!
        let 动态地图域名:NSString = 全局_喵窩API["动态地图域名"]!
        var 工具栏可用:Bool = false
        if (当前网址.length > 动态地图域名.length) {
            let 当前网址裁剪:String = 当前网址.substringToIndex(动态地图域名.length)
            if (动态地图域名.isEqualToString(当前网址裁剪)) {
                工具栏可用 = true
            }
        }
        动态地图工具栏可用(工具栏可用)
    }
    
    func 请求页面源码() {
        if (解析延迟定时器 == nil) {
            解析延迟定时器 = MSWeakTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(self.请求页面源码2), userInfo: nil, repeats: false, dispatchQueue: dispatch_get_main_queue())
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
        let 网页标题:String? = 源码[0]
        let 网页内容:String? = 源码[1]
        if (网页标题 == 全局_喵窩API["注册页面标题"]!) {
            //网页内容?.rangeOfString("Enter user ID and password") != nil
            自动登录动态地图()
        } else if (网页内容?.rangeOfString("Web files are not matched with plugin version") != nil) {
            浏览器!.loadHTMLString("", baseURL: nil)
            let 提示:UIAlertController = UIAlertController(title: "地图连接失败", message: "请切换其他地图试试", preferredStyle: UIAlertControllerStyle.Alert)
            let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            提示.addAction(取消按钮)
        } else if (网页标题 != 全局_喵窩API["地图页面标题"]!) {
            let 提示:UIAlertController = UIAlertController(title: "地图连接失败", message: "错误：\(网页标题)", preferredStyle: UIAlertControllerStyle.Alert)
            let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            提示.addAction(取消按钮)
        }
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        浏览器?.loadHTMLString("", baseURL: nil)
        if (等待提示 != nil) {
            等待提示?.dismissViewControllerAnimated(false, completion: nil)
            等待提示 = nil
        }
        动态地图工具栏可用(false)
        let 消息提示:UIAlertController = UIAlertController(title: "载入失败", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        消息提示.addAction(取消按钮)
        self.presentViewController(消息提示, animated: true, completion: nil)
    }
    
    func 装入网页(网址:String) {
        if (等待提示 == nil) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            等待提示 = UIAlertController(title: "⌛️正在连接地图服务器", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let 取消按钮 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.浏览器?.reload()
                self.等待提示 = nil
            })
            等待提示!.addAction(取消按钮)
            self.presentViewController(等待提示!, animated: true, completion: nil)
        }
        let 要加载的网页URL:NSURL = NSURL(string: 网址)!
        let 加载地图网络请求:NSURLRequest =  NSURLRequest(URL: 要加载的网页URL, cachePolicy: 全局_缓存策略, timeoutInterval: 30)
        浏览器!.loadRequest(加载地图网络请求)
    }
    
    @IBAction func 动态开关(sender: UISwitch) {
        装入地图(nil, y: nil, z: nil)
    }
    
    @IBAction func 三维开关(sender: UISwitch) {
        装入地图(nil, y: nil, z: nil)
    }
    
    @IBAction func 转到按钮(sender: UIButton) {
        let 提示框:UIAlertController = UIAlertController(title: "请输入转到目标", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
        })
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
            self.提示框处理(提示框)
        })
        提示框.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "X 坐标"
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        提示框.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Y 坐标"
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        提示框.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Z 放大倍数(0-10)"
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        提示框.addAction(okAction)
        提示框.addAction(cancelAction)
        self.presentViewController(提示框, animated: true, completion: nil)
    }
    
    func 提示框处理(提示框:UIAlertController) {
        let x输入框:UITextField = 提示框.textFields![0] as UITextField
        let y输入框:UITextField = 提示框.textFields![1] as UITextField
        let z输入框:UITextField = 提示框.textFields![2] as UITextField
        //TODO: 坐标补偿、是否为纯数字校验
        
        //
        装入地图(x输入框.text, y: y输入框.text, z: z输入框.text)
    }
    
//    - (BOOL)isValidateNum:(NSString *)string
//    
//    {
//    
//    NSString *numCheck = @"[A-Z0-9a-z]";
//    
//    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",numCheck];
//    
//    return [numTest evaluateWithObject:string];
//    
//    }

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
