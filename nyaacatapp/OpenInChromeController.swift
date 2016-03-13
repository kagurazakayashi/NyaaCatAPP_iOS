//
//  OpenInChromeController.swift
//
//  Opening links in Chrome for iOS.
//  This file requires ARC support.
//
//  Objective-C:
//  Copyright 2012-2014, Google Inc. All rights reserved.
//  https://github.com/GoogleChrome/OpenInChrome
//  
//  Objective-C to Swift(iOS 9 SDK):
//  Copyright 2016, KagurazakaYashi. All rights reserved.
//  Created by KagurazakaYashi on 16/3/13.
//  https://github.com/cxchope/OpenInChrome
//

import UIKit

class OpenInChromeController: NSObject {
    let kGoogleChromeHTTPScheme = "googlechrome:"
    let kGoogleChromeHTTPSScheme = "googlechromes:"
    let kGoogleChromeCallbackScheme = "googlechrome-x-callback:"
    
    func encodeByAddingPercentEscapes(input:String) -> String {
        //'CFURLCreateStringByAddingPercentEscapes' is deprecated: first deprecated in iOS 9.0
        let encodedValue = input.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        if (encodedValue == nil) {
            return String()
        }
        return encodedValue!
    }
    
    class func sharedInstance() -> OpenInChromeController {
        var sharedInstance:OpenInChromeController? = nil
        var onceToken:dispatch_once_t = 0
        dispatch_once(&onceToken) { () -> Void in
            sharedInstance = OpenInChromeController.init()
        }
        return sharedInstance!
    }
    
    func isChromeInstalled() -> Bool {
        let simpleURL:NSURL = NSURL(string: kGoogleChromeHTTPScheme)!
        let callbackURL:NSURL = NSURL(string: kGoogleChromeCallbackScheme)!
        return UIApplication.sharedApplication().canOpenURL(simpleURL) || UIApplication.sharedApplication().canOpenURL(callbackURL)
    }
    
    func openInChrome(url:NSURL) -> Bool {
        return openInChrome(url, callbackURL: nil, createNewTab: false)
    }
    
    func openInChrome(url:NSURL, callbackURL:NSURL?, createNewTab:Bool?) -> Bool {
        let chromeSimpleURL:NSURL = NSURL(string: kGoogleChromeHTTPScheme)!
        let chromeCallbackURL:NSURL = NSURL(string: kGoogleChromeCallbackScheme)!
        if (UIApplication.sharedApplication().canOpenURL(chromeCallbackURL)) {
            let appName:String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
            let scheme:String = url.scheme.lowercaseString
            // Proceed only if scheme is http or https.
            if (scheme == "http" || scheme == "https") {
                let chromeURLString:NSMutableString = NSMutableString()
                chromeURLString.appendFormat("%@//x-callback-url/open/?x-source=%@&url=%@",
                    kGoogleChromeCallbackScheme,
                    encodeByAddingPercentEscapes(appName),
                    encodeByAddingPercentEscapes(url.absoluteString))
                if (callbackURL != nil) {
                    chromeURLString.appendFormat("&x-success=%@", encodeByAddingPercentEscapes(callbackURL!.absoluteString))
                }
                if (createNewTab != nil) {
                    chromeURLString.appendString("&create-new-tab")
                }
                let chromeURL:NSURL = NSURL(string: chromeURLString as String)!
                // Open the URL with Google Chrome.
                return UIApplication.sharedApplication().openURL(chromeURL)
            }
        } else if (UIApplication.sharedApplication().canOpenURL(chromeSimpleURL)) {
            let scheme:String = url.scheme.lowercaseString
            // Replace the URL Scheme with the Chrome equivalent.
            var chromeScheme:String? = nil
            if (scheme == "http") {
                chromeScheme = kGoogleChromeHTTPScheme
            } else if (scheme == "https") {
                chromeScheme = kGoogleChromeHTTPSScheme
            }
            // Proceed only if a valid Google Chrome URI Scheme is available.
            if (chromeScheme != nil) {
                let absoluteString:String = url.absoluteString
                let rangeForScheme = absoluteString.rangeOfString(":")
                let urlNoScheme:String = absoluteString.substringFromIndex(rangeForScheme!.startIndex)
                let chromeURLString:String = chromeScheme!.stringByAppendingString(urlNoScheme)
                let chromeURL:NSURL = NSURL(string: chromeURLString)!
                // Open the URL with Google Chrome.
                return UIApplication.sharedApplication().openURL(chromeURL)
            }
        }
        return false
    }
    
}
