//
//  JKHBImageListViewController.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/10.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit
import Alamofire
import DGElasticPullToRefresh
import SwiftyJSON
import Kingfisher

class JKHBImageListViewController: UICollectionViewController {

    private var tags = NSMutableArray()
    
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
        self.collectionView?.backgroundColor = self.view.backgroundColor
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.sendRequest()
        
    }
    
    func sendRequest(){
        Alamofire.request(.GET, "http://api.huaban.com/fm/wallpaper/pins", parameters: ["limit": 81 , "tag":self.tagName!]).responseJSON { (respone) -> Void in
            
            let json = JSON(respone.result.value!)
            let pins = (json.object as! NSDictionary)["pins"]
            let tempTags = JKHBTagDetailInfo.parseDataFromHuaban(pins as! Array)
            self.tags.addObjectsFromArray(tempTags)
            self.collectionView?.reloadData()
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
        let tag = self.tags[indexPath.row] as! JKHBTagDetailInfo
        imageView!.kf_setImageWithURL(NSURL(string: tag.thumbnailImageURL)!)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let tag = self.tags[indexPath.row] as! JKHBTagDetailInfo
        let url = NSURL(string: tag.originalImageURL)
        KingfisherManager().downloader.downloadImageWithURL(url!, progressBlock: { (receivedSize, totalSize) -> () in

            }) { (image, error, imageURL, originalData) -> () in

                (self.navigationController as! JKHBNavigationController).dismissClick({ () -> Void in
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
