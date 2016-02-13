//
//  ViewController.swift
//  uploadimgtosmmstest
//
//  Created by 神楽坂紫 on 16/2/13.
//  Copyright © 2016年 神楽坂紫. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showpic()
    {
        imagePicker.delegate=self
        imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.CoverVertical
        imagePicker.allowsEditing=true
        self.presentViewController(imagePicker, animated:true, completion: nil)
        
    }
    UIImagePickerControllerDelegate 代理
    func imagePickerController(picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject :AnyObject])
    {
        self.dismissViewControllerAnimated(true, completion:nil);
        let gotImage=info[UIImagePickerControllerOriginalImage]as UIImage
        upload(gotImage)//上传
        
    }

    
    //上传
    func upload(img:UIImage)
    {

        let uploadurl:String="https://sm.ms/api/upload"//设置服务器接收地址
        let request=NSMutableURLRequest(URL:NSURL(string:uploadurl)!)
        request.HTTPMethod="POST"//设置请求方式
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

