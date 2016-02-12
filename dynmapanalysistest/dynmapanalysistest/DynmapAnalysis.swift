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
        let 起始点到结束点字符串:String = 抽取区间(html, 起始字符串: "<ul class=\"worldlist\"", 结束字符串: "</a></li></ul></li></ul>", 包含起始字符串: true, 包含结束字符串: false)
        let classworld分割:[String] = 起始点到结束点字符串.componentsSeparatedByString("<li class=\"world\">")
        var 世界名称:[String] = Array<String>()
        for (var classworld分割循环 = 1; classworld分割循环 < classworld分割.count; classworld分割循环++) {
            var 当前classworld分割:String = classworld分割[classworld分割循环]
            let 当前地图名称结束位置:Range = 当前classworld分割.rangeOfString("<")!
            当前classworld分割 = 当前classworld分割.substringToIndex(当前地图名称结束位置.startIndex)
            世界名称.append(当前classworld分割)
        }
        NSLog("取得世界名称：\(世界名称)")
        return 世界名称
    }
    
    func 取得在线玩家() {
        let 起始点到结束点字符串:String = 抽取区间(html, 起始字符串: "<ul class=\"playerlist\"", 结束字符串: "</ul><div class=\"scrolldown\"", 包含起始字符串: true, 包含结束字符串: true)
        let li分割:[String] = 起始点到结束点字符串.componentsSeparatedByString("<li class=\"player")
        var 在线玩家头像:[String] = Array<String>()
        var 在线玩家名:[String] = Array<String>()
        var 在线玩家名带字体格式:[String] = Array<String>()
        for (var li分割循环 = 1; li分割循环 < li分割.count; li分割循环++) {
            let 当前li分割:String = li分割[li分割循环]
            let 图片相对路径:String = 抽取区间(当前li分割, 起始字符串: "<img src=\"", 结束字符串: "\"></span><a href=\"#\"", 包含起始字符串: false, 包含结束字符串: false)
            let 图片相对路径分割:[String] = 图片相对路径.componentsSeparatedByString("/")
            let 图片文件名:String = 图片相对路径分割[图片相对路径分割.count-1]
            在线玩家头像.append(图片文件名)
            let 玩家名带格式:String = 抽取区间(当前li分割, 起始字符串: "title=\"Center on player\">", 结束字符串: "</a>", 包含起始字符串: false, 包含结束字符串: false)
            在线玩家名带字体格式.append(玩家名带格式)
            let 玩家名:[String] = 去除HTML标签(玩家名带格式,需要合成: true)
            在线玩家名.append(玩家名[0])
        }
        /*
        使用 在线玩家头像 时应补充：
        let 头像网址:String = "https://mcmap.90g.org/tiles/faces/"
        let 图片补路径:String = 头像网址 + "16x16/" + 在线玩家头像 //支持32x32
        
        使用 在线玩家名带字体格式 时应补充：
        let 网页头:String = "<html><meta http-equiv=Content-Type content=\"text/html;charset=utf-8\"><body>"
        let 网页尾:String = "</body></html>"
        */
        NSLog("在线玩家头像：\(在线玩家头像)")
        NSLog("在线玩家名：\(在线玩家名)")
        NSLog("在线玩家名带字体格式：\(在线玩家名带字体格式)")
        
    }
    
    //抽取区间(<#T##输入字符串: String##String#>, 起始字符串: <#T##String#>, 结束字符串: <#T##String#>, 包含起始字符串: <#T##Bool#>, 包含结束字符串: <#T##Bool#>)
    func 抽取区间(输入字符串:String,起始字符串:String,结束字符串:String,包含起始字符串:Bool,包含结束字符串:Bool) -> String {
        let 起始点位置:Range = 输入字符串.rangeOfString(起始字符串)!
        var 起始点到结束点字符串:String = ""
        if (包含起始字符串 == true) {
            起始点到结束点字符串 = 输入字符串.substringFromIndex(起始点位置.startIndex)
        } else {
            起始点到结束点字符串 = 输入字符串.substringFromIndex(起始点位置.endIndex)
        }
        let 搜索结束点:Range = 起始点到结束点字符串.rangeOfString(结束字符串)!
        if (包含结束字符串 != true) {
            起始点到结束点字符串 = 起始点到结束点字符串.substringToIndex(搜索结束点.startIndex)
        } else {
            起始点到结束点字符串 = 起始点到结束点字符串.substringToIndex(搜索结束点.endIndex)
        }
        return 起始点到结束点字符串
    }
    
    func 取得弹出提示() {
        //<div class="alertbox" style>Could not update map: error</div>
        var 对话框正在被显示:Bool = false
        var 起始点到结束点字符串:String = ""
        let alertbox起始点位置:Range? = html.rangeOfString("<div class=\"alertbox\"")
        if (alertbox起始点位置 != nil) {
            起始点到结束点字符串 = html.substringFromIndex(alertbox起始点位置!.startIndex)
            let 搜索结束点:Range = 起始点到结束点字符串.rangeOfString("</div>")!
            起始点到结束点字符串 = 起始点到结束点字符串.substringToIndex(搜索结束点.startIndex)
            let 检查对话框是否隐藏:Range? = html.rangeOfString("display: none")
            
            if (检查对话框是否隐藏 == nil) { //没有被隐藏
                对话框正在被显示 = true
            }
            let 提示信息起始点位置:Range = 起始点到结束点字符串.rangeOfString(">")!
            起始点到结束点字符串 = 起始点到结束点字符串.substringFromIndex(提示信息起始点位置.endIndex)
        }
        let 弹出提示信息:[NSObject] = [ 对话框正在被显示, 起始点到结束点字符串 ]
        NSLog("弹出提示信息：\(弹出提示信息)")
    }
    
    func 去除HTML标签(输入html:String,需要合成:Bool) -> [String] {
        var 输入参数:String = 输入html
        var 输出参数:[String] = Array<String>()
        let 输入参数分割:[String] = 输入参数.componentsSeparatedByString("<")
        for (var 输入参数分割循环 = 0; 输入参数分割循环 < 输入参数分割.count; 输入参数分割循环++) {
            let 当前输入参数分割:String = 输入参数分割[输入参数分割循环]
            let 文本内容起始点位置:Range? = 当前输入参数分割.rangeOfString(">")
            if (文本内容起始点位置 != nil) {
                let 文本内容:String = 当前输入参数分割.substringFromIndex(文本内容起始点位置!.endIndex)
                if (文本内容 != "") {
                    输出参数.append(文本内容)
                    //NSLog("\(文本内容)")
                }
            }
        }
        //NSLog("文本内容：\(输出参数)")
        if (需要合成 == true) {
            let 合成文本 = 输出参数.joinWithSeparator("")
            return [合成文本]
        }
        return 输出参数
    }
    
    /*
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
    */
}
