//
//  MapViewController.swift
//  instabtbu
//
//  Created by 陈禹志 on 15/2/19.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate, UITabBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
//        var tabbar = UITabBar(frame:CGRectMake(0, self.view.frame.height-49, self.view.frame.width, 49))
//        var item1 = UITabBarItem(title: "地铁线路", image: nil, tag: 0)
//        var item2 = UITabBarItem(title: "公交线路", image: nil, tag: 1)
//        tabbar.setItems([item1,item2], animated: true)
//        self.view.addSubview(tabbar)
//        tabbar.delegate = self
        
        let scrollview = UIScrollView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height-64))
        scrollview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollview)
        scrollview.delegate = self
        scrollview.tag = 10
        
        let pic = UIImageView(image: UIImage(named: "ditie_bjsubway"))
        let width = self.view.frame.width
        pic.frame = CGRect(x: 0, y: 0, width: width, height: width/450*399)
        scrollview.addSubview(pic)
        pic.tag = 11
        
        scrollview.maximumZoomScale = 10
        scrollview.minimumZoomScale = 1
        scrollview.bouncesZoom = false
        scrollview.contentSize = pic.frame.size
        
        self.navigationItem.title = "地铁"
        
        let leftDrawerButton = MMDrawerBarButtonItem(target: self, action: "leftDrawerButtonPress")
        self.navigationItem.leftBarButtonItem = leftDrawerButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftDrawerButtonPress(){
        drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0] as UIView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
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
