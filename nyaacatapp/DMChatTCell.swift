//
//  DMChatTCell.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/21.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import WebKit

class DMChatTCell: UITableViewCell {
    
//    @IBOutlet weak var 头像: UIImageView!
//    @IBOutlet weak var 名字底层: UIView!
//    @IBOutlet weak var 聊天内容: UILabel!
    var 内容:WKWebView? = nil
    let 头像:UIImageView = UIImageView()
    

    override func awakeFromNib() {
        super.awakeFromNib()
//        if (名字底层.subviews.count == 0) {
//            名字.frame = CGRectMake(0, 0, 名字底层.frame.size.width, 名字底层.frame.size.height)
//            名字底层.addSubview(名字)
//        }
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        头像.frame = CGRectMake(11, 11, 48, 48)
        头像.backgroundColor = UIColor.clearColor()
        头像.layer.masksToBounds = true
        头像.layer.cornerRadius = 头像.frame.size.width / 2
        self.addSubview(头像)
        
        let 浏览器设置:WKWebViewConfiguration = WKWebViewConfiguration()
        浏览器设置.allowsPictureInPictureMediaPlayback = false
        浏览器设置.allowsInlineMediaPlayback = false
        浏览器设置.allowsAirPlayForMediaPlayback = false
        浏览器设置.requiresUserActionForMediaPlayback = false
        浏览器设置.suppressesIncrementalRendering = false
        浏览器设置.applicationNameForUserAgent = "yashi_browser"
        let 浏览器偏好设置:WKPreferences = WKPreferences()
        浏览器偏好设置.minimumFontSize = 15.0
        浏览器偏好设置.javaScriptCanOpenWindowsAutomatically = false
        浏览器偏好设置.javaScriptEnabled = false
        浏览器设置.preferences = 浏览器偏好设置
        浏览器设置.selectionGranularity = .Dynamic
        内容 = WKWebView(frame: CGRectMake(头像.frame.origin.x + 头像.frame.size.width, 头像.frame.origin.y, self.frame.size.width - 头像.frame.origin.x*2 - 头像.frame.size.width, self.frame.size.height), configuration: 浏览器设置)
        内容!.backgroundColor = UIColor.clearColor()
        内容!.opaque = false
        内容!.userInteractionEnabled = false
        self.addSubview(内容!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
