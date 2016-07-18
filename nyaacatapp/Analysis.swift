//
//  Analysis.swift
//  dynmapanalysistest
//
//  Created by 神楽坂雅詩 on 16/3/26.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class Analysis: NSObject {
    
    //抽取区间(<#T##输入字符串: String##String#>, 起始字符串: <#T##String#>, 结束字符串: <#T##String#>, 包含起始字符串: <#T##Bool#>, 包含结束字符串: <#T##Bool#>)
    func 抽取区间(_ 输入字符串:String,起始字符串:String,结束字符串:String?,包含起始字符串:Bool,包含结束字符串:Bool) -> String {
        var 起始点到结束点字符串:String = ""
        //if (起始字符串 != nil && 起始字符串 != "") {}
        let 起始点位置:Range? = 输入字符串.range(of: 起始字符串)
        if (起始点位置 != nil) {
            if (包含起始字符串 == true) {
                起始点到结束点字符串 = 输入字符串.substring(from: 起始点位置!.lowerBound)
            } else {
                起始点到结束点字符串 = 输入字符串.substring(from: 起始点位置!.upperBound)
            }
            if (结束字符串 != nil && 结束字符串 != "") {
                let 搜索结束点:Range? = 起始点到结束点字符串.range(of: 结束字符串!)
                if (搜索结束点 != nil) {
                    if (包含结束字符串 != true) {
                        起始点到结束点字符串 = 起始点到结束点字符串.substring(to: 搜索结束点!.lowerBound)
                    } else {
                        起始点到结束点字符串 = 起始点到结束点字符串.substring(to: 搜索结束点!.upperBound)
                    }
                }
            }
        }
        return 起始点到结束点字符串
    }
    
    func 去除HTML标签(_ 输入html:String,需要合成:Bool) -> [String] {
        let 输入参数:String = 输入html
        var 输出参数:[String] = Array<String>()
        let 输入参数分割:[String] = 输入参数.components(separatedBy: "<")
        for 输入参数分割循环 in 0...输入参数分割.count-1 {
            autoreleasepool {
                let 当前输入参数分割:String = 输入参数分割[输入参数分割循环]
                let 文本内容起始点位置:Range? = 当前输入参数分割.range(of: ">")
                if (文本内容起始点位置 != nil) {
                    let 文本内容:String = 当前输入参数分割.substring(from: 文本内容起始点位置!.upperBound)
                    if (文本内容 != "") {
                        输出参数.append(文本内容)
                    }
                }
            }
        }
        if (需要合成 == true) {
            let 合成文本 = 输出参数.joined(separator: "")
            return [合成文本]
        }
        return 输出参数
    }
}
