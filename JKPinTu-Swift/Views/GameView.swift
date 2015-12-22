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

public enum JKGridBorderType : Int {
    case up
    case left
    case down
    case right
    case other
}

struct Position {
    var position: Int
    var sort: Int
}

let randomSwapCount:Int = 25 /// 随机移动次数
let lastRandomSwapCount:Int = 2 //随机的时候需要记录最后移动位置的个数，防止随机移动的时候一直在某几个位置之前变动，默认记录最后2个位置


class GameView: UIView {

    private var swapNum = randomSwapCount //随机移动次数
    
    /// 最后两次移动过的点
    private var lastPositions:[Int] = []
    
    /// 每个格子信息
    private var views = [JKGridInfo]()
    /// 移动的路径
    private var positions:[Position] = []

    /// 是否正在移动
    private var isMoving = false
    
    /// 总的格子数
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
    
    /// 游戏类型
    var gameMode:JKGameMode = .normal{
        
        didSet{
            self.resetViews()
        }
    }
    
    /*!
    检测游戏是否结束：location 与 sort 能匹配上则游戏结束
    
    - returns:
    */
    func checkGameOver()->Bool{
        
        var succ = true
        for item in self.views{
            
            if(item.sort != item.location){
                succ = false
                break
            }
            
            print("location: \(item.location)    sort: \(item.sort)" )
        }
        return succ
    }
    
    
    func reloadData(){
        
        let imageW = (image?.size.width)!/CGFloat(self.numberOfRows) * (image?.scale)!
        let imageH = (image?.size.height)!/CGFloat(self.numberOfRows) * (image?.scale)!

        for item in self.views {
            let x = (item.imageView?.tag)! % self.numberOfRows
            let y = (item.imageView?.tag)! / self.numberOfRows
            let rect = CGRectMake(CGFloat(x)*imageW, CGFloat(y)*imageH, CGFloat(imageW), CGFloat(imageH))
            let tempImage = UIImage.clipImage(self.image!, withRect: rect)
            item.imageView!.image = tempImage
            item.sort = self.views.indexOf(item)!
        }
    }
    
    /*!
    随机获取一个占位符附近的格子
    
    - parameter placeholder: 占位符
    
    - returns:
    */
    func randomGridNearbyPlaceholder(placeholder:JKGridInfo) -> JKGridInfo{
        
        var nearPositions:[Int] = []
        
        let types = self.borderType(placeholder)
        
        if (types.contains(.left) == false) {
            nearPositions.append(placeholder.location-1)
        }
        if (types.contains(.right) == false) {
            nearPositions.append(placeholder.location+1)
        }
        if (types.contains(.up) == false) {
            nearPositions.append(placeholder.location-self.numberOfRows)
        }
        if (types.contains(.down) == false) {
            nearPositions.append(placeholder.location+self.numberOfRows)
        }
        
        let randomIndex = arc4randomInRange(0, to: nearPositions.count)
        let randomPosition = nearPositions[randomIndex]

//        为了防止随机出来的全部点都已经在记录数组中造成死循环，这里需要判断随机点数组与记录点数组交集
        
        var nextGrid:JKGridInfo?
        for item in self.views{
            if item.location == randomPosition {
                nextGrid = item
                break
            }
        }
        if nextGrid == nil{
            nextGrid = self.randomGridNearbyPlaceholder(placeholder)
        }
        print("随机出来的点\(nextGrid?.location)  上次的点：\(self.lastPositions)")
        
        if (self.lastPositions.contains((nextGrid?.location)!)) {
            print("包含了前两次的点 重新再来")
            nextGrid = self.randomGridNearbyPlaceholder(placeholder)
        }else{
            self.lastPositions.append((nextGrid?.location)!)
        }
        
        if self.lastPositions.count > lastRandomSwapCount{
            self.lastPositions.removeFirst()
        }
        print("随机结束，需要移动到这个点：\(nextGrid?.location)   记录：\(self.lastPositions)")
        return nextGrid!
    }
    
    /*!
    获取占位符对象
    
    - returns: 占位符对象
    */
    func placeholderGridInfo() -> JKGridInfo{
        
        var p:JKGridInfo?
        for item in self.views {
            if item.sort == self.numberOfGrids - 1 {
                p = item
                break
            }
        }
        return p!
    }
    
    
    /*!
    自动随机移动格子

    */
    private func atomaticMove(){
        
        if self.swapNum <= 0 {
            self.swapNum = randomSwapCount
            return
        }
        let placeholder = self.placeholderGridInfo()
        
        let nextGrid = self.randomGridNearbyPlaceholder(placeholder)
        
        self.moveGrid(from: nextGrid, to: placeholder, durationPerStep: 0.25, completion: { () -> Void in
            self.swapNum = self.swapNum - 1
            self.atomaticMove()
        })
    }
    
    func randomGrids(){
        
        if self.swapNum <= 0{
            self.swapNum = randomSwapCount
        }
        self.atomaticMove()
    }
    
    
    func resetViews(){
        
        self.lastPositions.removeAll()
        self.positions.removeAll()
        for item in self.views {
            item.imageView!.removeFromSuperview()
        }
        self.views.removeAll()
        self.setupSubviews()
        
        if(self.image != nil){
            self.reloadData()
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
        
        for index in 0..<self.numberOfGrids {
            let x = index % self.numberOfRows
            let y = index / self.numberOfRows
            let imageview = UIImageView(frame: CGRectMake(CGFloat(x)*w, CGFloat(y)*h, CGFloat(w), CGFloat(h)))
            imageview.center = CGPointMake(CGFloat(x)*w + w*0.5, CGFloat(y)*h + h*0.5)
            imageview.contentMode = .ScaleAspectFit
            imageview.layer.borderWidth = (index == (self.numberOfGrids-1) && self.gameMode == .normal) ? 5 : 1
            imageview.layer.borderColor = (index == (self.numberOfGrids-1) && self.gameMode == .normal) ? UIColor.randomColor().CGColor : UIColor.whiteColor().CGColor
            imageview.layer.cornerRadius = (index == (self.numberOfGrids-1) && self.gameMode == .normal) ? 6 : 3
            imageview.clipsToBounds = true
            imageview.tag = index
            
            /// 常规模式用单击
            imageview.userInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: Selector("imageviewTapGestures:"))
            tapGesture.numberOfTapsRequired = 1
            imageview.addGestureRecognizer(tapGesture)
            
            /// 对换模式用轻扫手势
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
        
        if(isMoving){
            return
        }
        isMoving = true
        
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
                self.isMoving = false
            })
        }else{
            isMoving = false
            print(clickInfo)
        }
    }
    
    func imageviewTapGestures(recognizer:UITapGestureRecognizer){
        
        if (self.gameMode == .swapping){
            return
        }
        
        if(isMoving){
            return
        }
        isMoving = true
        
        let clickInfo = self.clickedGrid(recognizer.view!)
        
        let placeholder = self.placeholderGridInfo()
        if(self.checkMoveFrom(clickInfo, placeholderInfo: placeholder)){
            
            self.moveGrid(from: clickInfo, to: placeholder, completion: { () -> Void in
                self.isMoving = false
            })
            
        }else{
            isMoving = false
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
    
    /*!
    交换两个格子的位置 < 随机格子与点击格子的时候使用 >
    
    - parameter g1:              g1
    - parameter g2:              g2
    - parameter durationPerStep: 动画时间
    - parameter completion:      动画回调
    */
    private func moveGrid(from g1:JKGridInfo, to g2:JKGridInfo, durationPerStep: NSTimeInterval = 0.25 ,completion:()->Void){
        
        /// 位置信息
        let location1 = g1.location
        let location2 = g2.location
        /// 坐标
        let p1 = g1.imageView?.center
        let p2 = g2.imageView?.center
        
        let  position1 = Position(position: g2.location, sort: g2.sort)
        let  position2 = Position(position: g1.location, sort: g1.sort)
        
        self.positions.append(position1)
        self.positions.append(position2)
        
        /*!
        *
        *  互换坐标以及位置序号
        */
        UIView.animateWithDuration(durationPerStep, animations: { () -> Void in
            g1.imageView.center = p2!
            g2.imageView.center = p1!
            }, completion: { (finish) -> Void in
                g1.location = location2
                g2.location = location1
                
                let g1Index = self.views.indexOf(g1)
                let g2Index = self.views.indexOf(g2)
                self.views.exchangeObjectAtIndex(g1Index!, withObjectAtIndex: g2Index!)
                completion()
                self.printList()
        })
    }
    
    /*!
    交换两个格子的位置 < 自动完成的时候使用 >
    
    - parameter g1:              g1
    - parameter g2:              g2
    - parameter durationPerStep: 动画时间
    - parameter completion:      动画回调
    */
    private func reverseMoveGrid(from g1:JKGridInfo, to g2:JKGridInfo, durationPerStep: NSTimeInterval = 0.25 ,completion:()->Void){
        
        /// 位置信息
        let location1 = g1.location
        let location2 = g2.location
        /// 坐标
        let p1 = g1.imageView?.center
        let p2 = g2.imageView?.center

        UIView.animateWithDuration(durationPerStep, animations: { () -> Void in
            g1.imageView.center = p2!
            g2.imageView.center = p1!
            }, completion: { (finish) -> Void in
                g1.location = location2
                g2.location = location1
                
                let g1Index = self.views.indexOf(g1)
                let g2Index = self.views.indexOf(g2)
                self.views.exchangeObjectAtIndex(g1Index!, withObjectAtIndex: g2Index!)
                completion()
                self.printList()
        })
    }

    
    func completeAllGridByPositions(){
        
        print(self.positions)
        let count = self.positions.count
        
        if count < 2 {
            return
        }
        
//        let p1 = self.positions.last///最后一个是自己的当前位置
        let p2 = self.positions[count - 2] ///倒数第2个
        
        let placeholder = self.placeholderGridInfo()
        let lastGridInfo = self.views[p2.position]
        self.reverseMoveGrid(from: placeholder, to: lastGridInfo) { () -> Void in
            self.positions.removeLast()
            self.completeAllGridByPositions()
        }
    }
    
    /*!
    检测点击的格子相对于占位符能否移动
    
    - parameter clickInfo: 点击的格子信息
    - parameter p:         占位的格子信息
    
    - returns: 能否移动
    */
    private func checkMoveFrom(clickInfo:JKGridInfo ,placeholderInfo p:JKGridInfo) -> Bool{
        
        let otherPosintion = -1
        let upViewLocation = self.borderType(p).contains(.up) ? otherPosintion:(p.location - self.numberOfRows)
        let downViewLocation = self.borderType(p).contains(.down) ? otherPosintion:(p.location + self.numberOfRows)
        let leftViewLocation = self.borderType(p).contains(.left) ? otherPosintion:(p.location - 1)
        let rightViewLocation = self.borderType(p).contains(.right) ? otherPosintion:(p.location + 1)
        
        if(clickInfo.location == upViewLocation || clickInfo.location == downViewLocation || clickInfo.location == leftViewLocation || clickInfo.location == rightViewLocation){
            return true
        }
        return false
    }
    
    /*!
    格子的边界类型情况
    
    - parameter item: 格子信息
    
    - returns: 边界信息
    */
    func borderType(item:JKGridInfo) -> [JKGridBorderType]{
        
        var types:[JKGridBorderType] = []
        /*!
        *  是否为左边界的点
        */
        if ((item.location)%self.numberOfRows == 0){
            types.append(.left)
        }
        /*!
        *  是否为右边界
        */
        if ((item.location+1)%self.numberOfRows == 0){
            types.append(.right)
        }
        /*!
        *  是否为上边界
        */
        if (item.location < self.numberOfRows){
            types.append(.up)
        }
        /*!
        *  是否为下边界
        */
        if (item.location >= self.numberOfGrids - self.numberOfRows){
            types.append(.down)
        }
        
        /*!
        *  不是边界点就是中间的拉~
        */
        if types.count == 0 {
            types.append(.other)
        }
        return types
    }
    
    func printList() {
        print("------------------------")
        var text = ""
        for temp in self.views {
            text += "\t \(temp.sort) \t"
            if (temp.location + 1) % self.numberOfRows == 0 {
                text += "\n"
            }
        }
        print(text)
    }
}

