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
    var 遮盖:UIView = UIView(frame: CGRectZero)
    var 遮盖文字:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        遮盖.frame = CGRectMake(0, 0, self.view.frame.width, 64)
        遮盖.backgroundColor = UIColor(red: 1, green: 153/255.0, blue: 203/255.0, alpha: 1)
        遮盖文字.frame = CGRectMake(0, 20, self.view.frame.width, 44)
        遮盖文字.text = "NyaaBBS~"
        遮盖文字.textAlignment = .Center
        遮盖文字.textColor = UIColor.whiteColor()
        
        浏览器 = WKWebView(frame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.width, self.view.frame.height))
        浏览器.loadRequest(NSURLRequest(URL: NSURL(string: "https://bbs.nyaa.cat")!))
        
        浏览器.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        进度条 = UIProgressView(progressViewStyle: .Bar)
        进度条.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.width,2)
        进度条.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.浏览器)
        self.view.addSubview(进度条)
        self.view.addSubview(遮盖)
        遮盖.addSubview(遮盖文字)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress"){
            self.进度条.setProgress(Float(浏览器.estimatedProgress), animated: true)
        }
        if (浏览器.estimatedProgress == 1){
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.遮盖文字.text = ""
                self.进度条.alpha = 0
                self.遮盖.frame = CGRectMake(0, 0, self.view.frame.width, 20)
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