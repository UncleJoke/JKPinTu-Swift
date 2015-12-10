//
//  JKHBTagViewController.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/10.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit
import Alamofire
import DGElasticPullToRefresh
import SwiftyJSON

class JKHBTagViewController: UITableViewController {

    private let cellIdentifier = "UITableViewCell"
    
    private var tags = NSMutableArray()
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "美图分类"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.redColor()
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            self?.sendRequest()
            
            }, loadingView: loadingView)
        
        tableView.dg_setPullToRefreshFillColor(UIColor.RGBColor(244, g: 244, b: 244))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        
    }
    
    
    func sendRequest(){
        Alamofire.request(.GET, "http://api.huaban.com/fm/wallpaper/tags").responseJSON { (respone) -> Void in
            let json = JSON(respone.result.value!)
            let tempTags = JKHBTagInfo.parseDataFromHuaban(json.object as! Array)
            self.tags.addObjectsFromArray(tempTags)
            self.tableView.reloadData()
            self.tableView.dg_stopLoading()
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
        
        let tag = self.tags[indexPath.row] as! JKHBTagInfo
        
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
        let tag = self.tags[indexPath.row] as! JKHBTagInfo
        let vc = JKHBImageListViewController()
        vc.tagName = tag.tag_name
        self.navigationController?.pushViewController(vc, animated: true)
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

class JKHBNavigationController:BaseNavigationController {
    
    class func initJKHBNavigationController()->JKHBNavigationController{
        let vc = JKHBTagViewController()
        let nav:JKHBNavigationController = JKHBNavigationController(rootViewController:vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: nav, action: Selector("dismissClick"))
        return nav
    }
    
    func dismissClick(){
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    override func viewDidLoad() {
        
    }
}
