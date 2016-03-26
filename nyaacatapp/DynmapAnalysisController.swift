//
//  DynmapAnalysisController.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/2/20.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

//protocol DynmapAnalysisControllerDelegate {
//    func 解析完成(综合信息:Dictionary<String,NSObject>?,信息数据量:Dictionary<String,Int>?)
//}

class DynmapAnalysisController: NSObject {
    
//    var delegate:DynmapAnalysisControllerDelegate?
    var html:String? = nil
    var 综合信息:Dictionary<String,NSObject>? = nil
    var 信息数据量:Dictionary<String,Int>? = nil
    var 开始时间:Double = 0
    var 解析中:Bool = false
    let 数据量:Int = 7
    let 数据名:[String] = ["世界列表","弹出提示","时间天气","在线玩家","聊天记录","商店","地点"] //,"log"
    /*
    1综合信息["世界列表"] = [String]
    2综合信息["弹出提示"] = [String]
    3综合信息["时间天气"] = [String]
    4综合信息["在线玩家"] = Dictionary<String,[String]>
    5综合信息["聊天记录"] = [[String]]
    6综合信息["商店"] = [String] & 7综合信息["地点"] = [String]
    */
    
//    var 解析线程:[NSThread] = Array<NSThread>()
    
    deinit {
        if (解析中 == true) {
            NSLog("错误：在解析完成前析构了解析器")
        }
    }
    
    func start() {
        
        if (解析中 == true) {
            NSLog("上次解析未完成")
        } else {
            解析中 = true
            NSNotificationCenter.defaultCenter().postNotificationName("netbusyonce", object: nil)
            开始时间 = NSDate().timeIntervalSince1970
            //NSLog("开始解析...")
            开始解析(true)
        }
    }
    
    func 写入综合信息(k:String, v:NSObject, c:Int) {
        综合信息![k] = v
        信息数据量![k] = c
//        NSLog("解析中 \(综合信息.keys.count) / \(数据量)")
        if (综合信息!.keys.count == 数据量) {
            解析中 = false
            let 消耗时间:Double = NSDate().timeIntervalSince1970 - 开始时间
            var log:String = "解析用时 \(消耗时间)"
            for 当前数据名 in 数据名 {
                log += "，\(当前数据名) \(信息数据量![当前数据名]!)"
            }
            综合信息!["log"] = log
            //返回综合信息
//            delegate?.解析完成(综合信息, 信息数据量: 信息数据量)
            全局_综合信息 = 综合信息
            //.release()
            html = nil
            综合信息!.removeAll()
            综合信息 = nil
            信息数据量!.removeAll()
            信息数据量 = nil
            NSNotificationCenter.defaultCenter().postNotificationName("data", object: nil)
        }
    }
    
    func 开始解析(先校验:Bool) {
        if (先校验 == true) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                autoreleasepool {
                    var dma:DynmapAnalysis? = DynmapAnalysis()
                    dma!.html = self.html
                    let 返回值:Bool = dma!.有效性校验()
                    dma!.html = nil
                    dma = nil
                    dispatch_async(dispatch_get_main_queue(), {
                        self.有效性校验结果(返回值)
                    })
                }
            })
        } else {
            self.有效性校验结果(true)
        }
    }
    func 有效性校验结果(有效:Bool) {
        if (有效 == true) {
            综合信息 = Dictionary<String,NSObject>()
            信息数据量 = Dictionary<String,Int>()
            取得世界列表线程()
            取得弹出提示()
            取得时间和天气()
            取得在线玩家和当前世界活动状态()
            取得当前聊天记录()
            取得商店和地点列表()
            //NSThread.detachNewThreadSelector("取得世界列表线程", toTarget: self, withObject: nil)
            //NSThread.detachNewThreadSelector("取得弹出提示", toTarget: self, withObject: nil)
            //NSThread.detachNewThreadSelector("取得时间和天气", toTarget: self, withObject: nil)
            //NSThread.detachNewThreadSelector("取得在线玩家和当前世界活动状态", toTarget: self, withObject: nil)
            //NSThread.detachNewThreadSelector("取得当前聊天记录", toTarget: self, withObject: nil)
            //NSThread.detachNewThreadSelector("取得商店和地点列表", toTarget: self, withObject: nil)
        } else {
            NSLog("解析数据无效")
            解析中 = false
        }
    }
    
    func 取得世界列表线程() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            autoreleasepool {
                var dma:DynmapAnalysis? = DynmapAnalysis()
                dma!.html = self.html
                let 返回值:[String] = dma!.取得世界列表()
                dma!.html = nil
                dma = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.写入综合信息(self.数据名[0],v: 返回值,c: 返回值.count)
                })
            }
        })
    }
    
    func 取得弹出提示() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            autoreleasepool {
                var dma:DynmapAnalysis? = DynmapAnalysis()
                dma!.html = self.html
                let 返回值:[String] = dma!.取得弹出提示()
                dma!.html = nil
                dma = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.写入综合信息(self.数据名[1],v: 返回值,c: 返回值.count)
                })
            }
        })
    }
    
    func 取得时间和天气() { //[时间字符串,时段,天气]
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            autoreleasepool {
                var dma:DynmapAnalysis? = DynmapAnalysis()
                dma!.html = self.html
                let 返回值:[String] = dma!.取得时间和天气()
                dma!.html = nil
                dma = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.写入综合信息(self.数据名[2],v: 返回值,c: 返回值.count)
                })
            }
        })
    }
    
    func 取得在线玩家和当前世界活动状态() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            autoreleasepool {
                var dma:DynmapAnalysis? = DynmapAnalysis()
                dma!.html = self.html
                let 返回值:Dictionary<String,[String]> = dma!.取得在线玩家和当前世界活动状态()
                dma!.html = nil
                dma = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.写入综合信息(self.数据名[3],v: 返回值,c: 返回值.count)
                })
            }
        })
    }
    
    func 取得当前聊天记录() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            autoreleasepool {
                var dma:DynmapAnalysis? = DynmapAnalysis()
                dma!.html = self.html
                let 返回值:[[String]] = dma!.取得当前聊天记录()
                dma!.html = nil
                dma = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.写入综合信息(self.数据名[4],v: 返回值,c: 返回值.count)
                })
            }
        })
    }
    
    func 取得商店和地点列表() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            autoreleasepool {
                var dma:DynmapAnalysis? = DynmapAnalysis()
                dma!.html = self.html
                let 返回值:[[[String]]] = dma!.取得商店和地点列表()
                dma!.html = nil
                dma = nil
                dispatch_async(dispatch_get_main_queue(), {
                    self.写入综合信息(self.数据名[5],v: 返回值[0],c: 返回值[0].count)
                    self.写入综合信息(self.数据名[6],v: 返回值[1],c: 返回值[1].count)
                })
            }
        })
    }
}
