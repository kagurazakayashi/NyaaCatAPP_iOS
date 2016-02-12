//
//  DynmapAnalysis.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/2/11.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import Cocoa

class DynmapAnalysis: NSObject {
    
    var html:String = ""
    var 提取信息:NSMutableDictionary = NSMutableDictionary()

    func 取得世界列表() -> [String] {
        let worldlist起始点位置:Range = html.rangeOfString("<ul class=\"worldlist\"")!
        var 起始点到结束点字符串:String = html.substringFromIndex(worldlist起始点位置.startIndex)
        let 搜索结束点:Range = 起始点到结束点字符串.rangeOfString("</a></li></ul></li></ul>")!
        起始点到结束点字符串 = 起始点到结束点字符串.substringToIndex(搜索结束点.endIndex)
        let classworld分割:[String] = 起始点到结束点字符串.componentsSeparatedByString("<li class=\"world\">")
        var 世界名称:[String] = Array<String>()
        for (var i = 1; i < classworld分割.count; i++) {
            var 当前classworld分割:String = classworld分割[i]
            let 当前地图名称结束位置:Range = 当前classworld分割.rangeOfString("<")!
            当前classworld分割 = 当前classworld分割.substringToIndex(当前地图名称结束位置.startIndex)
            世界名称.append(当前classworld分割)
        }
        NSLog("取得世界名称：\(世界名称)")
        return 世界名称
    }
    
    func 取得弹出提示() {
        //<div class="alertbox" style>Could not update map: error</div>
        let alertbox起始点位置:Range? = html.rangeOfString("<div class=\"alertbox\"")
        if (alertbox起始点位置 != nil) {
            var 起始点到结束点字符串:String = html.substringFromIndex(alertbox起始点位置!.startIndex)
            let 搜索结束点:Range = 起始点到结束点字符串.rangeOfString("</div>")!
            起始点到结束点字符串 = 起始点到结束点字符串.substringToIndex(搜索结束点.startIndex)
            let 检查对话框是否隐藏:Range? = html.rangeOfString("display: none")
            var 对话框正在被显示:Bool = false
            if (检查对话框是否隐藏 == nil) { //没有被隐藏
                对话框正在被显示 = true
            }
            let 提示信息起始点位置:Range = 起始点到结束点字符串.rangeOfString(">")!
            起始点到结束点字符串 = 起始点到结束点字符串.substringFromIndex(提示信息起始点位置.endIndex)
            let 弹出提示信息:[NSObject] = [ 对话框正在被显示, 起始点到结束点字符串 ]
            NSLog("弹出提示信息：\(弹出提示信息)")
            //let classworld分割:[String] = 起始点到结束点字符串.componentsSeparatedByString("<li class=\"world\">")
        }
    }
    
    func 去除HTML标签(输入html:String) -> String {
        var 输入参数:String = 输入html
        let 扫描器:NSScanner = NSScanner(string: 输入参数)
        var 纯文本:NSString? = nil
        while(扫描器.atEnd == false) {
            扫描器.scanUpToString("<", intoString: nil) //找到标签的起始位置
            扫描器.scanUpToString(">", intoString: &纯文本) //找到标签的结束位置
            输入参数 = 输入参数.stringByReplacingOccurrencesOfString("\(纯文本)>", withString: "")
        }
        return 输入参数
    }
    
}
