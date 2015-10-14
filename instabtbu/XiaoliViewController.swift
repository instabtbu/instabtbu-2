//
//  XiaoliViewController.swift
//  playswift
//
//  Created by 陈禹志 on 14/12/17.
//  Copyright (c) 2014年 com.insta. All rights reserved.
//

import UIKit

class XiaoliViewController: UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        let scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollview)
        var XLheight:CGFloat = 0
        var SUMheight:CGFloat = 0
        var Pixheight:[CGFloat] = [2124,1398,1674,1426,1392]
        for i in 1...5 {
            XLheight = self.view.frame.width/1440*Pixheight[i-1]
            let XL = UIImageView(frame: CGRect(x: 0, y: SUMheight, width: self.view.frame.width, height: XLheight))
            XL.image = UIImage(named: "xiaoli_0\(i)")
            SUMheight += XLheight
            scrollview.addSubview(XL)
        }
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: SUMheight)
        scrollview.bounces = false
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