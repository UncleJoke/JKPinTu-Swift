//
//  OtherViewController.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/7.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit

class OtherViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.table!.delegate = self
        self.table!.dataSource = self
        self.navigationController?.hidesBarsOnSwipe = true

    }

    // UITableViewDataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        var imageView = cell.contentView.viewWithTag(1111) as? UIImageView
        if(imageView == nil){
            imageView = UIImageView(frame: cell.bounds)
            imageView!.tag = 1111
            cell.contentView.addSubview(imageView!)
        }
        let name = "00" + String(indexPath.row)
        imageView?.image = UIImage(named: name)
        
        return cell
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
