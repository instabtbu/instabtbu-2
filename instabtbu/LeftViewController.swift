//
//  LeftViewController.swift
//  instabtbu
//
//  Created by 陈禹志 on 15/2/13.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {
    
    var AButtonName:[String] = ["SW","JW","DT","GY"]
    var Buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 61/255, green: 63/255, blue: 79/255, alpha: 1)
        var TX = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 125))
        TX.image = UIImage(named: "TX")
        self.view.addSubview(TX)
        var Sumheight:CGFloat = 125
        for i in 0...3 {
            var AButton = UIButton(frame: CGRect(x: 0, y: Sumheight, width: 200, height: 43))
            Sumheight += 43
            AButton.setBackgroundImage(UIImage(named: "\(AButtonName[i])f"), forState: UIControlState.Normal)
            AButton.addTarget(self, action: "qiehuan:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(AButton)
            Buttons.append(AButton)
        }
        Buttons[0].setBackgroundImage(UIImage(named: "\(AButtonName[0])t"), forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func qiehuan(sender: UIButton) {
        var i = Int((sender.frame.maxY - 125)/43)
        println("\(i)")
        if i == 1 {
            navigation.viewControllers = [(stb.instantiateViewControllerWithIdentifier("SW") as ViewController)]
        }
        else if i == 2 {
            navigation.viewControllers = [(stb.instantiateViewControllerWithIdentifier("JW") as JWGLViewController)]
        }
        else if i == 3 {
            navigation.viewControllers = [MapViewController()]
        }
        else if i == 4 {
            navigation.viewControllers = [AboutViewController()]
        }
        var k = 0
        for j in Buttons {
            j.setBackgroundImage(UIImage(named: "\(AButtonName[k])f"), forState: UIControlState.Normal)
            k++
        }
        sender.setBackgroundImage(UIImage(named: "\(AButtonName[i-1])t"), forState: UIControlState.Normal)
        drawerController.closeDrawerAnimated(true, completion: nil)
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
