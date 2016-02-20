//
//  DynmapAnalysisController.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/2/20.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import Cocoa

class DynmapAnalysisController: NSObject {
    
    var html:String = ""
    
    func start() {
        NSThread.detachNewThreadSelector("取得世界列表线程", toTarget: self, withObject: nil)
    }
    
    func 取得世界列表线程() {
        let dma:DynmapAnalysis = DynmapAnalysis()
        dma.html = html
        let 返回值:[String] = dma.取得世界列表()
        
        //[self performSelectorOnMainThread:@selector(mainThreadMethod) withObject:nil waitUntilDone:NO];
        self.performSelectorOnMainThread("取得世界列表", withObject: 返回值, waitUntilDone: true)
    }
    
    func 取得世界列表(data:[String]) -> [String] {
        for i in 0...data.count-1 {
            NSLog("返回值=" + data[i])
        }
        return data
    }
//
//    func 取得弹出提示() -> [NSObject] {
//        
//    }
//    
//    func 取得时间和天气() -> [String] {
//        
//    }
//    
//    func 取得在线玩家和当前世界活动状态() -> Dictionary<String,[String]> {
//        
//    }
//    
//    func 取得当前聊天记录() -> [[String]] {
//        
//    }
//    
//    func 取得商店和地点列表() -> [[[String]]] {
//        
//    }
}
