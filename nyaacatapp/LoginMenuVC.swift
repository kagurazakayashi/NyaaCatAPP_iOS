//
//  LoginMenuVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/10.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

protocol LoginMenuVCDelegate {
    func 返回登录请求(用户名:String?,密码:String?)
    func 弹出代理提示框(提示框:UIAlertController)
}

class LoginMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var 选项表格: UITableView!
    var 行标题 = ["用户名：","密码：","记住用户名和密码","登录","","我还没注册过动态地图","我还没有入服","游客登录"]
    var 提示框:UIAlertController? = nil
    var 用户名:String = 全局_喵窩API["测试动态地图用户名"]!
    var 密码:String = 全局_喵窩API["测试动态地图密码"]!
    var 记住用户名和密码:Bool = false
    var 代理:LoginMenuVCDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        选项表格.backgroundColor = UIColor.clearColor()
        选项表格.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        选项表格.separatorColor = UIColor.clearColor()
        选项表格.delegate = self
        选项表格.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 行标题.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let 单元格ID:String = "Cell"
        let 行数:Int = indexPath.row
        var 单元格:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(单元格ID)
        if(单元格 == nil) {
            单元格 = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: 单元格ID)
            单元格?.backgroundColor = UIColor.clearColor()
            单元格?.detailTextLabel?.textColor = UIColor.lightGrayColor()
        }
        if(行数 == 3) {
            单元格?.textLabel?.textColor = UIColor.redColor()
            单元格?.frame = CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)
            单元格?.textLabel?.frame = 单元格!.frame
            
            单元格?.textLabel?.textAlignment = NSTextAlignment.Center
        } else {
            单元格?.textLabel?.textColor = UIColor.whiteColor()
            单元格?.textLabel?.textAlignment = NSTextAlignment.Left
        }
        if (行数 == 0) {
            单元格?.textLabel?.text = 行标题[行数] + 用户名
        } else if (行数 == 1) {
            var 隐藏密码:String = ""
            for _ in 0 ..< 密码.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) {
                隐藏密码 += "*"
            }
            单元格?.textLabel?.text = 行标题[行数] + 隐藏密码
        } else if (行数 == 2) {
            if (记住用户名和密码 == false) {
                单元格?.textLabel?.text = 行标题[行数] + " OFF";
            } else {
                单元格?.textLabel?.text = 行标题[行数] + " ON";
            }
        } else {
            单元格?.textLabel?.text = 行标题[行数]
        }
        //单元格?.detailTextLabel?.text = "1234567890"
        return 单元格!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let 行数:Int = indexPath.row
        if (行数 < 2) {
            提示框 = UIAlertController(title: "请输入用户名和密码", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: { (动作:UIAlertAction) -> Void in
                self.提示框处理(false)
            })
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: { (动作:UIAlertAction) -> Void in
                self.提示框处理(true)
            })
            提示框!.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
                textField.placeholder = "用户名"
                textField.text = self.用户名
            }
            提示框!.addTextFieldWithConfigurationHandler {
                (textField: UITextField!) -> Void in
                textField.placeholder = "密码"
                textField.secureTextEntry = true
                textField.text = self.密码
            }
            提示框!.addAction(okAction)
            提示框!.addAction(cancelAction)
            代理?.弹出代理提示框(提示框!)
        } else if (行数 == 2) {
            记住用户名和密码 = !记住用户名和密码
            选项表格.reloadData()
        } else if (行数 == 3) {
            代理?.返回登录请求(用户名, 密码: 密码)
        } else if (行数 == 7) {
            代理?.返回登录请求(nil, 密码: nil)
        }
    }
    
    func 提示框处理(确定:Bool) {
        if (确定 == true) {
            let 用户名输入框:UITextField = 提示框!.textFields!.first! as UITextField
            let 密码输入框:UITextField = 提示框!.textFields!.last! as UITextField
            用户名 = 用户名输入框.text!
            密码 = 密码输入框.text!
            选项表格.reloadData()
            
        }
        提示框 = nil
    }
    
    func 进入动画(目标位置:CGRect) {
        self.view.frame = CGRectMake(目标位置.origin.x + 目标位置.size.width, 目标位置.origin.y, 目标位置.size.width, 目标位置.size.height)
        self.view.alpha = 0
        UIView.animateWithDuration(0.6) { () -> Void in
            self.view.alpha = 1
            self.view.frame = CGRectMake(目标位置.origin.x, 目标位置.origin.y, 目标位置.size.width, 目标位置.size.height)
        }
    }
    func 退出动画() {
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.view.alpha = 0
            self.view.frame = CGRectMake(self.view.frame.origin.x - self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)
            }) { (ani:Bool) -> Void in
                self.view.removeFromSuperview()
        }
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
