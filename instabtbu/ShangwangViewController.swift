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
                xiancheng({self.denglu2()})
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
            println(gps)
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
            self.denglu2()
        })
    }
    
    func denglu2(){
        var ip = oc().getIP()
        if ip != nil{
            var buf:[UInt8] = [0x7E,0x11,0x00,0x00,0x54,0x01,0x7E]
            var trytime = 0
            var rec = [UInt8]()
            
            do{
                do
                {
                    connect()
                    send(buf)
                    rec = read()
                    rec=fanzhuanyi(rec)
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
                    verify=[UInt8]()
                    for i in 0...15
                    {
                        verify.append(rec[i+4])
                    }
                    println("获取到验证码:\(t(verify))")
                    var msg = user(numtext.text, psw: pswtext.text)
                    msg=feng(msg, cmd: 0x01)
                    msg=zhuanyi(msg)
                    send(msg)
                    rec = read()
                }
            }while(rec.count == 0)
            
            client.close()
            if jiefeng(rec){
                println("保持在线数据:\(t(remain))")
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
                    self.numtext.enabled = true
                    self.pswtext.enabled = true
                })
                always = true
                //保持在线线程
                xiancheng({
                    self.baochi()
                })
                //测试是否在线线程
                xiancheng({
                    self.testonline()
                })
            }else {
                show(recString)
                println(recString)
            }
        }else {
            show("获取数据出错");
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
        
        var udp = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        udp.connectToHost("192.168.8.8", onPort: 21099, error: nil)
        var cmd = getcmd(1)
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
        isBaochi = false
        istestOnline = false
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
    
    var isBaochi = false
    
    func baochi(){
        MobClick.beginEvent("service")
        var udp = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        udp.connectToHost("192.168.8.8", onPort: 21099, error: nil)
        var err = NSErrorPointer()
        udp.bindToPort(21099, error: err)
        if err != nil{
            println(err.debugDescription)
        }
        udp.beginReceiving(nil)
        
        if !isBaochi{
            isBaochi = true
            while always{
                var cmd = getcmd(0)
                var data = NSData(bytes: cmd, length: cmd.count)
                sleep(30)
                udp.sendData(data, withTimeout: 30000, tag: 0)
                println("发送保持数据:\(t(cmd))")
            }
        }
        MobClick.endEvent("service")
    }
    
    var istestOnline = false
    func testonline(){
        if !istestOnline{
            istestOnline = true
            while always{
                sleep(30)
                var testclient = TCPClient(addr: "baidu.com", port: 80)
                var (success, error) = testclient.connect(timeout: 15)
                println("\(success),\(error)")
                if success == false{
                    denglu2()
                }
                testclient.close()
            }
        }
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        var s = [UInt8](count:27,repeatedValue:0x0)
        data.getBytes(&s, length: 27)
        println("recr:\(t(s))")
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
                    connect()
                    send(buf)
                    rec = read()
                    rec=fanzhuanyi(rec)
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
                    verify=[UInt8]()
                    for i in 0...15
                    {
                        verify.append(rec[i+4])
                    }
                    println("获取到验证码:\(t(verify))")
                    var num = numtext.text
                    var psw = pswtext.text
                    var msg = user_noip(num, psw: psw)
                    println("构造发送数据:\(t(msg))")
                    msg=feng(msg, cmd: 0x03)
                    msg=zhuanyi(msg)
                    send(msg)
                    rec = read()
                }
            }while(rec.count == 0)
            
            client.close()
            jiefeng(rec)
            var regex = NSRegularExpression(pattern: "(\\d+)兆", options: NSRegularExpressionOptions.allZeros, error: nil)
            var len = count(recString)
            println(len)
            
            if len < 100{
                show(recString)
            }
            else {
                var match = regex?.matchesInString(recString, options: NSMatchingOptions.allZeros, range: NSMakeRange(0,len))
                var liuliang = 0
                for a in match!{
                    let range = NSMakeRange(a.range.location, a.range.length-1)
                    let tmp = (recString as NSString).substringWithRange(range)
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
                len = count(recString)
                if let tmp = regex?.firstMatchInString(recString, options: NSMatchingOptions.allZeros, range: NSMakeRange(0,len)){
                    let range = NSMakeRange(tmp.range.location+3, tmp.range.length-3)
                    let tmp2 = (recString as NSString).substringWithRange(range)
                    self.zaixianlabel.text=tmp2
                }
                
                if let data = NSUserDefaults(suiteName: "data"){
                    data.setObject(liulianglabel.text, forKey: "liuliang")
                    data.setObject(zaixianlabel.text, forKey: "zaixian")
                }
            }

        }else {

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
    
    var verify:[UInt8] = []
    //首次空包返回的随机验证码
    var remain:[UInt8] = []
    //登录成功之后保存的保持在线数据
    var recString:String = ""
    //查流量或者登录失败的时候取出的纯文本信息
    
    func jiami(buf:[UInt8])->[UInt8]{
        var re:[UInt8] = [UInt8](count:128,repeatedValue:0x0)
        rsajiami(buf,CInt(count(buf)),&re)
        return re
    }
    
    func jiefeng(buf:[UInt8])->Bool{
        var buf2 = fanzhuanyi(buf)
        var len1 = Int(buf[2])
        var len2 = Int(buf[3])*256
        var len = len1+len2
        var f = false
        var re = [UInt8]()
        for var i=0;i<Int(len);i=i+1{
            re.append(buf2[i+4])
        }
        
        if buf[1]==1 {
            remain = [UInt8](count:20,repeatedValue:0x0)
            rsajiemi(re,&remain)
            f=true
        }else{
            var data = NSData(bytes: re, length: count(re))
            
            var gbk = CFStringConvertEncodingToNSStringEncoding(0x0632)
            if let rec = NSString(bytes: &re, length: re.count, encoding: gbk){
                recString = rec as String
                println("返回文本:\(recString)")
            }else{
                println("转码失败")
            }
        }
        
        return f
    }
    
    func feng(buf:[UInt8],cmd:Int)->[UInt8]{
        var jiamiUInt8s = jiami(buf)
        var crcUInt8s = [UInt8(cmd),UInt8(jiamiUInt8s.count&0xff),UInt8(jiamiUInt8s.count>>8)] + jiamiUInt8s
        var crc = getCRC16(crcUInt8s)
        crcUInt8s = [UInt8(0x7E)] + crcUInt8s + [UInt8(crc&0xFF),UInt8(crc>>8),UInt8(0x7E)]
        return crcUInt8s
    }
    
    func getcmd(cmd:Int)->[UInt8]{
        if remain.count==20 {
            var re:[UInt8] = [UInt8(cmd),0x14,0x00]+remain
            var crc = getCRC16(re)
            re=[0x7E]+re+[UInt8(crc&0xFF),UInt8(crc>>8),UInt8(0x7E)]
            return re
        }else{
            return []
        }
    }
    
    func user(num:String,psw:String)->[UInt8]{
        var msg = [UInt8](count: 82, repeatedValue: 0)
        var ip = oc().getIP();
        var i = 0
        for c in num.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i++
        }
        i=23
        for c in psw.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i++
        }
        i=23+23
        for c in ip.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i++
        }
        i=23+23+20
        for c in verify{
            msg[i]=UInt8(c)
            i++
        }
        return msg;
    }
    
    func user_noip(num:String , psw:String)->[UInt8]{
        var msg = [UInt8](count: 62, repeatedValue: 0)
        var ip = oc().getIP();
        var i = 0
        for c in num.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i++
        }
        i=23
        for c in psw.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i++
        }
        for i in 0..<verify.count{
            msg[i+23+23]=verify[i]
        }
        return msg;
    }
    
    func zhuanyi(buf:[UInt8])->[UInt8]{
        var re = [UInt8]()
        re.append(0x7E)
        for var i=1;i<buf.count-1;i++ {
            if buf[i]==0x7D||buf[i]==0x7E{
                re.append(0x7D)
                re.append(buf[i]^0x40)
            }else {
                re.append(buf[i])
            }
        }
        re.append(0x7E)
        return re;
    }
    
    func fanzhuanyi(buf:[UInt8])->[UInt8]{
        var re = [UInt8]()
        for var i=0;i<buf.count;i++ {
            if buf[i]==0x7D{
                re.append(buf[++i]^0x40)
            }else {
                re.append(buf[i])
            }
        }
        return re;
    }
    
    func getCRC16(UInt8s:[UInt8])->Int{
        var table = [0x0000,0x8005,0x800F,0x000A,0x801B,0x001E,0x0014,0x8011,0x8033,0x0036,0x003C,0x8039,0x0028,0x802D,0x8027,
            0x0022,0x8063,0x0066,0x006C,0x8069,0x0078,0x807D,0x8077,0x0072,0x0050,0x8055,0x805F,0x005A,0x804B,0x004E,0x0044,
            0x8041,0x80C3,0x00C6,0x00CC,0x80C9,0x00D8,0x80DD,0x80D7,0x00D2,0x00F0,0x80F5,0x80FF,0x00FA,0x80EB,0x00EE,0x00E4,
            0x80E1, 0x00A0,0x80A5,0x80AF,0x00AA,0x80BB,0x00BE,0x00B4,0x80B1,0x8093,0x0096,0x009C,0x8099,0x0088,0x808D,0x8087,
            0x0082,0x8183,0x0186,0x018C,0x8189,0x0198,0x819D,0x8197,0x0192,0x01B0,0x81B5,0x81BF,0x01BA,0x81AB,0x01AE,0x01A4,
            0x81A1,0x01E0,0x81E5,0x81EF,0x01EA,0x81FB,0x01FE,0x01F4,0x81F1,0x81D3,0x01D6,0x01DC,0x81D9,0x01C8,0x81CD,0x81C7,
            0x01C2,0x0140,0x8145,0x814F,0x014A,0x815B,0x015E,0x0154,0x8151,0x8173,0x0176,0x017C,0x8179,0x0168,0x816D,0x8167,
            0x0162,0x8123,0x0126,0x012C,0x8129,0x0138,0x813D,0x8137,0x0132,0x0110,0x8115,0x811F,0x011A,0x810B,0x010E,0x0104,
            0x8101,0x8303,0x0306,0x030C,0x8309,0x0318,0x831D,0x8317,0x0312,0x0330,0x8335,0x833F,0x033A,0x832B,0x032E,0x0324,
            0x8321,0x0360,0x8365,0x836F,0x036A,0x837B,0x037E,0x0374,0x8371,0x8353,0x0356,0x035C,0x8359,0x0348,0x834D,0x8347,
            0x0342,0x03C0,0x83C5,0x83CF,0x03CA,0x83DB,0x03DE,0x03D4,0x83D1,0x83F3,0x03F6,0x03FC,0x83F9,0x03E8,0x83ED,0x83E7,
            0x03E2,0x83A3,0x03A6,0x03AC,0x83A9,0x03B8,0x83BD,0x83B7,0x03B2,0x0390,0x8395,0x839F,0x039A,0x838B,0x038E,0x0384,
            0x8381,0x0280,0x8285,0x828F,0x028A,0x829B,0x029E,0x0294,0x8291,0x82B3,0x02B6,0x02BC,0x82B9,0x02A8,0x82AD,0x82A7,
            0x02A2,0x82E3,0x02E6,0x02EC,0x82E9,0x02F8,0x82FD,0x82F7,0x02F2,0x02D0,0x82D5,0x82DF,0x02DA,0x82CB,0x02CE,0x02C4,
            0x82C1,0x8243,0x0246,0x024C,0x8249,0x0258,0x825D,0x8257,0x0252,0x0270,0x8275,0x827F,0x027A,0x826B,0x026E,0x0264,
            0x8261,0x0220,0x8225,0x822F,0x022A,0x823B,0x023E,0x0234,0x8231,0x8213,0x0216,0x021C,0x8219,0x0208,0x820D,0x8207,
            0x0202]
        var i = 0;
        var len = UInt8s.count;
        var crc = 0;
        while(i<len){
            var index = UInt8(crc>>8)^UInt8s[i++];
            crc = ((crc&0xFF)<<8) ^ table[Int(index)]
        }
        return crc;
    }
    
    func t(buf:[UInt8])->String{
        var re = ""
        for b in buf{
            re+=bts(b)+" "
        }
        re+=" 长度:\(buf.count)"
        return re
    }
    
    func bts(b:UInt8)->String{
        var table = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
        return "\(table[Int(b/16)])\(table[Int(b%16)])"
    }
    
    var client = TCPClient(addr: "192.168.8.8", port: 21098)
    
    func connect()->Bool{
        var (success,error) = client.connect(timeout: 7)
        if !success{
        }
        println("连接服务器成功")
        return success
    }
    
    func send(buf:[UInt8]){
        println("开始发送数据:\(t(buf))")
        let (succeed,error) = client.send(data: buf)
        if succeed{
            println("发送数据成功")
        }else{
            println("发送数据失败:\(error)")
        }
    }
    
    func read()->[UInt8]{
        println("开始读取数据")
        if let re = client.read(1024*10){
            println("获取数据成功:\(t(re))")
            return re
        }else{
            println("获取数据失败")
            return []
        }
    }
    
    @IBAction func force(sender: AnyObject) {
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

