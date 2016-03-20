//
//  StatusTVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/24.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import WebKit

class StatusTVC: UITableViewController {
    
    var 要呈现的数据:呈现数据 = .玩家列表
    enum 呈现数据 {
        case 玩家列表
        case 城市列表
        case 商店列表
        case 世界列表
    }
    
    let 补偿X轴:Int = 0
    let 补偿Y轴:Int = 0
    var 行主标题:[String]? = nil;
    var 行副标题:[String]? = nil;
    var 图像路径:[String]? = nil;
    var 默认头像:UIImage? = nil;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let 背景图:UIImageView = UIImageView(frame: tableView.frame)
        背景图.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("bg", ofType: "jpg")!)!
        背景图.contentMode = .ScaleAspectFill
        self.tableView.backgroundView = 背景图
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        装入数据()
    }
    
    func 装入数据() {
        行主标题 = Array<String>();
        行副标题 = Array<String>();
        图像路径 = Array<String>();
        if (要呈现的数据 == 呈现数据.玩家列表) {
            self.title = "在线玩家"
            let 在线玩家字典:Dictionary<String,[String]> = 全局_综合信息!["在线玩家"] as! Dictionary<String,[String]>
            let 在线玩家数据:[String] = Array(在线玩家字典.keys)
            for 在线玩家key:String in 在线玩家数据 {
                let 玩家字典:[String] = 在线玩家字典[在线玩家key]!
                图像路径?.append(玩家字典[0])
                let 合并html:String = "<!doctype html><html><head><meta charset=\"UTF-8\"></head><body><font size=\"40\">\(玩家字典[1])</font></body></html>"
                行副标题?.append(合并html)
            }
            行主标题 = 在线玩家数据
//            行副标题 = nil
            默认头像 = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("player_face", ofType: "png")!)!
        } else if (要呈现的数据 == 呈现数据.城市列表) {
            self.title = "坐标列表"
            let 在线城市数据:[[String]] = 全局_综合信息!["地点"] as! [[String]]
            for 在线城市:[String] in 在线城市数据 {
                行主标题?.append(在线城市[0])
                行副标题?.append(坐标修正(在线城市[1]))
            }
            默认头像 = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("home_icon", ofType: "png")!)!
        } else if (要呈现的数据 == 呈现数据.商店列表) {
            self.title = "商店列表"
            let 在线商店数据:[[String]] = 全局_综合信息!["商店"] as! [[String]]
            for 在线商店:[String] in 在线商店数据 {
                行主标题?.append(在线商店[0])
                行副标题?.append(坐标修正(在线商店[1]))
            }
            默认头像 = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("signshop_icon", ofType: "png")!)!
        } else if (要呈现的数据 == 呈现数据.世界列表) {
            self.title = "世界列表"
            let 在线世界数据:[String] = 全局_综合信息!["世界列表"] as! [String]
            行主标题 = 在线世界数据
            行副标题 = nil
            默认头像 = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("follow_on", ofType: "png")!)!
        }
        tableView.reloadData();
    }
    
    func 坐标修正(坐标描述:String) -> String {
        let 坐标数组:[String] = 坐标描述.componentsSeparatedByString(",")
        let x:Int = Int(坐标数组[0])!
        let y:Int = Int(坐标数组[1])!
        //TODO: ======================对坐标进行补偿======================
        
        
        //
        return "坐标 x:\(String(x)) , z:\(String(y))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (行主标题 == nil) {
            return 0
        }
        return 行主标题!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseIdentifier")
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        let 行:Int = indexPath.row
        if (要呈现的数据 == 呈现数据.玩家列表) {
            cell.textLabel?.text = nil
            cell.detailTextLabel?.text = nil
            let 完整路径:String = "\(全局_喵窩API["32px头像接口"]!)\(图像路径![行])"
            cell.imageView?.setImageWithURL(NSURL(string: 完整路径)!, placeholderImage: 默认头像)
            let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
            浏览器设置.allowsPictureInPictureMediaPlayback = false
            浏览器设置.allowsInlineMediaPlayback = false
            浏览器设置.allowsAirPlayForMediaPlayback = false
            浏览器设置.requiresUserActionForMediaPlayback = false
            浏览器设置.suppressesIncrementalRendering = false
            let 浏览器偏好设置:WKPreferences = WKPreferences()
            浏览器偏好设置.minimumFontSize = 40.0
            浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
            浏览器偏好设置.javaScriptEnabled = false
            浏览器设置.preferences = 浏览器偏好设置
            浏览器设置.selectionGranularity = .Dynamic
            let 格式:WKWebView = WKWebView(frame: CGRectMake(50, 10, cell.frame.size.width - 50, cell.frame.size.height - 10), configuration: 浏览器设置)
            格式.backgroundColor = UIColor.clearColor()
            格式.userInteractionEnabled = false
            格式.opaque = false
            cell.addSubview(格式)
            格式.loadHTMLString(行副标题![行], baseURL: nil)
        } else {
            if (行主标题 == nil) {
                cell.textLabel?.text = nil
            } else {
                cell.textLabel?.text = 行主标题![行]
            }
            if (行副标题 == nil) {
                cell.detailTextLabel?.text = nil
            } else {
                cell.detailTextLabel?.text = 行副标题![行]
            }
            cell.imageView?.image = 默认头像
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
