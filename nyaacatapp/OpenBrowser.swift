//
//  OpenBrowser.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/27.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

enum Browser:Int {
    case safari = 0
    case chrome = 1
    case firefox = 2
    case google＋ = 3
    case biliBili = 4
}

class OpenBrowser: NSObject {
    
    let CallbackURL = URL(string:"nyaacatapp://open")!
    
    func 打开浏览器(_ 网址:String) -> Bool {
        return 打开浏览器(网址, 浏览器尝试顺序: [Browser.biliBili, Browser.chrome, Browser.firefox, Browser.safari])
    }
    
    func 打开浏览器(_ 网址:String, 浏览器尝试顺序:[Browser]) -> Bool {
        var 成功打开:Bool = false
        for 当前浏览器:Browser in 浏览器尝试顺序 {
            if (打开浏览器(网址, 浏览器: 当前浏览器) == true) {
                成功打开 = true
                break
            }
        }
        return 成功打开
    }
    
    func 打开浏览器(_ 网址:String, 浏览器:Browser) -> Bool {
        if (浏览器 == Browser.safari) {
            return 使用Safari浏览器中打开(网址)
        } else if (浏览器 == Browser.chrome) {
            return 使用Chrome浏览器打开(网址)
        } else if (浏览器 == Browser.firefox) {
            return 使用Firefox浏览器打开(网址)
        } else if (浏览器 == Browser.google＋) {
            return 使用Google＋打开(网址)
        } else if (浏览器 == Browser.biliBili) {
            return 使用BiliBili打开(网址)
        }
        return false
    }
    
    func 使用Google＋打开(_ 网址:String) -> Bool {
        let url:URL = URL(string:网址)!
        let gpScheme:String = "gplus"
        let absoluteString:String = url.absoluteString
        let rangeForScheme = absoluteString.range(of: ":")
        let urlNoScheme:String = absoluteString.substring(from: rangeForScheme!.lowerBound)
        let gpURLString:String = gpScheme + urlNoScheme
        let gpURL:URL = URL(string: gpURLString)!
        if (UIApplication.shared.canOpenURL(gpURL)) {
            return UIApplication.shared.openURL(gpURL)
        }
        return false
    }
    
    func 使用Chrome浏览器打开(_ 网址:String) -> Bool {
        let url:URL = URL(string:网址)!
        let chrome:OpenInChromeController = OpenInChromeController()
        return chrome.openInChrome(url, callbackURL: CallbackURL, createNewTab: false)
    }
    
    func 使用Firefox浏览器打开(_ 网址:String) -> Bool {
        let openurlstr = "firefox://?url=\(网址)"
        let firefoxURL:URL = URL(string: openurlstr)!
        if (UIApplication.shared.canOpenURL(firefoxURL)) {
            return UIApplication.shared.openURL(firefoxURL)
        }
        return false
    }
    
    func 使用BiliBili打开(_ 网址:String) -> Bool {
        if (网址.characters.count > 30) {
            let 网站:String = 网址.substring(to: 网址.characters.index(网址.startIndex, offsetBy: 30))
            if (网站 == "http://www.bilibili.com/video/" || 网站 == "https://www.bilibili.com/video") {
                let 解析:Analysis = Analysis()
                let AV号:String = 解析.抽取区间(网址, 起始字符串: "video/av", 结束字符串: "/", 包含起始字符串: false, 包含结束字符串: false)
                let BiliURLstr:String = "bilibili://?av=\(AV号)"
                let BiliURL:URL = URL(string: BiliURLstr)!
                if (UIApplication.shared.canOpenURL(BiliURL)) {
                    return UIApplication.shared.openURL(BiliURL)
                }
            }
        }
        return false
    }
    
    func 使用Safari浏览器中打开(_ 网址:String) -> Bool {
        let url:URL = URL(string:网址)!
        return UIApplication.shared.openURL(url)
    }
    
    //    func 在内嵌的Safari浏览器中打开(URL:NSURL) {
    //        let safari:SFSafariViewController = SFSafariViewController(URL: URL)
    //        self.presentViewController(safari, animated: true) { () -> Void in
    //        }
    //    }
}
