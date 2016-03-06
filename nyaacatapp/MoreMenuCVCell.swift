//
//  MoreMenuCVCell.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/6.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class MoreMenuCVCell: UICollectionViewCell {
    
    @IBOutlet weak var 按钮图片: UIImageView!
    @IBOutlet weak var 按钮文本: UILabel!
    
    func 设置内容(图片:UIImage?, 文本:String?) {
        按钮图片.image = 图片
        按钮文本.text = 文本
    }
    
    func 设置坐标(父级尺寸:CGRect, 序号:Int) {
        //计算元件尺寸
        let width:CGFloat = 父级尺寸.size.width / 3
        let height:CGFloat = 父级尺寸.size.height / 3
        NSLog("width=%f,height=%f", width,height)
        //计算本体坐标
        var x:CGFloat = 0
        var y:CGFloat = 0
        if (序号 == 2 || 序号 == 5 || 序号 == 8) {
            x = width * 2
        } else if (序号 == 1 || 序号 == 4 || 序号 == 7) {
            x = width
        } //else if (序号%3 == 0)
        if (序号 >= 6 && 序号 <= 8) {
            y = height * 2
        } else if (序号 >= 3 && 序号 <= 5) {
            y = height
        }
        self.frame = CGRectMake(x, y, width, height)
        //设置元件坐标
        按钮图片.frame = CGRectMake(0, 0, width, height - 20)
        按钮文本.frame = CGRectMake(0, height - 20 , width, 20)
    }
    
    
    
}
