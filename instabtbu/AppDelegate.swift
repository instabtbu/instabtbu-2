//
//  AppDelegate.swift
//  instabtbu
//
//  Created by 杨培文 on 14/12/15.
//  Copyright (c) 2014年 杨培文. All rights reserved.
//

import UIKit

var drawerController: MMDrawerController!
var navigation: UINavigationController!
var stb: UIStoryboard!
let centerViewController = stb.instantiateViewControllerWithIdentifier("navigationController") as! UINavigationController
let leftSideDrawerViewController = LeftViewController()
let swViewController = stb.instantiateViewControllerWithIdentifier("SW") as! ShangwangViewController
let jwViewController = stb.instantiateViewControllerWithIdentifier("JW") as! JWGLViewController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var jwusn: String?
    var jwpsw: String?
    var kecheng = NSMutableArray(capacity: 100)
    var chengji = NSMutableArray(capacity: 100)
    var xuefen = NSMutableArray(capacity: 100)
    var urlList = NSMutableArray(capacity: 100)
    var kebiao = NSMutableArray(capacity: 100)
    var xueqi = ""
    var jidian: String?
    var chenggong: Bool?
    var cundang: Bool = false
    var pangting: Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            MobClick.startWithAppkey("54928b14fd98c57631000120", reportPolicy: BATCH , channelId: "instabtbu")
            UMFeedback.setAppkey("54928b14fd98c57631000120")
        })
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) {
            stb = UIStoryboard(name: "Main", bundle: nil)
        }
        else {
            stb = UIStoryboard(name: "Main_iPad", bundle: nil)
        }
        println("\(UIDevice.currentDevice().model)")
        
        drawerController = MMDrawerController(centerViewController: centerViewController, leftDrawerViewController: leftSideDrawerViewController)
        drawerController.maximumLeftDrawerWidth = centerViewController.view.frame.width*20/32
        drawerController.openDrawerGestureModeMask = .All
        drawerController.closeDrawerGestureModeMask = .All
        drawerController.shouldStretchDrawer = false
        
        self.window?.rootViewController = drawerController
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

