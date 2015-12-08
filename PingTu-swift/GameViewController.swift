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
        // Do any additional setup after loading the view.
        self.gameView = GameView(frame: self.view.bounds)
        gameView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(gameView)
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
