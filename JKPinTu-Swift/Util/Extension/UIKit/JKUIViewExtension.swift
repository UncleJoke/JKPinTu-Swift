//
//  JKUIViewExtension.swift
//  JKPinTu-Swift
//
//  Created by bingjie-macbookpro on 15/12/15.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import Foundation
import UIKit


extension UIView
{
    public func left()->CGFloat{
        return self.frame.origin.x
    }
    
    public func right()->CGFloat{
        return self.frame.origin.x + self.frame.size.width
    }
    
    public func top()->CGFloat{
        return self.frame.origin.y
    }
    
    public func bottom()->CGFloat{
        return self.frame.origin.y + self.frame.size.height
    }
    
    public func width()->CGFloat{
        return self.frame.size.width
    }
    
    public func height()->CGFloat{
        return self.frame.size.height
    }
    
    
    public func addTapGesturesTarget(target:AnyObject, action selector:Selector){
        self.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: target, action: selector)
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
    
    public func removeAllSubviews(){
        while (self.subviews.count != 0)
        {
            let child = self.subviews.last
            child!.removeFromSuperview()
        }
    }
    public func makeSubviewRandomColor(){
        for view in self.subviews{
            view.backgroundColor = UIColor.randomColor()
        }
    }
}