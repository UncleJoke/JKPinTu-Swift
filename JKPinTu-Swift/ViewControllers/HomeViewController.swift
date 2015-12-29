//
//  HomeViewController.swift
//  PingTu-swift
//
//  Created by bingjie-macbookpro on 15/12/5.
//  Copyright © 2015年 Bingjie. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.randomColor()
    
    }
    @IBAction func startButtonClick(sender: AnyObject) {
        
//        let tagVC = JKHBTagViewController()
//        self.navigationController?.pushViewController(tagVC, animated: true)
//        return

        let pVC:GameViewController = GameViewController();
        self.navigationController!.pushViewController(pVC, animated: true);
        
    }

    @IBAction func otherButtonClick(sender: AnyObject) {
        let pVC:OtherViewController = OtherViewController();
        self.navigationController!.pushViewController(pVC, animated: true);
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
