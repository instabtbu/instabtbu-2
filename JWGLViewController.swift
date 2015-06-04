//
//  JWGLViewController.swift
//  instabtbu
//
//  Created by 陈禹志 on 14-10-23.
//  Copyright (c) 2014年 ice-coldhand. All rights reserved.
//

import UIKit

class JWGLViewController: UIViewController, UITextFieldDelegate {
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    let foc = oc()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let iSave = NSUserDefaults(suiteName: "iSaveJW") {
            usn.text = iSave.stringForKey("SaveUsn")
            psw.text = iSave.stringForKey("SavePsw")
            delegate.jwusn = usn.text
            delegate.jwpsw = psw.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureMode.None
        drawerController.closeDrawerGestureModeMask = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        drawerController.openDrawerGestureModeMask = .All
        drawerController.closeDrawerGestureModeMask = .All
    }
    
    @IBAction func pswdid(sender: AnyObject) {
        usn.resignFirstResponder()
    }
    
    @IBAction func usndid(sender: AnyObject) {
        psw.becomeFirstResponder()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        usn.resignFirstResponder()
        psw.resignFirstResponder()
    }
    
    @IBOutlet weak var usn: UITextField!
    @IBOutlet weak var psw: UITextField!
    
    
    @IBAction func Clear(sender: AnyObject) {
        if let iSave = NSUserDefaults(suiteName: "iSaveJW") {
            iSave.removeObjectForKey("SaveUsn")
            iSave.removeObjectForKey("SavePsw")
            iSave.removeObjectForKey("kebiao")
            iSave.removeObjectForKey("xueqi")
            usn.text = ""
            psw.text = ""
        }
    }
    
    //线程执行代码,可以随意丢入任务,线程池自动管理
    func xiancheng(code:dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    //主线程,也就是UI线程,不可放耗时任务
    func ui(code:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), code)
    }
    
    @IBAction func ChengjiStart(sender: AnyObject) {
        xiancheng({
            self.chengjistart2()
        })
    }
    
    func chengjistart2(){
        if logon(usn.text, sendpsw: psw.text) {
            delegate.kecheng = NSMutableArray(capacity: 100)
            delegate.chengji = NSMutableArray(capacity: 100)
            delegate.xuefen = NSMutableArray(capacity: 100)
            if mark() {
                delegate.chenggong = true
                ui({
                    self.navigationController?.pushViewController(ChengjiViewController(), animated: true)
                })
            }
            else {
                delegate.chenggong = false
            }
        }
    }
    
    @IBAction func KebiaoStart(sender: AnyObject) {
        xiancheng({
            self.kebiaostart2()
        })
    }
    
    func kebiaostart2(){
        delegate.kebiao = NSMutableArray(capacity: 100)
        if let iSave = NSUserDefaults(suiteName: "iSaveJW") {
            //判断是否有存档
            delegate.cundang = (iSave.objectForKey("kebiao") != nil)&&((iSave.objectForKey("xueqi") as! NSString) != ""&&(usn.text == iSave.stringForKey("SaveUsn"))&&(psw.text == iSave.stringForKey("SavePsw")))
            //有存档不用登陆
            if delegate.cundang {
                delegate.kebiao = iSave.mutableArrayValueForKey("kebiao")
                delegate.xueqi = iSave.stringForKey("xueqi")!
                println("\(delegate.xueqi)")
                ui({
                    self.navigationController?.pushViewController(KebiaoViewController(), animated: true)
                })
            }
            else if logon(usn.text, sendpsw: psw.text) {
                ui({
                    self.navigationController?.pushViewController(KebiaoViewController(), animated: true)
                })
            }
        }
    }
    
    @IBAction func Xiaoli(sender: AnyObject) {
        self.navigationController?.pushViewController(XiaoliViewController(), animated: true)
    }
    
    func logon(sendusn:String, sendpsw:String)->Bool {
        var url = NSURL(string: "http://jwgl.btbu.edu.cn/verifycode.servlet")
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if (data != nil) {
            var animage = UIImage(data: data!)
            var yzm = getyzm(animage!)
            var retstr = foc.iPOSTwithurl("http://jwgl.btbu.edu.cn/Logon.do", withpost: "method=logon&USERNAME="+sendusn+"&PASSWORD="+sendpsw+"&RANDOMCODE="+yzm)
            if foc.iFind("http://jwgl.btbu.edu.cn/framework/main.jsp", inthe: retstr) {
                //获取权限
                var a = foc.iPOSTwithurl("http://jwgl.btbu.edu.cn/Logon.do?method=logonBySSO", withpost: "")
                //储存账户密码在本地以及委托
                let iSave = NSUserDefaults(suiteName: "iSaveJW")
                iSave?.setObject(sendusn, forKey: "SaveUsn")
                iSave?.setObject(sendpsw, forKey: "SavePsw")
                delegate.jwusn = sendusn
                delegate.jwpsw = sendpsw
                //判断旁听生 目前只有成绩需要用旁听生bool 成绩必须要登陆
                if foc.iFind("P", inthe: sendusn) {
                    delegate.pangting = true
                    println("P")
                }
                return true
            }
            else {
                foc.ShowMessage("登录失败", msg: "请尝试重新登陆或重新输入登陆信息，默认密码为学号或身份证后六位。")
                return false
            }
        }
        else {
            return false
        }
    }
    
    func mark()->Bool {
        var result = sGet("http://jwgl.btbu.edu.cn/xszqcjglAction.do?method=queryxscj&PageNum=1")
        if result == "" {
            return false
        }
        else {
            //绩点
            delegate.jidian = zhongjian(result, str1: "平均学分绩点<span>", str2: "。</span>")
            
            var firstreg:NSArray = foc.iRegular("<tr heigth = 23.+?>.+?</tr>", and: result, withx: 0)
            println("\(result as String)")
            for j in 0..<firstreg.count {
                var test:NSArray = foc.iRegular("<td.+?>(.*?(\\w*)(</a>)?)</td>", and: firstreg.objectAtIndex(j) as! String, withx: 1)
                if delegate.pangting {
                    for i in 0..<test.count {
                        if (i % 10 == 2) {
                            if foc.iFind("<div id", inthe: test.objectAtIndex(i) as! String) {}
                            else {
                                delegate.kecheng.addObject(test.objectAtIndex(i) as! String)
                            }
                        }
                        else if (i % 10 == 3) {
                            delegate.chengji.addObject(zhongjian((test.objectAtIndex(i) as? String)!, str1: ")\">", str2: "</a>"))
                            delegate.urlList.addObject("http://jwgl.btbu.edu.cn"+zhongjian((test.objectAtIndex(i) as! String), str1: "JsMod('", str2: "\">"))
                        }
                        else if (i % 10 == 8) {
                            delegate.xuefen.addObject(test.objectAtIndex(i) as! String)
                        }
                    }
                }
                else {
                    for i in 0..<test.count {
                        if (i % 13 == 4) {
                            if foc.iFind("<div id", inthe: test.objectAtIndex(i) as! String) {}
                            else {
                                delegate.kecheng.addObject(test.objectAtIndex(i) as! String)
                            }
                        }
                        else if (i % 13 == 5) {
                            delegate.chengji.addObject(zhongjian((test.objectAtIndex(i) as? String)!, str1: ")\">", str2: "</a>"))
                            delegate.urlList.addObject("http://jwgl.btbu.edu.cn"+zhongjian((test.objectAtIndex(i) as? String)!, str1: "JsMod('", str2: "\">"))
                        }
                        else if (i % 13 == 10) {
                            delegate.xuefen.addObject(test.objectAtIndex(i) as! String)
                        }
                    }
                }
            }
            var getye:NSArray = foc.iRegular("value=\\w+.+value=(\\w)+.+末页", and: result, withx: 1)
            var ye:Int?
            if getye.count == 0 {
                ye = 1
            }
            else {
                ye = (getye.objectAtIndex(0) as! String).toInt()
            }
            println("\(ye)页")
            var xh = 2
            while xh<=ye {
                result = sGet("http://jwgl.btbu.edu.cn/xszqcjglAction.do?method=queryxscj&PageNum=\(xh)")
                if result != "" {
                    var firstreg:NSArray = foc.iRegular("<tr heigth = 23.+?>.+?</tr>", and: result, withx: 0)
                    for j in 0..<firstreg.count {
                        var test:NSArray = foc.iRegular("<td.+?>(.*?(\\w*)(</a>)?)</td>", and: firstreg.objectAtIndex(j) as! String, withx: 1)
                        if delegate.pangting {
                            for i in 0..<test.count {
                                if (i % 10 == 2) {
                                    if foc.iFind("<div id", inthe: test.objectAtIndex(i) as! String) {}
                                    else {
                                        delegate.kecheng.addObject(test.objectAtIndex(i) as! String)
                                    }
                                }
                                else if (i % 10 == 3) {
                                    delegate.chengji.addObject(zhongjian((test.objectAtIndex(i) as! String), str1: ")\">", str2: "</a>"))
                                    delegate.urlList.addObject("http://jwgl.btbu.edu.cn"+zhongjian((test.objectAtIndex(i) as! String), str1: "JsMod('", str2: "\">"))
                                }
                                else if (i % 10 == 8) {
                                    delegate.xuefen.addObject(test.objectAtIndex(i) as! String)
                                }
                            }
                        }
                        else {
                            for i in 0..<test.count {
                                if (i % 13 == 4) {
                                    if foc.iFind("<div id", inthe: test.objectAtIndex(i) as! String) {}
                                    else {
                                        delegate.kecheng.addObject(test.objectAtIndex(i) as! String)
                                    }
                                }
                                else if (i % 13 == 5) {
                                    delegate.chengji.addObject(zhongjian((test.objectAtIndex(i) as! String), str1: ")\">", str2: "</a>"))
                                    delegate.urlList.addObject("http://jwgl.btbu.edu.cn"+zhongjian((test.objectAtIndex(i) as! String), str1: "JsMod('", str2: "\">"))
                                }
                                else if (i % 13 == 10) {
                                    delegate.xuefen.addObject(test.objectAtIndex(i) as! String)
                                }
                            }
                        }
                    }
                }
                xh++
            }
            return true
        }
    }
    
    func schedule() ->Bool {
        var result1 = sGet("http://jwgl.btbu.edu.cn/tkglAction.do?method=goListKbByXs&sql=&xnxqh="+delegate.xueqi)
        if foc.iFind("该学期无课表时间信息!", inthe: result1) {
            println("f")
            return false
        }
        else {
            var b:NSArray = foc.iRegular("<div id=\"(.+?)-2\".*?>(.+?)</div>", and: result1, withx: 0)
            for i in b {
                println("\(i)")
            }
            var i = 0
            
            for (i = 0;i<b.count;i++) {
                var c = foc.iRegular("&nbsp;(.*?)<br>(.+?)<br>(.*?)<br><nobr> *(.*?)<nobr><br>(.*?)<br>(.*?)<br>", and: b.objectAtIndex(i) as! String, withx: 0)
                println("\(c)")
                if c.count == 0{
                    delegate.kebiao.addObject("")
                }
                else {
                    delegate.kebiao.addObject(b.objectAtIndex(i))
                }
            }
            println("\(delegate.kebiao.count)")
            println("\(b.count)")
            return true
        }
    }
    
    func sGet(string:String) ->String {
        var url = NSURL(string: string)
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if (data != nil) {
            var result = NSString(data: data!, encoding: NSUTF8StringEncoding)
            return result as! String
        }
        else {
            return ""
        }
    }
    
    func zhongjian(str:String,str1:String,str2:String)->String {
        var left = str.rangeOfString(str1)
        var right = str.rangeOfString(str2)
        var r = Range(start: (left?.endIndex)! , end: (right?.startIndex)!)
        var s = str.substringWithRange(r)
        return s
    }
    
    func getyzm(img:UIImage) -> String {
        let cg = img.CGImage
        let w = Int(CGImageGetWidth(cg))
        let h = Int(CGImageGetHeight(cg))
        let provider = CGImageGetDataProvider(cg)
        let cfdata = CGDataProviderCopyData(provider)
        let data = NSData(data: cfdata)
        let yzm = oc().shibie(data, withW: w, withH: h)
        println(yzm)
        return yzm
    }
}
