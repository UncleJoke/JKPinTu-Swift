//
//  JKHBTagInfo.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/10.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit

class JKHBTagInfo: NSObject {

    var tag_name:String!
    var pin_count:Int!

    convenience init(name: String, count:Int) {
        self.init()
        self.tag_name = name
        self.pin_count = count
    }
    
    class func parseDataFromHuaban(responseArray:Array<AnyObject>) -> Array<JKHBTagInfo> {
        
        var objs = [JKHBTagInfo]()
        for item in responseArray{
            let name = (item as! NSDictionary)["tag_name"] as! String
            let count = (item as! NSDictionary)["pin_count"] as! Int
            
            let tag = JKHBTagInfo(name: name, count: count)
            objs.append(tag)
        }
        return objs
    }
}
