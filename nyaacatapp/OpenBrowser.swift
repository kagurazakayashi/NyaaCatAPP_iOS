//
//  OpenBrowser.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/27.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

enum Browser:Int {
    case Safari = 0
    case Chrome = 1
    case Firefox = 2
    case Google＋ = 3
    case BiliBili = 4
}

class OpenBrowser: NSObject {
    
    let CallbackURL = NSURL(string:"nyaacatapp://open")!
    
    func 打开浏览器(网址:String) -> Bool {
        return 打开浏览器(网址, 浏览器尝试顺序: [Browser.BiliBili, Browser.Chrome, Browser.Firefox, Browser.Safari])
    }
    
    func 打开浏览器(网址:String, 浏览器尝试顺序:[Browser]) -> Bool {
        var 成功打开:Bool = false
        for 当前浏览器:Browser in 浏览器尝试顺序 {
            if (打开浏览器(网址, 浏览器: 当前浏览器) == true) {
                成功打开 = true
                break
            }
        }
        return 成功打开
    }
    
    func 打开浏览器(网址:String, 浏览器:Browser) -> Bool {
        if (浏览器 == Browser.Safari) {
            return 使用Safari浏览器中打开(网址)
        } else if (浏览器 == Browser.Chrome) {
            return 使用Chrome浏览器打开(网址)
        } else if (浏览器 == Browser.Firefox) {
            return 使用Firefox浏览器打开(网址)
        } else if (浏览器 == Browser.Google＋) {
            return 使用Google＋打开(网址)
        } else if (浏览器 == Browser.BiliBili) {
            return 使用BiliBili打开(网址)
        }
        return false
    }
    
    func 使用Google＋打开(网址:String) -> Bool {
        let url:NSURL = NSURL(string:网址)!
        let gpScheme:String = "gplus"
        let absoluteString:String = url.absoluteString
        let rangeForScheme = absoluteString.rangeOfString(":")
        let urlNoScheme:String = absoluteString.substringFromIndex(rangeForScheme!.startIndex)
        let gpURLString:String = gpScheme.stringByAppendingString(urlNoScheme)
        let gpURL:NSURL = NSURL(string: gpURLString)!
        if (UIApplication.sharedApplication().canOpenURL(gpURL)) {
            return UIApplication.sharedApplication().openURL(gpURL)
        }
        return false
    }
    
    func 使用Chrome浏览器打开(网址:String) -> Bool {
        let url:NSURL = NSURL(string:网址)!
        let chrome:OpenInChromeController = OpenInChromeController()
        return chrome.openInChrome(url, callbackURL: CallbackURL, createNewTab: false)
    }
    
    func 使用Firefox浏览器打开(网址:String) -> Bool {
        let openurlstr = "firefox://?url=\(网址)"
        let firefoxURL:NSURL = NSURL(string: openurlstr)!
        if (UIApplication.sharedApplication().canOpenURL(firefoxURL)) {
            return UIApplication.sharedApplication().openURL(firefoxURL)
        }
        return false
    }
    
    func 使用BiliBili打开(网址:String) -> Bool {
        if (网址.characters.count > 30) {
            let 网站:String = 网址.substringToIndex(网址.startIndex.advancedBy(30))
            if (网站 == "http://www.bilibili.com/video/" || 网站 == "https://www.bilibili.com/video") {
                let 解析:Analysis = Analysis()
                let AV号:String = 解析.抽取区间(网址, 起始字符串: "video/av", 结束字符串: "/", 包含起始字符串: false, 包含结束字符串: false)
                let BiliURLstr:String = "bilibili://?av=\(AV号)"
                let BiliURL:NSURL = NSURL(string: BiliURLstr)!
                if (UIApplication.sharedApplication().canOpenURL(BiliURL)) {
                    return UIApplication.sharedApplication().openURL(BiliURL)
                }
            }
        }
        return false
    }
    
    func 使用Safari浏览器中打开(网址:String) -> Bool {
        let url:NSURL = NSURL(string:网址)!
        return UIApplication.sharedApplication().openURL(url)
    }
    
    //    func 在内嵌的Safari浏览器中打开(URL:NSURL) {
    //        let safari:SFSafariViewController = SFSafariViewController(URL: URL)
    //        self.presentViewController(safari, animated: true) { () -> Void in
    //        }
    //    }
}