//
//  GameView.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/5.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit



class GameView: UIView {

    private var views = [JKGridInfo]()
    private var whitePoint:CGPoint = CGPointZero
    private var step:CGFloat = 0
    
    var numberOfRows:Int = 4

    var images: NSArray = [] {
        
        didSet{
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupSubviews(){
        
        let w = self.bounds.width/CGFloat(self.numberOfRows)
        let h = self.bounds.height/CGFloat(self.numberOfRows)
        
        self.step = w
        self.whitePoint = CGPointMake((CGFloat(self.numberOfRows) - 0.5)*w, (CGFloat(self.numberOfRows) - 0.5)*h)
        
        let count = self.numberOfRows*self.numberOfRows
        
        for index in 0..<count {
            let x = index % self.numberOfRows
            let y = index / self.numberOfRows
            let imageview = UIImageView(frame: CGRectMake(CGFloat(x)*w, CGFloat(y)*h, CGFloat(w), CGFloat(h)))
            imageview.center = CGPointMake(CGFloat(x)*w + w*0.5, CGFloat(y)*h + h*0.5)
            imageview.contentMode = .ScaleAspectFit
            imageview.backgroundColor = (index == (count-1)) ? UIColor.whiteColor() : UIColor.randomColor()
            imageview.addTapGesturesTarget(self, action: Selector("imageviewTapGestures:"))
            imageview.tag = index
            
            let info = JKGridInfo.init(location: index, imageView: imageview)
            self.views.append(info)
            self.addSubview(imageview)
        }
    }
    
    
    func imageviewTapGestures(recognizer:UITapGestureRecognizer){
        
        var clickInfo:JKGridInfo?
        
        for item in self.views {
            if((item.imageView?.isEqual(recognizer.view)) == true){
                clickInfo = item
                break;
            }
        }
        
        let placeholderInfo = self.views.last
        if(self.checkMoveFrom(clickInfo!, placeholderInfo: placeholderInfo!)){
            
            /// 位置信息
            let location1 = clickInfo?.location
            let location2 = placeholderInfo?.location
            /// 坐标
            let p1 = clickInfo?.imageView?.center
            let p2 = placeholderInfo?.imageView?.center
            
            /*!
            *  @author Bingjie, 15-12-08 14:12:45
            *
            *  互换坐标以及位置序号
            */
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                clickInfo?.imageView?.center = p2!
                placeholderInfo?.imageView?.center = p1!
                }, completion: { (completion) -> Void in
                    clickInfo?.location = location2!
                    placeholderInfo?.location = location1!
            })
            
        }else{
            
            print(clickInfo)
        }
    }
    
    /*!
    检测点击的格子相对于占位符能否移动
    
    - parameter clickInfo: 点击的格子信息
    - parameter p:         占位的格子信息
    
    - returns: 能否移动
    */
    private func checkMoveFrom(clickInfo:JKGridInfo ,placeholderInfo p:JKGridInfo) -> Bool{
        let upViewLocation = p.location - self.numberOfRows
        let downViewLocation = p.location + self.numberOfRows
        let leftViewLocationg = p.location - 1
        let rightViewLocation = p.location + 1
        
        if(clickInfo.location == upViewLocation || clickInfo.location == downViewLocation || clickInfo.location == leftViewLocationg || clickInfo.location == rightViewLocation){
            return true
        }
        return false
    }
    
    
    /*!
    切割图片
    
    - parameter image: 需要切割的图片
    - parameter rect:  位置
    - returns: 切割后的图
    */
    func clipImage(image:UIImage,withRect rect:CGRect) ->UIImage{
        let cgImage = CGImageCreateWithImageInRect(image.CGImage, rect)
        return UIImage(CGImage: cgImage!)
    }
}


extension UIView {
    
    func addTapGesturesTarget(target:AnyObject, action selector:Selector){
        self.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: target, action: selector)
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
    }
}

extension UIColor {
    
    class func randomColor()->UIColor{
        
        let red     = ( arc4random() % 256)
        let green   = ( arc4random() % 256)
        let blue    = ( arc4random() % 256)
        
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1)
    }
}