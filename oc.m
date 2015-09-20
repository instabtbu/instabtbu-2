//
//  oc.m
//  instabtbu
//
//  Created by 杨培文 on 14/12/15.
//  Copyright (c) 2014年 杨培文. All rights reserved.
//

#import "oc.h"
#import "NU.h"

@implementation NSURLRequest(IgnoreSSL)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end

@implementation oc
- (NSString *) getIP
{

    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }

    return nil;
}

- (NSString *)iPOSTwithurl:(NSString *)inurl withpost:(NSString *)inpost
{
    NSURL *url = [NSURL URLWithString:[inurl URLEncodedString]];
    NSData *postData = [inpost dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //异步发送request，成功后会得到服务器返回的数据 GB2312
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSData *data = [NSData dataWithContentsOfURL:url];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *retStr = [[NSString alloc] initWithData:returnData encoding:enc];
    return retStr;
}

- (BOOL)iFind:(NSString *)astr inthe:(NSString *)lstr
{
    NSRange iwf = [lstr rangeOfString:astr];
    if (iwf.length == astr.length) {
        return YES;
    }
    else return NO;
}

- (void)ShowMessage:(NSString *) title msg:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    [alert show];
}

- (NSArray *)iRegular:(NSString *)regTags and:(NSString *)retStr withx:(NSNumber *)x
{
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags options:0 error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:retStr
                                      options:0
                                        range:NSMakeRange(0, [retStr length])];
    
    NSMutableArray *traffic = [NSMutableArray array];
    // 用下面的办法来加上每一条匹配记录
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [retStr substringWithRange:[match rangeAtIndex:[x intValue]]];
        [traffic addObject:tagValue];
    }
    return traffic;
}

const unsigned char yzm1[] = {
    0,0,0,0,0,1,1,0,0,
    0,0,0,1,1,1,1,0,0,
    0,0,0,1,1,1,1,0,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,1,1,1,1,1,1,
    0,0,0,1,1,1,1,1,1,
};
const unsigned char yzm2[] = {
    0,0,1,1,1,1,1,0,0,
    0,1,1,1,1,1,1,1,0,
    0,1,0,0,0,0,0,1,1,
    0,0,0,0,0,0,0,1,1,
    0,0,0,0,0,0,0,1,1,
    0,0,0,0,0,0,1,1,0,
    0,0,0,0,1,1,1,0,0,
    0,0,0,1,1,0,0,0,0,
    0,0,1,1,0,0,0,0,0,
    0,1,1,0,0,0,0,0,0,
    0,1,1,1,1,1,1,1,1,
    0,1,1,1,1,1,1,1,1,
};
const unsigned char yzm3[] = {
    0,0,1,1,1,1,1,0,0,
    0,1,1,1,1,1,1,1,0,
    0,1,0,0,0,0,1,1,1,
    0,0,0,0,0,0,0,1,1,
    0,0,0,0,0,0,1,1,0,
    0,0,0,1,1,1,1,0,0,
    0,0,0,1,1,1,1,1,0,
    0,0,0,0,0,0,1,1,1,
    0,0,0,0,0,0,0,1,1,
    0,1,0,0,0,0,1,1,1,
    0,1,1,1,1,1,1,1,0,
    0,0,1,1,1,1,1,0,0,
};
const unsigned char yzmb[] = {
    0,1,1,0,0,0,0,0,0,
    0,1,1,0,0,0,0,0,0,
    0,1,1,0,0,0,0,0,0,
    0,1,1,0,1,1,1,1,0,
    0,1,1,1,1,1,1,1,1,
    0,1,1,1,0,0,0,1,1,
    0,1,1,0,0,0,0,0,1,
    0,1,1,0,0,0,0,0,1,
    0,1,1,0,0,0,0,0,1,
    0,1,1,1,0,0,0,1,1,
    0,1,1,1,1,1,1,1,1,
    0,1,1,0,1,1,1,1,0,
};
const unsigned char yzmc[] = {
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,0,0,1,1,1,1,1,0,
    0,0,1,1,1,1,1,1,0,
    0,1,1,1,0,0,0,0,0,
    0,1,1,0,0,0,0,0,0,
    0,1,1,0,0,0,0,0,0,
    0,1,1,0,0,0,0,0,0,
    0,1,1,1,0,0,0,0,0,
    0,0,1,1,1,1,1,1,0,
    0,0,0,1,1,1,1,1,0,
};
const unsigned char yzmm[] = {
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,1,1,0,1,1,1,1,0,
    0,1,1,1,1,1,1,1,1,
    0,1,1,1,0,0,0,1,1,
    0,1,1,0,0,0,0,1,1,
    0,1,1,0,0,0,0,1,1,
    0,1,1,0,0,0,0,1,1,
    0,1,1,0,0,0,0,1,1,
    0,1,1,0,0,0,0,1,1,
    0,1,1,0,0,0,0,1,1,
};
const unsigned char yzmn[] = {
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,1,1,0,0,1,1,1,1,
    0,1,1,0,1,1,1,1,1,
    0,1,1,1,1,0,0,0,1,
    0,1,1,1,0,0,0,0,1,
    0,1,1,0,0,0,0,0,1,
    0,1,1,0,0,0,0,0,1,
    0,1,1,0,0,0,0,0,1,
    0,1,1,0,0,0,0,0,1,
    0,1,1,0,0,0,0,0,1,
};
const unsigned char yzmv[] = {
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    1,1,0,0,0,0,0,1,1,
    0,1,1,0,0,0,1,1,0,
    0,1,1,0,0,0,1,1,0,
    0,1,1,0,0,0,1,1,0,
    0,0,1,1,0,1,1,0,0,
    0,0,1,1,0,1,1,0,0,
    0,0,1,1,0,1,1,0,0,
    0,0,0,1,1,1,0,0,0,
    0,0,0,1,1,1,0,0,0,
};
const unsigned char yzmx[] = {
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    1,1,1,0,0,0,1,1,1,
    0,1,1,0,0,0,1,1,0,
    0,0,1,1,0,1,1,0,0,
    0,0,0,1,1,1,0,0,0,
    0,0,0,1,1,1,0,0,0,
    0,0,0,1,1,1,0,0,0,
    0,0,1,1,0,1,1,0,0,
    0,1,1,0,0,0,1,1,0,
    1,1,1,0,0,0,1,1,1,
};
const unsigned char yzmz[] = {
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,
    0,1,1,1,1,1,1,1,0,
    0,1,1,1,1,1,1,1,0,
    0,0,0,0,0,1,1,0,0,
    0,0,0,0,1,1,0,0,0,
    0,0,0,1,1,0,0,0,0,
    0,0,1,1,0,0,0,0,0,
    0,1,1,0,0,0,0,0,0,
    0,1,1,1,1,1,1,1,0,
    0,1,1,1,1,1,1,1,0,
};

const unsigned char *m[]= {
    yzm1,yzm2,yzm3,yzmb,yzmc,yzmm,yzmn,yzmv,yzmx,yzmz
};

NSString *w[] = {@"1",@"2",@"3",@"b",@"c",@"m",@"n",@"v",@"x",@"z"};


- (NSString *)shibie:(NSData*)data withW:(NSInteger)width withH:(NSInteger)height{
    NSString *yzm = @"";
    unsigned char *tu1 = (unsigned char *)data.bytes;//原图
    
    unsigned char *tu2 = malloc(width*height*sizeof(unsigned char));
    for (int i = 0; i<data.length/4; i++) {
        int liangdu = (*tu1+*(tu1+1)+*(tu1+2))/3>128;
        if(liangdu)*(tu2+i) = 0;
        else *(tu2+i) = 1;
        tu1+=4;
    }//二值化
    for (int qietu = 0; qietu<4; qietu++) {
        int err[10] = {0};
        for (int duibi = 0; duibi<10; duibi++) {
            for (int y = 0; y<12; y++) {
                for (int x = 0; x<9; x++) {
                    int col1 = *(tu2+x+3+10*qietu + (y+4)*width);
                    int col2 = *(m[duibi]+x+y*9);
                    if(col2>col1)err[duibi]++;
                }
            }
        }
        int wz = 0,min=100;
        for (int i=0; i<10; i++){
            if(err[i]<min){min=err[i];wz=i;}
        }
        yzm = [NSString stringWithFormat:@"%@%@",yzm,w[wz]];
    }
    free(tu2);
    return yzm;
}

@end