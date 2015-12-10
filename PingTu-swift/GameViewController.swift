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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拼图"
        
        let settingButton = UIBarButtonItem.init(title: "设置", style: .Plain, target: self, action: Selector("settingButtonClick"))
        let refreshButton = UIBarButtonItem.init(title: "换图", style: .Plain, target: self, action: Selector("changePhotoClick"))
        let huabanButton = UIBarButtonItem.init(title: "花瓣", style: .Plain, target: self, action: Selector("huabanClick"))
        self.navigationItem.rightBarButtonItems = [huabanButton,refreshButton,settingButton]
        
        // Do any additional setup after loading the view.
        let rect = CGRectMake(20, 20, SCREEN_WIDTH - 2*20, SCREEN_WIDTH - 2*20)
        self.gameView = GameView(frame: rect)
        gameView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(gameView)
        self.changePhotoClick()
        
        
        let chechButton = UIButton(type: .Custom)
        chechButton.setTitle("check", forState: .Normal)
        chechButton.setTitleColor(UIColor.randomColor(), forState: .Normal)
        chechButton.addTarget(self, action: Selector("checkGameOver"), forControlEvents: .TouchUpInside)
        chechButton.frame = CGRectMake(0, self.gameView.frame.origin.y + self.gameView.frame.size.width + 20, SCREEN_WIDTH, 30)
        self.view.addSubview(chechButton)
    }
    
    func huabanClick(){
    
        let nav:JKHBNavigationController = JKHBNavigationController.initJKHBNavigationController()
        self.presentViewController(nav, animated: true) { () -> Void in
        }
    }
    
    func settingButtonClick(){
        
        let alertController = UIAlertController(title: "设置", message: "", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let array = [3,4,5,6,7]
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
    }
    
    
    func checkGameOver(){
        
        if(self.gameView.checkGameOver() == true){
            print("恭喜拼图成功，游戏结束")
        }else{
            print("还没拼出来，加油哦")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
