//
//  ViewController.swift
//  instabtbu
//
//  Created by 杨培文 on 14/12/15.
//  Copyright (c) 2014年 杨培文. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class ShangwangViewController: UIViewController,CLLocationManagerDelegate,GCDAsyncUdpSocketDelegate{
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation = self.navigationController
        //        self.navigationController?.navigationBar.barStyle=UIBarStyle.BlackTranslucent
        //        self.navigationItem.title="instabtbu"
        //        scroll.contentSize=CGSize(width: 240, height: 320)
        //        sleep(1)
        //上网的房子图标
        //        var image = UIImage(named: "shangwang_baritem1")
        //        image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //        tabBarItem.selectedImage=image
        
        //配置流量和设备数的label,不同机型不一样
        var width = UIScreen.mainScreen().bounds.width
        println(width)
        if width == 320{
            liulianglabel.frame = CGRect(x: 188.0, y: 138.0, width: 220, height: 21)
            zaixianlabel.frame = CGRect(x: 275.0, y: 138.0, width: 100, height: 21)
        }else if width == 375{
            liulianglabel.frame = CGRect(x: 225, y: 152, width: 220, height: 21)
            zaixianlabel.frame = CGRect(x: 325, y: 152, width: 100, height: 21)
            liulianglabel.font = UIFont(name: "Helvetica", size: 20)
            zaixianlabel.font = UIFont(name: "Helvetica", size: 20)
        }else if width == 414{
            liulianglabel.frame = CGRect(x: 248, y: 160, width: 220, height: 21)
            zaixianlabel.frame = CGRect(x: 360, y: 160, width: 100, height: 21)
            liulianglabel.font = UIFont(name: "Helvetica", size: 22)
            zaixianlabel.font = UIFont(name: "Helvetica", size: 22)
        }
        else {
            liulianglabel.frame = CGRect(x: 441.0, y: 203.0, width: 220, height: 45)
            zaixianlabel.frame = CGRect(x: 620.0, y: 203.0, width: 100, height: 45)
            liulianglabel.font = UIFont(name: "Helvetica", size: 36)
            zaixianlabel.font = UIFont(name: "Helvetica", size: 36)
        }
        
        liulianglabel.textColor = UIColor.whiteColor()
        zaixianlabel.textColor = UIColor.whiteColor()
        self.view.addSubview(liulianglabel)
        self.view.addSubview(zaixianlabel)
        println(liulianglabel.frame)
        println(zaixianlabel.frame)
        
        /*
        iPhone 5s
        320.0
        (188.0, 138.0, 220.0, 21.0)
        (275.0, 138.0, 100.0, 21.0)
        
        iPhone 6
        375.0
        (225.0, 152.34375, 220.0, 21.0)
        (325.78125, 152.34375, 100.0, 21.0)
        
        iPhone 6 Plus
        414.0
        (248.4, 160.425, 220.0, 21.0)
        (359.6625, 160.425, 100.0, 21.0)
        
        iPad Simulator
        768.0
        (441.0, 203.0, 220.0, 45.0)
        (620.0, 203.0, 100.0, 45.0)
        */
        
        //配置locationManager,精度稍低,防止使用GPS过度耗电
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate=self
        if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8 {
            locationManager.requestAlwaysAuthorization()
        }
        
        //读取储存在本地的用户名和密码等配置信息
        if let data = NSUserDefaults(suiteName: "data")
        {
            numtext.text=data.stringForKey("num")
            pswtext.text=data.stringForKey("psw")
            liulianglabel.text=data.stringForKey("liuliang")
            zaixianlabel.text=data.stringForKey("zaixian")
            
            var zdc = data.integerForKey("zidongcha")
            var zddl = data.integerForKey("zidongdenglu")
            if zdc != 0 {
                zidongchabutton.setImage(UIImage(named: "shangwang_zidongcha1.png"), forState: UIControlState.Normal)
                zidongchaliuliang()
            }else{
                zidongchabutton.setImage(UIImage(named: "shangwang_zidongcha0.png"), forState: UIControlState.Normal)
            }
            if zddl != 0 {
                zidongdenglubutton.setImage(UIImage(named: "shangwang_zidongdenglu1.png"), forState: UIControlState.Normal)
                xiancheng({self.denglu2(false)})
            }else{
                zidongdenglubutton.setImage(UIImage(named: "shangwang_zidongdenglu0.png"), forState: UIControlState.Normal)
            }
        }
        
        //self.locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //        MobClick.beginLogPageView("shangwang")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //        MobClick.endLogPageView("shangwang")
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location:CLLocation = locations[locations.count-1] as! CLLocation
        
        if(location.horizontalAccuracy>0){
            //获取到gps信息
            let gps="GPS信息:\n经度:\(location.coordinate.latitude)\n纬度:\(location.coordinate.longitude)"
            //println(gps)
            //print("GPS")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pswdid(sender: AnyObject) {
        println("pswdid")
        numtext.resignFirstResponder()
        //把键盘弹下去
    }
    
    @IBAction func numdid(sender: AnyObject) {
        println("numdid")
        pswtext.becomeFirstResponder()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        numtext.resignFirstResponder()
        pswtext.resignFirstResponder()
        //触摸其他地方的时候也把键盘弹下去
    }
    
    @IBAction func zidongcha(sender: AnyObject) {
        if let data = NSUserDefaults(suiteName: "data")
        {
            var zdc = data.integerForKey("zidongcha")
            zdc=1-zdc
            if zdc != 0 {
                zidongchabutton.setImage(UIImage(named: "shangwang_zidongcha1.png"), forState: UIControlState.Normal)
            }else{
                zidongchabutton.setImage(UIImage(named: "shangwang_zidongcha0.png"), forState: UIControlState.Normal)
            }
            data.setInteger(zdc, forKey: "zidongcha")
        }
    }
    
    @IBAction func zidongdenglu(sender: AnyObject) {
        if let data = NSUserDefaults(suiteName: "data")
        {
            var zddl = data.integerForKey("zidongdenglu")
            zddl=1-zddl
            if zddl != 0 {
                zidongdenglubutton.setImage(UIImage(named: "shangwang_zidongdenglu1.png"), forState: UIControlState.Normal)
            }else{
                zidongdenglubutton.setImage(UIImage(named: "shangwang_zidongdenglu0.png"), forState: UIControlState.Normal)
            }
            data.setInteger(zddl, forKey: "zidongdenglu")
        }
    }
    
    @IBAction func feedback(sender: AnyObject) {
        //反馈
        navigationController?.pushViewController(UMFeedback.feedbackViewController(), animated: true)
    }
    
    var liulianglabel = UILabel()
    var zaixianlabel = UILabel()
    //上面两个用代码生成,因为不用代码就没办法修改位置
    
    //    @IBOutlet weak var zaixianlabel: UILabel!
    //    @IBOutlet weak var liulianglabel: UILabel!
    @IBOutlet weak var zhuangtai: UIImageView!
    @IBOutlet weak var numtext: UITextField!
    @IBOutlet weak var pswtext: UITextField!
    @IBOutlet weak var denglubutton: UIButton!
    @IBOutlet weak var zidongchabutton: UIButton!
    @IBOutlet weak var zidongdenglubutton: UIButton!
    
    @IBAction func denglu(sender: AnyObject) {
        xiancheng({
            self.denglu2(false)
        })
    }
    
    func denglu2(isbackground: Bool){
        var ip = oc().getIP()
        if ip != nil{
            var buf:[UInt8] = [0x7E,0x11,0x00,0x00,0x54,0x01,0x7E]
            var trytime = 0
            var rec = [UInt8]()
            
            do{
                do
                {
                    Common.connect()
                    Common.send(buf)
                    rec = Common.read()
                    rec = Common.fanzhuanyi(rec)
                    trytime++
                    println("第\(trytime)次")
                    if trytime > 20{
                        red()
                        //show("登录失败")
                        
                        //只要失败次数超过指定次数就直接return
                        return
                    }
                    NSThread.sleepForTimeInterval(0.1)
                    //防止服务器一直丢弃连接,我们需要一定的延时
                }while(rec.count != 23)
                
                if rec.count==23 {
                    Common.verify=[UInt8]()
                    for i in 0...15
                    {
                        Common.verify.append(rec[i+4])
                    }
                    println("获取到验证码:\(Common.t(Common.verify))")
                    var msg = Common.user(numtext.text, psw: pswtext.text)
                    msg = Common.feng(msg, cmd: 0x01)
                    msg=Common.zhuanyi(msg)
                    Common.send(msg)
                    rec = Common.read()
                }
            }while(rec.count == 0)
            
            Common.client.close()
            if Common.jiefeng(rec){
                println("保持在线数据:\(Common.t(Common.remain))")
                ui({
                    self.locationManager.startUpdatingLocation()
                    //通过locationManager保持后台
                    
                    let data = NSUserDefaults(suiteName: "data")
                    data?.setObject(self.numtext.text, forKey: "num")
                    data?.setObject(self.pswtext.text, forKey: "psw")
                    
                    //登录成功之后调整UI
                    self.zhuangtai.image=UIImage(named: "shangwang_yilianjie5.png")
                    self.denglubutton.setImage(UIImage(named: "shangwang_denglu0.png"), forState: UIControlState.Normal)
                    self.zidongchaliuliang()
                    self.numtext.enabled = false
                    self.pswtext.enabled = false
                })
                always = true
                //保持在线线程
                if !isbackground{
                    xiancheng({
                        self.baochi()
                    })
                    //测试是否在线线程
                    xiancheng({
                        self.testonline()
                    })
                }
            }else {
                if !isbackground{
                    show(Common.recString)
                }
                println(Common.recString)
            }
        }else {
            if !isbackground{
                show("获取数据出错");
            }
        }
    }
    
    var always = false
    
    func zidongchaliuliang(){
        xiancheng({
            if let data = NSUserDefaults(suiteName: "data")
            {
                var zdc = data.integerForKey("zidongcha")
                if zdc != 0{
                    self.xiancheng({self.chaliuliang2()})
                }
            }
        })
    }
    
    @IBAction func duankai(sender: AnyObject) {
        println("断开中")
        var udp = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        udp.connectToHost("192.168.8.8", onPort: 21099, error: nil)
        var cmd = Common.getcmd(1)
        var data = NSData(bytes: cmd, length: cmd.count)
        
        udp.sendData(data, withTimeout: 15, tag: 0)
        NSThread.sleepForTimeInterval(0.1)
        udp.sendData(data, withTimeout: 15, tag: 0)
        NSThread.sleepForTimeInterval(0.1)
        udp.sendData(data, withTimeout: 15, tag: 0)
        NSThread.sleepForTimeInterval(0.1)
        udp.sendData(data, withTimeout: 15, tag: 0)
        println("断开成功")
        always = false
        zhuangtai.image=UIImage(named: "shangwang_weilianjie.png")
        denglubutton.setImage(UIImage(named: "shangwang_denglu1.png"), forState: UIControlState.Normal)
        locationManager.stopUpdatingLocation()
        numtext.enabled = true
        pswtext.enabled = true
        
        xiancheng({
            sleep(1)
            self.zidongchaliuliang()
        })
    }
    
    //线程执行代码,可以随意丢入任务,线程池自动管理
    func xiancheng(code:dispatch_block_t){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), code)
    }
    //主线程,也就是UI线程,不可放耗时任务
    func ui(code:dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), code)
    }
    
    var delaytime:UInt32 = 30
    
    func baochi(){
        MobClick.beginEvent("service")
        
//        var udp = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
//        udp.connectToHost("192.168.8.8", onPort: 21099, error: nil)
//        var err = NSErrorPointer()
//        udp.bindToPort(21099, error: err)
//        if err != nil{
//            println(err.debugDescription)
//        }
//        udp.beginReceiving(nil)
//        
//        while always{
//            var cmd = getcmd(0)
//            var data = NSData(bytes: cmd, length: cmd.count)
//            sleep(30)
//            udp.sendData(data, withTimeout: 30000, tag: 0)
//            println("发送保持数据:\(t(cmd))")
//        }
        
        var udpclient = UDPClient(addr: "192.168.8.8", port: 21099)
        while always{
            sleep(delaytime)
            var cmd = Common.getcmd(0)
            var data = NSData(bytes: cmd, length: cmd.count)
            var (success,errmsg) = udpclient.send(data: data)
            if success{
                delaytime = 30
                println("发送保持数据成功:\(Common.t(cmd))")
            }else {
                //一旦发送失败,加快发送速度
                delaytime = 2
                println("发送保持数据失败,原因: \(errmsg)")
            }
        }
        
        MobClick.endEvent("service")
        
        
    }
    
    func testonline(){
        while always{
            sleep(delaytime)
            var testclient = TCPClient(addr: "baidu.com", port: 80)
            var (success, error) = testclient.connect(timeout: 15)
            println("\(success),\(error)")
            testclient.close()
            if success == false{
                if always{
                    denglu2(true)
                }
            }
        }
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        var s = [UInt8](count:27,repeatedValue:0x0)
        data.getBytes(&s, length: 27)
        println("recr:\(Common.t(s))")
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didNotSendDataWithTag tag: Int, dueToError error: NSError!) {
        println("not send data \(tag)")
    }
    
    func chaliuliang2(){
        MobClick.event("chaliuliang")
        println("开始连接");
        var ip = oc().getIP()
        if ip != nil{
            var buf:[UInt8] = [0x7E,0x11,0x00,0x00,0x54,0x01,0x7E]
            var rec = [UInt8]()
            var trytime = 0
            do{
                do{
                    Common.connect()
                    Common.send(buf)
                    rec = Common.read()
                    rec = Common.fanzhuanyi(rec)
                    trytime++
                    println("第\(trytime)次")
                    if trytime > 20{
                        //show("查询流量失败")
                        red()
                        return
                    }
                    NSThread.sleepForTimeInterval(0.1)
                }while(rec.count != 23)
                
                if rec.count==23 {
                    Common.verify=[UInt8]()
                    for i in 0...15
                    {
                        Common.verify.append(rec[i+4])
                    }
                    println("获取到验证码:\(Common.t(Common.verify))")
                    var num = numtext.text
                    var psw = pswtext.text
                    var msg = Common.user_noip(num, psw: psw)
                    println("构造发送数据:\(Common.t(msg))")
                    msg = Common.feng(msg, cmd: 0x03)
                    msg = Common.zhuanyi(msg)
                    Common.send(msg)
                    rec = Common.read()
                }
            }while(rec.count == 0)
            
            Common.client.close()
            Common.jiefeng(rec)
            var regex = NSRegularExpression(pattern: "(\\d+)兆", options: NSRegularExpressionOptions.allZeros, error: nil)
            var len = count(Common.recString)
            println(len)
            
            if len < 100{
                show(Common.recString)
            }
            else {
                var match = regex?.matchesInString(Common.recString, options: NSMatchingOptions.allZeros, range: NSMakeRange(0,len))
                var liuliang = 0
                for a in match!{
                    let range = NSMakeRange(a.range.location, a.range.length-1)
                    let tmp = (Common.recString as NSString).substringWithRange(range)
                    if let temp = tmp.toInt(){
                        liuliang+=temp
                    }
                }
                println(liuliang)
                
                let data = NSUserDefaults(suiteName: "data")
                data?.setObject(self.numtext.text, forKey: "num")
                data?.setObject(self.pswtext.text, forKey: "psw")
                
                self.liulianglabel.text="\(liuliang)M"
                
                self.yellow()
                
                regex = NSRegularExpression(pattern: "在线:\\d+", options: NSRegularExpressionOptions.allZeros, error: nil)
                len = count(Common.recString)
                if let tmp = regex?.firstMatchInString(Common.recString, options: NSMatchingOptions.allZeros, range: NSMakeRange(0,len)){
                    let range = NSMakeRange(tmp.range.location+3, tmp.range.length-3)
                    let tmp2 = (Common.recString as NSString).substringWithRange(range)
                    self.zaixianlabel.text=tmp2
                }
                
                if let data = NSUserDefaults(suiteName: "data"){
                    data.setObject(liulianglabel.text, forKey: "liuliang")
                    data.setObject(zaixianlabel.text, forKey: "zaixian")
                }
            }
            
        }else {
            red()
        }
        
    }
    
    func yellow(){
        xiancheng({
            var color = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
            self.liulianglabel.textColor=color
            self.zaixianlabel.textColor=color
            
            for var i:CGFloat=0;i<255;i+=5{
                var color = UIColor(red: 1, green: 1, blue: (i/255.0), alpha: 1)
                self.ui({
                    self.liulianglabel.textColor=color
                    self.zaixianlabel.textColor=color
                })
                NSThread.sleepForTimeInterval(0.02)
            }
            
        })
    }
    
    func red(){
        xiancheng({
            var color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
            self.liulianglabel.textColor=color
            self.zaixianlabel.textColor=color
            
            for var i:CGFloat=0;i<255;i+=5{
                var color = UIColor(red: 1, green: (i/255.0), blue: (i/255.0), alpha: 1)
                self.ui({
                    self.liulianglabel.textColor=color
                    self.zaixianlabel.textColor=color
                })
                NSThread.sleepForTimeInterval(0.02)
            }
            
        })
    }
    
    @IBAction func chaliuliang(sender: AnyObject) {
        //使用线程查询流量
        xiancheng({
            self.chaliuliang2()
        })
    }
    
    @IBAction func force(sender: AnyObject) {
        xiancheng({
            self.force2()
        })
    }
    
    func force2(){
        var mypost = oc()
        var rec = mypost.iPOSTwithurl("http://self.btbu.edu.cn/cgi-bin/nacgi.cgi", withpost: "textfield=" + numtext.text+"&textfield2=" + pswtext.text + "&Submit=%CC%E1%BD%BB&nacgicmd=9&radio=1&jsidx=1")
        println(rec)
        if let range = rec.rangeOfString("成功断开本帐号的当前的所有连接"){
            println("成功断开本帐号的当前的所有连接")
            show("成功断开本帐号的当前的所有连接")
        }else{
            println("断开失败")
            show("断开失败")
        }
    }
    
    func show(show:String){
        ui({
            UIAlertView(title: "", message: show, delegate: nil, cancelButtonTitle: "确定").show()
        })
    }
    
}

