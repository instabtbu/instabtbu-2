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
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
        let dangqian = UILabel(frame: CGRectMake(x[0], y[0], w[0], h[0]))
        dangqian.text = "当前学期：" + delegate.xueqi
        self.view.addSubview(dangqian)
        
        //选学期按钮
        let xuanxueqi = UIButton(type: .System)
        xuanxueqi.frame = CGRectMake(x[1], y[0], w[1], h[0])
        xuanxueqi.setTitle("学期", forState: .Normal)
        xuanxueqi.backgroundColor = UIColor(red: 43.0/255.0, green: 188.0/255.0, blue: 93.0/255.0, alpha: 1.0)
        xuanxueqi.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        xuanxueqi.addTarget(self, action: #selector(KebiaoViewController.xuanXQ), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(xuanxueqi)
        
        //整体滑动
        let scrollview = UIScrollView(frame: CGRectMake(0, y[1], self.view.frame.width, self.view.frame.height-y[1]))
        scrollview.backgroundColor = UIColor.whiteColor()
        scrollview.bounces = false
        self.view.addSubview(scrollview)
        
        //滑动内容
        let myView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, y[2]*6))
        scrollview.addSubview(myView)
        scrollview.contentSize = myView.frame.size
        
        //有委托学期则证明查过课表 生成ui
        if delegate.xueqi != "" {
            for i in 0...5 {
                for j in 0...6 {
                    if (delegate.kebiao.objectAtIndex(i*7+j)as! String) != ""{
                        let chulihou = chuli((delegate.kebiao.objectAtIndex(i*7+j) as! String))
                        let aCgf = self.view.frame.width * CGFloat(j)
                        let kechengT = UITextView(frame: CGRectMake(aCgf/5+self.view.frame.width/100, CGFloat(i)*y[2], self.view.frame.width*9/50, y[2]))
                        //kechengT.scrollEnabled = false
                        kechengT.bounces = false
                        chuli.addObject(chulihou)
                        kechengT.text = chulihou
                        kechengT.editable = false
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
            //存档bool为假 储存新的课表和学期 另外学期和课表同时储存不用在jw中进行单一判断
            if !delegate.cundang {
                iSave?.setObject(delegate.kebiao, forKey: "kebiao")
                iSave?.setObject(delegate.xueqi, forKey: "xueqi")
                delegate.cundang = true
            }
        }
        else {
            xuanXQ()
            print("xuanxueqi")
        }
        //星期
        var xingqi = ["一","二","三","四","五"]
        for i in 0...4 {
            let aCgf = myView.frame.width * CGFloat(i)
            let xingqiji = UILabel(frame: CGRectMake(aCgf/5 + myView.frame.width/x[2], y[3], w[2], h[0]))
            xingqiji.text = "星期\(xingqi[i])"
            if view.frame.width == 768 {
                xingqiji.font = UIFont(name: "Helvetica", size: 34)
            }
            self.view.addSubview(xingqiji)
        }
        //表格纵线
        for i in 1...4 {
            let xian = UIView(frame: CGRectMake(myView.frame.width*CGFloat(i)/5, y[3], 1, self.view.frame.height))
            xian.backgroundColor = UIColor.blackColor()
            self.view.addSubview(xian)
        }
        //表格横线
        for i in 1...5 {
            let hengxian = UIView(frame: CGRectMake(0, CGFloat(i)*y[2], view.frame.width, 1))
            hengxian.backgroundColor = UIColor.blackColor()
            scrollview.addSubview(hengxian)
        }
        //表头线
        let xian = UIView(frame: CGRectMake(0, y[1], view.frame.width, 1))
        xian.backgroundColor = UIColor.blackColor()
        self.view.addSubview(xian)
        print("\(view.frame.width)")
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
    
    func chuli(instr:String) -> String{
        let a1 = instr.stringByReplacingOccurrencesOfString("<nobr><br>", withString: "\n")
        let a2 = a1.stringByReplacingOccurrencesOfString("<br><nobr>", withString: "\n")
        let a3 = a2.stringByReplacingOccurrencesOfString("<br><br>", withString: "\n")
        let a4 = a3.stringByReplacingOccurrencesOfString("<br>", withString: "\n")
        if let s1 = a4.rangeOfString("&nbsp;"){
            let a5 = a4.substringWithRange(s1.endIndex..<a4.endIndex)
            if let s2 = a5.rangeOfString("</div>"){
                let a6 = a5.substringWithRange(a1.startIndex..<s2.startIndex)
                var a7 = a6.stringByReplacingOccurrencesOfString(" ", withString: "")
                a7 = a7.substringToIndex(a7.endIndex.predecessor())
                return a7
            }
        }
        return ""
    }
    
    func btnBackClicked(sender:AnyObject) {
        self.navigationController?.navigationBar.popNavigationItemAnimated(true)
    }
    
    func xuanXQ() {
        if delegate.cundang {
            JWGLViewController().logon(delegate.jwusn!, sendpsw: delegate.jwpsw!)
        }
        let result = sGet("http://jwgl.btbu.edu.cn/tkglAction.do?method=kbxxXs")
        if result != "" {
            let a = oc().iRegular("<option value=\".*?\".*?>(.*?)</option>", and: result, withx: 1)
            xueqiA = NSMutableArray(capacity: 30)
            for i in a {
                let nian = iSave?.stringForKey("SaveUsn")
                let nianqian = 2000 + ((nian! as NSString).substringToIndex(2) as NSString).integerValue
                let xuehaonian = i.integerValue
                if xuehaonian >= nianqian {
                    xueqiA.addObject(i)
                    print("\(xuehaonian)")
                }
            }
            let aAl = UIAlertView(title: "选择学期", message: "", delegate: self, cancelButtonTitle: "取消")
            for i in xueqiA {
                aAl.addButtonWithTitle("\(i)")
            }
            aAl.show()
        }
        else {
            let aAl = UIAlertView(title: "选择学期失败", message: "请确认和教务系统间通讯无碍", delegate: self, cancelButtonTitle: "确定")
            aAl.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            //确定委托学期
            delegate.xueqi = alertView.buttonTitleAtIndex(buttonIndex)!
            //重置课表数组
            delegate.kebiao = NSMutableArray(capacity: 100)
            //选完学期->查课表 成功更新ui 不成功说明连接有误或者无课表
            if JWGLViewController().schedule() {
                delegate.cundang = false
                for i in self.view.subviews {
                    i.removeFromSuperview()
                }
                self.viewDidLoad()
            }
            else {
                let aAl = UIAlertView(title: "选择学期失败", message: "该学期无课表时间信息!", delegate: self, cancelButtonTitle: "确定")
                aAl.show()
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
