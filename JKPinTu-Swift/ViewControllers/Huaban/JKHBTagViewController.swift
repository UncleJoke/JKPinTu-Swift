//
//  JKHBTagViewController.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/10.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MJRefresh

final class JKHBTagViewController: UITableViewController {

    private let cellIdentifier = "UITableViewCell"
    
    private var tags = [JKHBTagInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        self.title = "美图分类"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("sendRequest"))
        self.tableView.mj_header.beginRefreshing()
    }
    
    func sendRequest(){
        
        Alamofire.request(.GET, "http://api.huaban.com/fm/wallpaper/tags").jk_responseSwiftyJSON { (request, response, JSON_obj, error) -> Void in
            if JSON_obj == JSON.null {
                return
            }
            let tempTags = JKHBTagInfo.parseDataFromHuaban(JSON_obj.object as! Array)
            self.tags = tempTags
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.tags.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if(cell == nil){
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.textColor = UIColor.blackColor()
            cell?.detailTextLabel?.textColor = UIColor.grayColor()
        }
        
        let tag = self.tags[indexPath.row]
        
        let tagName = tag.tag_name
        let pinCountString = " 共\(tag.pin_count)张"
        let displayString = tagName + pinCountString
        let attributedString = NSMutableAttributedString(string: displayString, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)])
        attributedString.setAttributes([NSFontAttributeName:UIFont.systemFontOfSize(11),NSForegroundColorAttributeName:UIColor.grayColor()], range: NSMakeRange(tagName.characters.count, pinCountString.characters.count))
        cell?.textLabel?.attributedText = attributedString
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let tag = self.tags[indexPath.row]
        let vc = JKHBImageListViewController()
        vc.tagName = tag.tag_name
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

class JKHBNavigationController:BaseNavigationController {
    
    var imageBlock : ((AnyObject) -> Void)?
    
    class func initJKHBNavigationController()->JKHBNavigationController{
        let vc = JKHBTagViewController()
        let nav:JKHBNavigationController = JKHBNavigationController(rootViewController:vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: nav, action: Selector("dismiss"))
        return nav
    }
    
    func dismiss(){
        self.dismissClick { () -> Void in
        }
    }
    
    func dismissClick(completion: (() -> Void)?){
        self.dismissViewControllerAnimated(true, completion: completion)
    }
    
    override func viewDidLoad() {
        
    }
}
