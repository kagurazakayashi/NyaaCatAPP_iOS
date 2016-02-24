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
    
    var 浏览器:WKWebView = WKWebView()
    var 进度条:UIProgressView = UIProgressView()
    var 遮盖:UIView = UIView(frame: CGRectZero)
    var 遮盖文字:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        self.view.addSubview(浏览器)
        
        浏览器.loadRequest(NSURLRequest(URL: NSURL(string: "https://bbs.nyaa.cat")!))
        浏览器.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        进度条 = UIProgressView(progressViewStyle: .Bar)
        
        遮盖.frame = CGRectMake(0, 0, 1024, 64)
        遮盖文字.frame = CGRectMake(0, 20, self.view.frame.width, 44)
        
        遮盖.backgroundColor = UIColor(red: 1, green: 153/255.0, blue: 203/255.0, alpha: 1)
        遮盖文字.text = "NyaaBBS~"
        遮盖文字.textAlignment = .Center
        遮盖文字.textColor = UIColor.whiteColor()
        
        进度条.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 64, self.view.frame.width,2)
        进度条.backgroundColor = UIColor.whiteColor()
        
        浏览器.translatesAutoresizingMaskIntoConstraints = false
    
        let 左约束 = NSLayoutConstraint(item: 浏览器, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0)
        let 右约束 = NSLayoutConstraint(item: 浏览器, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0)
        let 上约束 = NSLayoutConstraint(item: 浏览器, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0)
        let 下约束 = NSLayoutConstraint(item: 浏览器, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([左约束,右约束,上约束,下约束])

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
                self.遮盖.frame = CGRectMake(0, 0, 1024, 20)
                }) { (已完成:Bool) -> Void in
                    self.进度条.removeFromSuperview()
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            }) { (UIViewControllerTransitionCoordinatorContext) -> Void in
                if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait && UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone{
                    self.遮盖.frame = CGRectMake(0, 0, 1024, 20)
                } else {
                    self.遮盖.frame = CGRectMake(0, 0, 1024, 0)
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