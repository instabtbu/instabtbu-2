//
//  Common.swift
//  instabtbu
//
//  Created by 杨培文 on 15/6/4.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

import UIKit

class Common: NSObject {
    static var verify:[UInt8] = []
    //首次空包返回的随机验证码
    static var remain:[UInt8] = []
    //登录成功之后保存的保持在线数据
    static var recString:String = ""
    //查流量或者登录失败的时候取出的纯文本信息
    
    static func jiami(buf:[UInt8])->[UInt8]{
        var re:[UInt8] = [UInt8](count:128,repeatedValue:0x0)
        rsajiami(buf,CInt(buf.count),&re)
        return re
    }
    
    static func jiefeng(buf:[UInt8])->Bool{
        var buf2 = fanzhuanyi(buf)
        let len1 = Int(buf[2])
        let len2 = Int(buf[3])*256
        let len = len1+len2
        var f = false
        var re = [UInt8]()
        for i in 0..<Int(len){
            re.append(buf2[i+4])
        }
        
        if buf[1]==1 {
            remain = [UInt8](count:20,repeatedValue:0x0)
            rsajiemi(re,&remain)
            f=true
        }else{
            //var data = NSData(bytes: re, length: re.count)
            
            let gbk = CFStringConvertEncodingToNSStringEncoding(0x0632)
            if let rec = NSString(bytes: &re, length: re.count, encoding: gbk){
                recString = rec as String
                print("返回文本:\(recString)")
            }else{
                print("转码失败")
            }
        }
        
        return f
    }
    
    static func feng(buf:[UInt8],cmd:Int)->[UInt8]{
        let jiamiUInt8s = jiami(buf)
        var crcUInt8s = [UInt8(cmd),UInt8(jiamiUInt8s.count&0xff),UInt8(jiamiUInt8s.count>>8)] + jiamiUInt8s
        let crc = getCRC16(crcUInt8s)
        let a = UInt8(crc&0xFF)
        let b = UInt8(crc>>8)
        crcUInt8s = [UInt8(0x7E)] + crcUInt8s + [a,b,UInt8(0x7E)]
        return crcUInt8s
    }
    
    static func getcmd(cmd:Int)->[UInt8]{
        if remain.count==20 {
            var re:[UInt8] = [UInt8(cmd),0x14,0x00]+remain
            let crc = getCRC16(re)
            re=[0x7E]+re+[UInt8(crc&0xFF),UInt8(crc>>8),UInt8(0x7E)]
            return re
        }else{
            return []
        }
    }
    
    static func user(num:String,psw:String)->[UInt8]{
        var msg = [UInt8](count: 82, repeatedValue: 0)
        let ip = oc().getIP();
        var i = 0
        for c in num.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i += 1
        }
        i=23
        for c in psw.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i += 1
        }
        i=23+23
        for c in ip.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i += 1
        }
        i=23+23+20
        for c in verify{
            msg[i]=UInt8(c)
            i += 1
        }
        return msg;
    }
    
    static func user_noip(num:String , psw:String)->[UInt8]{
        var msg = [UInt8](count: 62, repeatedValue: 0)
        //var ip = oc().getIP();
        var i = 0
        for c in num.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i += 1
        }
        i=23
        for c in psw.cStringUsingEncoding(NSASCIIStringEncoding)!{
            msg[i]=UInt8(c)
            i += 1
        }
        for i in 0..<verify.count{
            msg[i+23+23]=verify[i]
        }
        return msg;
    }
    
    static func zhuanyi(buf:[UInt8])->[UInt8]{
        var re = [UInt8]()
        re.append(0x7E)
        for i in 1 ..< buf.count-1 {
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
    
    static func fanzhuanyi(buf:[UInt8])->[UInt8]{
        var re = [UInt8]()
        for var i in 0..<buf.count{
            if buf[i]==0x7D{
                i += 1
                re.append(buf[i]^0x40)
            }else {
                re.append(buf[i])
            }
        }
        return re;
    }
    
    static func getCRC16(UInt8s:[UInt8])->Int{
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
        let len = UInt8s.count;
        var crc = 0;
        while(i<len){
            let index = UInt8(crc>>8)^UInt8s[i];
            i += 1
            crc = ((crc&0xFF)<<8) ^ table[Int(index)]
        }
        return crc;
    }
    
    static func t(buf:[UInt8])->String{
        var re = ""
        for b in buf{
            re+=bts(b)+" "
        }
        re+=" 长度:\(buf.count)"
        return re
    }
    
    static func bts(b:UInt8)->String{
        var table = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
        return "\(table[Int(b/16)])\(table[Int(b%16)])"
    }
    
    static var client = TCPClient(addr: "192.168.8.8", port: 21098)
    
    static func connect()->Bool{
        let (success,_) = client.connect(timeout: 7)
        //var (success,error) = client.connect(timeout: 7)
        if !success{
        }
        print("连接服务器成功")
        return success
    }
    
    static func send(buf:[UInt8]){
        print("开始发送数据:\(t(buf))")
        let (succeed,error) = client.send(data: buf)
        if succeed{
            print("发送数据成功")
        }else{
            print("发送数据失败:\(error)")
        }
    }
    
    static func read()->[UInt8]{
        print("开始读取数据")
        if let re = client.read(1024*10){
            print("获取数据成功:\(t(re))")
            return re
        }else{
            print("获取数据失败")
            return []
        }
    }

}
