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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "刷新", style: .Plain, target: self, action: Selector("refresh"))
        
        // Do any additional setup after loading the view.
        let rect = CGRectMake(20, 20, SCREEN_WIDTH - 2*20, SCREEN_WIDTH - 2*20)
        self.gameView = GameView(frame: rect)
        gameView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(gameView)
        
        self.refresh()
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
