//
//  BBSVC.swift
//  nyaacatapp
//
//  Created by 神楽坂紫 on 16/2/14.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import WebKit
import UIKit

class BBSVC: UIViewController, WKNavigationDelegate {
    
    var 浏览器:WKWebView!
    var 进度条:UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.浏览器 = WKWebView(frame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.width, self.view.frame.height))
        self.浏览器.loadRequest(NSURLRequest(URL: NSURL(string: "https://bbs.nyaa.cat")!))
        
        self.浏览器.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        self.进度条 = UIProgressView(progressViewStyle: .Bar)
        self.进度条.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.width,2)
        self.进度条.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.浏览器)
        self.view.addSubview(进度条)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress"){
            self.进度条.setProgress(Float(浏览器.estimatedProgress), animated: true)
        }
        if (浏览器.estimatedProgress == 1){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.进度条.alpha = 0
                }) { (已完成:Bool) -> Void in
                    self.进度条.removeFromSuperview()
            }
        }
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