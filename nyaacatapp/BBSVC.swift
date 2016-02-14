//
//  BBSVC.swift
//  nyaacatapp
//
//  Created by 神楽坂紫 on 16/2/14.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import WebKit
import UIKit

class BBSVC: UIViewController {
    
    var 浏览器:WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.浏览器 = WKWebView(frame: self.view.frame)
        self.浏览器.loadRequest(NSURLRequest(URL: NSURL(string: "https://bbs.nyaa.cat")!))
        self.view.addSubview(self.浏览器)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}