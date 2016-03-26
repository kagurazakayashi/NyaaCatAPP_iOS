//
//  WikiAnalysis.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/3/26.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import Cocoa

class WikiAnalysis: NSObject {
    
    var html:String? = nil
    var 解析:Analysis = Analysis()
    let 页面特征:String = "[Nyaa Wiki]"
    
    func 有效性校验() -> Bool {
        if (html?.rangeOfString(页面特征) != nil) {
            return true
        }
        return false
    }
    
    func 维基主菜单() -> [[String]]? {
        var 主菜单:[[String]] = [[String()]]
        let 主菜单区间:String = 解析.抽取区间(html!, 起始字符串: "<!-- ********** ASIDE ********** -->", 结束字符串: "<!-- /aside -->", 包含起始字符串: false, 包含结束字符串: false)
        let 主菜单分割:[String] = 主菜单区间.componentsSeparatedByString("<li ")
        for 当前主菜单分割:String in 主菜单分割 {
            if (当前主菜单分割.characters.count > 10) {
                let 超链接:String = 解析.抽取区间(当前主菜单分割, 起始字符串: "<a href=\"", 结束字符串: "\"", 包含起始字符串: false, 包含结束字符串: false)
                let 名称串:String = 解析.抽取区间(当前主菜单分割, 起始字符串: "title=\"", 结束字符串: "</a>", 包含起始字符串: false, 包含结束字符串: true)
                var 名称:String = 解析.抽取区间(名称串, 起始字符串: ">", 结束字符串: "</a>", 包含起始字符串: false, 包含结束字符串: false)
                var 缩进:String = 解析.抽取区间(当前主菜单分割, 起始字符串: "class=\"level", 结束字符串: "\">", 包含起始字符串: false, 包含结束字符串: false)
                let 缩进分割:[String] = 缩进.componentsSeparatedByString(" ")
                if (缩进分割.count > 0) {
                    缩进 = 缩进分割[0]
                }
                if (缩进.characters.count > 0) {
                    let 缩进量:Int = Int(缩进)! - 1
                    for i in 0...缩进量 {
                        if (i > 0) {
                            名称 = "　" + 名称
                        }
                    }
                }
                NSLog(名称)
                let 当前菜单项:[String] = [名称,缩进,超链接]
                主菜单.append(当前菜单项)
            }
        }
        return 主菜单
    }
}
