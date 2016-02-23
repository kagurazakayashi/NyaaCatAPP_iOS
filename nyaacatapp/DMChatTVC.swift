//
//  DMChatTVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/21.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import WebKit

class DMChatTVC: UITableViewController,WKNavigationDelegate { //,UIScrollViewDelegate
    
    let 消息发送接口:String = "https://mcmap.90g.org/up/sendmessage"
    let 动态地图登录接口:String = "https://mcmap.90g.org/up/login"
    let 允许转义颜色代码:Bool = false //true: 将&视为颜色代码
    
//    let 消息发送接口:String = "https://yoooooooooo.com/sendmessagetest.php"
//    let 动态地图登录接口:String = "https://mcmap.90g.org/up/login"
    
//    let 消息发送接口:String = "http://123.56.133.111:8123/up/sendmessage"
//    let 动态地图登录接口:String = "http://123.56.133.111:8123/up/login"
    
    var 实时聊天数据:[[String]]? = nil
    var 默认头像:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("seting-icon", ofType: "png")!)!
    var 第三方软件发送头像:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("t_logo", ofType: "png")!)!
    var 动态地图聊天头像:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("msg-icon", ofType: "png")!)!
    var 手机聊天头像:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("mobile-2-icon", ofType: "png")!)!
    var 左上按钮:UIBarButtonItem? = nil
    var 右上按钮:UIBarButtonItem? = nil
    var 聊天文字输入框:UIAlertController? = nil
//    var 后台网页加载器:WKWebView? = nil
    var 正在发送的消息:String? = nil
    var 网络模式:网络模式选项 = 网络模式选项.提交登录请求
    
    enum 网络模式选项 {
        case 提交登录请求
        case 发送聊天消息
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let 背景图:UIImageView = UIImageView(frame: tableView.frame)
        背景图.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("bg", ofType: "jpg")!)!
        背景图.contentMode = .ScaleAspectFill
//        self.tableView.insertSubview(背景图, atIndex: 0)
        self.tableView.backgroundView = 背景图
        self.tableView.backgroundColor = UIColor.clearColor()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "接收数据更新通知", name: "data", object: nil)
        
//        初始化WebView()
        
        左上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "左上按钮点击")
        navigationItem.leftBarButtonItem = 左上按钮
        右上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "右上按钮点击")
        navigationItem.rightBarButtonItem = 右上按钮
    }
    
    func 初始化WebView() {
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        浏览器设置.allowsPictureInPictureMediaPlayback = false
        浏览器设置.allowsInlineMediaPlayback = false
        浏览器设置.allowsAirPlayForMediaPlayback = false
        浏览器设置.requiresUserActionForMediaPlayback = false
        浏览器设置.suppressesIncrementalRendering = false
//        浏览器设置.applicationNameForUserAgent = "Mozilla/5.0 (kagurazaka-browser)"
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        浏览器偏好设置.minimumFontSize = 40.0
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
        浏览器偏好设置.javaScriptEnabled = false
        //        let 用户脚本文本:String = "$('div img').remove();"
        //        let 用户脚本:WKUserScript = WKUserScript(source: 用户脚本文本, injectionTime: .AtDocumentEnd, forMainFrameOnly: false)
        //        浏览器设置.userContentController.addUserScript(用户脚本)
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .Dynamic
        
//        后台网页加载器 = WKWebView(frame: CGRectMake(0, 0, 300, 300), configuration: 浏览器设置)
//        后台网页加载器?.alpha = 0.5
//        后台网页加载器?.userInteractionEnabled = false
//        self.view.addSubview(后台网页加载器!)
//        后台网页加载器!.navigationDelegate = self
        
        //        后台网页加载器!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        //        后台网页加载器!.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    }
    
    /*
    Request URL:https://mcmap.90g.org/up/sendmessage
    Request Method:POST
    Status Code:200 OK
    Remote Address:114.215.110.235:443
    Response Headers
    content-length:16
    content-type:text/plain;charset=UTF-8
    date:Mon, 22 Feb 2016 13:07:30 GMT
    expires:Thu, 01 Dec 1994 16:00:00 GMT
    last-modified:Mon Feb 22 21:07:30 CST 2016
    server:nginx
    status:200 OK
    strict-transport-security:max-age=31536000; preload
    version:HTTP/1.1
    Request Headers
    :host:mcmap.90g.org
    :method:POST
    :path:/up/sendmessage
    :scheme:https
    :version:HTTP/1.1
    accept:application/json, text/javascript, * / *; q=0.01
    accept-encoding:gzip, deflate
    accept-language:zh-CN,zh;q=0.8,en;q=0.6,ja;q=0.4
    content-length:25
    content-type:application/json; charset=UTF-8
    cookie:JSESSIONID=z6cwxznc5lb9n5x0wdm7tkkh
    dnt:1
    origin:https://mcmap.90g.org
    referer:https://mcmap.90g.org/index.html
    user-agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.109 Safari/537.36
    x-requested-with:XMLHttpRequest
    Request Payload
    view source
    {name: "", message: " "}
    message: " "
    name: ""
    */
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        网络连接完成()
    }
    
    func 网络连接完成() {
        if (网络模式 == 网络模式选项.提交登录请求) {
            网络模式 = 网络模式选项.发送聊天消息
            //向服务器提交聊天消息
            let 网络参数:NSString = "{\"name\":\"\",\"message\":\"§2" + 全局_手机发送消息关键字 + "§f" + 正在发送的消息! + "\"}"
            let 要加载的网页URL:NSURL = NSURL(string: 消息发送接口)!
            let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 30)
            let 网络参数数据:NSData = 网络参数.dataUsingEncoding(NSUTF8StringEncoding)!
            网络请求.HTTPMethod = "POST"
            //§2[NyaaCatAPP] §fThis is a test message.
            //[urlRequest setValue: [NSString stringWithFormat:@"%@\r\n", @"http://XXXXXX HTTP/1.1"]];
            //application/json , application/x-www-data-urlencoded
            网络请求.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "accept")
            网络请求.setValue("gzip, deflate", forHTTPHeaderField: "accept-encoding")
            网络请求.setValue("zh-CN,zh;q=0.8,en;q=0.6,ja;q=0.4", forHTTPHeaderField: "accept-language")
            网络请求.setValue("\(网络参数数据.length)", forHTTPHeaderField: "content-length")
            网络请求.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "content-type")
            网络请求.setValue("1", forHTTPHeaderField: "dnt")
            网络请求.setValue("https://mcmap.90g.org", forHTTPHeaderField: "origin")
            网络请求.setValue("https://mcmap.90g.org/index.html", forHTTPHeaderField: "referer")
            网络请求.setValue("XMLHttpRequest", forHTTPHeaderField: "x-requested-with")
            //网络请求.HTTPBody = 网络参数数据
            //            后台网页加载器!.loadRequest(网络请求)
            let 上传会话 = NSURLSession.sharedSession()
            let 上传任务 = 上传会话.uploadTaskWithRequest(网络请求, fromData: 网络参数数据){
                (data:NSData?, reponse:NSURLResponse?, error:NSError?) ->Void in
                
                if(error != nil){
                    self.网络连接失败(error!.localizedDescription)
                } else{
                    let 回应:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                    if (回应 == "{\"error\":\"none\"}") {
                        self.右上按钮?.enabled = true
                        self.网络连接完成()
                    } else {
                        self.网络连接失败(回应)
                    }
                }
            }
            上传任务.resume()
            
        } else {
            右上按钮!.enabled = true
        }
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        网络连接失败(error.localizedDescription)
    }
    
    func 网络连接失败(错误描述:String) {
        NSLog("消息发送失败=%@", 错误描述)
        网络模式 = 网络模式选项.提交登录请求
        if (正在发送的消息 != nil) {
            正在发送的消息 = 转义颜色代码(false, 内容: 正在发送的消息!)
        }
        打开发送消息框(正在发送的消息,错误描述: 错误描述)
        正在发送的消息 = nil
    }
    
    func 左上按钮点击() {
        if (全局_用户名 != nil) {
            NSNotificationCenter.defaultCenter().postNotificationName("reloadwebview", object: nil)
        } else {
            //正在以游客身份登录，没有参与聊天的权限
        }
    }
    func 右上按钮点击() {
        if (全局_用户名 != nil) {
            打开发送消息框(nil,错误描述: nil)
        } else {
            //正在以游客身份登录，没有参与聊天的权限
        }
    }
    
    func 打开发送消息框(重试消息:String?,错误描述:String?) {
        var 标题:String = "输入聊天信息"
        var 内容:String? = nil
        if (重试消息 != nil) {
            标题 = "消息发送失败"
            内容 = 错误描述
        }
        聊天文字输入框 = UIAlertController(title: 标题, message: 内容, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
            self.提示框处理(false)
        })
        let okAction = UIAlertAction(title: "发送", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
            self.提示框处理(true)
        })
        聊天文字输入框!.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            textField.placeholder = "请在此输入要发送的内容"
            textField.text = 重试消息
        }
        聊天文字输入框!.addAction(cancelAction)
        聊天文字输入框!.addAction(okAction)
        self.presentViewController(聊天文字输入框!, animated: true, completion: nil)
    }
    
    func 提示框处理(确定:Bool) {
        if (确定 == true) {
            let 输入框:UITextField = 聊天文字输入框!.textFields!.first! as UITextField
            let 聊天文本:String? = 输入框.text
            if (聊天文本 != nil && 聊天文本 != "") {
                发送消息(聊天文本!)
            }
        } else {
            self.右上按钮?.enabled = true
        }
        聊天文字输入框 = nil
    }
    
    func 转义颜色代码(转义:Bool, 内容:String) -> String {
        if (转义 == true) {
            if (允许转义颜色代码) {
                return 内容.stringByReplacingOccurrencesOfString("&", withString: "§", options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
        } else {
            return 内容.stringByReplacingOccurrencesOfString("§", withString: "&", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        return 内容
    }
    
    func 发送消息(消息:String) {
        右上按钮!.enabled = false
        正在发送的消息 = 转义颜色代码(true,内容: 消息)
        网络模式 = 网络模式选项.提交登录请求
        let 网络参数:String = "j_username=" + 全局_用户名! + "&j_password=" + 全局_密码!
        let 包含参数的网址:String = 动态地图登录接口 + "?" + 网络参数
        let 要加载的网页URL:NSURL = NSURL(string: 包含参数的网址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(URL: 要加载的网页URL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 10)
        网络请求.HTTPMethod = "POST"
        let 上传会话 = NSURLSession.sharedSession()
        let 上传任务 = 上传会话.dataTaskWithRequest(网络请求) {
            (data:NSData?, reponse:NSURLResponse?, error:NSError?) ->Void in
            
            if(error != nil){
                self.网络连接失败(error!.localizedDescription)
            } else{
                let 回应:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                if (回应 == "{\"result\":\"success\"}") {
                    self.网络连接完成()
                } else {
                    self.网络连接失败(回应)
                }
            }
        }
        上传任务.resume()
    }
    
    func 接收数据更新通知() {
        if (全局_综合信息 != nil) {
            实时聊天数据 = 全局_综合信息!["聊天记录"] as? [[String]]
            装入信息()
        }
    }
    
    func 装入信息() {
        if (实时聊天数据 != nil && 实时聊天数据?.count > 0) {
            if (tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.size.height) {
                tableView.reloadData()
                //self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 实时聊天数据!.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
            } else {
                tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
//    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//    }
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (实时聊天数据 == nil || 实时聊天数据?.count == 0) {
            return 1
        }
        return 实时聊天数据!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("chatcell", forIndexPath: indexPath) as! DMChatTCell
        let row = indexPath.row
                //聊天.append([玩家头像,玩家名称,类型,玩家消息])
        if (实时聊天数据 == nil || 实时聊天数据?.count == 0) {
            cell.头像.image = 默认头像
            if (全局_用户名 != nil) {
                cell.内容!.loadHTMLString(合并html("<span>没有数据</span>",内容文本: "暂时还没有人发送消息"), baseURL: nil)
            } else {
                cell.内容!.loadHTMLString(合并html("<span>正在以游客身份登录</span>",内容文本: "没有参与聊天的权限"), baseURL: nil)
            }
        } else {
            let 当前聊天:[String] = 实时聊天数据![row]
            //聊天.append([玩家头像,玩家名称,类型,玩家消息])
//            var 头像文本路径:String = ""
            var 头像相对路径:String = 当前聊天[0]
//            if (头像相对路径 != "") {
//                头像文本路径 = "https://mcmap.90g.org/tiles/faces/32x32/\(当前聊天[0])"
//            } else {
//                头像文本路径 = 默认头像路径
//            }
            if (头像相对路径 != "") {
                头像相对路径 = "https://mcmap.90g.org/tiles/faces/32x32/\(当前聊天[0])"
                cell.头像.setImageWithURL(NSURL(string: 头像相对路径)!, placeholderImage: 默认头像)
            } else {
                //0=游戏内聊天/动态地图，1=上下线消息，2=Telegram/IRC，3=手机
                if (当前聊天[2] == "3") {
                    cell.头像.image = 手机聊天头像
                } else if (当前聊天[2] == "0") {
                    cell.头像.image = 动态地图聊天头像
                } else if (当前聊天[2] == "2") {
                    cell.头像.image = 第三方软件发送头像
                } else {
                    cell.头像.image = 默认头像
                }
            }
            cell.内容!.loadHTMLString(合并html(当前聊天[1],内容文本: 当前聊天[3]), baseURL: nil)
        }
        return cell
    }
    
    func 合并html(名字html:String,内容文本:String) -> String { //头像URL:String,
        //return "<!doctype html><html><head><meta charset=\"UTF-8\"></head><body><table width=\"100%\" border=\"0\"><tbody><tr><td width=\"64\"><img src=\"\(头像URL)\" width=\"64\" height=\"64\" alt=\"\"/></td><td align=\"left\" valign=\"top\">\(名字html)<p><span style=\"color:#FF99CC\">\(内容文本)</span></td></tr></tbody></table></body></html>"
            return "<!doctype html><html><head><meta charset=\"UTF-8\"></head><body><span style=\"color:#FFF\">\(名字html)<p><span style=\"color:#FF99CC\">\(内容文本)</span></body></html>"
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
