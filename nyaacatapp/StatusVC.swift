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

    @IBOutlet weak var 背景图片: UIImageView!
    @IBOutlet weak var 世界名称: UILabel!
    @IBOutlet weak var 天气图标: UIImageView!
    @IBOutlet weak var 天气描述: UILabel!
    @IBOutlet weak var 世界时间: UILabel!
    @IBOutlet weak var 玩家按钮: UIButton!
    @IBOutlet weak var 城市按钮: UIButton!
    @IBOutlet weak var 商店按钮: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldViewFrame = self.view.frame
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().statusBarHidden = true
        self.view.frame = CGRectMake(0, -20, oldViewFrame!.size.width, oldViewFrame!.size.height + 20)
    }
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden = false
    }

    @IBAction func 玩家按钮点击(sender: UIButton) {
        let 打开的列表:StatusTVC = self.navigationController?.viewControllers[1] as! StatusTVC
        打开的列表.要呈现的数据 = .玩家列表
    }
    
    @IBAction func 城市按钮点击(sender: UIButton) {
        let 打开的列表:StatusTVC = self.navigationController?.viewControllers[1] as! StatusTVC
        打开的列表.要呈现的数据 = .城市列表
    }
    
    @IBAction func 商店按钮点击(sender: UIButton) {
        let 打开的列表:StatusTVC = self.navigationController?.viewControllers[1] as! StatusTVC
        打开的列表.要呈现的数据 = .商店列表
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
