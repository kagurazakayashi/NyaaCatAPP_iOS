//
//  WikiAnalysis.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/3/26.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class WikiAnalysis: NSObject {
    
    var html:String? = nil
    var 解析:Analysis = Analysis()
    let 页面特征:String = "[Nyaa Wiki]"
    
    func 有效性校验() -> Bool {
        if (html?.range(of: 页面特征) != nil) {
            return true
        }
        return false
    }
    
    func 维基主菜单() -> [[String]] {
        var 主菜单:[[String]] = [[String()]]
        let 主菜单区间:String = 解析.抽取区间(html!, 起始字符串: "<!-- ********** ASIDE ********** -->", 结束字符串: "<!-- /aside -->", 包含起始字符串: false, 包含结束字符串: false)
        let 主菜单分割:[String] = 主菜单区间.components(separatedBy: "<li ")
        for 当前主菜单分割:String in 主菜单分割 {
            if (当前主菜单分割.characters.count > 10) {
                let 超链接:String = 解析.抽取区间(当前主菜单分割, 起始字符串: "<a href=\"", 结束字符串: "\"", 包含起始字符串: false, 包含结束字符串: false)
                let 名称串:String = 解析.抽取区间(当前主菜单分割, 起始字符串: "title=\"", 结束字符串: "</a>", 包含起始字符串: false, 包含结束字符串: true)
                let 名称:String = 解析.抽取区间(名称串, 起始字符串: ">", 结束字符串: "</a>", 包含起始字符串: false, 包含结束字符串: false)
                var 缩进:String = 解析.抽取区间(当前主菜单分割, 起始字符串: "class=\"level", 结束字符串: "\">", 包含起始字符串: false, 包含结束字符串: false)
                let 缩进分割:[String] = 缩进.components(separatedBy: " ")
                if (缩进分割.count > 0) {
                    缩进 = 缩进分割[0]
                }
                /*
                if (缩进.characters.count > 0) {
                    let 缩进量:Int = Int(缩进)! - 1
                    var 空格:String = ""
                    for i in 0...缩进量 {
                        if (i > 0) {
                            空格 = "　" + 空格
                        }
                    }
                    名称 = 空格 + 名称 //空格 + "·" + 名称
                }
 */
                if (名称.characters.count > 0 && 超链接.characters.count > 0) {
                    let 当前菜单项:[String] = [名称,超链接,缩进]
                    主菜单.append(当前菜单项)
                    //print("\(缩进) \(名称) (\(超链接))")
                }
            }
        }
        return 主菜单
    }
    
    func 维基内容(_ 域名:String) -> String {
        var 内容区间:String = 解析.抽取区间(html!, 起始字符串: "<!-- wikipage start -->", 结束字符串: "<!-- wikipage stop -->", 包含起始字符串: false, 包含结束字符串: false)
        if (内容区间.characters.count == 0) {
            内容区间 = "未能读取这个维基页面。"
        } else {
            //var filtered = url.stringByReplacingOccurrencesOfString("/", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            内容区间 = 内容区间.replacingOccurrences(of: "<a href=\"/", with: "<a href=\"\(域名)/", options: NSString.CompareOptions.literal, range: nil)
        }
        let 返回网页:String = "<!DOCTYPE html><html lang=\"zh\" dir=\"ltr\" class=\"no-js\"><head><meta charset=\"utf-8\" /><title>wikipage</title></head><body>\(内容区间)</body></html>"
        //print(返回网页)
        return 返回网页
    }
}
