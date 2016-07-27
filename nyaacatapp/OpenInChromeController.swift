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
    private static var __once: () = { () -> Void in
            let sharedInstance = OpenInChromeController.init()
        }()
    let kGoogleChromeHTTPScheme = "googlechrome:"
    let kGoogleChromeHTTPSScheme = "googlechromes:"
    let kGoogleChromeCallbackScheme = "googlechrome-x-callback:"
    
    func encodeByAddingPercentEscapes(_ input:String) -> String {
        //'CFURLCreateStringByAddingPercentEscapes' is deprecated: first deprecated in iOS 9.0
        let encodedValue = input.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if (encodedValue == nil) {
            return String()
        }
        return encodedValue!
    }
    
    class func sharedInstance() -> OpenInChromeController {
        let sharedInstance:OpenInChromeController? = nil
        var onceToken:Int = 0
        _ = OpenInChromeController.__once
        return sharedInstance!
    }
    
    func isChromeInstalled() -> Bool {
        let simpleURL:URL = URL(string: kGoogleChromeHTTPScheme)!
        let callbackURL:URL = URL(string: kGoogleChromeCallbackScheme)!
        return UIApplication.shared().canOpenURL(simpleURL) || UIApplication.shared().canOpenURL(callbackURL)
    }
    
    func openInChrome(_ url:URL) -> Bool {
        return openInChrome(url, callbackURL: nil, createNewTab: false)
    }
    
    func openInChrome(_ url:URL, callbackURL:URL?, createNewTab:Bool?) -> Bool {
        let chromeSimpleURL:URL = URL(string: kGoogleChromeHTTPScheme)!
        let chromeCallbackURL:URL = URL(string: kGoogleChromeCallbackScheme)!
        if (UIApplication.shared().canOpenURL(chromeCallbackURL)) {
            let appName:String = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String //NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as! String
            let scheme:String = url.scheme!.lowercased()
            // Proceed only if scheme is http or https.
            if (scheme == "http" || scheme == "https") {
                let chromeURLString:NSMutableString = NSMutableString()
                chromeURLString.appendFormat("%@//x-callback-url/open/?x-source=%@&url=%@",
                    kGoogleChromeCallbackScheme,
                    encodeByAddingPercentEscapes(appName),
                    encodeByAddingPercentEscapes(url.absoluteString!))
                if (callbackURL != nil) {
                    chromeURLString.appendFormat("&x-success=%@", encodeByAddingPercentEscapes(callbackURL!.absoluteString!))
                }
                if (createNewTab != nil) {
                    chromeURLString.append("&create-new-tab")
                }
                let chromeURL:URL = URL(string: chromeURLString as String)!
                // Open the URL with Google Chrome.
                return UIApplication.shared().openURL(chromeURL)
            }
        } else if (UIApplication.shared().canOpenURL(chromeSimpleURL)) {
            let scheme:String = url.scheme!.lowercased()
            // Replace the URL Scheme with the Chrome equivalent.
            var chromeScheme:String? = nil
            if (scheme == "http") {
                chromeScheme = kGoogleChromeHTTPScheme
            } else if (scheme == "https") {
                chromeScheme = kGoogleChromeHTTPSScheme
            }
            // Proceed only if a valid Google Chrome URI Scheme is available.
            if (chromeScheme != nil) {
                let absoluteString:String = url.absoluteString!
                let rangeForScheme = absoluteString.range(of: ":")
                let urlNoScheme:String = absoluteString.substring(from: rangeForScheme!.lowerBound)
                let chromeURLString:String = chromeScheme! + urlNoScheme
                let chromeURL:URL = URL(string: chromeURLString)!
                // Open the URL with Google Chrome.
                return UIApplication.shared().openURL(chromeURL)
            }
        }
        return false
    }
    
}
