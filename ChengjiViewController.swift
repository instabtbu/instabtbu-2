//
//  ChengjiViewController.swift
//  playswift
//
//  Created by 陈禹志 on 14/12/24.
//  Copyright (c) 2014年 com.insta. All rights reserved.
//

import UIKit

class ChengjiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var tableview:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.redColor()
        self.title = "成绩"
        
        self.tableview = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style: UITableViewStyle.Plain)
        self.tableview!.delegate = self
        self.tableview!.dataSource = self
        
        self.tableview!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "swiftcell")
        self.view.addSubview(self.tableview!)
        
        let headerLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, 40))
        headerLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        headerLabel.text = "   平均绩点：\(delegate.jidian!)"
        self.tableview!.tableHeaderView = headerLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.kecheng.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identify:String = "swiftcell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identify, forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        let xuefen = UILabel(frame: CGRectMake(cell.frame.maxX*7/10, cell.frame.minY, 100, cell.frame.height))
        self.tableview?.addSubview(xuefen)
        
        let chengjiL = UILabel(frame: CGRectMake(cell.frame.maxX*17/20, cell.frame.minY, 100, cell.frame.height))
        self.tableview?.addSubview(chengjiL)
        
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 16)
        cell.textLabel?.text = " " + (delegate.kecheng.objectAtIndex(indexPath.row) as! String)
        
        xuefen.font = UIFont(name: "Helvetica", size: 16)
        xuefen.text = "\(delegate.xuefen.objectAtIndex(indexPath.row))"
        
        chengjiL.font = UIFont(name: "Helvetica", size: 16)
        chengjiL.text = "\(delegate.chengji.objectAtIndex(indexPath.row))"
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) {
            
        }
        else {
            cell.textLabel?.text = "       " + (delegate.kecheng.objectAtIndex(indexPath.row) as! String)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableview?.deselectRowAtIndexPath(indexPath, animated: true)
        let result = sGet(delegate.urlList.objectAtIndex(indexPath.row) as! String)
        let fen:NSArray = oc().iRegular("70\" title=.+?>(.+?)</td>", and: result, withx: 1)
        if fen.count == 3 {
            let detail = UIAlertView(title: delegate.kecheng.objectAtIndex(indexPath.row) as! String as String, message: "平时成绩：\(fen.objectAtIndex(0))，期末成绩：\(fen.objectAtIndex(1))，总成绩：\(fen.objectAtIndex(2))", delegate: self, cancelButtonTitle: "确定")
            detail.show()
        }
        else {
            let detail = UIAlertView(title: delegate.kecheng.objectAtIndex(indexPath.row) as? String, message: "该科目只有总成绩！", delegate: self, cancelButtonTitle: "确定")
            detail.show()
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
