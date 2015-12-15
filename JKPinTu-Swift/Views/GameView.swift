//
//  GameView.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/5.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit

public enum JKGameMode : Int {
    
    case normal
    case swapping
    
}

class GameView: UIView {

    private var views = [JKGridInfo]()
    
    private var numberOfGrids:Int {
        get{
            return self.numberOfRows*self.numberOfRows
        }
    }
    /// 每一行/列有多少个格子
    var numberOfRows:Int = 3 {
        
        didSet{
            //设置了格子数之后需要更新控件信息
            self.resetViews()
        }
    }

    var image: UIImage? {
        didSet{
            //处理图片并显示
            self.reloadData()
        }
    }
    
    var gameMode:JKGameMode = .normal{
        
        didSet{
            self.resetViews()
        }
    }
    
    
    func checkGameOver()->Bool{
        
        var succ = true
        for item in self.views{

            if(item == self.views.last){
                break
            }
            
            if(item.imageInfo?.imageSortNumber != item.imageView.tag){
                succ = false
                return succ
            }
            
            print("location: \(item.location)    imageSortNumber: \(item.imageInfo?.imageSortNumber)   tag: \(item.imageView.tag)" )
        }
        
        return succ
    }
    
    
    func reloadData(){
        
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

        /*!
        *  @author Bingjie, 15-12-09 17:12:35
        *
        *  打乱的次数等于每行的格子数 * 2
        */
        for _ in 0..<self.numberOfRows*2{
            self.randomSortArray(images)
        }
        
        /*!
        *  @author Bingjie, 15-12-09 17:12:51
        *
        *  合并图片数组到self.views里边去
        */
        for index in 0..<self.views.count{
            let gridInfo = self.views[index]
            let imageInfo = images[index]
            
            gridInfo.imageInfo = imageInfo as? JKImageInfo
            gridInfo.location = index
            
            let x = (gridInfo.imageView?.tag)! % self.numberOfRows
            let y = (gridInfo.imageView?.tag)! / self.numberOfRows
            UIView.animateWithDuration(0.15, animations: { () -> Void in
                gridInfo.imageView?.center = CGPointMake(CGFloat(x)*w + w*0.5, CGFloat(y)*h + h*0.5)
            })
            gridInfo.location = index
        }
    }
    
    func resetViews(){
        
        for item in self.views {
            item.imageView.removeFromSuperview()
        }
        self.views.removeAll()
        self.setupSubviews()
        
        if(self.image != nil){
            self.reloadData()
        }
    }
    
    
    private func randomSortArray(array:NSMutableArray){
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
            imageview.layer.borderWidth = (index == (self.numberOfGrids-1) && self.gameMode == .normal) ? 4 : 1
            imageview.layer.borderColor = (index == (self.numberOfGrids-1) && self.gameMode == .normal) ? UIColor.randomColor().CGColor : UIColor.whiteColor().CGColor
            imageview.layer.cornerRadius = 3
            imageview.clipsToBounds = true
            imageview.tag = index
            
            imageview.userInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: Selector("imageviewTapGestures:"))
            tapGesture.numberOfTapsRequired = 1
            imageview.addGestureRecognizer(tapGesture)
            
            let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeFrom:"))
            leftSwipeGesture.direction = UISwipeGestureRecognizerDirection.Left
            imageview.addGestureRecognizer(leftSwipeGesture)
            
            let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeFrom:"))
            rightSwipeGesture.direction = UISwipeGestureRecognizerDirection.Right
            imageview.addGestureRecognizer(rightSwipeGesture)
            
            let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeFrom:"))
            upSwipeGesture.direction = UISwipeGestureRecognizerDirection.Up
            imageview.addGestureRecognizer(upSwipeGesture)
            
            let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipeFrom:"))
            downSwipeGesture.direction = UISwipeGestureRecognizerDirection.Down
            imageview.addGestureRecognizer(downSwipeGesture)
            
            
            let info = JKGridInfo(location: index, imageView: imageview)
            self.views.append(info)
            self.addSubview(imageview)
        }
        self.sendSubviewToBack((self.views.last?.imageView)!)
    }
    
    
    
    func handleSwipeFrom(recognizer:UISwipeGestureRecognizer) {
        
        if (self.gameMode == .normal){
            return
        }
        
        if(isClick){
            return
        }
        isClick = true
        
        let clickInfo = self.clickedGrid(recognizer.view!)
        var endLocation = 0
        
        let direction = recognizer.direction
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
            endLocation = clickInfo.location - 1
            break
        case UISwipeGestureRecognizerDirection.Right:
            endLocation = clickInfo.location + 1
            break
        case UISwipeGestureRecognizerDirection.Up:
            endLocation = clickInfo.location - self.numberOfRows
            break
        case UISwipeGestureRecognizerDirection.Down:
            endLocation = clickInfo.location + self.numberOfRows
            break
        default:
            break;
        }
        
        var placeholderInfo:JKGridInfo?
        for temp in self.views{
            if(temp.location == endLocation){
                placeholderInfo = temp
                break
            }
        }
        
        if(placeholderInfo != nil){
            self.moveGrid(from: clickInfo, to: placeholderInfo!, completion: { () -> Void in
                self.isClick = false
            })
        }else{
            isClick = false
            print(clickInfo)
        }
    }
    
    var isClick = false
    func imageviewTapGestures(recognizer:UITapGestureRecognizer){
        
        if (self.gameMode == .swapping){
            return
        }
        
        if(isClick){
            return
        }
        isClick = true
        
        let clickInfo = self.clickedGrid(recognizer.view!)
        
        let placeholderInfo = self.views.last
        if(self.checkMoveFrom(clickInfo, placeholderInfo: placeholderInfo!)){
            
            self.moveGrid(from: clickInfo, to: placeholderInfo!, completion: { () -> Void in
                self.isClick = false
            })
            
        }else{
            isClick = false
        }

        
    }
    
    private func clickedGrid(view:UIView) -> JKGridInfo{
        
        var clickInfo:JKGridInfo?
        for item in self.views {
            if((item.imageView?.isEqual(view)) == true){
                clickInfo = item
                break;
            }
        }
        return clickInfo!
    }
    
    private func moveGrid(from g1:JKGridInfo, to g2:JKGridInfo,completion:()->Void){
        
        /// 位置信息
        let location1 = g1.location
        let location2 = g2.location
        /// 坐标
        let p1 = g1.imageView?.center
        let p2 = g2.imageView?.center
        
        /*!
        *  @author Bingjie, 15-12-08 14:12:45
        *
        *  互换坐标以及位置序号
        */
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            g1.imageView.center = p2!
            g2.imageView.center = p1!
            }, completion: { (finish) -> Void in
                g1.location = location2
                g2.location = location1
                
                completion()

        })
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

