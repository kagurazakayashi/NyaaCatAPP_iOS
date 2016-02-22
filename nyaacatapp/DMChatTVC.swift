//
//  DMChatTVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/21.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class DMChatTVC: UITableViewController {
    
    var 实时聊天数据:[[String]]? = nil
    var 默认头像:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("seting-icon", ofType: "png")!)!
    var 第三方软件发送头像:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("t_logo", ofType: "png")!)!
    var 动态地图聊天头像:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("msg-icon", ofType: "png")!)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let 背景图:UIImageView = UIImageView(frame: tableView.frame)
        背景图.image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("bg", ofType: "jpg")!)!
        背景图.contentMode = .ScaleAspectFill
//        self.tableView.insertSubview(背景图, atIndex: 0)
        self.tableView.backgroundView = 背景图
        self.tableView.backgroundColor = UIColor.clearColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "接收数据更新通知", name: "data", object: nil)
    }
    
    func 接收数据更新通知() {
        if (全局_综合信息 != nil) {
            实时聊天数据 = 全局_综合信息!["聊天记录"] as? [[String]]
            tableView.reloadData()
        }
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
            cell.内容.loadHTMLString(合并html("<span style=\"color:#FF99CC\">没有数据</span>",内容文本: "暂时还没有人发送消息"), baseURL: nil)
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
                //0=游戏内聊天/动态地图，1=上下线消息，2=Telegram/IRC
                if (当前聊天[2] == "0") {
                    cell.头像.image = 动态地图聊天头像
                } else if (当前聊天[2] == "2") {
                    cell.头像.image = 第三方软件发送头像
                } else {
                    cell.头像.image = 默认头像
                }
            }
            cell.内容.loadHTMLString(合并html(当前聊天[1],内容文本: 当前聊天[3]), baseURL: nil)
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
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
