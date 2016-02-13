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
        let contentType:String = "multipart/form-data;boundary="+boundary
        上传请求.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let 上传内容 = UIImagePNGRepresentation(img)
        
        let 请求 = NSURLSession.sharedSession()  //这个地方不太会喵……

        let 上传任务 = 请求.uploadTaskWithRequest(上传请求, fromData: 上传内容){
            (data:NSData?, reponse:NSURLResponse?, error:NSError?) ->Void in
            print("done")

            if(error != nil){
                print(error)
            } else{
                let 回应:String = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                print(回应)
            }
            
        }
        
        上传任务.resume()
        
        
//        
//        上传数据.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        上传数据.appendData(NSString(format:"Content-Disposition:form-data;name=\"userfile\";filename=\"dd.jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        上传数据.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        上传数据.appendData(图片数据!)
//        
//        上传数据.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
//        
//        上传请求.HTTPBody = 上传数据
//        
//        let 队列 = NSOperationQueue()
//        
//        NSURLConnection.sendAsynchronousRequest(上传请求, queue: 队列) { (回复, 数据, error) -> Void in
//            if(error != nil){
//                print(error)
//            } else{
//                let 回应:String = NSString(data: 数据!, encoding: NSUTF8StringEncoding) as! String
//                print(回应)
//            }
//            
//        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

