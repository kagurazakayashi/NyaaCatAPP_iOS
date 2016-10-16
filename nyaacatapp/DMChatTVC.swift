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
    
    let 允许转义颜色代码:Bool = false //true: 将&视为颜色代码
    
    var 实时聊天数据:[[String]]? = nil
    var 默认头像:UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "seting-icon", ofType: "png")!)!
    var 第三方软件发送头像:UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "t_logo", ofType: "png")!)!
    var 动态地图聊天头像:UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "msg-icon", ofType: "png")!)!
    var 手机聊天头像:UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "mobile-2-icon", ofType: "png")!)!
    var 服务器消息头像:UIImage = UIImage(contentsOfFile: Bundle.main.path(forResource: "cloud-icon", ofType: "png")!)!
    var 左上按钮:UIBarButtonItem? = nil
    var 右上按钮:UIBarButtonItem? = nil
    var 聊天文字输入框:UIAlertController? = nil
//    var 后台网页加载器:WKWebView? = nil
    var 正在发送的消息:String? = nil
    var 网络模式:网络模式选项 = 网络模式选项.提交登录请求
    var 首次更新数据:Bool = true
    var 空白提示信息:UILabel? = nil
    var 已读聊天数据:Int = 0
    
    enum 网络模式选项 {
        case 提交登录请求
        case 发送聊天消息
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let 背景图:UIImageView = UIImageView(frame: tableView.frame)
        背景图.image = UIImage(contentsOfFile: Bundle.main.path(forResource: "bg", ofType: "jpg")!)!
        背景图.contentMode = .scaleAspectFill
//        self.tableView.insertSubview(背景图, atIndex: 0)
        self.tableView.backgroundView = 背景图
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(DMChatTVC.接收数据更新通知), name: Notification.Name("data"), object: nil)
        
//        初始化WebView()
        
        左上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(DMChatTVC.左上按钮点击))
        navigationItem.leftBarButtonItem = 左上按钮
        右上按钮 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(DMChatTVC.右上按钮点击))
        navigationItem.rightBarButtonItem = 右上按钮
        
        左上按钮?.isEnabled = false
        右上按钮?.isEnabled = false
        
        空白提示信息 = UILabel(frame: CGRect(x: 0, y: 0-(self.navigationController?.navigationBar.frame.size.height)!, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
        空白提示信息!.backgroundColor = UIColor.clear
        空白提示信息!.textColor = UIColor.white
        空白提示信息!.textAlignment = .center
        空白提示信息!.text = "正在连接聊天服务器"
        self.view.addSubview(空白提示信息!)
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
        浏览器设置.selectionGranularity = .dynamic
        
//        后台网页加载器 = WKWebView(frame: CGRectMake(0, 0, 300, 300), configuration: 浏览器设置)
//        后台网页加载器?.alpha = 0.5
//        后台网页加载器?.userInteractionEnabled = false
//        self.view.addSubview(后台网页加载器!)
//        后台网页加载器!.navigationDelegate = self
        
        //        后台网页加载器!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        //        后台网页加载器!.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        网络连接完成()
    }
    
    func 网络连接完成() {
        if (网络模式 == 网络模式选项.提交登录请求) {
            网络模式 = 网络模式选项.发送聊天消息
            //向服务器提交聊天消息
            let 网络参数:NSString = "{\"name\":\"\",\"message\":\"§2" + 全局_手机发送消息关键字 + "§f" + 正在发送的消息! + "\"}" as NSString
            let 要加载的网页URL:URL = URL(string: 全局_喵窩API["消息发送接口"]!)!
            let 网络请求:NSMutableURLRequest = NSMutableURLRequest(url: 要加载的网页URL, cachePolicy: 全局_缓存策略, timeoutInterval: 30)
            let 网络参数数据:Data = 网络参数.data(using: String.Encoding.utf8.rawValue)!
            网络请求.httpMethod = "POST"
            //§2[NyaaCatAPP] §fThis is a test message.
            //[urlRequest setValue: [NSString stringWithFormat:@"%@\r\n", @"http://XXXXXX HTTP/1.1"]];
            //application/json , application/x-www-data-urlencoded
            网络请求.setValue("application/json, text/javascript, */*; q=0.01", forHTTPHeaderField: "accept")
            网络请求.setValue("gzip, deflate", forHTTPHeaderField: "accept-encoding")
            网络请求.setValue("zh-CN,zh;q=0.8,en;q=0.6,ja;q=0.4", forHTTPHeaderField: "accept-language")
            网络请求.setValue("\(网络参数数据.count)", forHTTPHeaderField: "content-length")
            网络请求.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "content-type")
            网络请求.setValue("1", forHTTPHeaderField: "dnt")
            网络请求.setValue(全局_喵窩API["动态地图域名"], forHTTPHeaderField: "origin")
            网络请求.setValue(全局_喵窩API["动态地图主页"], forHTTPHeaderField: "referer")
            网络请求.setValue("XMLHttpRequest", forHTTPHeaderField: "x-requested-with")
            //网络请求.HTTPBody = 网络参数数据
            //            后台网页加载器!.loadRequest(网络请求)
            let 上传会话 = URLSession.shared
            let 上传任务 = 上传会话.uploadTask(with: 网络请求 as URLRequest, from: 网络参数数据){
                (data:Data?, reponse:URLResponse?, error:Error?) ->Void in
                
                if(error != nil){
                    self.网络连接失败(error!.localizedDescription)
                } else{
                    let 回应:String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                    if (回应 == "{\"error\":\"none\"}") {
                        self.右上按钮?.isEnabled = true
                        self.网络连接完成()
                    } else {
                        self.网络连接失败(回应)
                    }
                }
            }
            上传任务.resume()
            
        } else {
            右上按钮!.isEnabled = true
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        网络连接失败(error.localizedDescription)
    }
    
    func 网络连接失败(_ 错误描述:String) {
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
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadwebview"), object: nil)
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
    
    func 打开发送消息框(_ 重试消息:String?,错误描述:String?) {
        var 标题:String = "输入聊天信息"
        var 内容:String? = nil
        if (错误描述 != nil) {
            内容 = "回复给 \(错误描述!): "
        }
        if (重试消息 != nil) {
            标题 = "消息发送失败"
            内容 = 错误描述
        }
        聊天文字输入框 = UIAlertController(title: 标题, message: 内容, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (动作:UIAlertAction) -> Void in
            self.提示框处理(false)
        })
        let okAction = UIAlertAction(title: "发送", style: UIAlertActionStyle.default, handler: { (动作:UIAlertAction) -> Void in
            self.提示框处理(true)
        })
        聊天文字输入框!.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "请在此输入要发送的内容"
            textField.text = 重试消息
        }
        聊天文字输入框!.addAction(cancelAction)
        聊天文字输入框!.addAction(okAction)
        self.present(聊天文字输入框!, animated: true, completion: nil)
    }
    
    func 提示框处理(_ 确定:Bool) {
        if (确定 == true) {
            let 输入框:UITextField = 聊天文字输入框!.textFields!.first! as UITextField
            var 聊天文本:String? = 输入框.text
            if (聊天文本 != nil && 聊天文本 != "") {
                if (聊天文字输入框!.message != nil && 聊天文字输入框!.message != "") {
                    聊天文本 = 聊天文字输入框!.message! + 聊天文本!
                }
                发送消息(聊天文本!)
            }
        } else {
            self.右上按钮?.isEnabled = true
        }
        聊天文字输入框 = nil
    }
    
    func 转义颜色代码(_ 转义:Bool, 内容:String) -> String {
        if (转义 == true) {
            if (允许转义颜色代码) {
                return 内容.replacingOccurrences(of: "&", with: "§", options: NSString.CompareOptions.literal, range: nil)
            }
        } else {
            return 内容.replacingOccurrences(of: "§", with: "&", options: NSString.CompareOptions.literal, range: nil)
        }
        return 内容
    }
    
    func 发送消息(_ 消息:String) {
        右上按钮!.isEnabled = false
        正在发送的消息 = 转义颜色代码(true,内容: 消息)
        网络模式 = 网络模式选项.提交登录请求
        let 网络参数:String = "j_username=" + 全局_用户名! + "&j_password=" + 全局_密码!
        let 包含参数的网址:String = 全局_喵窩API["动态地图登录接口"]! + "?" + 网络参数
        let 要加载的网页URL:URL = URL(string: 包含参数的网址)!
        let 网络请求:NSMutableURLRequest = NSMutableURLRequest(url: 要加载的网页URL, cachePolicy: 全局_缓存策略, timeoutInterval: 10)
        网络请求.httpMethod = "POST"
        let 上传会话 = URLSession.shared
        let 上传任务 = 上传会话.dataTask(with: 网络请求 as URLRequest) { (data:Data?, reponse:URLResponse?, error:Error?) in
            do {
                if(error != nil) {
                    self.网络连接失败(error!.localizedDescription)
                } else {
                    let 回应:String = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as! String
                    if (回应 == "{\"result\":\"success\"}") {
                        self.网络连接完成()
                    } else {
                        self.网络连接失败(回应)
                    }
                }
            }
        }
        上传任务.resume()
    }
    
    func 接收数据更新通知() {
        if (首次更新数据 == true) {
            首次更新数据 = false
            空白提示信息?.removeFromSuperview()
            空白提示信息 = nil
            if (全局_用户名 != nil && 左上按钮?.isEnabled == false) {
                左上按钮?.isEnabled = true
                右上按钮?.isEnabled = true
            }
            tableView.reloadData()
        }
        if (全局_综合信息 != nil) {
            实时聊天数据 = 全局_综合信息!["聊天记录"] as? [[String]]
            //显示消息数量
            let 当前选项卡按钮:UITabBarItem = self.tabBarController!.tabBar.items![1]
            当前选项卡按钮.badgeValue = String(实时聊天数据!.count)
            装入信息()
        }
    }
    
    func 装入信息() {
        if (实时聊天数据 != nil && (实时聊天数据?.count)! > 0) {
            if (tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.size.height) {
                tableView.reloadData()
                //self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
                self.tableView.scrollToRow(at: IndexPath(row: 实时聊天数据!.count-1, section: 0), at: .bottom, animated: true)
            } else {
                tableView.reloadData()
            }
        } else {
            tableView.reloadData()
        }
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        全局_调整计时器延迟(10,外接电源时: 10) //列表被拖动时
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        全局_调整计时器延迟(3,外接电源时: 1) //列表拖动结束时
    }
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
    override func viewDidAppear(_ animated: Bool) {
        全局_调整计时器延迟(3,外接电源时: 1) //进入页面时
    }
    override func viewDidDisappear(_ animated: Bool) {
        全局_调整计时器延迟(10,外接电源时: 1) //退出页面时
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (首次更新数据 == true) {
            return 0
        }
        if (实时聊天数据 == nil || 实时聊天数据?.count == 0) {
            return 1
        }
        return 实时聊天数据!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! DMChatTCell
        let row = (indexPath as NSIndexPath).row
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
//                头像文本路径 = "https://map.nyaa.cat/tiles/faces/32x32/\(当前聊天[0])"
//            } else {
//                头像文本路径 = 默认头像路径
//            }
            if (头像相对路径 != "") {
                头像相对路径 = "\(全局_喵窩API["32px头像接口"]!)\(当前聊天[0])"
                cell.头像.setImageWith(URL(string: 头像相对路径)!, placeholderImage: 默认头像)
            } else {
                //0=游戏内聊天/动态地图，1=上下线消息，2=Telegram/IRC，3=手机
                if (当前聊天[1] == " Server: ") {
                    cell.头像.image = 服务器消息头像
                } else if (当前聊天[2] == "3") {
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
    
    func 合并html(_ 名字html:String,内容文本:String) -> String { //头像URL:String,
        //return "<!doctype html><html><head><meta charset=\"UTF-8\"></head><body><table width=\"100%\" border=\"0\"><tbody><tr><td width=\"64\"><img src=\"\(头像URL)\" width=\"64\" height=\"64\" alt=\"\"/></td><td align=\"left\" valign=\"top\">\(名字html)<p><span style=\"color:#FF99CC\">\(内容文本)</span></td></tr></tbody></table></body></html>"
            return "<!doctype html><html><head><meta charset=\"UTF-8\"></head><body><font size=\"40\"><span style=\"color:#FFF;\">\(名字html)<p><span style=\"color:#FF99CC;\">\(内容文本)</span></font></body></html>"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (全局_用户名 != nil && 实时聊天数据 != nil && (实时聊天数据?.count)! > indexPath.row) {
            let 当前聊天:[String] = 实时聊天数据![indexPath.row]
            let 转换器:Analysis = Analysis()
            let 用户名单数组:[String] = 转换器.去除HTML标签(当前聊天[1], 需要合成: true)
            let 用户名文本:String = 用户名单数组[0]
            打开发送消息框(nil,错误描述: 用户名文本)
        } else {
            //正在以游客身份登录，没有参与聊天的权限
        }
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
