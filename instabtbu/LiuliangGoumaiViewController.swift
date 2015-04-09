//
//  LiuliangGoumaiViewController.swift
//  instabtbu
//
//  Created by 杨培文 on 15/4/9.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class LiuliangGoumaiViewController: UIViewController, UIAlertViewDelegate {
    
    var post:String?
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var foc = oc()
        if(buttonIndex==1){
            var rec = foc.iPOSTwithurl("https://self.btbu.edu.cn/cgi-bin/nacgi.cgi", withpost: post)
            var m:NSArray = foc.iRegular("align=\"center\">(.*)<br>", and: rec, withx: 1)
            if m.count > 0{
                var rec2 = m.objectAtIndex(0) as NSString
                rec2 = rec2.stringByReplacingOccurrencesOfString("<br>", withString: "\n")
                var alert = UIAlertView(title: "提示", message: rec2, delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }else{
                var alert = UIAlertView(title: "提示", message: "申请包月失败", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }

        }
    }
    
    @IBAction func bagb(sender: AnyObject) {
        println(8)
        if let data = NSUserDefaults(suiteName: "data")
        {
            var num=data.stringForKey("num")
            var psw=data.stringForKey("psw")
            if (num != nil) {
                post = "textfield=" + num! + "&textfield2=" + psw!
                    + "&jsidx=1&radio=2&Submit=%CC%E1%BD%BB&nacgicmd=2"
                var sure = UIAlertView(title: "提示", message: "确认包8GB流量吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                sure.show()
            }else{
                var sure = UIAlertView(title: "提示", message: "请先登录后再进行该操作", delegate: self, cancelButtonTitle: "确定")
                sure.show()
            }
        }
    }

    @IBAction func ershigb(sender: AnyObject) {
        println(20)
        if let data = NSUserDefaults(suiteName: "data")
        {
            var num=data.stringForKey("num")
            var psw=data.stringForKey("psw")
            if (num != nil) {
                post = "textfield=" + num! + "&textfield2=" + psw!
                + "&jsidx=2&radio=2&Submit=%CC%E1%BD%BB&nacgicmd=2"
                var sure = UIAlertView(title: "提示", message: "确认包20GB流量吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                sure.show()
            }else{
                var sure = UIAlertView(title: "提示", message: "请先登录后再进行该操作", delegate: self, cancelButtonTitle: "确定")
                sure.show()
            }
        }
    }
}
