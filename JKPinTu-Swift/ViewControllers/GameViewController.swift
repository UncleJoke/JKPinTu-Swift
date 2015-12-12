//
//  GameViewController.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/5.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit



class GameViewController: BaseViewController {
    
    
    var gameView : GameView!
    var preView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        self.extendedLayoutIncludesOpaqueBars = true
        ;
        self.title = "拼图"
        
        let settingButton = UIBarButtonItem.init(title: "设置", style: .Plain, target: self, action: Selector("settingButtonClick"))
        let refreshButton = UIBarButtonItem.init(title: "换图", style: .Plain, target: self, action: Selector("changePhotoClick"))
        let huabanButton = UIBarButtonItem.init(title: "花瓣", style: .Plain, target: self, action: Selector("huabanClick"))
        self.navigationItem.rightBarButtonItems = [huabanButton,refreshButton,settingButton]
        
        // Do any additional setup after loading the view.
        let rect = CGRectMake(20, 10, SCREEN_WIDTH - 2*20, SCREEN_WIDTH - 2*20)
        self.gameView = GameView(frame: rect)
        gameView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(gameView)
        
        let chechButton = UIButton(type: .Custom)
        chechButton.setTitle("check", forState: .Normal)
        chechButton.setTitleColor(UIColor.randomColor(), forState: .Normal)
        chechButton.addTarget(self, action: Selector("checkGameOver:"), forControlEvents: .TouchUpInside)
        chechButton.frame = CGRectMake(0, self.gameView.frame.origin.y + self.gameView.frame.size.height + 10, SCREEN_WIDTH, 20)
        self.view.addSubview(chechButton)
        
        self.preView = UIImageView()
        self.preView.frame = CGRectMake(0, chechButton.frame.origin.y + chechButton.frame.size.height + 15, SCREEN_WIDTH, self.view.bounds.size.height - chechButton.frame.origin.y - chechButton.frame.size.height - STATUSBARHEIGHT - TOPBARHEIGHT - 30)
        self.preView.contentMode = .ScaleAspectFit
        self.view.addSubview(self.preView)
        
        self.changePhotoClick()
    }
    
    func huabanClick(){
    
        let nav:JKHBNavigationController = JKHBNavigationController.initJKHBNavigationController()
        nav.imageBlock = { (image) -> Void in
            let newImage = self.dealWithImage(image as! UIImage)
            self.gameView.image = newImage
            self.preView.image = newImage
        }

        self.presentViewController(nav, animated: true) { () -> Void in
        }
    }
    
    func dealWithImage(image:UIImage) -> UIImage {
        let w = image.size.width
        let h = image.size.height
        let imageWidth = w>h ? h: w
        let px = w>h ? (w - imageWidth)*0.5 : 0
        let py = w>h ? 0 : (h - imageWidth)*0.5
        let newImage = UIImage.clipImage(image, withRect: CGRectMake(px, py, imageWidth, imageWidth))
        return newImage
    }
    
    func settingButtonClick(){
        
        let alertController = UIAlertController(title: "设置", message: "", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let array = [3,4,5,6]
        for value in array{
            let name = String(value) + "*" +  String(value)
            let a = UIAlertAction(title: name, style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.gameView.numberOfRows = value
            }
            alertController.addAction(a)
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func changePhotoClick(){
        
        let index = arc4randomInRange(0, to: 4)
        let imageName = "00" + String(index)
        self.gameView.image = UIImage(named: imageName)
        self.preView.image = UIImage(named: imageName)
    }
    
    
    func checkGameOver(button:UIButton){
        
        if(self.gameView.checkGameOver() == true){
            button.setTitle("恭喜拼图成功，游戏结束", forState: .Normal)
        }else{
            button.setTitle("check again", forState: .Normal)
        }
    }
    
}
