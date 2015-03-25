//
//  oc.h
//  instabtbu
//
//  Created by 杨培文 on 14/12/15.
//  Copyright (c) 2014年 杨培文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ifaddrs.h>
#import <arpa/inet.h>


@interface oc : NSObject
- (NSString*)getIP;
- (NSString *)iPOSTwithurl:(NSString *)inurl withpost:(NSString *)inpost;
- (BOOL)iFind:(NSString *)astr inthe:(NSString *)lstr;
- (void)ShowMessage:(NSString *) title msg:(NSString *) message;
- (NSArray *)iRegular:(NSString *)regTags and:(NSString *)retStr withx:(NSNumber *)x;
- (NSString *)shibie:(NSData*)data withW:(NSInteger)width withH:(NSInteger)height;
@end
