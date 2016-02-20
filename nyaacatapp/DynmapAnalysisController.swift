//
//  DynmapAnalysisController.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/2/20.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class DynmapAnalysisController: NSObject {
    
    var html:String = ""
    var 综合信息:Dictionary<String,NSObject> = Dictionary<String,NSObject>()
    var 开始时间:Double = 0
    var 解析中:Bool = false
    let 数据量:Int = 7
    
    func start() {
        
        if (解析中 == true) {
            NSLog("上次解析未完成")
        } else {
            解析中 = true
            开始时间 = NSDate().timeIntervalSince1970
            NSLog("开始解析...")
            综合信息.removeAll()
            NSThread.detachNewThreadSelector("取得世界列表线程", toTarget: self, withObject: nil)
            NSThread.detachNewThreadSelector("取得弹出提示", toTarget: self, withObject: nil)
            NSThread.detachNewThreadSelector("取得时间和天气", toTarget: self, withObject: nil)
            NSThread.detachNewThreadSelector("取得在线玩家和当前世界活动状态", toTarget: self, withObject: nil)
            NSThread.detachNewThreadSelector("取得当前聊天记录", toTarget: self, withObject: nil)
            NSThread.detachNewThreadSelector("取得商店和地点列表", toTarget: self, withObject: nil)
        }
    }
    
    func 写入综合信息(k:String, v:NSObject) {
        综合信息[k] = v
        NSLog("解析中 \(综合信息.keys.count) / \(数据量)")
        if (综合信息.keys.count == 数据量) {
            解析中 = false
            let 消耗时间:Double = NSDate().timeIntervalSince1970 - 开始时间
            NSLog("解析完成，用时 \(消耗时间)")
        }
    }
    
    /*
    1综合信息["世界列表"] = [String]
    2综合信息["弹出提示"] = [String]
    3综合信息["时间天气"] = [String]
    4综合信息["在线玩家"] = Dictionary<String,[String]>
    5综合信息["聊天记录"] = [[String]]
    6综合信息["商店"] = [String] & 7综合信息["地点"] = [String]
*/
    
    func 取得世界列表线程() {
        let inhtml:String = html
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dma:DynmapAnalysis = DynmapAnalysis()
            dma.html = inhtml
            let 返回值:[String] = dma.取得世界列表()
            dispatch_async(dispatch_get_main_queue(), {
                self.写入综合信息("世界列表",v: 返回值)
            })
        })
    }
    
    func 取得弹出提示() {
        let inhtml:String = html
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dma:DynmapAnalysis = DynmapAnalysis()
            dma.html = inhtml
            let 返回值:[String] = dma.取得弹出提示()
            dispatch_async(dispatch_get_main_queue(), {
                self.写入综合信息("弹出提示",v: 返回值)
            })
        })
    }
    
    func 取得时间和天气() { //[时间字符串,时段,天气]
        let inhtml:String = html
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dma:DynmapAnalysis = DynmapAnalysis()
            dma.html = inhtml
            let 返回值:[String] = dma.取得时间和天气()
            dispatch_async(dispatch_get_main_queue(), {
                self.写入综合信息("时间天气",v: 返回值)
            })
        })
    }
    
    func 取得在线玩家和当前世界活动状态() {
        let inhtml:String = html
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dma:DynmapAnalysis = DynmapAnalysis()
            dma.html = inhtml
            let 返回值:Dictionary<String,[String]> = dma.取得在线玩家和当前世界活动状态()
            dispatch_async(dispatch_get_main_queue(), {
                self.写入综合信息("在线玩家",v: 返回值)
            })
        })
    }
    
    func 取得当前聊天记录() {
        let inhtml:String = html
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dma:DynmapAnalysis = DynmapAnalysis()
            dma.html = inhtml
            let 返回值:[[String]] = dma.取得当前聊天记录()
            dispatch_async(dispatch_get_main_queue(), {
                self.写入综合信息("聊天记录",v: 返回值)
            })
        })
    }
    
    func 取得商店和地点列表() {
        let inhtml:String = html
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let dma:DynmapAnalysis = DynmapAnalysis()
            dma.html = inhtml
            let 返回值:[[[String]]] = dma.取得商店和地点列表()
            dispatch_async(dispatch_get_main_queue(), {
                self.写入综合信息("商店",v: 返回值[0])
                self.写入综合信息("地点",v: 返回值[1])
            })
        })
    }
}
