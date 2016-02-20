//
//  DMChatNC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/20.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class DMChatNC: UINavigationController {

    override func viewDidLoad() {
//        let 导航栏背景:UIView = UIView(frame: CGRectMake(0,-20,navigationBar.frame.size.width,navigationBar.frame.size.height+20))
//        导航栏背景.backgroundColor = 全局_导航栏颜色
//        navigationBar.insertSubview(导航栏背景, atIndex: 1)
        navigationBar.barTintColor = 全局_导航栏颜色
        navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
}
