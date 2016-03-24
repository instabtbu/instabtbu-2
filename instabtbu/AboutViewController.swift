//
//  AboutViewController.swift
//  instabtbu
//
//  Created by 陈禹志 on 15/2/17.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit
import MMDrawerController

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        var width = self.view.frame.width
        var Aboutus = UIImageView()
        if width >= 768{
            Aboutus = UIImageView(frame: CGRect(x: (width-512)/2, y: 128, width: 512, height: 512/720*710))
        }else{
            Aboutus = UIImageView(frame: CGRect(x: 0, y: 64, width: width, height: width/720*710))
        }
        Aboutus.image = UIImage(named: "about_us")
        self.view.addSubview(Aboutus)

        
        var scrollview = UIScrollView()
        if width >= 768{
            scrollview = UIScrollView(frame: CGRect(x: (width-512)/2, y: 128 + 512/720*710, width:512, height: self.view.frame.height - 512/720*710 - 128))
            width = 512
        }
        else{
            scrollview = UIScrollView(frame: CGRect(x: 0, y: 64 + width/720*710, width:width, height: self.view.frame.height - width/720*710 - 64))
        }
        scrollview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollview)
        
        var name:[String] = ["ypw","lxm","lxw","cyz","lzy"]
        var sumheight:CGFloat = 0
        for i in 0...4 {
            let poi = UIImageView(frame: CGRect(x: 0, y: sumheight, width: width, height: width*0.15))
            poi.image = UIImage(named: "about_\(name[i])")
            scrollview.addSubview(poi)
            sumheight += width*0.15
        }
        scrollview.contentSize = CGSize(width: width, height: sumheight)
        
        width = self.view.frame.width
        if width >= 768{
            scrollview.frame = CGRect(x: (width-512)/2, y: 128 + 512/720*710, width:512, height: sumheight)
        }
        self.navigationItem.title = "关于我们"
        
        let leftDrawerButton = MMDrawerBarButtonItem(target: self, action: #selector(AboutViewController.leftDrawerButtonPress))
        self.navigationItem.leftBarButtonItem = leftDrawerButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftDrawerButtonPress(){
        drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
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
