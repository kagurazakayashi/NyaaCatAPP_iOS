//
//  StatusVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/24.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class StatusVC: UIViewController {
    
    var oldViewFrame:CGRect?
    let 时段词:Dictionary<String,String> = ["day":"白天","night":"夜晚"]
    let 天气词:Dictionary<String,String> = ["stormy":"降雨","sunny":"晴朗","thunder":"雷雨"]

    @IBOutlet weak var 背景图片: UIImageView!
    @IBOutlet weak var 世界名称: UILabel!
    @IBOutlet weak var 天气图标: UIImageView!
    @IBOutlet weak var 天气描述: UILabel!
    @IBOutlet weak var 世界时间: UILabel!
    @IBOutlet weak var 玩家按钮: UIButton!
    @IBOutlet weak var 城市按钮: UIButton!
    @IBOutlet weak var 商店按钮: UIButton!
    @IBOutlet weak var 世界按钮: UIButton!
    
    var 数据:[String]? = nil
    var 白天:Bool = true
    let 白天颜色:UIColor = UIColor.yellow()
    let 夜晚颜色:UIColor = UIColor.lightGray()
    var 时:Int = 0
    var 分:Int = 0
    var 闪烁冒号:Bool = true
    var 时间补偿:MSWeakTimer? = nil
    var 天气图标图像:Dictionary<String,UIImage> = Dictionary<String,UIImage>()
    var 导航栏前一状态:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldViewFrame = self.view.frame
        世界时间.font = UIFont(name: "longzhoufeng", size: 50)
        //天气图标图像
        let 时段词KeyL:LazyMapCollection<Dictionary<String, String>, String> = 时段词.keys
        let 天气词KeyL:LazyMapCollection<Dictionary<String, String>, String> = 天气词.keys
        let 时段词Key:[String] = Array(时段词KeyL)
        let 天气词Key:[String] = Array(天气词KeyL)
        for 天气字:String in 天气词Key {
            for 时段字:String in 时段词Key {
                let 当前图片文件名:String = "\(天气字)_\(时段字)"
                let 当前图片文件路径:String = Bundle.main().pathForResource(当前图片文件名, ofType: "png")!
                let 当前图片数据:UIImage = UIImage(contentsOfFile: 当前图片文件路径)!
                天气图标图像[当前图片文件名] = 当前图片数据
            }
        }
        NotificationCenter.default().addObserver(self, selector: #selector(StatusVC.接收数据更新通知), name: "data", object: nil)
        时间补偿 = MSWeakTimer.scheduledTimer(withTimeInterval: 1.0, target: self, selector: #selector(StatusVC.时间补偿触发), userInfo: nil, repeats: true, dispatchQueue: DispatchQueue.main)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        UIApplication.sharedApplication().statusBarHidden = true
//        self.view.frame = CGRectMake(0, -20, oldViewFrame!.size.width, oldViewFrame!.size.height + 20)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    func 时间补偿触发() {
        if (分 != 0 && 时 != 0) {
            分 += 1
            if (分 >= 60) {
                分 = 0
                时 += 1
                if (时 >= 24) {
                    时 = 0
                    分 = 0
                }
            }
        }
        更新时间字符串()
    }
    
    func 更新时间字符串() {
        let 冒号:String = ":"
//        闪烁冒号 = !闪烁冒号
//        if (闪烁冒号 == false) {
//            冒号 = " "
//        }
        var 时字 = String(时)
        if (时 < 10) {
            时字 = "0\(时字)"
        }
        var 分字 = String(分)
        if (分 < 10) {
            分字 = "0\(分字)"
        }
        世界时间.text = "\(时字)\(冒号)\(分字)"
    }
    
    func 接收数据更新通知() {
        if (全局_综合信息 != nil) {
            数据 = 全局_综合信息!["时间天气"] as? [String]
            if (数据 != nil && 数据?.count == 3) {
                //[时间字符串,时段,天气]
                let 时间:String = 数据![0]
                let 时段:String = 数据![1]
                if (时段 == "day") {
                    白天 = true
                    世界时间.textColor = 白天颜色
                    天气描述.textColor = 白天颜色
                } else {
                    白天 = false
                    世界时间.textColor = 夜晚颜色
                    天气描述.textColor = 夜晚颜色
                }
                let 天气:String = 数据![2]
                let 天气数据:String? = 天气词[天气]
                let 时段数据:String? = 时段词[时段]
                if (天气数据 != nil && 时段数据 != nil) {
                    天气描述.text = "\(天气词[天气]!)/\(时段词[时段]!)"
                    let 当前图片文件名:String = "\(天气)_\(时段)"
                    let 当前天气图片:UIImage = 天气图标图像[当前图片文件名]!
                    天气图标.image = 当前天气图片
                    let 时间数组 = 时间.components(separatedBy: ":")
                    时 = Int(时间数组[0])!
                    分 = Int(时间数组[1])!
                    更新时间字符串()
                }
            }
            let 在线玩家字典:Dictionary<String,[String]> = 全局_综合信息!["在线玩家"] as! Dictionary<String,[String]>
            let 在线玩家数据:[String] = Array(在线玩家字典.keys)
            玩家按钮.setTitle("\(String(在线玩家数据.count)) 位在线玩家 >", for: UIControlState())
            let 在线城市数据:[[String]] = 全局_综合信息!["地点"] as! [[String]]
            城市按钮.setTitle("\(String(在线城市数据.count)) 个城市坐标 >", for: UIControlState())
            let 在线商店数据:[[String]] = 全局_综合信息!["商店"] as! [[String]]
            商店按钮.setTitle("\(String(在线商店数据.count)) 个玩家商店 >", for: UIControlState())
            let 在线世界数据:[String] = 全局_综合信息!["世界列表"] as! [String]
            世界按钮.setTitle("\(String(在线世界数据.count)) 个游戏世界 >", for: UIControlState())
            //数据 = 全局_综合信息!["时间天气"] as? [String]
        }
    }

    @IBAction func 玩家按钮点击(_ sender: UIButton) {
        let 打开的列表:StatusTVC = self.navigationController?.viewControllers[1] as! StatusTVC
        打开的列表.要呈现的数据 = .玩家列表
    }
    
    @IBAction func 城市按钮点击(_ sender: UIButton) {
        let 打开的列表:StatusTVC = self.navigationController?.viewControllers[1] as! StatusTVC
        打开的列表.要呈现的数据 = .城市列表
    }
    
    @IBAction func 商店按钮点击(_ sender: UIButton) {
        let 打开的列表:StatusTVC = self.navigationController?.viewControllers[1] as! StatusTVC
        打开的列表.要呈现的数据 = .商店列表
    }
    
    @IBAction func 世界按钮点击(_ sender: UIButton) {
        let 打开的列表:StatusTVC = self.navigationController?.viewControllers[1] as! StatusTVC
        打开的列表.要呈现的数据 = .世界列表
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
