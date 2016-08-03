//
//  DMChatNC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/2/21.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class DMChatNC: UINavigationController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = 全局_导航栏颜色
        navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.white]
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
