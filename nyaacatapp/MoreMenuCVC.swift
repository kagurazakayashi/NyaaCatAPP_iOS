//
//  MoreMenuCVC.swift
//  nyaacatapp
//
//  Created by 神楽坂雅詩 on 16/3/6.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MoreMenuCVC: UICollectionViewController {
    
    let 按钮文本和对应图片:[[String]] = [["活动信息","rss-icon"],["喵窩维基","notebook-icon"],["游戏录像","video-icon"],["游戏直播","tv-icon"],["官方网站","lcd-icon"],["G+社群","GooglePlus-logos-02"],["开源项目","calculator-icon"],["APP设置","seting-icon"],["关于反馈","msg-icon"]]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 按钮文本和对应图片.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:MoreMenuCVCell = collectionView.dequeueReusableCellWithReuseIdentifier("MoreMenuCVCell", forIndexPath: indexPath) as! MoreMenuCVCell
        let 当前按钮文本和对应图片:[String] = 按钮文本和对应图片[indexPath.row]
        let 当前文本:String = 当前按钮文本和对应图片[0]
        let 当前图片:UIImage = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(当前按钮文本和对应图片[1], ofType: "png")!)!
        cell.设置坐标(collectionView.frame, 序号:indexPath.row) //似乎并不需要用代码来设置坐标
        cell.设置内容(当前图片, 文本: 当前文本)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
