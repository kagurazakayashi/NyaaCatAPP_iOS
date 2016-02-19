 //
//  main.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/2/11.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import Foundation

print("Hello, World!")

let path = NSBundle.mainBundle().pathForResource("html", ofType: "txt")
var html:String = ""
var contents: String? = nil
 if (path != nil) {
    do {
        contents = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
    } catch _ {
        contents = nil
    }
    if (contents != nil) {
        let dma:DynmapAnalysis = DynmapAnalysis()
        dma.html = contents!
//        dma.取得世界列表()
//        dma.取得弹出提示()
//        dma.取得时间和天气()
////        dma.取得在线玩家()
////        dma.取得当前世界活动玩家状态()
//        dma.取得在线玩家加当前世界活动状态()
        dma.取得当前聊天记录()
////        dma.去除HTML标签(contents!)
    } else {
        print("contents null")
    }
 } else {
    print("path null")
 }