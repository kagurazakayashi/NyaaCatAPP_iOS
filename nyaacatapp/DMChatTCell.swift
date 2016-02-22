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
    let 内容:WKWebView = WKWebView()
    let 头像:UIImageView = UIImageView()
    

    override func awakeFromNib() {
        super.awakeFromNib()
//        if (名字底层.subviews.count == 0) {
//            名字.frame = CGRectMake(0, 0, 名字底层.frame.size.width, 名字底层.frame.size.height)
//            名字底层.addSubview(名字)
//        }
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        头像.frame = CGRectMake(11, 11, 48, 48)
        头像.backgroundColor = UIColor.clearColor()
        头像.layer.masksToBounds = true
        头像.layer.cornerRadius = 头像.frame.size.width / 2
        self.addSubview(头像)
        内容.frame = CGRectMake(头像.frame.origin.x + 头像.frame.size.width, 头像.frame.origin.y, self.frame.size.width - 头像.frame.origin.x*2 - 头像.frame.size.width, self.frame.size.height)
        内容.backgroundColor = UIColor.clearColor()
        内容.opaque = false
        内容.userInteractionEnabled = false
        self.addSubview(内容)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
