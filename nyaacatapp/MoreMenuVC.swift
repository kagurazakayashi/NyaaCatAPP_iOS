//
//  MoreMenuVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/12.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class MoreMenuVC: UIViewController, MoreMenuCellViewDelegate {
    
    var TAG组:Int = 0
    let 按钮文本和对应图片:[[String]] = [["活动信息","rss-icon"],["喵窩维基","notebook-icon"],["游戏录像","video-icon"],["游戏直播","tv-icon"],["官方网站","lcd-icon"],["G+社群","GooglePlus-logos-02"],["开源项目","calculator-icon"],["封禁查询","mike-icon"],["关于反馈","msg-icon"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        加载UI()
    }
    override func viewWillDisappear(animated: Bool) {
        卸载UI()
    }
    
    func 加载UI() {
        let 上栏高度 = navigationController!.navigationBar.frame.size.height + 20
        let 下栏高度 = tabBarController!.tabBar.frame.size.height
        let 底栏:UIView = UIView(frame: CGRectMake(0, 上栏高度, view.frame.size.width, view.frame.size.height-上栏高度-下栏高度))
        底栏.alpha = 0
        let 按钮尺寸:CGSize =  CGSizeMake(底栏.frame.size.width/3, 底栏.frame.size.height/3)
        let 每行列数:CGFloat = 2
        var 列:CGFloat = 0
        var 行:CGFloat = 0
        for 序号:Int in 0...按钮文本和对应图片.count-1 {
            let 当前按钮位置:CGRect = CGRectMake(按钮尺寸.width*列, 按钮尺寸.height*行, 按钮尺寸.width, 按钮尺寸.height)
            let 当前按钮显示:[String] = 按钮文本和对应图片[序号]
            let 当前按钮:MoreMenuCellView = MoreMenuCellView(frame: 当前按钮位置)
            当前按钮.设置内容(当前按钮显示[0], 图片文件名: 当前按钮显示[1])
            TAG组++
            当前按钮.tag = TAG组
            当前按钮.代理 = self
            底栏.addSubview(当前按钮)
            列++
            if (列 > 每行列数) {
                列 = 0
                行++
            }
        }
        底栏.tag = 0
        view.addSubview(底栏)
        UIView.animateWithDuration(0.5) { () -> Void in
            底栏.alpha = 1
        }
    }
    
    func 卸载UI() {
        self.view.viewWithTag(0)?.removeFromSuperview()
        for nowTag:Int in 1...TAG组 {
            let nowView:UIView? = self.view.viewWithTag(nowTag)
            if (nowView != nil) {
                let now:MoreMenuCellView = nowView as! MoreMenuCellView
                now.卸载()
            } else {
                NSLog("release err")
            }
        }
        TAG组 = 0
    }
    
    func 点击图标(按钮tag:Int) {
        let 当前选择:[String] = 按钮文本和对应图片[按钮tag-1]
        NSLog("%@", 当前选择[0])
    }
    
    override func viewDidAppear(animated: Bool) {
        //底栏.alpha = 0
        
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
