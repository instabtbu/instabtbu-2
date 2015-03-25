//
//  AboutViewController.swift
//  instabtbu
//
//  Created by 陈禹志 on 15/2/17.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        var Aboutus = UIImageView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.width/720*710))
        Aboutus.image = UIImage(named: "about_us")
        self.view.addSubview(Aboutus)
        
        var scrollview = UIScrollView(frame: CGRect(x: 0, y: 64 + self.view.frame.width/720*710, width:self.view.frame.width, height: self.view.frame.height - self.view.frame.width/720*710 - 64))
        scrollview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollview)
        
        var name:[String] = ["ypw","lxm","lxw","cyz","lzy"]
        var sumheight:CGFloat = 0
        for i in 0...4 {
            var poi = UIImageView(frame: CGRect(x: 0, y: sumheight, width: self.view.frame.width, height: self.view.frame.width*0.15))
            poi.image = UIImage(named: "about_\(name[i])")
            scrollview.addSubview(poi)
            sumheight += self.view.frame.width*0.15
        }
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: sumheight)
        self.navigationItem.title = "关于我们"
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
