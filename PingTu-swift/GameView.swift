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
    
    private var numberOfGrids:Int {
        get{
            return self.numberOfRows*self.numberOfRows
        }
    }
    
    /// 每一行/列有多少个格子
    var numberOfRows:Int = 3

    var image: UIImage? {
        
        didSet{
            
            /// 所有格子重置到原来位置
            let w = self.bounds.width/CGFloat(self.numberOfRows)
            let h = self.bounds.height/CGFloat(self.numberOfRows)
            
            let imageW = (image?.size.width)!/CGFloat(self.numberOfRows) * (image?.scale)!
            let imageH = (image?.size.height)!/CGFloat(self.numberOfRows) * (image?.scale)!

            let images:NSMutableArray! = NSMutableArray()
            
            for item in self.views {
                let x = (item.imageView?.tag)! % self.numberOfRows
                let y = (item.imageView?.tag)! / self.numberOfRows
                let rect = CGRectMake(CGFloat(x)*imageW, CGFloat(y)*imageH, CGFloat(imageW), CGFloat(imageH))
                let tempImage = UIImage.clipImage(self.image!, withRect: rect)
                
                let imageInfo = JKImageInfo()
                imageInfo.image = tempImage
                imageInfo.imageSortNumber = item.imageView.tag
                
                images.addObject(imageInfo)
            }
            self.randomSortArray(images)
            self.randomSortArray(images)
            self.randomSortArray(images)
            self.randomSortArray(images)
            self.randomSortArray(images)
            self.randomSortArray(images)

            for index in 0..<self.views.count{
                let gridInfo = self.views[index]
                let imageInfo = images[index]
                
                if(index != self.views.count-1){
                    gridInfo.imageInfo = imageInfo as? JKImageInfo
                }
                gridInfo.location = index
                
                let x = (gridInfo.imageView?.tag)! % self.numberOfRows
                let y = (gridInfo.imageView?.tag)! / self.numberOfRows
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    gridInfo.imageView?.center = CGPointMake(CGFloat(x)*w + w*0.5, CGFloat(y)*h + h*0.5)
                })
                gridInfo.location = index
            }
            
//            for item in self.views {
//                let x = (item.imageView?.tag)! % self.numberOfRows
//                let y = (item.imageView?.tag)! / self.numberOfRows
//
//                UIView.animateWithDuration(0.15, animations: { () -> Void in
//                    item.imageView?.center = CGPointMake(CGFloat(x)*w + w*0.5, CGFloat(y)*h + h*0.5)
//                })
//                item.location = (item.imageView?.tag)!
//
//                if(item != self.views.last){
//                    
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                        let rect = CGRectMake(CGFloat(x)*imageW, CGFloat(y)*imageH, CGFloat(imageW), CGFloat(imageH))
//                        let tempImage = UIImage.clipImage(self.image!, withRect: rect)
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            item.imageView?.image = tempImage
//                        })
//                    })
//                }
//            }
            
        }
    }
    
    func randomSortArray(array:NSMutableArray){
        let x = arc4randomInRange(0, to: self.views.count-1)
        let y = arc4randomInRange(0, to: self.views.count-1)
        array.exchangeObjectAtIndex(x, withObjectAtIndex: y)
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
        
        for index in 0..<self.numberOfGrids {
            let x = index % self.numberOfRows
            let y = index / self.numberOfRows
            let imageview = UIImageView(frame: CGRectMake(CGFloat(x)*w, CGFloat(y)*h, CGFloat(w), CGFloat(h)))
            imageview.center = CGPointMake(CGFloat(x)*w + w*0.5, CGFloat(y)*h + h*0.5)
            imageview.contentMode = .ScaleAspectFit
            imageview.layer.borderWidth = 1
            imageview.layer.borderColor = UIColor.whiteColor().CGColor
            imageview.layer.cornerRadius = 3
            imageview.clipsToBounds = true
            imageview.backgroundColor = (index == (self.numberOfGrids-1)) ? UIColor.whiteColor() : UIColor.randomColor()
            imageview.addTapGesturesTarget(self, action: Selector("imageviewTapGestures:"))
            imageview.tag = index
            
            let info = JKGridInfo.init(location: index, imageView: imageview)
            self.views.append(info)
            self.addSubview(imageview)
        }
        self.sendSubviewToBack((self.views.last?.imageView)!)
    }
    
    var isClick = false
    func imageviewTapGestures(recognizer:UITapGestureRecognizer){
        
        if(isClick){
            return
        }
        isClick = true
        
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
                    self.isClick = false
            })
            
        }else{
            
            isClick = false
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
    
}

extension UIImage
{
    /*!
    切割图片
    
    - parameter image: 需要切割的图片
    - parameter rect:  位置
    - returns: 切割后的图
    */
    class func clipImage(image:UIImage,withRect rect:CGRect) ->UIImage{
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