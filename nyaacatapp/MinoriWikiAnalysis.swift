//
//  MinoriWikiAnalysis.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/4/3.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class MinoriWikiAnalysis: NSObject {
    var html:String? = nil
    var 解析:Analysis = Analysis()
    let 页面特征:String = "powered by MinoriWiki"
    
    func 有效性校验() -> Bool {
        if (html?.rangeOfString(页面特征) != nil) {
            return true
        }
        return false
    }
    
    func 获取主菜单() -> Dictionary<String,[[String]]> {
        var 主菜单:Dictionary<String,[[String]]> = Dictionary<String,[[String]]>()
        let 主菜单区间:String = 解析.抽取区间(html!, 起始字符串: "<h3>", 结束字符串: "footer-text", 包含起始字符串: false, 包含结束字符串: false)
        let 分类区间:[String] = 主菜单区间.componentsSeparatedByString("<h3>")
        for 当前分类区间:String in 分类区间 {
            let 分类内容组:[String] = 当前分类区间.componentsSeparatedByString("</h3>")
            if (分类内容组.count == 2) {
                let 分类名称:String = 分类内容组[0]
                if (分类名称 != "API") {
                    let 分类内容:String = 分类内容组[1]
                    let 子菜单项:[[String]] = 获取子菜单(分类内容)
                    主菜单[分类名称] = 子菜单项
                }
            }
        }
        return 主菜单
    }
    
    func 获取子菜单(子html:String) -> [[String]] {
        var 子菜单项:[[String]] = [[String]]()
        let 子菜单:[String] = 子html.componentsSeparatedByString("<li>")
        for 当前子菜单:String in 子菜单 {
            let 超链接区间:String = 解析.抽取区间(当前子菜单, 起始字符串: "<a href=\"", 结束字符串: "</a>", 包含起始字符串: false, 包含结束字符串: false)
            let 超链接信息:[String] = 超链接区间.componentsSeparatedByString("\" target=\"_self\">")
            if (超链接信息.count == 2) {
                let 链接:String = 超链接信息[0]
                let 文字:String = 超链接信息[1]
                let 超链接:[String] = [文字, 链接]
                子菜单项.append(超链接)
            }
        }
        return 子菜单项
    }
}
