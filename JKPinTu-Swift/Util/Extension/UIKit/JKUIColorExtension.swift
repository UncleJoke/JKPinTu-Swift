//
//  JKUIColorExtension.swift
//  JKPinTu-Swift
//
//  Created by bingjie-macbookpro on 15/12/15.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    
    public class func randomColor()->UIColor{
        
        let red     = ( arc4random() % 256)
        let green   = ( arc4random() % 256)
        let blue    = ( arc4random() % 256)
        
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
    
   public class func RGBColor(r:CGFloat,g:CGFloat ,b:CGFloat)->UIColor{
        
        let red     = r/255.0
        let green   = g/255.0
        let blue    = b/255.0
    
        return UIColor(red: red, green: green, blue:blue, alpha: 1)
    }
    
}