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
        let refreshButton = UIBarButtonItem.init(title: "换图", style: .Plain, target: self, action: Selector("refresh"))
        
        self.navigationItem.rightBarButtonItems = [refreshButton,settingButton]
        
        // Do any additional setup after loading the view.
        let rect = CGRectMake(20, 20, SCREEN_WIDTH - 2*20, SCREEN_WIDTH - 2*20)
        self.gameView = GameView(frame: rect)
        gameView.backgroundColor = UIColor.clearColor()
//        gameView.numberOfRows = 5
        self.view.addSubview(gameView)
        
        self.refresh()
    }
    
    func settingButtonClick(){
        
//        self.gameView.numberOfRows = arc4randomInRange(3, to: 9)
        
        let alertController = UIAlertController(title: "设置", message: "", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)

        let a = UIAlertAction(title: "3*3", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.gameView.numberOfRows = 3
        }
        alertController.addAction(a)
        
        let b = UIAlertAction(title: "4*4", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.gameView.numberOfRows = 4
        }
        alertController.addAction(b)
        
        let c = UIAlertAction(title: "5*5", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.gameView.numberOfRows = 5
        }
        alertController.addAction(c)
        
        let d = UIAlertAction(title: "6*6", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.gameView.numberOfRows = 6
        }
        alertController.addAction(d)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func refresh(){
        
        let index = arc4randomInRange(0, to: 4)
        let imageName = "00" + String(index)
        self.gameView.image = UIImage(named: imageName)
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
