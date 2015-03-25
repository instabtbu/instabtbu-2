//
//  MapViewController.swift
//  instabtbu
//
//  Created by 陈禹志 on 15/2/19.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        var scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scrollview.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollview)
        scrollview.delegate = self
        
        var subway = UIImageView(image: UIImage(named: "ditie_bjsubway"))
        var width = self.view.frame.width
        subway.frame = CGRect(x: 0, y: 0, width: width, height: width/450*399)
        scrollview.addSubview(subway)
        
        scrollview.maximumZoomScale = 10
        scrollview.minimumZoomScale = 1
        scrollview.bouncesZoom = false
//        scrollview.bounces = false
        scrollview.contentSize = subway.frame.size
    }
    //只有左侧滑动
    //    override func viewDidAppear(animated: Bool) {
    //        drawerController.openDrawerGestureModeMask = OpenDrawerGestureMode.BezelPanningCenterView
    //    }
    //
    //    override func viewWillDisappear(animated: Bool) {
    //        drawerController.openDrawerGestureModeMask = OpenDrawerGestureMode.All
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews[0] as? UIView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        
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
