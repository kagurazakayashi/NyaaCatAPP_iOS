//
//  ViewController.swift
//  uploadimgtosmmstest
//
//  Created by 神楽坂紫 on 16/2/13.
//  Copyright © 2016年 神楽坂紫. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var 按钮: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func 按按钮(sender: UIButton) {
        加载相册图片()
    }
    
    func 加载相册图片()
    {
        let 相册图片 = UIImagePickerController()
        相册图片.delegate = self
        相册图片.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        相册图片.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        相册图片.allowsEditing = true
        self.presentViewController(相册图片, animated:true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion:nil);
        let gotImage = image
         upload(gotImage)//上传

        
    }

    //上传
    
//    func 上传图片(img:UIImage){
//        
//        let 请求地址 = NSURL(string: "https://sm.ms/api/upload")
//        let 上传请求 = NSURLRequest(URL: 请求地址!)
//        
//        let 请求 = NSURLSession.sharedSession()
//        
//        let 上传内容 = UIImagePNGRepresentation(img)
//        

//        }
//        
//        上传任务.resume()
//    }
    
    func upload(img:UIImage)
    {

        let 上传地址:String="https://sm.ms/api/upload"
        let 上传请求 = NSMutableURLRequest(URL:NSURL(string:上传地址)!)
        上传请求.HTTPMethod="POST"

        let boundary:String = "-nyaacat"
        let contentType:String = String("multipart/form-data;charset=utf-8;boundary=\(boundary)")
        上传请求.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let 上传内容:NSData = UIImagePNGRepresentation(img)!
        
        let 上传队列 = NSMutableString()
        上传队列.appendFormat("--\(boundary)\r\n")
        上传队列.appendFormat("Content-Disposition:form-data;name=\"smfile\";filename=\"nyaa.png\"\r\n\r\n")
        上传队列.appendFormat("Content-Type:image/png\r\n")
        上传队列.appendFormat("--\(boundary)\r\n")
        上传队列.appendFormat("Content-Disposition:form-data;name=\"ssl\"\r\n\r\n")
        上传队列.appendFormat("true\r\n")
        
        let 请求 = NSMutableData()
        请求.appendData(上传队列.dataUsingEncoding(NSUTF8StringEncoding)!)
        请求.appendData(上传内容)
        请求.appendData(NSString(format: "\r\n--\(boundary)--\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        let 上传会话 = NSURLSession.sharedSession()  //这个地方不太会喵……

        let 上传任务 = 上传会话.uploadTaskWithRequest(上传请求, fromData: 请求){
            (data:NSData?, reponse:NSURLResponse?, error:NSError?) ->Void in
            print("done")

            if(error != nil){
                print(error)
            } else{
                let 回应:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                print(回应)
                self.解析json(回应)
            }
        }
        上传任务.resume()
        
    }
    
    func 解析json(json:String){
        let 解析data = json.dataUsingEncoding(NSUTF8StringEncoding)
        var 解析字典:NSDictionary = NSDictionary()
        do {
            解析字典 = try NSJSONSerialization.JSONObjectWithData(解析data!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
        } catch _ {

        }
        let 解析状态 = 解析字典.objectForKey("code")!
        if (解析状态.isEqualToString("") || 解析状态.isEqualToString("error")){
            //失败
        } else {
            let 数据字典:NSDictionary = 解析字典.valueForKey("data") as! NSDictionary
            print(数据字典)
        let 图片地址 = 数据字典.objectForKey("url")
            print(图片地址)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

