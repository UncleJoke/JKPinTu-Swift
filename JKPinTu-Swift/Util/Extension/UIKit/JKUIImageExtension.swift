//
//  JKUIImageExtension.swift
//  JKPinTu-Swift
//
//  Created by bingjie-macbookpro on 15/12/15.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import Foundation
import UIKit



extension UIImage
{
    /*!
    切割图片
    
    - parameter image: 需要切割的图片
    - parameter rect:  位置
    - returns: 切割后的图
    */
    public class func clipImage(image:UIImage,withRect rect:CGRect) ->UIImage{
        let cgImage = CGImageCreateWithImageInRect(image.CGImage, rect)
        return UIImage(CGImage: cgImage!)
    }
    
    
    /*!
    根据颜色生成图片
    
    - parameter color: UIColor
    - parameter size:  CGSize
    
    - returns: UIImage
    */
    public class func imageFromColor(color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img;
    }
    
}

