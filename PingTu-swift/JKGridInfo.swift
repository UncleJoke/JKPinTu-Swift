//
//  JKGridInfo.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/8.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit

class JKGridInfo: NSObject {
    
    /// 所在格子的序号
    var location:Int = 0
    
    var imageView:UIImageView?

    convenience init(location: Int, imageView:UIImageView) {
        self.init()
        self.imageView = imageView
        self.location = location
    }
}
