//
//  JKHBImageListViewController.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/10.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import MJRefresh
import MBProgressHUD

final class JKHBImageListViewController: UICollectionViewController {

    private var tags = [JKHBTagDetailInfo]()
    
    var tagName:String? = ""
    
    convenience init(){
        let layout = UICollectionViewFlowLayout()
        let width = SCREEN_WIDTH/3 - 2
        layout.itemSize = CGSizeMake(width, width * 1.5)
        layout.sectionInset = UIEdgeInsetsZero
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        layout.scrollDirection = .Vertical
        self.init(collectionViewLayout:layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        self.collectionView!.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headerRefresh"))
        self.collectionView!.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: Selector("footerRefresh"))
        self.collectionView!.mj_header.beginRefreshing()
    }
    
    func headerRefresh(){
        
        self.sendRequest(0)
    }
    func footerRefresh(){
        var seq = 0
        if self.tags.count != 0{
            let lastObjc = self.tags.last
            seq = lastObjc!.seq == 0 ? 0 : lastObjc!.seq
        }
        self.sendRequest(seq)
    }
    
    func sendRequest(seq:Int){
        
        let max = seq == 0 ? "" : "\(seq)"

        Alamofire.request(.GET, "http://api.huaban.com/fm/wallpaper/pins", parameters: ["limit": 21 , "tag":self.tagName! , "max": max]).jk_responseSwiftyJSON { (request, response, JSON_obj, error) -> Void in
            if JSON_obj == JSON.null {
                return
            }
            let pins = (JSON_obj.object as! NSDictionary)["pins"]
            let tempTags = JKHBTagDetailInfo.parseDataFromHuaban(pins as! Array)
            self.tags =  seq != 0 ? (self.tags + tempTags) : tempTags
            self.collectionView?.reloadData()
            self.collectionView!.mj_header.endRefreshing()
            self.collectionView!.mj_footer.endRefreshing()
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.whiteColor()
        
        var imageView = cell.contentView.viewWithTag(1111) as? UIImageView
        if(imageView == nil){
            imageView = UIImageView(frame: cell.bounds)
            imageView!.tag = 1111
            imageView?.clipsToBounds = true
            imageView?.contentMode = .ScaleAspectFill
            cell.contentView.addSubview(imageView!)
        }
        let tag = self.tags[indexPath.row]
        imageView!.kf_setImageWithURL(NSURL(string: tag.thumbnailImageURL)!)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let tag = self.tags[indexPath.row]
        let url = NSURL(string: tag.originalImageURL)
        
        KingfisherManager.sharedManager.downloader.downloadImageWithURL(url!, progressBlock: { (receivedSize, totalSize) -> () in
            
//            let progress = Float(receivedSize)/Float(totalSize)

            }) { [unowned self] (image, error, imageURL, originalData) -> () in
                
                (self.navigationController as! JKHBNavigationController).dismissClick({ [unowned self] () -> Void in
                    if((self.navigationController as! JKHBNavigationController).imageBlock != nil){
                        (self.navigationController as! JKHBNavigationController).imageBlock!(image!)
                    }
                })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
