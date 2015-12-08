//
//  GameView.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/5.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit

class GameView: UIView {

    private var views = [UIImageView]()

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
        
        let w = self.bounds.width/3
        let h = self.bounds.height/3
        for index in 0..<8 {
            let x = index%3
            let y = index/3
            let imageview = UIImageView(frame: CGRectMake(CGFloat(x)*w, CGFloat(y)*h, CGFloat(w), CGFloat(h)))
            imageview.contentMode = .ScaleAspectFit
//            imageview.backgroundColor = (index/2==0) ? UIColor.redColor() : UIColor.whiteColor()
//            self.views.append(imageview)
            self.addSubview(imageview)
        }
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


