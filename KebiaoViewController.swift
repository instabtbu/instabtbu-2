//
//  KebiaoViewController.swift
//  playswift
//
//  Created by 陈禹志 on 14/12/25.
//  Copyright (c) 2014年 com.insta. All rights reserved.
//

import UIKit
import Foundation

class KebiaoViewController: UIViewController, UIAlertViewDelegate {
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    var chuli:NSMutableArray = NSMutableArray(capacity: 100)
    let iSave = NSUserDefaults(suiteName: "iSaveJW")
    var xueqiA:NSMutableArray = NSMutableArray(capacity: 30)
    var x: [CGFloat] = [20,240,50]
    var y: [CGFloat] = [84,140,156,120]
    var w: [CGFloat] = [200,60,100]
    var h: [CGFloat] = [20]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        if view.frame.width == 768 {
            x = [40,600,30]
            y = [104,200,182,160]
            w = [400,120,200]
            h = [40]
        }
        else if view.frame.width == 414 {
            x = [20,320,26]
        }
        else if view.frame.width == 375 {
            x = [20,290,32]
        }
        //显示学期
        var dangqian = UILabel(frame: CGRectMake(x[0], y[0], w[0], h[0]))
        dangqian.text = "当前学期：" + delegate.xueqi
        self.view.addSubview(dangqian)
        //选学期按钮
        var xuanxueqi: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        xuanxueqi.frame = CGRectMake(x[1], y[0], w[1], h[0])
        xuanxueqi.setTitle("学期", forState: UIControlState.Normal)
        xuanxueqi.backgroundColor = UIColor.whiteColor()
        xuanxueqi.addTarget(self, action: "xuanXQ", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(xuanxueqi)
        //整体滑动
        var scrollview = UIScrollView(frame: CGRectMake(0, y[1], self.view.frame.width, self.view.frame.height-y[1]))
        scrollview.backgroundColor = UIColor.whiteColor()
        scrollview.bounces = false
        self.view.addSubview(scrollview)
        //滑动内容
        var myView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, y[2]*6))
        scrollview.addSubview(myView)
        scrollview.contentSize = myView.frame.size
        
        if delegate.xueqi != "" {
            for i in 0...5 {
                for j in 0...6 {
                    if !(delegate.kebiao.objectAtIndex(i*7+j) as NSString).isEqualToString(""){
                        var chulihou = chuli((delegate.kebiao.objectAtIndex(i*7+j) as NSString))
                        var aCgf = self.view.frame.width * CGFloat(j)
                        var kechengT = UITextView(frame: CGRectMake(aCgf/5+self.view.frame.width/100, CGFloat(i)*y[2], self.view.frame.width*9/50, y[2]))
                        //kechengT.scrollEnabled = false
                        kechengT.bounces = false
                        chuli.addObject(chulihou)
                        kechengT.text = chulihou
                        if view.frame.width == 768 {
                            kechengT.font = UIFont(name: "Helvetica", size: 16)
                        }
                        else {
                            kechengT.font = UIFont(name: "Helvetica", size: 11)
                        }
                        scrollview.addSubview(kechengT)
                        //println("\(kechengT.text)")
                    } else {
                        chuli.addObject("")
                    }
                }
            }
            if !delegate.cundang {
                iSave?.setObject(delegate.kebiao, forKey: "kebiao")
                iSave?.setObject(delegate.xueqi, forKey: "xueqi")
                delegate.cundang = true
            }
        }
        else {
            xuanXQ()
            println("xuanxueqi")
        }
        //星期
        var xingqi = ["一","二","三","四","五"]
        for i in 0...4 {
            var aCgf = myView.frame.width * CGFloat(i)
            var xingqiji = UILabel(frame: CGRectMake(aCgf/5 + myView.frame.width/x[2], y[3], w[2], h[0]))
            xingqiji.text = "星期\(xingqi[i])"
            if view.frame.width == 768 {
                xingqiji.font = UIFont(name: "Helvetica", size: 34)
            }
            self.view.addSubview(xingqiji)
        }
        //表格纵线
        for i in 1...4 {
            var xian = UIView(frame: CGRectMake(myView.frame.width*CGFloat(i)/5, y[3], 1, self.view.frame.height))
            xian.backgroundColor = UIColor.blackColor()
            self.view.addSubview(xian)
        }
        //表格横线
        for i in 1...5 {
            var hengxian = UIView(frame: CGRectMake(0, CGFloat(i)*y[2], view.frame.width, 1))
            hengxian.backgroundColor = UIColor.blackColor()
            scrollview.addSubview(hengxian)
        }
        //表头线
        var xian = UIView(frame: CGRectMake(0, y[1], view.frame.width, 1))
        xian.backgroundColor = UIColor.blackColor()
        self.view.addSubview(xian)
        println("\(view.frame.width)")
        //ipad文字
        if view.frame.width == 768 {
            dangqian.font = UIFont(name: "Helvetica", size: 34)
            xuanxueqi.titleLabel?.font = UIFont(name: "Helvetica", size: 34)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chuli(instr:NSString) -> NSString{
        var a1 = sReplace(instr, findstr: "<nobr><br>", repstr: "\n")
        var a2 = sReplace(a1, findstr: "<br><nobr>", repstr: "\n")
        var a3 = sReplace(a2, findstr: "<br><br>", repstr: "\n")
        var a4 = sReplace(a3, findstr: "<br>", repstr: "\n")
        var s1 = a4.rangeOfString("&nbsp;")
        var r1 = Range(start: (s1.toRange()?.endIndex)! , end: a4.length)
        var a5:NSString = a4.substringWithRange(NSRange(r1))
        var s2 = a5.rangeOfString("</div>")
        var r2 = Range(start: 0, end: (s2.toRange()?.startIndex)!)
        var a6 = a5.substringWithRange(NSRange(r2))
        var a7 = sReplace(a6, findstr: " ", repstr: "")
        a7 = a7.substringToIndex(a7.length-1)
        return a7
    }
    
    func sReplace(instr:NSString,findstr:NSString,repstr:NSString) -> NSString {
        var aRange = instr.rangeOfString(findstr)
        var inM = NSMutableString(string: instr)
        while aRange.toRange() != nil {
            inM.replaceCharactersInRange(aRange, withString: repstr)
            aRange = inM.rangeOfString(findstr)
        }
        return inM
    }
    
    func sCount(instr:NSString,findstr:NSString) -> NSNumber {
        var iC = 0
        var aRange = instr.rangeOfString(findstr)
        var inM = NSMutableString(string: instr)
        while aRange.toRange() != nil {
            inM.replaceCharactersInRange(aRange, withString: "")
            aRange = inM.rangeOfString(findstr)
            iC++
        }
        return iC
    }
    
    func btnBackClicked(sender:AnyObject) {
        self.navigationController?.navigationBar.popNavigationItemAnimated(true)
    }
    
    func xuanXQ() {
        if delegate.cundang {
            JWGLViewController().logon(delegate.jwusn!, sendpsw: delegate.jwpsw!)
        }
        var result = JWGLViewController().sGet("http://jwgl.btbu.edu.cn/tkglAction.do?method=kbxxXs")
        if result != "" {
            var a = oc().iRegular("<option value=\".*?\".*?>(.*?)</option>", and: result, withx: 1)
            xueqiA = NSMutableArray(capacity: 30)
            for i in a {
                var nian = iSave?.stringForKey("SaveUsn")
                var nianqian = 2000 + ((nian! as NSString).substringToIndex(2) as NSString).integerValue
                var xuehaonian = (i as NSString).integerValue
                if xuehaonian >= nianqian {
                    xueqiA.addObject(i)
                    println("\(xuehaonian)")
                }
            }
            var aAl = UIAlertView(title: "选择学期", message: "", delegate: self, cancelButtonTitle: "取消")
            for i in xueqiA {
                aAl.addButtonWithTitle("\(i)")
            }
            aAl.show()
        }
        else {
            var aAl = UIAlertView(title: "选择学期失败", message: "请确认和教务系统间通讯无碍", delegate: self, cancelButtonTitle: "确定")
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            delegate.xueqi = alertView.buttonTitleAtIndex(buttonIndex)
            delegate.kebiao = NSMutableArray(capacity: 100)
            if JWGLViewController().schedule() {
                delegate.cundang = false
                for i in self.view.subviews {
                    i.removeFromSuperview()
                }
                self.viewDidLoad()
            }
        }
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
